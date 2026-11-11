---
type: Project
name: cambria-for-graphs
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Ink & Switch]]"
RELATED_IDEA:
  - kind: complements
    reason: explicitly the cross-system twin of this cross-time lens
    target: "[[Project/graph-lens-over-any-database]]"
USES_TECH:
  - "[[Technology/Cambria]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
---

# Cambria for Graphs

> Schema evolution as a stored lens graph: every schema version a node,
> bidirectional lens edges between them — old data never becomes unreadable,
> and the migration history travels inside the file it describes.

## What

Schema migration tools — [Liquibase](https://www.liquibase.org/) (with
[liquibase-neo4j](https://github.com/liquibase/liquibase-neo4j)),
[neo4j-migrations](https://github.com/michael-simons/neo4j-migrations), and
the [neocarta](https://github.com/neo4j-labs/neocarta) data-model lineage —
express schema change the relational way: an ordered list of one-way
migration scripts, applied once, forward only. It is a *timeline you must
walk*, and once you've walked it, data at the old versions is effectively
unreachable: a v1 dump and a v5 database are two different worlds, connected
only by the pile of scripts nobody re-runs.

The Cambria move (Ink & Switch's lens paper) replaces the timeline with a
*graph of schemas*: each version is a node (`(:SchemaVersion)`), each change
is a **bidirectional lens edge** — a stored transformation that can read old
data in the new shape and write new data back into the old shape. A query
against a v1 checkpoint routes through the lens chain (shortest path v1 →
current) automatically; a v5 write meant for a v2 consumer goes back through
the inverse. Nothing is orphaned because nothing is one-way.

For a single-file graph engine this lands somewhere special: **the evolution
history lives inside the `.cl` file, next to the data it describes**. A
dataset you receive at v3 carries the lenses to v5 and back — the file
presents its current schema everywhere while preserving every version it has
ever been. Round-tripping (Cambria's bidirectionality requirement: compose
forward, invert, and check you got back what you started with) is the
validation harness that keeps lenses honest.

## Why RelateDB

The catalog already models labels, relationship types, and property keys as
first-class data — a schema *version* is one more thing it can store, and
the lens chain is itself a graph the engine queries natively (this is the
Meta section's "graphs about graphs" pattern at work). A lens is stored
Cypher — `DEFINE PROCEDURE` (the local-callables preview) is exactly the
mechanism for an authored, named, parameterized transformation riding inside
the store — and the WAL records when each lens was minted, so the evolution
has provenance. Checkpoints are the natural version boundary: lens
composition happens at open/traversal time over a checkpoint, and the
`.cl` portability promise gains a time axis — the
[Graph Lens over Any Database](graph-lens-over-any-database.md) is a lens
across *systems*; this is a lens across *time*.

## What it needs

- The `(:SchemaVersion)` / lens-edge schema, with lens edges carrying the
  transformation (stored Cypher, local-callables) in both directions
- Lens composition: routing a query on old data through the shortest lens
  chain — query rewriting at the catalog level, or materialize-on-traversal
  with the inverse for writes
- The round-trip validation harness (bidirectionality is a property you can
  *test*, not just promise)
- Authoring UX: generate a draft lens by diffing two versions' catalogs;
  agents authoring lenses over MCP with the validation harness as the gate
- A story for lenses too hard to invert (flagged as one-way, so the chain
  stays honest — an explicit `:IRREVERSIBLE` mark, not a silent gap)

## Lineage & inspiration

- [Cambria: Translate your data with lenses](https://www.inkandswitch.com/cambria/)
  (Ink & Switch, 2020; code: [cambria](https://github.com/inkandswitch/cambria))
  — bidirectional lenses as an isolated translation layer; lenses form a
  graph and Cambria routes through it — this project is that graph, held in
  the graph database the data lives in
- [Liquibase](https://www.liquibase.org/) /
  [liquibase-neo4j](https://github.com/liquibase/liquibase-neo4j) and
  [neo4j-migrations](https://github.com/michael-simons/neo4j-migrations) —
  the migration tradition this project upgrades from timeline to lens graph:
  their change vocabulary (changesets, checksums, applied-order) is the
  starting point for what a lens edge records
- [neocarta](https://github.com/neo4j-labs/neocarta) — the data-model/semantic
  layer lineage; schema-as-graph is also a data-model question, not only a
  migration question
- `research/ink-and-switch-catalog.md` — the full essay/project catalog
- [Graph Lens over Any Database](graph-lens-over-any-database.md) — the
  cross-system twin; this is the cross-time lens
