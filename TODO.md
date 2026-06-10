# TODO — Grok Oracle Experiment

## Immediate (this session / next)

- [x] Create core project structure and docs (README, Strategic Spec, Project Brief, AGENTS.md)
- [x] Write the `grok-oracle` SKILL.md (source in `skill/`)
- [x] Build initial bridge (`bridge/grok-oracle.ps1` + README)
- [x] Write integration guides for Claude, Cursor, Aider, and general protocol
- [x] Add example queries
- [ ] Install the skill to `~/.grok/skills/grok-oracle/SKILL.md` so it is live
- [ ] Test the skill with several real queries from `examples/sample-queries.md` (especially X-heavy ones)
- [ ] Verify that X tools are being used and output is well-structured for LLM consumption
- [ ] Add a small install helper script (`scripts/install-skill.ps1`)
- [ ] Update README with accurate "how to install and use" steps once tested
- [ ] Add a short "Session Log" entry or note the first real usage

## Soon

- Polish the skill instructions based on real test runs (what worked, what was too verbose, what the other agents actually needed).
- Decide on direct headless bridge path vs always-interactive (document the decision).
- Consider a tiny cross-platform bridge (Node or Python) for non-Windows users / other agents.
- Explore whether we want a local MCP server exposure in a follow-up experiment (would be a natural evolution of this).
- Add more integrations if new agents become relevant (Zed, Cline, Windsurf, etc.).

## Later / Nice to Have

- Ability for the oracle to "escalate" and actually trigger a `best-of-n` or subagent run on the user's behalf (with strong human confirmation gates).
- Persistent memory of "what kinds of questions this user (or their agents) ask the oracle most" so future answers can be even more targeted.
- Metrics / light logging of oracle usage (purely local) to see which integrations get the most value.

## Notes

Keep scope tight for Experiment 1. The goal is a working, delightful skill + bridge that the user can actually use with their other agents tomorrow, not a complete autonomous agent economy.
