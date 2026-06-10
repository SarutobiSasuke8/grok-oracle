# Grok Oracle Bridge

Small, dependency-free (or minimal) helpers that other coding agents can call when they need to consult Grok with its privileged X access and Grok Build patterns.

## Philosophy

- Keep the human in the loop as the explicit approval and paste boundary (v1).
- Make the request formatting dead simple and consistent.
- The heavy lifting (real X searches + deep thinking) happens inside the Grok TUI with the `grok-oracle` skill loaded.

## Current Bridge

- `grok-oracle.ps1` — PowerShell script for Windows (primary for this user).

Run it from another agent by shelling out:

```powershell
pwsh -File "C:\path\to\bridge\grok-oracle.ps1" -FromAgent "cursor" "What are people on X actually saying about the latest Claude coding agent changes in the last week?"
```

Or with the query as trailing arguments:

```powershell
pwsh -File "C:\path\to\bridge\grok-oracle.ps1" "Run a second-order + assumption audit on shipping a local MCP server so other agents can call Grok Build tools."
```

The script will print a clean `=== GROK ORACLE REQUEST ===` block containing the query and exact instructions for the human.

The human then pastes into the Grok TUI and runs `/grok-oracle`.

## Future / Alternative Bridges (ideas)

- A tiny Node or Python CLI that does the same formatting (cross-platform).
- A version that attempts direct `grok -p` headless invocation with the oracle rules injected (for lower-friction queries where the human is okay with less visibility).
- A local stdio or HTTP MCP server that any MCP-capable agent can connect to (longer term, would turn this into a proper tool other agents can call autonomously within the user's trust boundary).

For now, the PowerShell bridge + clear protocol is the pragmatic win.

## Protocol (for agents that don't want to shell out)

If an agent cannot or should not shell out to the script, it can simply emit a block in this format:

```
GROK-ORACLE-QUERY:
<the actual question or task, can be multiple lines>
```

The human knows to look for that marker and invoke the skill.
