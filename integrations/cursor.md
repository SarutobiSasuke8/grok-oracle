# Grok Oracle Integration for Cursor

## Best Pattern: Cursor Rules (or .cursorrules / Project Rules)

Add the following (or a condensed version) to your Cursor project rules or a dedicated rule file. This makes the Cursor agent proactively use Grok Oracle when appropriate.

### Recommended Rule Text

```
You can consult "Grok Oracle" (the user's Grok Build TUI with privileged X tools and strong build strategy patterns) as an external specialist.

Call it when:
- You need current builder sentiment or recent high-signal discussion from X/Twitter that you don't have fresh visibility on (AI coding tools, agent workflows, MCP, local dev setups, model releases, shipping stories, complaints, etc.).
- The task would benefit from Grok-style analysis: comparing multiple approaches in parallel, explicit assumption audits, second-order risks, or strong simplicity bias.
- You want fresh external research before making a big recommendation.

Invocation (preferred):
Use the bridge script via shell:
pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" -FromAgent "cursor" "<precise question>"

If shelling out is not practical in the current context, emit this exact marker and stop:

GROK-ORACLE-QUERY:
<the question — include time windows, specific constraints, or the options being considered when relevant>

The human will run it in the Grok TUI (using the grok-oracle skill) and paste the structured result back to you.

Treat oracle responses as high-value context. Pay attention to sources, dates, and any escalation offers at the end. You are encouraged to use this capability proactively rather than guessing on topics where X signal or different strategic thinking would clearly help.
```

## Alternative: Custom Command (if Cursor supports agent commands)

Create a custom command like "Ask Grok Oracle" that injects the above logic and forces the agent to produce either a bridge call or a marked query block.

## .cursorrules Snippet (lighter version)

If you prefer a short `.cursorrules` at the root:

```
When you need fresh X/Twitter builder signal or a Grok Build style second opinion (parallel approaches, assumption audits, etc.), call the Grok Oracle bridge:

pwsh -File "C:\Dev\Experiments\Grok Build Experiment 1\bridge\grok-oracle.ps1" -FromAgent "cursor" "YOUR QUESTION"

Or output a GROK-ORACLE-QUERY: block and stop for the human to handle.

Use this proactively on anything involving current sentiment, recent discourse, or complex strategic tradeoffs.
```

## Practical Tips in Cursor

- The Cursor agent is often very aggressive about using tools it knows about. Once the rule is in place, it will start calling the bridge naturally.
- For queries about "what are people actually experiencing", add time scoping in the rule guidance or in individual prompts ("in the last 5 days", "since the latest release").
- After an oracle response comes back, you can continue the thread and ask the human for a follow-up oracle call with refined focus if the first answer surfaces new questions.

This is one of the highest-leverage ways to combine Cursor's excellent in-editor agency with Grok's unique external signal and thinking style.
