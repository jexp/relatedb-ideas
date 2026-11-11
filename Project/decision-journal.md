---
type: Project
name: decision-journal
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_ORG:
  - "[[Company/Obsidian]]"
RELATED_IDEA:
  - kind: complements
    reason: markdown notes as the human surface over the same local graph
    target: "[[Project/obsidian-vfs-native]]"
  - kind: complements
    reason: decisions graded against outcomes, the analytical half of the same record
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Markdown]]"
  - "[[Technology/Obsidian]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
---

# Decision Journal

> The Obsidian-native one — life choices as graph events; retro
> decision-quality queries ("what did I actually know when I chose?").

## What

The decision journal is a beloved Obsidian ritual: write the decision,
the options, the reasoning, the expected outcome — grade it later. Its
weakness is that the entries never talk to each other. This project
makes each decision a graph event: `(:Decision {made, domain,
expected})` with `(:Option)` nodes, edges to the `(:Information)` nodes
available at choice time (docs, messages, advisors' opinions — each
with a known-at timestamp), and later `(:Outcome {graded, actual})`
nodes closing the loop. What you chose, what you knew, what you
didn't, what happened.

The queries make it more than navel-gazing: decisions where the
decisive information existed one hop away at choice time but wasn't
consulted (the "you already knew this" report); decision patterns —
domains where outcomes consistently diverge from expectations
(over-optimism per domain, not per anecdote); and the retro the
README names precisely: for any past decision, "what did I actually
know when I chose?" as a time-windowed neighborhood, so you grade
the *process* (the reasonable choice given what was known) instead of
the *result* — the poker player's lesson, as data.

## Why RelateDB

The whole journal is one private `.cl` file on your disk — no cloud, no
vendor, the most personal dataset there is staying local. Bi-temporal
semantics are the native fit: RelateDB's temporal types separate
*when information became known to you* from *when it was true* from
*when you ingested it* — the exact distinction the retro query needs.
The WAL is the journaling ritual itself: decisions and outcomes append
with fsync durability, never rebuilt, replayable — a life log in the
engine's natural shape. Obsidian integration rides the Obsidian/VFS
idea (markdown entries as the human surface, the graph behind them),
Python bindings ingest notes and exports, and `serve --mcp stdio`
lets an agent run the pattern queries — "before I take this offer,
how have my last five career decisions graded?" — against the record
instead of a flattering summary.

## What it needs

- The decision model: Decision/Option/Information/Outcome with
  known-at, validity and ingestion timestamps kept distinct
- Ingest from existing practices: Obsidian decision-note frontmatter,
  bullet-journal transcriptions, "decided today" emails
- The retro query pack: known-at reconstruction, near-miss
  information, per-domain expectation-vs-outcome grading
## Lineage & inspiration

- Annie Duke, *Thinking in Bets* — deciding well vs. getting lucky;
  grading process over outcome, which is what the retro query encodes:
  https://thinkinginbets.com/
- The Obsidian decision-journal templates the community already keeps
  (and that never talk to each other): https://forum.obsidian.md/
- Farnam Street's decision journal practice — the ritual this project
  instrumented: https://fs.blog/decision-journal/
