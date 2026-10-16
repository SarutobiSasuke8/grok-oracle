# Simple installer for the grok-oracle skill
#
# The logic lives in a function so tests can dot-source this file without
# installing anything. Running the script behaves exactly as before; see the
# guard at the bottom of the file.

function Install-GrokOracleSkill {
    param(
        [string]$Source = (Join-Path $PSScriptRoot "..\skill\grok-oracle\SKILL.md"),
        [string]$DestinationRoot = $env:USERPROFILE
    )

    $ErrorActionPreference = "Stop"

    $destDir = Join-Path $DestinationRoot ".grok\skills\grok-oracle"
    $dest = Join-Path $destDir "SKILL.md"

    if (-not (Test-Path $Source)) {
        Write-Error "Source skill not found at $Source. Run this script from the scripts/ directory inside the Grok Oracle experiment."
        return 1
    }

    New-Item -ItemType Directory -Path $destDir -Force | Out-Null
    Copy-Item $Source $dest -Force

    Write-Host "Installed grok-oracle skill to: $dest" -ForegroundColor Green
    Write-Host ""
    Write-Host "The TUI should pick it up automatically (skills reload on file change)." -ForegroundColor Gray
    Write-Host "You can verify with: grok inspect | findstr /i oracle" -ForegroundColor Gray
    Write-Host ""
    Write-Host "Test it with:" -ForegroundColor Gray
    Write-Host '  /grok-oracle What are builders on X saying about local MCP servers or agent-to-agent tool exposure lately?'

    return 0
}

# Run only when executed, not when dot-sourced (". .\install-skill.ps1") by the tests.
if ($MyInvocation.InvocationName -ne '.') {
    $exitCode = Install-GrokOracleSkill
    if ($exitCode -ne 0) { exit $exitCode }
}
