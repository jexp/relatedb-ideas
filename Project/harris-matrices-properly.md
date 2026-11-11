---
type: Project
name: harris-matrices-properly
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Aarhus University]]"
  - "[[Company/TU Wien]]"
MENTIONS_PERSON:
  - "[[Person/E. C. Harris]]"
  - "[[Person/Joe Roe]]"
RELATED_IDEA:
  - kind: complements
    reason: the same-as identity-resolution craft needed for cross-trench correlation
    target: "[[Project/gedcom-importer-merger]]"
  - kind: complements
    reason: the humanities-graph craft this field-recording project applies
    target: "[[Project/the-hnr-humanities-pack]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Harris Matrix]]"
  - "[[Technology/R]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
  - "[[Technology/stratigraphr]]"
  - "[[Technology/tidygraph]]"
---

# Harris Matrices, Properly

> Archaeological stratigraphy is *defined* as a directed acyclic graph —
> the Harris matrix, 1973 — yet digs still argue about software for it.
> The excavation itself as a queryable graph: contexts, superposition,
> cuts, and the phasing as path queries over your own trench.

## What

Every excavation records contexts (stratigraphic units — layers, walls,
pits, fills) and the relationships between them: this lies above that
(later), this cuts through that (even later), same-as (one unit recorded
twice). The Harris matrix turns those records into a directed graph —
and the dig's true sequence is the transitive reduction plus the
chronological constraints. It is the single most graph-native artifact in
mainstream field science, and the field's tooling is exactly where it was
decades ago: the tools exist (ArchEd from Vienna, the Harris Matrix
Composer from Aarhus, tidygraph/stratigraphr in R), each with followings,
none with a query language — archaeologists publish matrix *diagrams*,
not queryable digs.

This project is the excavation as a store: `(:Context {type, description,
supervisor})` with `[:ABOVE]`, `[:CUTS]`, `[:SAME_AS]`, `[:FILLS]` edges,
periods and phases as nodes the contexts join, and finds (pottery,
samples, bones) attached with their stratigraphic provenance. The
Harris matrix drawing becomes one rendering of the store (the DAG
layout); the questions become queries:

- "every context sealed by the collapse layer, with their finds" — a
  provenance path query
- "which cuts are in ambiguous order" — cycle detection on the
  stratigraphic graph, the dig's honest controversies surfaced
- phasing: group contexts into phases by shared constraints — a
  constraint-propagation query, not a re-drawing
- cross-trench correlation: the same burning event in three trenches as
  a candidate SAME_AS problem — the entity-resolution craft again, with
  an archaeologist in the loop

## Why RelateDB

A single season's excavation is thousands of contexts — a `.cl` file, not
a server: the dig's data laptop runs offline (trenches have no wifi),
syncs later, and the season's store is the citable supplementary
artifact (the HNR-pack pattern for fieldwork). The DAG questions are
native Cypher traversals; temporal types carry the absolute-dating
constraints (radiocarbon, coins) that anchor the relative sequence; and
the WASM tab publishes a dig — its matrix, phases, and find contexts —
as an explorable page beside the report.

## What it needs

- The context-record loader (the standard single-context recording
  sheets/exports → the graph)
- The query pack: transitive-reduction checks, cycle detection, phase
  grouping, sealed-context provenance
- The matrix renderer (DAG layout, the diagram the field expects) and
  the phasing view
- A single-season pilot: one real excavation's records, published as a
  `.cl` file with its report

## Lineage & inspiration

- The Harris matrix (E. C. Harris, 1973) — the discipline's own graph
  formalism, predating every tool
- [stratigraphr](https://github.com/joeroe/stratigraphr/) (R, Joe Roe) —
  the tidy-data approach to stratigraphic sequences
- [Harris Matrix Composer](https://hmc.archpro.science/) (Aarhus) and
  [ArchEd](https://ac.tuwien.ac.at/files/archive/ArchEd/ArchEd_UsersGuide.pdf)
  (Vienna) — the incumbent tools this query layer serves beside
- [ArkMatrix](https://github.com/selforganizedpatterns/ArkMatrix) and
  the [1990 CAA graph-theoretic programs paper](https://proceedings.caaconference.org/files/1990/09_Herzog_Scollar_CAA_1990.pdf)
  — the graph-drawing tradition in archaeology
- [The HNR Humanities Pack](the-hnr-humanities-pack.md) — the
  humanities-graph craft; [GEDCOM Importer & Merger](gedcom-importer-merger.md)
  — the same-as resolution craft
