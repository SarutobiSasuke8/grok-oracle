# Grok Oracle Instructions for Codex / OpenAI Agents

## Purpose

These instructions turn Codex (or ChatGPT agent features, Responses API, etc.) into a good citizen that knows when and how to request help from the user's Grok Build environment — especially for real-time X builder signal and Grok-style strategic reviews.

## Core Instructions (add to custom instructions or system prompt)

```
You have access to an external specialist called Grok Oracle (part of the user's local Grok Build TUI). It has strong real-time access to X/Twitter builder discourse and uses rigorous "Grok Build" analysis patterns (parallel approach evaluation, explicit assumption audits, second-order thinking).

Use Grok Oracle when:
- You need current, high-quality signal from builders on X about tools, agents, MCP, workflows, shipping experiences, complaints, or wins (especially anything recent).
- A decision would benefit from fresh external validation or a different strategic lens than your default training + tools provide.
- You are about to recommend an architecture or process and want to surface hidden assumptions or recent real-world data.

Invocation methods (in order of preference):

1. Shell out to the bridge script when possible:
   pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" -FromAgent "codex" "Precise question here, with time windows or options if relevant"

2. Emit this exact marker and stop so the human can forward it:
   GROK-ORACLE-QUERY:
   <the full question>

After the human pastes the result back to you, treat the "Key Signals from X", "Sources", and "Grok Build Take" sections as high-signal input. Explicitly reference recency and credibility when using the information.

You are encouraged to use this proactively rather than guessing on topics where social proof or current discourse would clearly improve the answer.
```

## Notes Specific to OpenAI / Codex Environment

- As of mid-2026, OpenAI has been adding strong MCP (Model Context Protocol) support, including private MCP servers and tunnels. This Grok Oracle setup is complementary to MCP — it gives access to capabilities that are harder to expose purely via MCP today (privileged X search + the full parallel-thinking loop).
- The shell bridge or marker method is the current reliable path. A future evolution could wrap Grok Oracle itself as an MCP tool/server that Codex can connect to directly.
- Be explicit about the human mediation: "I need to ask the user's Grok instance for fresh X data on this..."

## Recommended Slash / Tool Name

If the Codex environment supports custom tools or slash commands, name it:
- `/grok-oracle`
- `ask_grok_oracle`
- `consult_grok`

## Example Queries That Work Well

- Recent builder reaction to specific agent features or MCP implementations.
- Assumption audits on cross-agent tool exposure patterns.
- "What are people who have actually shipped X reporting in the last 7-14 days?"

This setup lets Codex stay excellent at what it does while getting the user’s Grok instance to handle the parts where Grok currently has a real edge (X data + certain build meta-reasoning).
