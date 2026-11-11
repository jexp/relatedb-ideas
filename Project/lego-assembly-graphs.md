---
type: Project
name: lego-assembly-graphs
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/LDraw]]"
  - "[[Company/Rebrickable]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: reference-vs-build divergence mirrors the lens-across-time pattern
    target: "[[Project/cambria-for-graphs]]"
  - kind: complements
    reason: community-catalog loader tradition shared with the parts catalog
    target: "[[Project/gedcom-importer-merger]]"
  - kind: complements
    reason: factory-floor BOM queries are the industrial sibling of the build BOM
    target: "[[Project/use-case-gallery]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/LDraw]]"
  - "[[Technology/Rebrickable]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# LEGO Assembly Graphs

> Parts, connectors, reference constructions, and the provenance
> manifest — the assembly graph as a queryable store: what connects to
> what, which substitutions hold, and how your build's bill of materials
> diverges from the reference.

## What

The [ldraw-nova](https://github.com/anteloc/ldraw-nova) project (467★)
found the honest shape for LEGO-as-data: parts with their connector
metadata, reference constructions assembled from them, and a provenance
manifest tracking which piece of the instructions produced which part of
the build — the JEV layer scoring and checking along the way. That is an
assembly graph in everything but the engine.

This project makes the shape explicit and queryable. Nodes: `(:Part)`
(the catalog — ~20k elements with connectivity metadata), `(:Connector)`
(the studs/holes/axles with type and position), `(:Submodel)` and
  `(:Build)`, `(:InstructionStep)`. Edges: `[:FITS {type}]` between
connector pairs (the compatibility lattice), `[:CONTAINS {qty}]` the BOM
hierarchy, `[:SUBSTEP_OF]` the construction tree. The questions that
become queries:

- **Reachability and substitution**: "which alternative parts have the
  same connector signature as this one within this submodel's exposed
  connections" — the substitution checker every brick-sorter wants
- **Divergence from the reference**: your build's BOM against the
  instruction manifest — missing pieces, substitutions made, structural
  differences (the provenance manifest as a diff-able graph, the
  Cambria-across-time trick in miniature)
- **What can I build with what I own**: the inventory graph against the
  reference-construction graph — the question the whole hobby revolves
  around, as a subgraph-matching query with partial-match scoring
- **Element history**: which sets contained which part in which color
  and year — the lineage/collection analytics (BrickSet/Rebrickable data
  as public corpora)

## Why RelateDB

A personal inventory is thousands of parts; a reference construction is
hundreds — the entire domain is single-file scale, offline, no server
(the closet is not a datacenter). The compatibility lattice and
substitution questions are native traversals; the BOM diff is the
checkpoint-diff pattern; the WASM tab makes "what can I build tonight" a
kitchen-counter page over the inventory `.cl` file. And the public
catalog corpora (Rebrickable's part/relationship exports are famously
clean) make the loader straightforward.

## What it needs

- The catalog loader (Rebrickable/LDraw exports → parts, connectors,
  compatibility edges, set inventories)
- The inventory model and the "what can I build" partial-match scorer
  (honest scoring: exact, substituted, missing-N)
- The build-vs-reference diff (the provenance manifest as graph)
- The collection analytics pack (element lineage, color/year history)

## Lineage & inspiration

- [ldraw-nova](https://github.com/anteloc/ldraw-nova) — the assembly +
  provenance manifest architecture this project makes native
  (`research/jev-head.md`)
- [Rebrickable](https://rebrickable.com/downloads/) — the clean public
  part/relationship/set corpora the loader ingests; the LDraw parts
  library — the geometry/catalog foundation
- [Cambria for Graphs](cambria-for-graphs.md) — the reference-vs-build
  divergence is the lens-across-time pattern in miniature;
  [Factory-Floor BOMs](use-case-gallery.md) — the industrial sibling
  (where-used, change impact) this entry's craft generalizes down to the
  toy scale — or up from it
- [The GEDCOM Importer & Merger](gedcom-importer-merger.md) — the
  community-catalog loader tradition
