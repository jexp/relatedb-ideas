---
type: Project
name: stitch-graphs
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
RELATED_IDEA:
  - kind: complements
    reason: cited for the community-format loader craft
    target: "[[Project/gedcom-importer-merger]]"
  - kind: inspired-by
    reason: cited as the pattern-as-story format applied to a new domain
    target: "[[Project/graphgists-reborn]]"
  - kind: complements
    reason: both model garments and their structure as graph data
    target: "[[Project/wardrobe-planner]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GraphGist]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Stitch Graphs

> Knitting and weaving patterns are directed graphs — stitches as nodes,
> yarn paths as edges — and every knitter manipulates them mentally,
> row by row, without a query language. Pattern libraries, sizing
> transforms, and cable braids as Cypher.

## What

A knitting pattern is a graph wearing a prose costume. Every row
instructs stitches, but the *yarn* connects them: a knit-2-together is an
edge merging two stitches into one; a yarn-over is a new node appearing;
a cable is a regular braid permutation of subgraphs; a bind-off is a
boundary. Computer graphics formalized this years ago — "stitch meshes"
model knitted clothing at yarn level, and the knitting community's
chart notation has been a visual graph language all along.

This project makes the craft's own structure explicit: `(:Stitch
{type})` nodes per row segment, yarn edges between them, `(:Row)` and
`(:Round)` as sequence layers, `(:Cable)` braids as pattern-level
subgraphs, and garment geometry (sleeves, yokes, panels) as the
structural overlay. The payoffs:

- **Reading**: "what does row 12 actually connect to" — the chart as a
  queryable object; abbreviations and cross-references resolve to
  structure, not prose
- **Sizing as a transform**: graded sizes are graph edits with
  stitch-count conservation constraints — "grow this sweater to 48-inch
  bust while preserving the yoke ratio" is a constrained-rewrite query,
  not a table lookup
- **The library**: a personal pattern collection as `.cl` — "which
  patterns use a technique I've already mastered," "find me a
  two-skein cowl with no cables" — pattern matching over craft
- **Weaving drafts**: the loom's threading/tie-up/treadling grid is a
  bipartite interaction graph — the same store serves the other half of
  the craft world

The audience is enormous (tens of millions of active knitters), the
craft is inherently graph-shaped, and the tooling today is PDFs and
YouTube.

## Why RelateDB

A pattern is small (hundreds to thousands of stitches) — the WASM tab
is a pattern *player*: watch the fabric grow row by row, the stitch
graph building itself, with the swatch rendered beside it. The
structured-transform story (sizing) is exactly the kind of constrained
graph rewrite engines express well and prose cannot. And a shared
pattern as a `.cl` file is the craft community's first machine-readable
pattern currency — the GraphGists pattern for a domain that never had
them.

## What it needs

- The pattern loader: knitting-chart notation → the stitch graph (the
  community's chart standards are the input grammar); weaving drafts as
  the second loader
- The sizing-transform pack with conservation constraints
- The visual: fabric rendering (rows building over time) beside the
  graph view — the stitch-level sim is CG-research territory; a
  schematic-level rendering is the honest v1
- The pattern-library schema and the collection queries

## Lineage & inspiration

- [Stitch meshes for modeling knitted clothing with yarn-level detail](https://doi.org/10.1145/2185520.2185533)
  and [Stitch meshing (TOG)](https://dl.acm.org/doi/10.1145/3197517.3201360)
  — the CG formalization that proved knitting is graph structure;
  [simulating knitted cloth at the yarn level](https://dl.acm.org/doi/10.1145/1360612.1360664)
  the founding sim
- The community's chart notation (Knitting charts, lace/cable symbols) —
  the visual graph language this project makes queryable
- [GraphGists, Reborn](graphgists-reborn.md) — the pattern-as-story
  format for a new domain; [GEDCOM Importer & Merger](gedcom-importer-merger.md)
  — the community-format loader craft
- Ravelry's pattern graph — the community hub whose data model stops
  at the catalog, never reaching the yarn
