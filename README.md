# Grok Oracle

A skill + bridge that lets **other coding agents** (Claude, Cursor, Aider, Cline, Windsurf, etc.) query this Grok instance — with privileged X data access and deep Grok Build expertise — through a clean, structured interface.

## Why this exists

Most coding agents have weak or no native access to high-quality, real-time X/Twitter signal (builder sentiment, narrative momentum, what indie hackers are actually shipping and complaining about right now).

This Grok environment has excellent `x_semantic_search`, `x_keyword_search`, thread fetching, and the full Grok Build skill ecosystem (best-of-n parallel thinking, ruthless reviews, assumption audits, design+implement loops, etc.).

Grok Oracle turns that advantage into something other agents can actually use.

## Core Deliverables

- **`grok-oracle` skill** — installed to `~/.grok/skills/grok-oracle/`. Run with `/grok-oracle <query>`.
- **Bridge scripts** (`bridge/`) — small CLI helpers other agents can shell out to.
- **Integration packs** (`integrations/`) — ready-to-paste instructions for Claude, Cursor, Aider, etc.
- **Protocol** — simple, reliable way for another agent to request help and get high-signal structured answers back.

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

## Installation (Done)

The skill is already installed to:

`C:\Users\sarut\.grok\skills\grok-oracle\SKILL.md`

(Installed via `scripts\install-skill.ps1` from this folder.)

The TUI should pick it up on next load or file change. Verify anytime with `grok inspect`.

You can also re-run the installer from this folder if you edit the source skill:

```powershell
.\scripts\install-skill.ps1
```

## Project Structure

- `skill/grok-oracle/SKILL.md` — the actual Grok skill definition
- `bridge/` — invocation helpers / CLI for other agents
- `integrations/` — system prompt additions and command examples for popular agents
- `docs/` — Project Brief, Strategic Spec, etc.
- `examples/` — sample queries and expected outputs

## Status

**Done for v0.1 / Experiment 1:**

- `grok-oracle` skill written and installed (heavy emphasis on X tools + structured output for other LLMs).
- PowerShell bridge (`bridge\grok-oracle.ps1`) ready for other agents to shell out to.
- Integration guides for Claude, Cursor, Aider + general protocol.
- Example queries and full project docs in the user's preferred experiment style.

**Live test (right now in this session):** The X searches above were exactly the kind of query this is built for (MCP servers + agent tool exposure). The skill would have turned those results into a tight, citable summary + Grok Build take + escalation offers.

This is **Grok Build Experiment 1** — deliberately meta. We used the Grok Build environment (and its privileged X tools + skill system) to build something that makes those same strengths available to the rest of your agent stack.

See `docs/` (Strategic Build Spec + Project Brief) and `examples/sample-queries.md` for more.

## How to Use It Today

**Direct (you in Grok TUI):**
```
/grok-oracle What are builders on X saying about local MCP servers for agents right now?
```

**From Claude (now with native command support):**
- Copy `claude-commands/grok-oracle.md` to `~/.claude/commands/grok-oracle.md` (or project `.claude/commands/`).
- Then in Claude you (or Claude) can type `/grok-oracle <question>`.
- It will either shell the bridge or output the clean marker for you to forward.

See `claude-commands/README.md` and `claude-skills/` for easy install options. We also ship a `claude-skills/grok-oracle/SKILL.md` for the skills folder.

**From Codex / OpenAI agents:**
- Use the instructions in `codex/grok-oracle-instructions.md`.
- Same bridge or marker mechanism.

**From Cursor / Aider:**
- Use the files in `integrations/` (or the new Claude command if Cursor is Claude-backed).

The bridge script also writes a temp file with the exact block if that's easier to copy from.

## Claude & Codex Skill Usability

Yes — we have packaged it as proper Claude commands and skills (matching your other experiments like Agent Grove). 

See the new `claude-commands/` and `claude-skills/` folders + the Codex instructions. 

Note: The actual X tool calls and deepest Grok Build work still happen on the Grok side (human forwards the request). This is intentional for now. The Claude/Codex side is excellent at *knowing when to ask* and formatting the request cleanly.
