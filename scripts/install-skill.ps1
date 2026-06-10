# Simple installer for the grok-oracle skill
$ErrorActionPreference = "Stop"

$source = Join-Path $PSScriptRoot "..\skill\grok-oracle\SKILL.md"
$destDir = Join-Path $env:USERPROFILE ".grok\skills\grok-oracle"
$dest = Join-Path $destDir "SKILL.md"

if (-not (Test-Path $source)) {
    Write-Error "Source skill not found at $source. Run this script from the scripts/ directory inside the Grok Oracle experiment."
    exit 1
}

New-Item -ItemType Directory -Path $destDir -Force | Out-Null
Copy-Item $source $dest -Force

Write-Host "Installed grok-oracle skill to: $dest" -ForegroundColor Green
Write-Host ""
Write-Host "The TUI should pick it up automatically (skills reload on file change)." -ForegroundColor Gray
Write-Host "You can verify with: grok inspect | findstr /i oracle" -ForegroundColor Gray
Write-Host ""
Write-Host "Test it with:" -ForegroundColor Gray
Write-Host '  /grok-oracle What are builders on X saying about local MCP servers or agent-to-agent tool exposure lately?'
