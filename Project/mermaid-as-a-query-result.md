---
type: Project
name: mermaid-as-a-query-result
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/GitHub]]"
RELATED_IDEA:
  - kind: complements
    reason: diagram-as-query-output habit applied to every result set
    target: "[[Project/architecture-diagram-that-never-lies]]"
  - kind: inspired-by
    reason: same query-in-prose-rendered-result authoring shape
    target: "[[Project/graphgists-reborn]]"
  - kind: complements
    reason: EXPLAIN trees rendered as flowcharts by the same formatter
    target: "[[Project/query-plans-as-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
---

# Mermaid as a Query Result

> `RETURN mermaid(path)` — any Cypher result renders as a live diagram for docs,
> issues, and slides.

## What

A result formatter that emits Mermaid instead of (or beside) a table. Path
results become `flowchart` sequences; a handful of node/relationship rows become
a small `graph LR` diagram; a chain of steps becomes `sequenceDiagram`. The
output is plain text, which is the point: paste it into a GitHub issue, a PR
description, a README, a slide, or the cookbook — anywhere that already renders
Mermaid — and the diagram is live, reviewable in diffs, and diffable itself.

The function shape matters: it composes with everything. `MATCH path = ... RETURN
mermaid(path)` renders one path; `MERGE` a few nodes and return the subgraph, get
the schema diagram; wrap an `EXPLAIN` tree and get the plan as a flowchart. Because
Mermaid is generated from the result set, the diagram never drifts from the query —
rerun and the diagram updates, commit it and it's pinned.

This is the "diagram as query output" habit from the architecture-diagram world,
applied everywhere: the diagram stops being a hand-drawn artifact someone
maintains and becomes a view over the graph, regenerated on demand.

## Why RelateDB

RelateDB already has a formatter crate for exactly this shape of work — table,
CSV, JSON, JSONL are output modes over result sets, so `mermaid` is a new writer
in an existing extension point, not a new pipeline. The cookbook format is the
natural first consumer: cookbook markdown already renders recorded results and
Mermaid diagrams (the diagram render step exists), so a cookbook recipe can show
a query *and* its live diagram side by side, recorded and checked by the same
gate. And `db.schema.visualization` gives the killer one-liner: it already returns
the schema as virtual nodes + relationships, so `CALL db.schema.visualization()
YIELD * RETURN mermaid(...)` renders your schema as a diagram with zero extra
modeling. Docs, issues, and slides get free diagrams from a single binary that
runs anywhere — including the WASM build for in-tab rendering.

## What it needs

- A `mermaid(...)` result function (or formatter mode) in the formatter crate:
  paths → flowchart, rows → graph, trees → flowchart/sequence
- Escaping/label-truncation rules (Mermaid chokes on some node text)
- Cookbook integration: record the diagram beside the table result, parity-checked
- Docs: which result shapes map to which diagram types
- Optional CLI flag (`--mode mermaid`) so shell users can pipe diagrams straight
  into files

## Lineage & inspiration

- [Mermaid](https://mermaid.js.org/) — the diagram-as-code syntax every markdown
  host (GitHub, Notion, the cookbook pipeline) already renders
- RelateDB's `db.schema.visualization` — the built-in schema graph with virtual
  nodes that becomes a schema diagram in one call
- The GraphGist lineage — "query in prose, rendered result below it" is the same
  authoring shape, with Mermaid as the rendering target
