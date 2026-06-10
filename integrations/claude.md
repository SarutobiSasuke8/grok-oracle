# Grok Oracle Integration for Claude (Claude Code, Projects, Cursor Claude, etc.)

## Recommended Approach

Add the following as **Project Knowledge**, **Custom Instructions**, or a **slash command / skill** in Claude.

The goal is to make Claude naturally decide to call Grok Oracle when it hits the limits of its own X visibility or wants a different strategic lens.

## Text to Add (Custom Instructions / Project Rules)

```
You have access to a powerful external oracle called "Grok Oracle" (part of the user's Grok Build environment).

Use it when any of these are true:
- You need fresh, high-quality signal from X/Twitter about what builders are actually saying, shipping, or struggling with (especially around AI tooling, coding agents, MCP, local setups, new model releases, etc.).
- A question would benefit from real-time builder sentiment or recent high-signal threads that you don't have strong visibility into.
- The user or the task would benefit from a "Grok Build" style analysis: parallel evaluation of approaches, explicit assumption audits, second-order consequences, or a ruthless simplicity bias.
- You want a second opinion from a different tool surface before committing to a big architectural recommendation.

How to invoke:
1. Prefer shelling out to the bridge when possible:
   pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" -FromAgent "claude" "Your precise question here"

2. If you cannot shell out reliably, output a clearly marked block and stop so the human can handle it:

GROK-ORACLE-QUERY:
<your actual question or task — be specific and include time windows or decision criteria when relevant>

After the human pastes the result back to you, treat it as high-value fresh context. Pay special attention to the Sources section and any explicit assumptions or escalation offers.

You are allowed (and encouraged) to use this oracle proactively. Do not wait for the user to tell you to use it.
```

## Alternative: As a Slash Command / Custom Command

If the environment supports custom commands (Claude Code, some Cursor setups, etc.), you can register something like:

**Command name:** `/grok-oracle` or `/ask-grok`

**Prompt template:**

```
You are about to consult Grok Oracle on behalf of the user.

Craft a precise, self-contained query that captures what we need from Grok (especially X signal or Grok Build strategic thinking).

Then output it using the bridge or the GROK-ORACLE-QUERY: marker as described in the project knowledge.

Query focus: {{user will fill or you infer from context}}
```

## Tips for Claude

- Claude is often quite good at knowing when its knowledge is stale on social/technical discourse. Lean into that.
- When asking about "what are people saying", explicitly tell the oracle the time window and the sub-community if you know it ("indie hackers shipping AI tools", "people actually using MCP in production", etc.).
- After receiving an oracle response, you can ask the human to run a follow-up oracle query with more context if needed ("take the top two approaches from the previous oracle answer and compare them on long-term maintenance burden").

This integration turns Claude + Grok into a small complementary team rather than two isolated agents.
