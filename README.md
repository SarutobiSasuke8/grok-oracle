# Grok Oracle

A skill + bridge that lets **other coding agents** (Claude, Cursor, Aider, Cline, Windsurf, etc.) query this Grok instance — with privileged X data access and deep Grok Build expertise — through a clean, structured interface.

## Why this exists

Most coding agents have weak or no native access to high-quality, real-time X/Twitter signal (builder sentiment, narrative momentum, what indie hackers are actually shipping and complaining about right now).

This Grok environment has excellent `x_semantic_search`, `x_keyword_search`, thread fetching, and the full Grok Build skill ecosystem (best-of-n parallel thinking, ruthless reviews, assumption audits, design+implement loops, etc.).

Grok Oracle turns that advantage into something other agents can actually use.

## Core Deliverables

- **`grok-oracle` skill**: installed to `~/.grok/skills/grok-oracle/`. Run with `/grok-oracle <query>`.
- **Bridge script** ([`bridge/grok-oracle.ps1`](bridge/grok-oracle.ps1)): a small PowerShell helper other agents can shell out to.
- **Integration packs** ([`integrations/`](integrations/)): ready-to-paste instructions for Claude, Cursor and Aider, plus a general protocol for any other agent.
- **Protocol**: a simple, reliable way for another agent to request help and get high-signal structured answers back.

## Killer Use Cases

- "What are actual builders saying on X about the new Cursor agent features this week?"
- "Run a second-order analysis + assumption audit on shipping a local MCP server for our internal tools."
- "Give me a Grok-style parallel evaluation of three different approaches to our auth refresh problem."
- "Find the most recent high-signal threads from indie hackers shipping AI coding tools and summarize the real problems they're hitting."

## Quick Start (for the human)

1. Install the skill (see below).
2. When another agent outputs a request in the documented format, paste it and run:
   ```
   /grok-oracle
   ```
   or with the query directly:
   ```
   /grok-oracle What are people on X saying about Grok 4 coding performance in the last 10 days?
   ```

## Installation

The installer ([`scripts/install-skill.ps1`](scripts/install-skill.ps1)) copies the source skill at [`skill/grok-oracle/SKILL.md`](skill/grok-oracle/SKILL.md) to:

`%USERPROFILE%\.grok\skills\grok-oracle\SKILL.md`

It resolves the source path relative to the script itself, so it works from any directory. The TUI should pick it up on next load or file change. Verify anytime with `grok inspect`.

Re-run the installer from the repo root whenever you edit the source skill:

```powershell
.\scripts\install-skill.ps1
```

## Project Structure

- [`skill/grok-oracle/SKILL.md`](skill/grok-oracle/SKILL.md): the Grok-side skill definition (source of truth)
- [`scripts/install-skill.ps1`](scripts/install-skill.ps1): installs the Grok skill to `~/.grok/skills/grok-oracle/`
- [`bridge/`](bridge/): the PowerShell bridge other agents shell out to, plus its [README](bridge/README.md)
- [`integrations/`](integrations/): custom instructions for [Claude](integrations/claude.md), [Cursor](integrations/cursor.md), [Aider](integrations/aider.md) and a [general protocol](integrations/general-protocol.md)
- [`claude-commands/`](claude-commands/): the Claude `/grok-oracle` command and install notes
- [`claude-skills/grok-oracle/SKILL.md`](claude-skills/grok-oracle/SKILL.md): the Claude-side liaison skill
- [`codex/grok-oracle-instructions.md`](codex/grok-oracle-instructions.md): instructions for Codex and OpenAI agents
- [`docs/PROJECT_BRIEF.md`](docs/PROJECT_BRIEF.md): the Project Brief
- [`Grok Oracle - Strategic Build Spec.md`](<Grok Oracle - Strategic Build Spec.md>): the Strategic Build Spec (at the repo root, not in `docs/`)
- [`examples/`](examples/): [sample queries](examples/sample-queries.md) and a [live MCP signal demo](examples/live-mcp-signal-demo.md)
- [`AGENTS.md`](AGENTS.md) and [`TODO.md`](TODO.md): the agent contract and the task list

## Status

**Done for v0.1 / Experiment 1:**

- `grok-oracle` skill written and installed (heavy emphasis on X tools + structured output for other LLMs).
- PowerShell bridge (`bridge\grok-oracle.ps1`) ready for other agents to shell out to.
- Integration guides for Claude, Cursor, Aider + general protocol.
- Example queries and full project docs in the user's preferred experiment style.

**Live test:** [`examples/live-mcp-signal-demo.md`](examples/live-mcp-signal-demo.md) shows the kind of query this is built for (MCP servers and agent tool exposure) and the structured answer the skill is designed to produce.

This is **Grok Build Experiment 1** — deliberately meta. We used the Grok Build environment (and its privileged X tools + skill system) to build something that makes those same strengths available to the rest of your agent stack.

See the [Strategic Build Spec](<Grok Oracle - Strategic Build Spec.md>), the [Project Brief](docs/PROJECT_BRIEF.md) and [`examples/sample-queries.md`](examples/sample-queries.md) for more.

## How to Use It Today

**Direct (you in Grok TUI):**
```
/grok-oracle What are builders on X saying about local MCP servers for agents right now?
```

**From Claude (now with native command support):**
- Copy `claude-commands/grok-oracle.md` to `~/.claude/commands/grok-oracle.md` (or project `.claude/commands/`).
- Then in Claude you (or Claude) can type `/grok-oracle <question>`.
- It will either shell the bridge or output the clean marker for you to forward.

See [`claude-commands/README.md`](claude-commands/README.md) and [`claude-skills/`](claude-skills/) for easy install options. We also ship a `claude-skills/grok-oracle/SKILL.md` for the skills folder.

**From Codex / OpenAI agents:**
- Use the instructions in [`codex/grok-oracle-instructions.md`](codex/grok-oracle-instructions.md).
- Same bridge or marker mechanism.

**From Cursor / Aider:**
- Use the files in `integrations/` (or the new Claude command if Cursor is Claude-backed).

The bridge script also writes a temp file with the exact block if that's easier to copy from.

## Claude & Codex Skill Usability

Yes — we have packaged it as proper Claude commands and skills (matching your other experiments like Agent Grove). 

See the new `claude-commands/` and `claude-skills/` folders + the Codex instructions. 

Note: The actual X tool calls and deepest Grok Build work still happen on the Grok side (human forwards the request). This is intentional for now. The Claude/Codex side is excellent at *knowing when to ask* and formatting the request cleanly.
