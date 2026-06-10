# Grok Oracle Integration for Aider

## Approach

Aider has strong support for shell commands and custom instructions.

The simplest reliable pattern is:

1. Add guidance in your Aider custom instructions / `.aider.conf.yml` or the equivalent prompt additions.
2. When Aider needs external signal, it will either run the bridge script directly (if allowed) or emit the `GROK-ORACLE-QUERY:` marker.

## Custom Instructions Text

Add something like this to Aider's instructions for the session or repo:

```
You have access to an external specialist called Grok Oracle via the user's Grok Build setup.

Use it for:
- Fresh high-quality X/Twitter signal on what real builders are saying and shipping (especially AI tools, agents, workflows, MCP, etc.).
- Strategic reviews that would benefit from parallel thinking, assumption audits, or second-order analysis.

To invoke:
- Best: shell out using the bridge (the human has configured shell access):
  pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" -FromAgent "aider" "Your precise question"

- Fallback: output a block like this and stop so the human can paste it into the Grok TUI:

GROK-ORACLE-QUERY:
<question>

After the result is pasted back, use it as authoritative fresh context. Note the sources and any escalation suggestions.

Be proactive about using this when your own knowledge of current discourse or a different strategic lens would clearly improve the outcome.
```

## Practical Usage with Aider

- You can explicitly ask Aider in chat: "Ask Grok Oracle what the recent builder reaction has been to local-first agent tooling."
- Or rely on the instructions to make Aider do it automatically when it detects a relevant knowledge gap.
- Because Aider is very good at running terminal commands, the bridge script path tends to work cleanly.

## Follow-ups

Aider can easily continue the conversation after the oracle result is returned. It can also request a second oracle call with more context or a narrower focus ("take the concerns from the previous oracle answer and find recent X examples of teams that solved them").

This pairing (Aider's excellent git-aware editing + Grok Oracle's X + strategy) is particularly strong for greenfield or high-uncertainty work.
