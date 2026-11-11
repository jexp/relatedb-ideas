---
type: Project
name: arrows-on-cypherlite
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: variant
    reason: the same thesis built from scratch; this is its shipped-front-end version
    target: "[[Project/direct-manipulation-graph-editor]]"
  - kind: complements
    reason: the umbrella thesis the canvas is one projection of
    target: "[[Project/the-intentional-graph-workbench]]"
  - kind: complements
    reason: named as an existing arrows workflow that gains the run loop
    target: "[[Project/whiteboard-to-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/arrows.app]]"
---

# Arrows on RelateDB

> Neo4j Labs' arrows.app, the interactive graph drawing and editing canvas,
> backed by RelateDB's WASM engine: draw as before, but the drawing is a
> live store — patterns run, results write back, the sketch and the data
> converge.

## What

[arrows.app](https://arrows.app) already answers "how do I draw a graph" —
Neo4j Labs' canvas for sketching nodes and relationships, with pop-out
properties and export to Cypher. But the drawing is a *picture* of a graph:
it exports statements, it doesn't run them. Backed by RelateDB's WASM
build, the canvas becomes the store — every node and edge drawn is a write,
every property edit is a write, and the query bar underneath answers over
exactly what you've drawn.

The convergence this unlocks: sketch a data model, flip to the query view,
test it against the sketch-as-data, keep drawing as the results reveal what's
missing. The workflow arrows already serves — model design, teaching,
whiteboard capture (see [Whiteboard to Graph](whiteboard-to-graph.md)) —
gains the run loop; and the reverse flow matters just as much: load a small
`.cl` dataset and *edit it on the canvas*, where the previous tools only
rendered. Arrows' export survives as a convenience; the import finally
exists.

## Why RelateDB

The WASM build is exactly the engine a browser canvas wants: one file,
in-memory, transactional enough for undo via the WAL, with a real query
language over the drawing. No server under the tool, no export-then-paste
detour — the canvas component and the query component are two projections
of the same embedded store, which is the [Intentional Graph
Workbench](the-intentional-graph-workbench.md) thesis in its most
shippable form. The `.cl` persistence means the drawing session is a file
that reopens anywhere.

## What it needs

- The embedding: arrows' canvas components over RelateDB-WASM instead of
  an in-memory drawing model (each UI action → a Cypher write; undo → WAL
  rewind or inverse statements)
- The query panel (a REPL pane over the same store the canvas renders)
- Import/export kept: arrows' existing Cypher export, plus `.cl` open/save
- The view sync: canvas renders query results (a materialized pattern view
  — layout modes for drawn vs. loaded)

## Lineage & inspiration

- [arrows.app](https://arrows.app) — Neo4j Labs' graph sketching canvas;
  the drawing surface this project gives a store
- The [Direct Manipulation Graph Editor](direct-manipulation-graph-editor.md)
  — the same thesis from scratch; this is its shipped-front-end version
- [The Intentional Graph Workbench](the-intentional-graph-workbench.md) —
  the umbrella: the canvas as one projection among several
