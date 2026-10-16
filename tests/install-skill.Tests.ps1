#Requires -Modules @{ ModuleName = 'Pester'; ModuleVersion = '5.0.0' }

# Tests for scripts/install-skill.ps1. Every install goes to $TestDrive; the real
# ~/.grok/skills folder is never touched.

BeforeAll {
    $script:InstallerPath = [System.IO.Path]::Combine($PSScriptRoot, '..', 'scripts', 'install-skill.ps1')
    $script:RepoSkill = [System.IO.Path]::GetFullPath([System.IO.Path]::Combine($PSScriptRoot, '..', 'skill', 'grok-oracle', 'SKILL.md'))
    . $script:InstallerPath

    function Get-InstalledSkillPath {
        param([string]$Root)
        return [System.IO.Path]::Combine($Root, '.grok', 'skills', 'grok-oracle', 'SKILL.md')
    }
}

Describe 'install-skill' {
    BeforeEach {
        Mock Write-Host { }
        Mock Invoke-RestMethod { throw 'Network call attempted in a unit test.' }
        Mock Invoke-WebRequest { throw 'Network call attempted in a unit test.' }
        Mock Start-Process { throw 'Process launch attempted in a unit test.' }
    }

    It 'ships the source skill file the installer copies by default' {
        Test-Path -LiteralPath $script:RepoSkill | Should -BeTrue
    }

    It 'copies the skill to HOME/.grok/skills/grok-oracle/SKILL.md and returns 0' {
        $root = Join-Path $TestDrive 'home1'
        Install-GrokOracleSkill -Source $script:RepoSkill -DestinationRoot $root | Should -Be 0

        $dest = Get-InstalledSkillPath $root
        Test-Path -LiteralPath $dest | Should -BeTrue
        (Get-FileHash -LiteralPath $dest).Hash | Should -Be (Get-FileHash -LiteralPath $script:RepoSkill).Hash
        Should -Invoke Write-Host -ParameterFilter { "$Object" -like 'Installed grok-oracle skill to:*' } -Exactly -Times 1
    }

    It 'resolves the default source relative to the script, not the working directory' {
        $root = Join-Path $TestDrive 'home-default'
        Push-Location $TestDrive
        try {
            Install-GrokOracleSkill -DestinationRoot $root | Should -Be 0
        }
        finally {
            Pop-Location
        }
        (Get-FileHash -LiteralPath (Get-InstalledSkillPath $root)).Hash | Should -Be (Get-FileHash -LiteralPath $script:RepoSkill).Hash
    }

    It 'overwrites an existing installed copy' {
        $root = Join-Path $TestDrive 'home2'
        $dest = Get-InstalledSkillPath $root
        New-Item -ItemType Directory -Path (Split-Path -Parent $dest) -Force | Out-Null
        Set-Content -LiteralPath $dest -Value 'stale'

        Install-GrokOracleSkill -Source $script:RepoSkill -DestinationRoot $root | Should -Be 0
        (Get-FileHash -LiteralPath $dest).Hash | Should -Be (Get-FileHash -LiteralPath $script:RepoSkill).Hash
    }

    It 'throws a clear error and creates nothing when the source is missing' {
        $root = Join-Path $TestDrive 'home3'
        $missing = Join-Path $TestDrive 'nope.md'
        { Install-GrokOracleSkill -Source $missing -DestinationRoot $root } | Should -Throw '*Source skill not found at*'
        Test-Path -LiteralPath $root | Should -BeFalse
    }

    It 'never touches the network or launches a process' {
        Install-GrokOracleSkill -Source $script:RepoSkill -DestinationRoot (Join-Path $TestDrive 'home4') | Out-Null
        Should -Invoke Invoke-RestMethod -Times 0 -Exactly
        Should -Invoke Invoke-WebRequest -Times 0 -Exactly
        Should -Invoke Start-Process -Times 0 -Exactly
    }
}
