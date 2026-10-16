<#
.SYNOPSIS
    Grok Oracle Bridge for Other Coding Agents

.DESCRIPTION
    Small helper that other agents (Claude, Cursor, Aider, etc.) can shell out to
    when they need to consult Grok with privileged X data or deep Grok Build thinking.

    Primary job: take a natural language query and produce a clean, ready-to-paste
    block for the human to drop into the Grok Build TUI and invoke with /grok-oracle.

    This keeps the human as the explicit trust and invocation boundary while making
    the handoff extremely low friction.

.PARAMETER Query
    The question or task to send to Grok Oracle. Can be a single string or multiple
    arguments that will be joined.

.PARAMETER FromAgent
    Optional label for the calling agent (e.g. "claude-cursor", "aider", "cline").
    Used for nicer formatting in the handoff block.

.EXAMPLE
    .\grok-oracle.ps1 "What are indie hackers saying on X about the new Cursor agent features this week?"

.EXAMPLE
    .\grok-oracle.ps1 -FromAgent "claude-cursor" -Query "Run a quick assumption audit on adding a local MCP server for Grok Build capabilities."
#>
[CmdletBinding()]
param(
    [Parameter(Position = 0, ValueFromRemainingArguments = $true)]
    [string[]]$Query,

    [string]$FromAgent = "unknown-agent"
)


# The logic lives in functions so tests can dot-source this file without running
# it. Running the script (.\grok-oracle.ps1 ...) behaves exactly as before; see the
# guard at the bottom of the file.

function Write-GrokOracleUsage {
    Write-Host "Usage: .\grok-oracle.ps1 [-FromAgent <name>] <your query here>"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host '  .\grok-oracle.ps1 "What are builders on X saying about Grok 4 coding in the last 10 days?"'
    Write-Host '  .\grok-oracle.ps1 -FromAgent "cursor" "Compare local file MCP vs small HTTP bridge for agent-to-Grok calls. Include recent X signal."'
}

function Join-GrokOracleQuery {
    param([string[]]$Query)
    return ($Query -join " ").Trim()
}

function Format-GrokOracleHandoff {
    param(
        [Parameter(Mandatory = $true)]
        [string]$FullQuery,

        [string]$FromAgent = "unknown-agent",

        [string]$Timestamp = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
    )

    return @"
=== GROK ORACLE REQUEST ===
Generated: $Timestamp
From Agent: $FromAgent

QUERY:
$FullQuery

--------------------------------------------------
INSTRUCTIONS FOR HUMAN (Grok Build TUI):

1. Copy everything after "QUERY:" above (or the whole block).
2. In your Grok TUI, type one of:
     /grok-oracle
   or (including the query on the same line):
     /grok-oracle $FullQuery

3. Grok (with the grok-oracle skill active) will research using privileged X tools
   + Grok Build patterns and return a structured answer optimized for pasting
   back into the requesting agent.

4. Once you have the response, copy it and paste it back to the other agent
   (usually as a normal message or as the result of the tool call).

The grok-oracle skill is designed to be consumed by other LLMs.
It prioritizes fresh X signal and clear evidence-backed answers.
--------------------------------------------------

If you want to run this query directly yourself:
  /grok-oracle $FullQuery
"@
}

function Get-GrokOracleRequestPath {
    param(
        [string]$Directory = [System.IO.Path]::GetTempPath(),
        [string]$Stamp = (Get-Date -Format "yyyyMMdd-HHmmss")
    )
    return Join-Path $Directory "grok-oracle-request-$Stamp.txt"
}

# Returns the process exit code: 1 for the usage path, 0 on success. An empty
# (whitespace-only) query raises a terminating error, as the original script did.
function Invoke-GrokOracleBridge {
    param(
        [string[]]$Query,
        [string]$FromAgent = "unknown-agent",
        [string]$OutputDirectory = [System.IO.Path]::GetTempPath()
    )

    $ErrorActionPreference = "Stop"

    if (-not $Query -or $Query.Count -eq 0) {
        Write-GrokOracleUsage
        return 1
    }

    $fullQuery = Join-GrokOracleQuery $Query

    if ([string]::IsNullOrWhiteSpace($fullQuery)) {
        Write-Error "Query cannot be empty."
        return 1
    }

    $handoff = Format-GrokOracleHandoff -FullQuery $fullQuery -FromAgent $FromAgent

    Write-Host $handoff

    # Also write to a temp file for easy copy (optional nicety)
    $tempFile = Get-GrokOracleRequestPath -Directory $OutputDirectory
    $handoff | Out-File -FilePath $tempFile -Encoding UTF8

    Write-Host ""
    Write-Host "(Also written to: $tempFile)" -ForegroundColor DarkGray
    Write-Host "You can open that file and copy the QUERY section if it's easier." -ForegroundColor DarkGray

    return 0
}

# Run only when executed, not when dot-sourced (". .\grok-oracle.ps1") by the tests.
if ($MyInvocation.InvocationName -ne '.') {
    $exitCode = Invoke-GrokOracleBridge -Query $Query -FromAgent $FromAgent
    if ($exitCode -ne 0) { exit $exitCode }
}
