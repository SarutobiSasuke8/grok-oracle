# Grok Oracle — Example Queries

These are realistic queries that other agents or the human might send to the oracle. Use them for testing the skill and for documentation.

## Pure X / Builder Sentiment

1. What are actual indie hackers and small teams saying on X about the real friction of shipping local AI coding agents in the last 10 days? Focus on concrete complaints and surprising wins rather than hype.

2. Semantic search for recent (past 2 weeks) high-signal threads from people who have tried building or using custom MCP servers for cross-agent tool access. Summarize the recurring patterns, both positive experiments and the things that turned out painful.

3. Find the most recent posts and threads from vocal builders (especially those who ship a lot) reacting to the latest Claude / Cursor / Aider agent improvements. What actually moved the needle for them vs what is still broken?

## Strategy + X Signal Mixed

4. We are deciding between (A) a local file-watching + stdio MCP server vs (B) a small always-on HTTP/WS bridge so that other coding agents can call into Grok Build capabilities (especially the X tools and parallel thinking). Run a quick assumption audit + second-order consequence analysis, and include any recent X signal from people who have tried similar "agent-to-agent tool exposure" patterns.

5. Our team is considering going all-in on a "one primary agent + oracle specialists" workflow (Cursor/Claude as primary, Grok Oracle for X + deep strategy, maybe others for specific domains). What are builders who have tried multi-agent orchestration patterns actually reporting on X right now? What tends to work vs create more coordination overhead than value?

## Pure Grok Build / Architecture Review Style

6. Give a Grok-style parallel evaluation of three approaches to letting other agents (that the user also trusts) invoke privileged tools from this Grok Build environment without constant manual copy-paste. For each approach note simplicity, security/trust surface, latency, and how well it would survive if the user is only half-paying-attention.

7. We have a large existing "vibe-coded" Next.js experiment with heavy persona docs, AGENTS.md, and multi-agent workflows. We want to add a new capability that lets any of the agents in that ecosystem ask Grok for X research or strategy. What are the second-order risks and hidden complexity if we try to make this fully automatic vs keeping a human in the loop? Include any relevant recent discourse if you can find it.

## Direct Human Use (also great for testing the skill)

8. /grok-oracle What is the current temperature on X among people actually using and extending the Grok Build TUI / skills system? Any interesting experiments or complaints in the last week or two?

9. /grok-oracle Run a quick but sharp assumption audit on the idea that "exposing Grok's X tools to other agents via a simple bridge will be net positive for the user's overall velocity and decision quality."

## Testing Notes

When testing the `grok-oracle` skill:
- Paste the query text after running `/grok-oracle` (or include it on the command line).
- Watch that it actually calls the X tools when the query is sentiment/discourse related.
- Check that the output follows the structured format (Summary, Evidence, Grok Build Take, Sources, Escalation).
- Verify that sources include real recent links or at least usable recency info.
- For mixed queries, confirm it does the X leg first before applying heavy strategic analysis.

Good oracle answers should feel like they contain information the calling agent genuinely could not have produced well on its own.
