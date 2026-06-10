---
title: "Grok Oracle — Skill + Bridge for Other Coding Agents"
type: strategic_build_spec
category: "Grok Build Infrastructure / Meta Tooling"
difficulty: "Medium"
build_order: 1
time_to_mvp: "1-2 focused sessions"
status: "in_progress"
version: "0.1"
primary_user: "The human running Grok Build TUI + any other coding agents they work with (Claude, Cursor, Aider, etc.)"
---

# Grok Oracle — Let Other Agents Query Grok (Especially for X Data)

## One-Line Thesis

Create a first-class Grok skill (`grok-oracle`) plus a small bridge + integration layer so that other coding agents can reliably "ask Grok" — with full access to privileged X search tools and Grok Build thinking patterns — and get back structured, high-signal, citable answers they can actually use.

## Core Identity

This is **infrastructure for agent collaboration**. It is not a consumer product. It is a power tool for people who already run multiple agents and want to give the weaker X/build-intelligence parts of the stack access to the strongest part (this Grok environment).

## The Real Problem

- Claude, Cursor, Aider, Cline, etc. are excellent at code, planning, and editing inside their context.
- They are **weak** at real-time, high-quality social signal from X (builder Twitter is still one of the best sources for "what's actually working / broken right now" in AI tooling and shipping).
- They cannot easily run true parallel implementation tournaments or the full Grok Build review/assumption/second-order loops with the same fidelity.
- Copy-pasting context manually is lossy and annoying.

Result: a huge amount of valuable signal and thinking style is locked inside the Grok Build TUI and not accessible to the rest of the user's agent workflow.

## Strategic Wedge

Be the **X oracle + Grok Build specialist** that other agents can call when they know they're out of their depth on signal or on deep strategy.

Win by:
1. Making the X data (semantic search, recent discourse, key threads, builder sentiment) trivially accessible.
2. Returning answers in a format that is *optimized for another LLM to consume and act on* (not fluffy human prose).
3. Providing a reliable, low-friction invocation path (skill for the human + bridge script for the other agent).
4. Keeping the door open for escalation ("if you want me to actually run a best-of-n or spawn subagents on this, say the word").

## Non-Goals (MVP)

- No direct machine-to-machine RPC between arbitrary agents in v1 (human is the trust/approval boundary).
- No exposing raw internal tools or the full subagent spawn capability without explicit human presence (safety + scope).
- Not trying to be a general "Grok API" replacement. Focused on the unique advantages this environment has.

## MVP Scope

**Must ship:**

1. A production-quality `grok-oracle` skill in `~/.grok/skills/grok-oracle/SKILL.md`.
2. The skill must be *extremely good* at:
   - Detecting and handling queries originating from another coding agent.
   - Aggressively using the X tools (`x_semantic_search`, `x_keyword_search`, `x_thread_fetch`, `x_user_search`) when relevant.
   - Producing clean, sectioned, evidence-backed output with proper citations.
   - Calling out assumptions and offering deeper Grok Build services.
3. A small, reliable bridge script (PowerShell first, since user is on Windows) that another agent can shell out to. Primary job: take a natural language query and produce a ready-to-paste block + instructions for the human ("Paste into Grok TUI and run /grok-oracle").
4. Integration documentation + copy-paste snippets for at least:
   - Claude (custom instructions / project knowledge / commands)
   - Cursor (rules or custom command)
   - A general "protocol" any agent can follow.
5. A small set of high-quality example queries + golden outputs in `examples/`.
6. Proper experiment docs (this spec, Project Brief, AGENTS.md, README).

**Stretch / immediate follow-up:**

- Headless-friendly invocation (a script that can call `grok -p` with the oracle rules injected so the human doesn't even need to switch windows for simpler queries).
- A tiny local HTTP/stdio bridge (Phase 2, could become a local MCP server later).
- Support for the other agent to request "escalated" actions (e.g. "run best-of-n on this approach and report back the winner summary").

## Ranked Priorities

1. **X data quality and freshness** — this is the unique moat. If the X answers are not dramatically better than what the other agent can do on its own, the whole thing is weak.
2. **Output format for LLMs** — structure, evidence, low hallucination, clear sourcing, explicit uncertainty.
3. **Frictionless handoff** — the other agent must be able to request help with almost zero extra work for the human.
4. **Build expertise** — when the query is about architecture, process, tradeoffs, or "how would Grok actually build this", the response must feel like it came from the full Grok Build loop (even if it doesn't literally spawn 5 subagents every time).
5. Documentation and adoption ease for the integrations.

## Core User Flows

**Flow A — Other agent proactively asks (most important)**
1. While working, Claude/Cursor/etc. decides it needs signal it doesn't have (X sentiment, recent builder takes, a deep Grok-style review).
2. It outputs a clearly marked request (e.g. `GROK-ORACLE-QUERY: ...` or calls the bridge script).
3. Human sees it, pastes into Grok TUI (or the bridge already formatted it nicely).
4. Human runs `/grok-oracle`.
5. Grok (with the skill loaded) does the X searches + thinking, returns a tight, citable answer.
6. Human pastes the result back to the other agent.
7. Other agent continues with much better information.

**Flow B — Human directly uses it**
- Human has a hard X research or build strategy question and just runs `/grok-oracle ...` themselves. The skill makes this experience excellent.

**Flow C — Escalation**
- The oracle response ends with "If you want me to treat this as a full build task and run parallel approaches / spawn reviewers / etc., reply with ESCALATE and the task."

## Success Criteria

- A real query from another agent about recent X builder sentiment returns genuinely useful, fresh, sourced signal that the other agent couldn't have easily gotten itself.
- The returned answer is easy for the other LLM to parse and act on (clear headings, bullet evidence, explicit "Sources / Citations" section).
- Installing the skill + dropping the integration text into Claude/Cursor takes < 5 minutes and "just works".
- The skill itself is a model of how to write high-agency Grok skills (clear steps, tool references, evaluation criteria inside the prompt).

## Output Contract (what the skill must produce)

For every response the skill should aim for:

- Short, high-density prose.
- Explicit sections: `## Summary`, `## Key Signals / Evidence`, `## Builder Sentiment`, `## Risks / Open Questions`, `## Sources` (with dates and links where possible).
- Use of the render citation style where applicable, or clean markdown equivalents.
- Clear separation between "observed on X", "inferred", and "my Grok Build opinion".
- An "Escalation / Next Actions" block at the end.

## Technical Notes

- The skill will live primarily as a **user skill** (`~/.grok/skills/grok-oracle/SKILL.md`) so it is always available.
- Source of truth for the skill during development lives in this experiment folder under `skill/grok-oracle/SKILL.md`.
- The bridge scripts should be trivial (no heavy dependencies). PowerShell + optional Node/Python fallback.
- We should be thoughtful about not leaking anything sensitive through the oracle channel.
- Because this is running inside the privileged Grok Build TUI, we get the real X tools (not whatever limited search the public API or other models have).

## Open Questions

- [ ] Should the bridge script attempt a direct `grok -p` headless call for low-stakes queries (with the oracle rules pre-injected), or always go through the interactive TUI for human visibility?
- [ ] How much "full Grok Build power" (actual subagent spawning, best-of-n, worktrees) do we expose in the first version vs keeping it advisory only?
- [ ] Do we also produce a standalone prompt file that can be used with any `grok -p` invocation even without the skill being installed?

## References

- User's existing experiment patterns (Agent Grove, AI QA Bot, Live Website Critic, etc.)
- `~/.grok/docs/user-guide/08-skills.md`
- The X search tools available in this environment
- The `best-of-n`, `implement`, `review`, `design`, `assumption-audit`, `second-order` thinking patterns
