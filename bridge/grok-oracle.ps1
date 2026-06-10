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

$ErrorActionPreference = "Stop"

if (-not $Query -or $Query.Count -eq 0) {
    Write-Host "Usage: .\grok-oracle.ps1 [-FromAgent <name>] <your query here>"
    Write-Host ""
    Write-Host "Examples:"
    Write-Host '  .\grok-oracle.ps1 "What are builders on X saying about Grok 4 coding in the last 10 days?"'
    Write-Host '  .\grok-oracle.ps1 -FromAgent "cursor" "Compare local file MCP vs small HTTP bridge for agent-to-Grok calls. Include recent X signal."'
    exit 1
}

$fullQuery = ($Query -join " ").Trim()

if ([string]::IsNullOrWhiteSpace($fullQuery)) {
    Write-Error "Query cannot be empty."
    exit 1
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"

$handoff = @"
=== GROK ORACLE REQUEST ===
Generated: $timestamp
From Agent: $FromAgent

QUERY:
$fullQuery

--------------------------------------------------
INSTRUCTIONS FOR HUMAN (Grok Build TUI):

1. Copy everything after "QUERY:" above (or the whole block).
2. In your Grok TUI, type one of:
     /grok-oracle
   or (including the query on the same line):
     /grok-oracle $fullQuery

3. Grok (with the grok-oracle skill active) will research using privileged X tools
   + Grok Build patterns and return a structured answer optimized for pasting
   back into the requesting agent.

4. Once you have the response, copy it and paste it back to the other agent
   (usually as a normal message or as the result of the tool call).

The grok-oracle skill is designed to be consumed by other LLMs.
It prioritizes fresh X signal and clear evidence-backed answers.
--------------------------------------------------

If you want to run this query directly yourself:
  /grok-oracle $fullQuery
"@

Write-Host $handoff

# Also write to a temp file for easy copy (optional nicety)
$tempDir = [System.IO.Path]::GetTempPath()
$stamp = Get-Date -Format "yyyyMMdd-HHmmss"
$tempFile = Join-Path $tempDir "grok-oracle-request-$stamp.txt"
$handoff | Out-File -FilePath $tempFile -Encoding UTF8

Write-Host ""
Write-Host "(Also written to: $tempFile)" -ForegroundColor DarkGray
Write-Host "You can open that file and copy the QUERY section if it's easier." -ForegroundColor DarkGray
