---
type: Project
name: spreadsheets-are-graphs
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the plain-data corner of the same move
    target: "[[Project/csv-to-graph-instantly]]"
  - kind: complements
    reason: cited as the live-editing sibling of the same spreadsheet reflex
    target: "[[Project/table-editor-to-graph]]"
  - kind: complements
    reason: cited as the umbrella idea this pitch accidentally proved
    target: "[[Project/the-intentional-graph-workbench]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Spreadsheets are Graphs

> Felienne Hermans' research made practical: a workbook's formulas, references,
> and sheets as a graph (dependencies, smell detection, "what breaks if I
> change this cell") — plus the table data itself.

## What

Felienne Hermans proved what every spreadsheet auditor knows: a workbook
is not a grid, it is a *program* — and the program is a graph. Every
formula is a node, every cross-cell reference a directed edge, every
sheet a labeled subgraph. Her smell catalogue (duplication, suspicious
inter-worksheet references) was computed by parsing `.xlsx` files into
exactly that dependency graph; the research stalled at one-off academic
prototypes, not something a finance team opens on a Tuesday.

This project makes it practical: parse a workbook into RelateDB —
`(:Cell {sheet, ref, formula})-[:REFERENCES]->(:Cell)`, `:Worksheet`,
`:NamedRange` — and the questions become one-liners. *What breaks if I
change this cell?* is a variable-length path over the reference edges.
The smell detectors are parameterized Cypher (duplication clusters are
near-identical formula bodies differing only in offsets, found by query
instead of by eye). Then the table data itself: the ranges the formulas
compute over become nodes too, and the dependency graph and the business
graph are one store — "which products' prices feed the cell the auditors
flagged" is a single traversal across both.

The research line is citable end to end: the TU Delft thesis "Analyzing
and Visualizing Spreadsheets", the Breviz tool that visualized the formula
dependency graph, the smell papers (formula smells, inter-worksheet
smells, and the refactoring study in Empirical Software Engineering),
and — the most direct ancestor of this project — "Automatically
Extracting Class Diagrams from Spreadsheets" (2010): the dependency
graph extracted as a class diagram, years before graph databases were
in the picture.

## Why RelateDB

A workbook is a single personal artifact — one person, one file, one
laptop — and the analysis should be too: drop the `.xlsx` on a
`relate` command, get a `.cl` file back, query it in the shell. The
WASM build makes it a browser tool — drag the workbook onto a page, see
the dependency graph, click a cell to light up its blast radius, no
upload of sensitive financial data to anyone's cloud. And in-memory
traversal handles the pathological case Hermans kept finding in the
wild: workbooks with hundreds of thousands of live formula cells, where
dependency reachability on a row-store is a join storm.

## What it needs

- An `.xlsx`/`.xlsm` parser to nodes and relationships (formulas as
  properties, references as edges, sheets/named ranges as structure)
- A formula-language model rich enough for the offset shapes (`A5:A9`,
  indirect references, cross-sheet ranges) so smells are detectable
- The smell pack: Hermans' catalogue as named, documented Cypher queries
- A worksheet-data projection: ranges as rows/nodes, bridging the formula
  graph and the data graph

## Lineage & inspiration

- Felienne Hermans — the TU Delft thesis "Analyzing and Visualizing Spreadsheets" (dependency-graph analysis of workbooks): https://repository.tudelft.nl/islandora/object/uuid:3a3ea534-68df-44a5-8a2d-411826d0335a
- Breviz — visualizing spreadsheets with the formula dependency graph: https://pinzger.github.io/papers/Hermans2011-breviz.pdf
- Code Smells in Spreadsheet Formulas: https://pinzger.github.io/papers/Hermans2012-formulasmells.pdf | inter-worksheet smells: https://pinzger.github.io/papers/Hermans2012-worksheetsmells.pdf | the refactoring study: https://doi.org/10.1007/s10664-013-9296-2
- Automatically Extracting Class Diagrams from Spreadsheets (2010) — the graph extraction, before graph databases: https://pinzger.github.io/papers/Hermans2010-classdiagrams.pdf
- *The Programmer's Brain* — the understandability line of the same research
- [The Intentional Graph Workbench](the-intentional-graph-workbench.md) — this pitch was its accidental proof: the beloved grid is a projection
- [Table Editor to Graph](table-editor-to-graph.md) — the live-editing sibling; [CSV → Graph, Instantly](csv-to-graph-instantly.md) — the plain-data corner of the same move
