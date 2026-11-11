---
type: Project
name: wikidata-wedge-for-research
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: variant
    reason: same wedge pattern over a sibling Wikimedia dataset
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SPARQL]]"
  - "[[Technology/Wikidata]]"
---

# Wikidata Wedge for Research

> Pull a Wikidata topic slice (entities, claims, references) into a queryable
> graph; correlation-mining across fields, provenance checks on citations,
> all offline in one file.

## What

Wikidata is already a graph — items, statements with qualifiers, and
references — but its interfaces make you explore one item at a time. The
wedge project inverts that: pick a topic area (all items that are instances
of *chemical compound* within 2 hops, or everyone who held the office of
*Prime Minister* plus their parties and predecessors), pull the slice via
the API or a dump, and load it with statements as typed relationships,
qualifiers as edge properties, and references as first-class nodes.

Then the questions get interesting. Provenance: *which claims in this slice
rest on a single reference?* is one query over reference nodes — a built-in
fragility detector. Cross-field correlation: *which chemists in this set
also appear in the film-award subgraph?* is a hop between wedges loaded
into one store. Temporal: qualifiers like `P585 (point in time)` become
edge timestamps, so *who held this position when that paper was published?*
is a temporal range join — reproducible research material, since the
store's own metadata records the dump date and the SPARQL query that
carved the slice.

Topical subsetting is already a named research problem with tooling:
KGTK (the ISI Knowledge Graph Toolkit) imports full Wikidata JSON dumps
into edge tables for set/join manipulation; wdsub streams dump subsets
selected by SPARQL-defined entity classes; and the 2023 *Wikidata
Subsetting* survey benchmarked the field's tools (WDumper, wdsub, KGTK)
on exactly this task. The wedge keeps that lineage but changes the
output: an interactive, queryable property-graph store instead of a
folder of TSV files.

## Why RelateDB

The reference-as-node, qualifier-as-property mapping lands natively on a
property graph — no reification gymnastics — and RelateDB's in-memory
engine makes exploratory correlation-mining over millions of
entities-and-claims feel instant, entirely offline, from the CLI. The
single-file store is the reproducibility story: one attachment carries the
dataset. For heavier slices, Parquet checkpoints are the durable form, and
the hybrid/vector search preview lets researchers mix exact-match queries
with semantic similarity over labels and descriptions. `relate serve
--mcp` then lets an agent answer "which of these claims cite only
Wikipedia?" interactively.

## What it needs

- A Wikidata client: SPARQL/API slicing (or dump filtering) → items, claims,
  qualifiers, references (a `wdt:` property → relationship mapping table)
- Reconciliation policy: same-as edges; deprecated claims kept with a flag,
  not silently dropped
- Canonical wedges shipped as `.cl` files: chemistry, officeholders,
  scholarly citations
- A cookbook of provenance/correlation queries; ideally a `relate pull`-style
  workflow from SPARQL query to store

## Lineage & inspiration

- [Wikidata](https://www.wikidata.org) and its
  [SPARQL query service](https://query.wikidata.org) — the source of truth
- [Six Degrees of Wikipedia (sdow)](https://github.com/jwngr/sdow) — the
  "ship the fun slice" pattern, extended to statements and references
- [NetworkX guides: applications](https://networkx.org/nx-guides/content/applications/index.html)
  — the notebook case-study genre the wedge queries slot into
- [KGTK](https://github.com/usc-isi-i2/kgtk/) — Wikidata dumps as
  manipulable edge tables; the incumbent subgraph tooling
- [wdsub](https://github.com/weso/wdsub) — SPARQL-defined topical subset
  extraction from Wikidata dumps
- [Wikidata Subsetting: Approaches, Tools, and Benchmarks](https://www.semantic-web-journal.net/system/files/swj3372.pdf)
  — the survey that names the problem this project joins
- [Scholia](https://scholia.toolforge.org) — Wikidata's scholarly-graph
  profiles; the wedge is its queryable offline form
