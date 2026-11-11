---
type: Project
name: table-editor-to-graph
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Graphileon]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the canvas-native skin of the same workbench
    target: "[[Project/direct-manipulation-graph-editor]]"
  - kind: complements
    reason: cited as the read-side sibling over data born in this editor
    target: "[[Project/spreadsheets-are-graphs]]"
  - kind: complements
    reason: cited as the umbrella idea this instantiates
    target: "[[Project/the-intentional-graph-workbench]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Table Editor to Graph

> Markus Wissing's interactive editing of table-shaped data that is
> *immediately* the graph: edit rows in a grid while the graph view updates
> live — the same store, two projections, no import step.

## What

Markus Wissing's point is the killer one: nobody wants an *import step*.
The classical graph-tool experience is "get your data into CSVs, run the
loader, then query" — by which time the moment is gone. His answer is a
table editor whose data is *already* the graph. Type rows into a familiar
grid — customers, orders, products — and each row is a node the moment it
exists; each foreign-key-ish column you name becomes a relationship; the
canvas view beside the grid re-renders live as you type.

And it is bidirectional: edit a cell in the grid and the graph view
moves; drag an edge on the canvas and the grid gains a relationship
column; delete a node and the row is gone everywhere, everything that
referenced it showing the hole immediately — the part spreadsheets
silently get wrong (dangling references, quiet breakage) and a graph
store gets right: the relationship *is* the data, so referential reality
is maintained by construction, not by validation after the fact.

The shipped cousin proves the demand and exposes the gap: Graphileon's
InterActor has run grid-plus-graph for years — a TableView over Cypher
results whose rows and cells click through into a NetworkView canvas,
both over the same store — but it is a hosted product over a server
database, with the loader still in front of the data. What that lineage
never had is the embedded case: no server between the grid and the
canvas, and the store itself as the editor's document.

## Why RelateDB

This is [The Intentional Graph
Workbench](the-intentional-graph-workbench.md) instantiated — its first
skin, the proof of the umbrella idea. The engine gives the workbench its
two hard parts for free: one honest representation (the grid's rows and
the canvas's circles are both *views*, neither owning the data) and one
change log underneath both, so undo and "what did I just do" are WAL
semantics, not per-editor machinery. The WASM build runs it all in a
browser tab — every keystroke a Cypher write, in-memory, the projection
re-rendered from a query at interactive speed. And every edit is a
durable write, so the `.cl` file *is* the editor's document format:
start editing at 10:00, email the file at 10:05 — there was never a save.

## What it needs

- The grid editor shell: a table view over a label/property selection,
  with write-back (cell edit → property set, new row → `CREATE`)
- The relationship gesture: name a column as a reference → edges
  materialize and the canvas shows them; the reverse gesture on canvas
- Projection sync: the canvas queries the same store the grid writes to;
  no second copy, ever
- View-definition metadata so a grid reopens on any RelateDB store

## Lineage & inspiration

- Markus Wissing — the interactive table-to-graph editing pitch (the grid as a live projection, no import step); an enterprise architect and graph practitioner: https://github.com/wirsel
- Graphileon InterActor — the shipped grid+canvas precedent over Neo4j: TableView docs at https://docs.graphileon.com/interactor/For_Dashboard_Designers/Reference/TableView.html | https://graphileon.com/
- [The Intentional Graph Workbench](the-intentional-graph-workbench.md) — the umbrella; [Direct Manipulation Graph Editor](direct-manipulation-graph-editor.md) — the canvas-native skin
- [Spreadsheets are Graphs](spreadsheets-are-graphs.md) — the read-side sibling: dependency analysis over data born in this editor
- The spreadsheet reflex — everyone's first data tool is a grid; this is the graph engine meeting that reflex where it lives
