---
type: Project
name: the-intentional-graph-workbench
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Graphileon]]"
  - "[[Company/Intentional Software]]"
  - "[[Company/JetBrains]]"
MENTIONS_PERSON:
  - "[[Person/Charles Simonyi]]"
  - "[[Person/Martin Fowler]]"
RELATED_IDEA:
  - kind: complements
    reason: first editor skin over the shared graph
    target: "[[Project/direct-manipulation-graph-editor]]"
  - kind: complements
    reason: one projection renderer for the workbench
    target: "[[Project/mermaid-as-a-query-result]]"
  - kind: inspired-by
    reason: grid as one projection of a graph
    target: "[[Project/spreadsheets-are-graphs]]"
  - kind: complements
    reason: grid projection editor of the same data
    target: "[[Project/table-editor-to-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphileon]]"
  - "[[Technology/JetBrains MPS]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The Intentional Graph Workbench

> Charles Simonyi's Intentional Workbench vision on a graph engine: one
> internal graph representation, projectional renderers and editors for
> every shape it can take — table, diagram, canvas, tree, timeline — each
> view a bidirectional editor, the mappings between them first-class.

## What

Charles Simonyi's Intentional Software thesis: stop arguing about *notation*
and store the intent once; render and edit it through whichever projection
suits the task. His Workbench prototypes did this for internal
graph-shaped data with mappings to interactive visualizations. The thesis
was right; the substrate was missing. A graph engine **is** that substrate.

The workbench: one RelateDB store as the single source of truth, and every
view is an editable projection — a table grid over the same nodes you edit
in the canvas; the tree outline; the timeline; the Mermaid render (see
[Mermaid as a Query Result](mermaid-as-a-query-result.md)). The mappings
are first-class and reversible: the same data, re-projected, still
round-trips. Editing a cell writes Cypher; moving a node writes Cypher;
every editor is a thin skin over the same engine, so undo, history, and
collaboration come for free from the WAL underneath all of them.

The program is on the record, and it named its own lineage. Simonyi's
"The Death of Computer Languages, The Birth of Intentional Programming"
(1995) and his USENIX DSL-97 "Ecology for Abstractions" talk state the
intent-once thesis; Fowler named the genre it founded ("Language
Workbenches", 2005) and reviewed JetBrains MPS — the projectional editor
that actually shipped — as the proof; projectional editing survives today
as the engineering line. And a commercial cousin already runs over Neo4j:
Graphileon — "your app is a graph" — whose dashboards, TableViews and
NetworkViews are themselves nodes in the graph, the workbench idea with
the app as the graph. What none of them have is the data itself being
that graph, on a laptop, with one change log under every projection.

## Why RelateDB

The engine already has the hard part: one honest, durable, transactional
representation (WAL + Parquet) with a real query language over it. The
workbench's editors are then *projections with write-back* — each a small
front-end (the WASM build runs them in a tab), none owning the data. The
WAL gives the whole system Simonyi's missing piece naturally: every
projection's edits land in one change log, so cross-view history, undo,
and audit are the engine's own semantics. And `serve --mcp stdio` lets an
agent use the *same* workbench as a tool — the agent edits the same graph
the human is editing, through its preferred projection (query text), while
the human watches the canvas move.

## What it needs

- The projection registry: view definitions (a table view = a node/property
  selection; a canvas view = a labeled subset) with bidirectional edit
  mappings — MPS's projections and Fowler's "language workbench" checklist
  are the design references
- The editor shells: grid, canvas, tree, timeline — thin skins sharing the
  WASM engine; Graphileon's TableView-over-Cypher is the shipped spec to
  match and then embed
- The agent seat: MCP mount so agents co-edit (see [Direct Manipulation
  Graph Editor](direct-manipulation-graph-editor.md) and [Table Editor to
  Graph](table-editor-to-graph.md) as the first two skins)

## Lineage & inspiration

- Charles Simonyi — The Death of Computer Languages, The Birth of Intentional Programming (1995): https://www.microsoft.com/en-us/research/publication/the-death-of-computer-languages-the-birth-of-intentional-programming/ | Intentional Programming — An Ecology for Abstractions (USENIX DSL-97): https://www.usenix.org/conference/dsl-97/invited-talk-intentional-programming-ecology-abstractions
- Martin Fowler — Language Workbenches: https://martinfowler.com/articles/languageWorkbench.html | A Language Workbench in Action: MPS: https://martinfowler.com/articles/mpsAgree.html | the [ProjectionalEditing](https://martinfowler.com/bliki/ProjectionalEditing.html) bliki
- JetBrains MPS — the projectional-editing proof that shipped
- Graphileon — "your app is a graph": the projectional app-builder running commercially over Neo4j: https://graphileon.com/ | InterActor [TableView](https://docs.graphileon.com/interactor/For_Dashboard_Designers/Reference/TableView.html) and [NetworkView](https://docs.graphileon.com/interactor/For_Dashboard_Users/NetworkView.html) docs
- [Spreadsheets are Graphs](spreadsheets-are-graphs.md) — the projection idea's accidental proof: the grid everyone loves is one projection of a graph
- Subform, Regular, and the projectional-UI explorers — modern attempts at exactly the bidirectional-view problem
