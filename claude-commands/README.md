# Claude Commands for Grok Oracle

This folder contains Claude-native command definitions (matching the style used in other experiments like Agent Grove).

## How to Install (User Level - available everywhere)

Copy the command into your personal Claude commands directory:

```powershell
# Create the directory if it doesn't exist
mkdir -p "$env:USERPROFILE\.claude\commands"

# Copy the command
Copy-Item "grok-oracle.md" "$env:USERPROFILE\.claude\commands\grok-oracle.md" -Force
```

After copying, in Claude you should be able to type `/grok-oracle` and it will load this persona + instructions.

## How to Install (Project Level)

Inside a specific project, create a `.claude/commands/` folder (or copy the whole thing) and put `grok-oracle.md` there. Many Claude setups will pick up project-local commands.

## What It Does

When you (or Claude) invoke `/grok-oracle <query>`, Claude switches into "Grok Oracle Liaison" mode. It will either:
- Shell out to the PowerShell bridge (preferred), or
- Output a clean `GROK-ORACLE-QUERY:` block for the human to forward to the Grok Build TUI.

The actual heavy X searching and deep Grok Build analysis still happens on the Grok side (where the privileged tools live). This command just makes the *requesting* side clean, consistent, and proactive.

## Related Files

- `grok-oracle.md` — the actual command definition
- `../integrations/claude.md` — longer custom instructions version (useful for Projects or base custom instructions)
- `../bridge/grok-oracle.ps1` — the script Claude will try to call
- `../skill/grok-oracle/SKILL.md` — the Grok-side skill that actually does the work

## Codex

See the `../codex/` folder for a separate set of instructions tailored to OpenAI Codex / agent features.
