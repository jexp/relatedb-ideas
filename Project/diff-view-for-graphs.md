---
type: Project
name: diff-view-for-graphs
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Ink & Switch]]"
RELATED_IDEA:
  - kind: variant
    reason: another read-side view of how a graph changed over time
    target: "[[Project/animated-graph-timelapse]]"
  - kind: complements
    reason: the edit session whose checkpoints this diff reviews before commit
    target: "[[Project/direct-manipulation-graph-editor]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/cr-sqlite]]"
  - "[[Technology/sqlsync]]"
---

# Diff View for Graphs

> Two checkpoints of the same store, visualized as a diff: added/removed/changed
> nodes and edges. The merge-conflict view for data.

## What

Git taught everyone to read changes as diffs; graphs have no equivalent. This is
it: open two checkpoints (or two `.cl` files, or two points in the WAL) of the
same store, and see what changed — nodes added (green), nodes removed (red),
properties and edges changed (amber) — as a subgraph view, not a text file.
The diff is itself queryable: "show me everything that changed in the
`Company` subgraph since Tuesday," "which edges' weights moved more than 10%?"

Under the diff view sits a diff *engine*: pairwise entity matching (by ID where
checkpoints share IDs, by key/label where they don't), property-level
comparison, and a change-set materialized as its own graph — `:Added`,
`:Removed`, `:Changed` nodes linked to both before and after versions. Once
changes are graph-shaped, the operations Git does with text become Cypher:
blame ("which ingest run created this node"), bisect ("which checkpoint between
these two first added this edge?"), and review ("show me the change-set, ranked
by blast radius — nodes whose removal broke the most paths").

The immediate audience is data curation: you edited a graph all day (manually, or
an agent did, or a pipeline pulled new data) — before you commit the checkpoint,
you read the diff.

## Why RelateDB

The WAL + Parquet checkpoint model is the substrate: durable points in time are
already first-class artifacts, so "diff these two checkpoints" is comparing two
things the engine natively produces — no CDC log, no triggers, no shadow tables
to build. The in-memory store means both sides of the diff can be resident at
once (two stores open simultaneously, or a checkpoint loaded beside the live
one) and matched at scan speed rather than through a server round trip per
entity. The diff result-set itself flows through the existing formatters (a
table for review, JSON for tooling) and into any viz through the adapters. And
the cookbook format gives the regression harness: recorded before/after pairs
checked in CI, so the diff engine is tested like the engine is.

## What it needs

- Checkpoint/WAL loading of two versions into one comparison context
- An entity-matching layer: shared IDs, then key/label fallback, with explicit
  rules for "renamed vs. deleted+added"
- Change-set materialization as a queryable graph (`Added`/`Removed`/`Changed`)
- The view: three-color subgraph rendering + a sortable table pane
- Downstream tools: blame over ingest provenance, checkpoint bisect, a
  `--dry-run`/review gate for pipelines and agent writes

## Lineage & inspiration

- Git's diff/blame/bisect model — the interaction vocabulary users already know
- RelateDB's WAL + Parquet checkpoint durability — the two-sides-of-the-diff
  artifacts, already first-class
- [cr-sqlite](https://github.com/vlcn-io/cr-sqlite) and
  [sqlsync](https://github.com/orbitinghail/sqlsync) — change over time as the
  core data model; the diff engine is the read-side of the same idea
- [Obsidian's graph diffing and the local-first sync lineage](https://www.inkandswitch.com/local-first/)
  — why data changes need human-reviewable views
