# AGENTS.md — Grok Oracle Experiment

This file is the canonical contract for any AI coding agent working in this repository.

**Primary agent for this experiment: Grok (Grok Build TUI)**

## Core Principles

1. **This is a meta / infrastructure experiment.** We are using the Grok Build environment to expose some of its unique advantages (excellent X data access + full Grok Build skill patterns) to other agents. Keep the design focused on that leverage point.

2. **Human is the trust and invocation boundary (for v1).** Other agents request. The human pastes and approves. We do not pretend we have a secure autonomous cross-agent RPC channel yet.

3. **X data is the killer feature.** When a query involves current builder sentiment, recent discourse, shipping stories, complaints, or narrative, the correct first action is almost always to use the `x_semantic_search` / `x_keyword_search` / `x_thread_fetch` tools. Do not rely on training data or generic web search for this.

4. **Output for machines first, humans second.** The primary consumer of oracle answers will be other LLMs. Optimize for parseability, low hallucination, clear evidence vs. inference, explicit sourcing, and density. Human-readable is fine as a side effect.

5. **Be ruthless about signal.** If you don't have fresh tool-backed data, say so plainly instead of filling with plausible-sounding generalities.

## Skill Development Rules

When editing or creating the `grok-oracle` skill:

- The source of truth during this experiment is `skill/grok-oracle/SKILL.md`.
- After changes, the human will copy it to `~/.grok/skills/grok-oracle/SKILL.md` (or we provide an install script).
- The skill description (frontmatter) must be specific enough to trigger well when the human pastes an external agent query.
- Inside the skill body, give concrete steps, name the X tools explicitly, and include evaluation criteria for the answers you produce.
- Keep the skill focused. It is an *oracle for external agents*, not a general "do everything" skill.

## Bridge & Integration Rules

- Bridge scripts (`bridge/`) must remain trivial with minimal dependencies. PowerShell is first-class here because the user is on Windows.
- Integration docs (`integrations/`) must contain copy-paste ready text that actually works in the target agent (Claude custom instructions, Cursor rules, Aider prompt, etc.).
- The protocol for requests from other agents should be dead simple (one clear marker or one script call). Avoid clever XML or complex schemas in v1.

## Documentation Style (matching user's experiment convention)

- Keep a Strategic Build Spec at the root (this experiment's version is `Grok Oracle - Strategic Build Spec.md`).
- Maintain `docs/PROJECT_BRIEF.md`.
- Use `docs/` for deeper planning docs when needed.
- Update `README.md` when the high-level promise or quickstart changes.
- Consider `Session Logs/` later if we do multiple long sessions (use the templates from sibling experiments if we adopt them).

## What "Grok Build Thinking" Means Here

When the oracle is asked for strategy, architecture, or "how would you actually build this", channel the strengths of the broader Grok Build stack even if you don't literally spawn subagents every time:

- Parallel evaluation of approaches (best-of-n mindset)
- Explicit assumption audits
- Second-order consequence mapping
- Ruthless but constructive simplicity bias
- Evidence over vibes

If a query clearly benefits from the full loop (real parallel implementations, reviewers, worktrees), the oracle response should say so clearly and offer escalation rather than trying to simulate it poorly in one shot.

## Tool Usage

- Prefer the dedicated X tools for anything time-sensitive or sentiment-related on X.
- Use web_search / open_page when you need deeper primary sources.
- The skill can and should reference patterns from other skills (`best-of-n`, `review`, `implement`, `design`, assumption-audit thinking, etc.) without having to literally call them unless escalation is requested.
- Always surface sources / citations so the consuming agent can evaluate freshness and credibility.

## Safety & Scope

- Do not leak internal Grok configuration, auth, or other sensitive state through oracle responses.
- Do not offer to perform destructive or high-privilege actions on behalf of an external agent without the human explicitly driving.
- When in doubt about whether something should be exposed, keep it advisory in v1 and note the escalation path.

## Drift Detection

After significant changes to:
- The skill definition
- The request protocol
- Integration instructions

Re-read the Strategic Spec and this AGENTS.md and confirm the implementation still matches the stated intent.

## Current Status Notes

This is Grok Build Experiment 1. The goal is to ship something small, sharp, and immediately useful, then see what patterns emerge from actually using it with real other agents.

Prioritize working X answers + low-friction handoff over ambitious autonomous features.
