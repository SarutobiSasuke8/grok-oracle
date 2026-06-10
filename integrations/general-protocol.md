# Grok Oracle — General Protocol for Other Agents

When you (as another coding agent) encounter a situation where you would benefit from:

- Fresh, high-quality signal from X/Twitter (builder sentiment, what indie hackers are actually shipping and struggling with, recent discourse on tools, models, or practices)
- A second opinion in the specific "Grok Build" style (parallel evaluation of approaches, explicit assumption audits, second-order consequence thinking, ruthless simplicity bias)
- Someone with different tool access doing a targeted research pass

...you should request help via Grok Oracle.

## Two Ways to Request

### 1. Preferred: Call the bridge script (when you can shell out)

The human will have placed the bridge somewhere accessible (e.g. inside this experiment folder or copied to a stable location).

Example (PowerShell on Windows):

```powershell
pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" `
     -FromAgent "your-agent-name" `
     "Your actual question or task here. Can be multiple sentences."
```

The script will output a clean handoff block. Stop after emitting the call — the human will handle the paste and bring the result back to you.

### 2. Fallback: Emit a clearly marked query block

If you cannot reliably shell out, just output a block like this and stop:

```
GROK-ORACLE-QUERY:
What are actual builders saying on X about the friction of local MCP servers vs custom bridges for cross-agent tool use in the last 10 days? Include both positive experiments and the recurring complaints.
```

The human will recognize the marker and invoke `/grok-oracle` with the content.

## What Kind of Queries Work Well

Good:
- Anything with "on X", "builders are saying", "recent sentiment", "indie hacker reaction", "what's the discourse".
- Architecture or process questions where a different thinking style + fresh signal would help ("compare these three approaches", "what are the second-order risks of...", "run an assumption audit on...").
- "Find the most recent high-signal threads from people who have actually shipped X".

Less ideal (but still okay):
- Pure code editing or local file reasoning (you are probably better at this in your own context).
- Things that require deep access to the user's private codebase or secrets (the oracle is advisory).

## What You Will Get Back

A structured response (usually with sections like Summary, Key Signals / Evidence, Grok Build Take, Sources, Escalation).

It is intentionally written to be easy for an LLM to parse and act on. Treat the "Sources" section seriously — it will often contain real recent links and dates.

## Escalation

Many oracle responses will end with an "Escalation / Next Steps" block. If the answer suggests that a full parallel implementation, multi-reviewer pass, or deeper design loop would be valuable, you can ask the human to take the next step with Grok directly (e.g. "run best-of-n on the top two approaches from the oracle analysis").

## Tips for Good Results

- Be specific about time windows when recency matters ("in the last 7 days", "since the latest model drop").
- Include the actual constraints or decision criteria you care about.
- If you're asking for a strategy review, briefly summarize the two or three options you're actually considering.
- You can follow up — the human can run another `/grok-oracle` with more context or a refined question.

This is deliberately lightweight and human-mediated in v1. The goal is to give you access to signal and thinking style you wouldn't otherwise have, with almost zero extra work for the human.
