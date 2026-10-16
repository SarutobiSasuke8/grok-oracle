#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

# Tests for bridge/grok-oracle.ps1. The bridge never calls Grok, X or any network
# service: it only formats a handoff block for a human to paste into the Grok TUI.
# Network and process cmdlets are mocked to throw anyway, so a future change that
# adds a live call fails these tests instead of reaching a real service.

BeforeAll {
    $script:BridgePath = [System.IO.Path]::Combine($PSScriptRoot, '..', 'bridge', 'grok-oracle.ps1')
    . $script:BridgePath
}

Describe 'grok-oracle bridge' {
    BeforeEach {
        Mock Invoke-RestMethod { throw 'Network call attempted in a unit test.' }
        Mock Invoke-WebRequest { throw 'Network call attempted in a unit test.' }
        Mock Start-Process { throw 'Process launch attempted in a unit test.' }
    }

    Context 'Join-GrokOracleQuery (argument parsing)' {
        It 'joins remaining arguments with single spaces' {
            Join-GrokOracleQuery @('What', 'are', 'builders', 'saying?') | Should -Be 'What are builders saying?'
        }

        It 'returns a single quoted argument unchanged' {
            Join-GrokOracleQuery @('One quoted query') | Should -Be 'One quoted query'
        }

        It 'trims leading and trailing whitespace' {
            Join-GrokOracleQuery @('  padded', 'query  ') | Should -Be 'padded query'
        }

        It 'returns an empty string for whitespace-only input' {
            Join-GrokOracleQuery @('   ', ' ') | Should -BeNullOrEmpty
        }
    }

    Context 'Format-GrokOracleHandoff (output formatting)' {
        BeforeAll {
            $script:Handoff = Format-GrokOracleHandoff -FullQuery 'Compare MCP bridges' -FromAgent 'claude-cursor' -Timestamp '2026-10-16 09:30:00'
            $script:Lines = $script:Handoff -split '\r?\n'
        }

        It 'starts with the request header' {
            $script:Lines[0] | Should -Be '=== GROK ORACLE REQUEST ==='
        }

        It 'includes the injected timestamp' {
            $script:Lines | Should -Contain 'Generated: 2026-10-16 09:30:00'
        }

        It 'labels the calling agent' {
            $script:Lines | Should -Contain 'From Agent: claude-cursor'
        }

        It 'puts the query on the line after QUERY:' {
            $index = [array]::IndexOf($script:Lines, 'QUERY:')
            $index | Should -BeGreaterThan 0
            $script:Lines[$index + 1] | Should -Be 'Compare MCP bridges'
        }

        It 'offers the one-line /grok-oracle command with the query twice' {
            ([regex]::Matches($script:Handoff, [regex]::Escape('/grok-oracle Compare MCP bridges'))).Count | Should -Be 2
        }

        It 'defaults the agent label to unknown-agent' {
            Format-GrokOracleHandoff -FullQuery 'q' -Timestamp 't' | Should -Match '(?m)^From Agent: unknown-agent\r?$'
        }

        It 'stamps the current time when no timestamp is given' {
            Format-GrokOracleHandoff -FullQuery 'q' | Should -Match '(?m)^Generated: \d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}\r?$'
        }

        It 'keeps special characters in the query literally' {
            $q = 'What about $env:PATH, "quotes" and {braces}?'
            $out = Format-GrokOracleHandoff -FullQuery $q -Timestamp 't'
            $out.Contains($q) | Should -BeTrue
        }
    }

    Context 'Get-GrokOracleRequestPath (path handling)' {
        It 'builds the request file name from the stamp inside the directory' {
            $path = Get-GrokOracleRequestPath -Directory $TestDrive -Stamp '20261016-093000'
            $path | Should -Be (Join-Path $TestDrive 'grok-oracle-request-20261016-093000.txt')
        }

        It 'defaults to the system temp directory' {
            $path = Get-GrokOracleRequestPath -Stamp 's'
            $expected = [System.IO.Path]::GetTempPath().TrimEnd([System.IO.Path]::DirectorySeparatorChar, [System.IO.Path]::AltDirectorySeparatorChar)
            (Split-Path -Parent $path) | Should -Be $expected
            (Split-Path -Leaf $path) | Should -Be 'grok-oracle-request-s.txt'
        }
    }

    Context 'Invoke-GrokOracleBridge' {
        BeforeEach {
            Mock Write-Host { }
        }

        It 'prints usage and returns 1 when no query is given' {
            Invoke-GrokOracleBridge -Query @() -OutputDirectory $TestDrive | Should -Be 1
            Should -Invoke Write-Host -ParameterFilter { "$Object" -like 'Usage:*' } -Exactly -Times 1
            Get-ChildItem $TestDrive -Filter 'grok-oracle-request-*' | Should -BeNullOrEmpty
        }

        It 'prints usage and returns 1 when the query is null' {
            Invoke-GrokOracleBridge -OutputDirectory $TestDrive | Should -Be 1
        }

        It 'throws on a whitespace-only query and writes no file' {
            { Invoke-GrokOracleBridge -Query @('   ') -OutputDirectory $TestDrive } | Should -Throw '*Query cannot be empty.*'
            Get-ChildItem $TestDrive -Filter 'grok-oracle-request-*' | Should -BeNullOrEmpty
        }

        It 'prints the handoff, writes it to a request file and returns 0' {
            $dir = Join-Path $TestDrive 'ok'
            New-Item -ItemType Directory -Path $dir | Out-Null

            Invoke-GrokOracleBridge -Query @('Is', 'MCP', 'hot?') -FromAgent 'aider' -OutputDirectory $dir | Should -Be 0

            Should -Invoke Write-Host -ParameterFilter { "$Object" -like '=== GROK ORACLE REQUEST ===*' } -Exactly -Times 1
            Should -Invoke Write-Host -ParameterFilter { "$Object" -like '(Also written to: *' } -Exactly -Times 1

            $files = @(Get-ChildItem $dir -Filter 'grok-oracle-request-*.txt')
            $files.Count | Should -Be 1
            $files[0].Name | Should -Match '^grok-oracle-request-\d{8}-\d{6}\.txt$'
            $content = Get-Content -Raw -LiteralPath $files[0].FullName
            $content | Should -Match '(?m)^From Agent: aider\r?$'
            $content | Should -Match '(?m)^Is MCP hot\?\r?$'
        }

        It 'never touches the network or launches a process' {
            Invoke-GrokOracleBridge -Query @('q') -OutputDirectory $TestDrive | Out-Null
            Should -Invoke Invoke-RestMethod -Times 0 -Exactly
            Should -Invoke Invoke-WebRequest -Times 0 -Exactly
            Should -Invoke Start-Process -Times 0 -Exactly
        }
    }

    Context 'running the script (child process, temp redirected to TestDrive)' {
        BeforeAll {
            $script:Shell = (Get-Process -Id $PID).Path

            function Invoke-Bridge {
                param([string[]]$Arguments)
                $tmp = Join-Path $TestDrive ('run-' + [guid]::NewGuid().ToString('N'))
                New-Item -ItemType Directory -Path $tmp | Out-Null
                $saved = @{ TMP = $env:TMP; TEMP = $env:TEMP; TMPDIR = $env:TMPDIR }
                try {
                    $env:TMP = $tmp; $env:TEMP = $tmp; $env:TMPDIR = $tmp
                    $output = & $script:Shell -NoProfile -NonInteractive -File $script:BridgePath @Arguments 2>&1 | Out-String
                    [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $output; TempDir = $tmp }
                }
                finally {
                    $env:TMP = $saved.TMP; $env:TEMP = $saved.TEMP; $env:TMPDIR = $saved.TMPDIR
                }
            }
        }

        It 'exits 1 with usage when run without arguments' {
            $r = Invoke-Bridge -Arguments @()
            $r.ExitCode | Should -Be 1
            $r.Output | Should -Match 'Usage:'
        }

        It 'exits 0 and writes the request file when given a query' {
            $r = Invoke-Bridge -Arguments @('-FromAgent', 'cline', 'hello', 'oracle')
            $r.ExitCode | Should -Be 0
            $r.Output | Should -Match 'From Agent: cline'
            $r.Output | Should -Match 'hello oracle'
            @(Get-ChildItem $r.TempDir -Filter 'grok-oracle-request-*.txt').Count | Should -Be 1
        }

        It 'exits non-zero on a whitespace-only query' {
            $r = Invoke-Bridge -Arguments @('   ')
            $r.ExitCode | Should -Not -Be 0
            $r.Output | Should -Match 'Query cannot be empty'
        }
    }
}
