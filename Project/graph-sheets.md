---
type: Project
name: graph-sheets
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Airtable]]"
  - "[[Company/Bending Spoons]]"
  - "[[Company/Ink & Switch]]"
MENTIONS_PERSON:
  - "[[Person/Adam Wiggins]]"
RELATED_IDEA:
  - kind: complements
    reason: local callables are the stored-query machinery the live views and bots ride on
    target: "[[Project/graph-native-agent-memory]]"
  - kind: complements
    reason: the workbook-as-graph analysis half of the spreadsheet family
    target: "[[Project/spreadsheets-are-graphs]]"
  - kind: complements
    reason: grid editing with a live graph view; this adds the app-platform layer
    target: "[[Project/table-editor-to-graph]]"
USES_TECH:
  - "[[Technology/Airtable]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/HyperCard]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Graph Sheets

> The linked-record grid as the face of a property graph: rows are nodes,
> linked columns are typed edges, views are stored queries — Airtable's
> user-facing idea over an actual graph engine, with the end-user-programming
> lessons as the design contract.

## What

Airtable smuggled the relational model to the masses: users who would never
say "foreign key" happily link records, and every linked-record field is a
relationship with an UI. But the grid strains at exactly what a property
graph is native at — anything multi-hop, hierarchical, or many-to-many gets
clunky fast. This project is the same front end over the right store:

- **Rows are nodes, linked columns are typed edges** — link a cell, you made
  an edge; the link renders as a visible, inspectable connection, not a
  hidden join table
- **Views are stored queries** — a view (filter, group, sort) is a named,
  parameterized Cypher statement; the view stays *live*, re-evaluated as the
  data changes, and the query that produced it is inspectable — the sheet
  never hides its own definition
- **A query bar joins the formula bar** — results open as a new live sheet
  ("everyone within two hops of this project"), linked to its source rather
  than a snapshot
- **Computation is data** — a saved view, a bot, an automation is a node in
  the same store: clone it, share it, see it on the canvas next to the rows
  it works on. "Computation follows the same rules as data (it can be
  cloned, shared, stored, etc.)"

The design contract comes from Ink & Switch's
[End-user programming](https://www.inkandswitch.com/end-user-programming/)
essay — the forty-year autopsy of why "users as programmers" keeps not
happening: apps are sealed appliances, and every attempt that demanded a
new toolchain, a new interface, or a jump into "programmer mindset" fell
into the abyss between using and modifying. The spreadsheet and HyperCard
worked because they reused concepts the user already had, gave immediate
results, and let domain experts (not engineers) be the authors. So:
**no chasm, a gradient** — grid-first with zero new concepts, the query bar
appearing over data the user can already see, views becoming saved queries,
automation becoming visible nodes; **embodiment** — the grid is already the
best embodiment layer ever shipped, and the edges stay visible things;
**living system** — no save/build/run anywhere, instant recalculation;
**in-place toolchain** — no server to set up, no separate builder mode, the
app is the file.

## Why RelateDB

An in-process engine is what makes the "living system" quality free: live
views are re-run queries at memory speed, no save-round-trip, no rebuild
pause. The WASM build makes the whole thing a web page — the grid shell and
the engine in one tab, zero install (the essay's finding that the web's
sandboxed instant-load is the only platform that ever worked for
hackability). The `.cl` file is the app: sharing a sheet *is* sharing the
database — Airtable needs a platform for that; here it's a file that reopens
in any RelateDB instance. Stored views ride as data via local-callables
(`DEFINE PROCEDURE` — named, parameterized, inspectable), and hybrid search
gives the gentlest first query there is: "rows like this one" as a view.

## What it needs

- The grid shell over WASM: editable table view, linked-record column
  convention (typed edges, direction, and cardinality visible in the cell)
- Live views: a named-query → result-sheet pipeline with incremental
  re-evaluation (and honest cost display when a view gets expensive)
- The gradient ladder, deliberately ordered: grid → query bar → saved
  views → bots (each rung reuses concepts from the rung below — the essay's
  lesson, applied as a feature order)
- Visible automation: bots as nodes on the same canvas, never hidden
  triggers ("hooks bring a significant downside: the computation is no
  longer visible")
- The template gallery: sheets people share (the HyperCard stacks of this
  generation) as `.cl` files with their views and bots inside

## Lineage & inspiration

- [End-user programming: Empowered computing](https://www.inkandswitch.com/end-user-programming/)
  (Adam Wiggins, Ink & Switch, 2019) — the design contract: embodiment,
  living system, in-place toolchain, the gradient not the chasm; the
  spreadsheet/HyperCard success pattern; see
  `research/ink-and-switch-catalog.md` for the rest of the lab's work
- [Airtable](https://airtable.com) — the proof that linked records, views,
  and bots are mass-audience concepts; this project keeps its front end
  and swaps the store beneath it. (Airtable is Bending Spoons-owned since
  Sep 2026 — `research/bending-spoons-portfolio.md` — which adds the
  export-anxiety angle: the `.cl` sheet is also the exit path for an
  Airtable base)
- [Spreadsheets are Graphs](spreadsheets-are-graphs.md) and
  [Table Editor to Graph](table-editor-to-graph.md) — the repo's existing
  pair: workbook-as-graph *analysis*, and grid-editing with a live graph
  view. This is the third piece: the **app platform** — end users building
  their own tools on a graph, not analyzing or editing one someone made
- [Graph-Native Agent Memory](graph-native-agent-memory.md) / local
  callables — the stored-query machinery the views and bots are built on
- HyperCard, via the essay — "a tool for making tools"; the stacks
  became templates became Wikipedia's ancestors; the shared `.cl` sheet
  wants that lineage
