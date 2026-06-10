# Grok Oracle — Project Brief

This is the project context agents should read before architecture, skill design, bridge implementation, or documentation work.

## Summary

Grok Oracle is a skill (`grok-oracle`) plus supporting bridge and integration layer that lets other coding agents reliably ask *this* Grok instance for things it is unusually good at — especially real-time high-quality X/Twitter builder signal and Grok Build-style deep strategy / parallel thinking / assumption audits.

The human remains in the loop as the invocation and trust boundary. Other agents (Claude in Cursor, Aider, Cline, etc.) are taught a simple protocol or given a small CLI helper so they can request help with almost zero friction. Grok (with the skill active) returns dense, evidence-backed, LLM-optimized answers that the other agent can immediately use.

## Vibe

- Sharp, no-bullshit, high signal-to-noise.
- Feels like calling a very senior, slightly savage staff engineer who also happens to live on builder Twitter and has read every important thread this month.
- Output is optimized for another agent to consume, not for human entertainment (though humans will also love using it directly).
- Anti-vibe: flowery prose, vague "it depends", hiding sources, pretending to have knowledge it doesn't actually have from tools.

## Users

**Primary:**
- The human who runs the Grok Build TUI and also uses one or more other coding agents in their daily work.

**Secondary (the actual callers):**
- Claude (especially in Cursor or Claude Code / Projects)
- Cursor's agent
- Aider
- Cline, Windsurf, Zed with agent features, etc.

The system must make it natural for these agents to decide "I should ask Grok Oracle about this" and then do so with minimal ceremony.

## Problem

Other agents are great at local code reasoning and editing but are information-starved on:
- Fresh, high-quality builder sentiment and narrative on X.
- The specific flavor of ruthless, first-principles, parallel-evaluation thinking that the Grok Build skill set enables.

Manually copy-pasting long contexts back and forth is lossy and breaks flow. There is no standard, repeatable way for the user's "agent team" to consult the member that has the best X access and build meta-skills.

## Product Promise (for the human)

Within one minute of another agent deciding it needs help, the human can:
1. See a clean, marked request from the other agent.
2. Paste (or have the bridge already format) it into the Grok TUI.
3. Run `/grok-oracle`.
4. Get back a tight, sourced, actionable answer.
5. Paste that answer back to the other agent and continue.

Direct use by the human (`/grok-oracle <hard question about X or architecture>`) should also feel excellent.

## Core Workflows

1. **Proactive request from another agent** (the money flow)
   - Agent detects knowledge gap (especially around current X discourse or complex tradeoffs).
   - Agent emits a `GROK-ORACLE-QUERY:` block or calls the bridge script.
   - Human invokes the skill.
   - Structured response comes back.

2. **Direct human use**
   - Human has a research or strategy question and invokes the skill explicitly.

3. **Escalation**
   - Oracle response surfaces that the query would benefit from full subagent work, best-of-n, or a design/implement/review loop, and offers a clear path to do it.

## Success Criteria

- X answers are *noticeably* better (fresher, more relevant threads, better synthesis) than what the calling agent could produce on its own.
- Returned artifacts are highly structured and low-hallucination (clear evidence vs inference, dates, links, explicit uncertainty).
- Integration into at least two major other agents (Claude + Cursor or Aider) is copy-paste simple and documented.
- The skill is itself a great example of a focused, high-leverage Grok skill (clear steps, tool references, evaluation guidance inside the prompt).
- The whole experiment folder follows the user's established "vibe coding experiment" conventions (strategic spec, project brief, AGENTS.md, session logs potential, etc.).

## Non-Goals

- Full autonomous machine-to-machine calling without the human (v1).
- Exposing raw dangerous capabilities (arbitrary subagent spawning, file system writes on the main workspace, etc.) to external agents without strong guardrails.
- Building a general-purpose Grok API or competing with official xAI offerings.
- Complex auth or multi-user scenarios.

## Constraints

- Must work on the user's current Windows + PowerShell setup.
- Bridge should have minimal or zero external dependencies.
- The skill must be installable as a normal user skill under `~/.grok/skills/`.
- Leverage existing tools (`x_*` search tools, web tools, the other skills' patterns) rather than reinventing.

## Quality Gates

- At least 5 realistic example queries (mix of pure X research + build strategy) produce good output when the skill is active.
- The integration docs are accurate enough that a fresh user can get Claude or Cursor successfully requesting help in one try.
- No sensitive internal state or credentials are at risk of leaking through the oracle channel.
- The skill description is specific enough for good automatic invocation when the human pastes an external query.

## Technical Notes & Architecture Sketch

- Primary artifact: `skill/grok-oracle/SKILL.md` (source here, installed to user skills).
- Bridge: small scripts in `bridge/` (start with PowerShell because of the Windows environment). Main responsibility is formatting a clean handoff for the human.
- Integrations: self-contained markdown files in `integrations/` that a human can drop into the target agent's custom instructions / rules / commands.
- The skill instructions should explicitly tell Grok to prefer the X tools for any query that smells like "current sentiment", "what are people saying", "recent discourse", "builder reaction", etc.
- Output style guidance inside the skill: favor structure (## headings, bullets, tables for comparisons), explicit sourcing, "for another LLM" density.
- Future evolution path noted: headless direct invocation, local MCP server exposure, escalation to real `best-of-n` / subagent execution.

## Open Questions (to resolve during build)

- Exact trigger format / protocol between other agents and the bridge (keep it dead simple).
- Whether the bridge should attempt direct headless `grok -p` calls for some queries (with oracle rules injected) or always route through interactive TUI.
- How much "I can escalate to full Grok Build power" language to put in the first version.
- Naming (grok-oracle feels right but confirm).

## References

- Strategic Build Spec at repo root
- User's other experiments for documentation and process patterns
- `~/.grok/docs/user-guide/08-skills.md` and related agent/headless docs
- Available X tools in the current Grok Build environment
