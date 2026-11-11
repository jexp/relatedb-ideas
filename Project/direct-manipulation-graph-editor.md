---
type: Project
name: direct-manipulation-graph-editor
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Gephi]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the renderer adapters the canvas front end is built on
    target: "[[Project/d3-sigma-cytoscape-adapters]]"
  - kind: complements
    reason: WAL query-log replay as undo is the same substrate as checkpoint diffing
    target: "[[Project/diff-view-for-graphs]]"
  - kind: variant
    reason: direct manipulation of nodes as the way a graph gets authored
    target: "[[Project/whiteboard-to-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Cytoscape]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
  - "[[Technology/WASM]]"
  - "[[Technology/sigma.js]]"
---

# Direct-Manipulation Graph Editor

> Drag nodes, draw relationships, edit properties in-place; every gesture is a
> Cypher write under the hood. Undo = query log replay.

## What

A graph editor where the UI is a lie and the database is the truth. The user
drags a node — nothing happens yet; on drop, the editor emits `SET n.x = 214,
n.y = 87`. The user drags from node A's edge handle to node B — a
`CREATE (A)-[:KNOWS {since: 2026}]->(B)` runs. Click a property in the inspector
and edit it — `SET n.name = 'Eponine'`. Every gesture in the canvas is exactly
one Cypher write; the canvas is just a view re-rendered from the store after
each one.

The consequence is radical but simple: undo is not a hand-rolled gesture stack,
it is replay of the query log — RelateDB persists every write to the WAL, so
"undo" rewinds and re-applies from there. And because the edit history is itself
a query history, the session ends with something no other editor gives you: a
script. Share the `.cl` file and the recipient replays how the graph was built,
or "collapse" the log into a clean CREATE script for a lesson or a fixture.

The honest framing: a Neo4j-Browser-shaped tool, but the storage is embedded
and the log is the protocol — the editor is a thin gesture-to-Cypher compiler
over one local file.

## Why RelateDB

Writes commit at in-memory speed with a durable fsync'd WAL, so gesture-latency
writes (drag-drop, property keystrokes) are cheap enough that no gesture needs
batching or debasing into "local state synced later" — the classic divergence
bug of editor-plus-store designs cannot exist here because there is only one
store. The single-file portability (WAL + Parquet checkpoint) makes every edit
session a file: commit it, email it, diff it between checkpoints. The WASM
build puts the whole editor in a browser tab against an in-tab store, and the
HTTP/Bolt serve modes make the same file the backing store of a shared lab
editor. And since every change is Cypher, the editor doubles as a
learn-Cypher-by-seeing tool: a "show the query" toggle turns each gesture into
a live lesson.

## What it needs

- A canvas front end: layout (force-directed or grid), drag, edge-handle
  gesture, inspector panel (sigma.js / Cytoscape / Pixi all work)
- The gesture→Cypher compiler: one emitting write per gesture, re-render from
  query results after each
- Undo/redo on WAL-log replay; the "collapse log to script" export
- Multi-user polish over `relate serve --http` (optimistic canvas, server
  as truth) — a stretch lane

## Lineage & inspiration

- Neo4j Browser and Bloom — the gesture-plus-Cypher model, minus the server
- [G.V() + Kuzu](https://gdotv.com/blog/fast-scalable-graph-querying-and-visualization-with-kuzu-and-g-v/)
  — proof that a native editing UX over an *embedded* graph is a real lane
- [Gephi](https://bellingcat.gitbook.io/toolkit/more/all-tools/gephi) — the
  curate-and-clean editing workflow this project inherits, done as a local file
  instead of a desktop application
- The spreadsheet mantra "the cell is the truth" — here, "the query log is the
  truth"
