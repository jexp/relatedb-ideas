---
type: Project
name: protein-interaction-sandbox
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
RELATED_IDEA:
  - kind: complements
    reason: supplies score propagation over the weighted interaction graph
    target: "[[Project/gds-round-trip]]"
  - kind: complements
    reason: the molecular layer beneath the protein interaction slice
    target: "[[Project/molecules-as-graphs]]"
USES_TECH:
  - "[[Technology/DuckDB]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
---

# Protein Interaction Sandbox

> STRING/BIOSISDB slices; "which pathways does drug X touch within 2 hops" at local
> speed.

## What

Protein-protein interaction (PPI) databases — STRING above all — publish enormous
confidence-scored graphs of "these two proteins physically interact". A biologist
never needs all of it; they need *their* slice: the interactome around a drug's
targets, a disease's GWAS hits, or one pathway's neighborhood. That slice is a
thousand-to-a-hundred-thousand node graph — and the questions are pure graph
questions.

This project materializes such a slice into RelateDB: `Protein {id, symbol,
organism}` nodes, `INTERACTS {score, mechanism}` edges, `Pathway` nodes from KEGG/
Reactome with `PARTICIPATES` edges, drug nodes with their targets, and disease
nodes from OMIM annotations. Then "which pathways does drug X touch within 2 hops"
is one pattern; "targets shared by drugs A and B" is a common-neighbor query; "rank
off-target proteins by interaction score and pathway essentiality" is a
filter-and-aggregate query over the same graph, at memory speed, offline.

The APIs to slice from are verified and generous. STRING documents a full REST API
(`network`, `interaction_partners`, enrichment endpoints) plus per-organism bulk
downloads at any confidence cutoff; BioGRID runs a REST service with JSON/TSV
interaction pulls by gene or publication. And there is a real embedded-analytics
precedent in bioinformatics: AnnSQL runs single-cell genomics analysis on an
embedded SQL engine from a laptop, dbverse embeds DuckDB for spatial-omics
work, and DuckDBGRanges brings interval queries to Bioconductor — biology's
"no-server, one-file" analytics wave. This project is that wave's graph answer.

## Why RelateDB

The insight of this idea is "at local speed" — today these questions either go
through a rate-limited web API or require a lab server with a full Neo4j instance.
A STRING slice as a single `.cl` file turns the interactome into something you
email a collaborator alongside a paper, open in a browser tab (WASM build), or
query from a notebook via the Python bindings without provisioning anything.
Vector/hybrid search earns its keep here: embed protein descriptions or abstracts
and find "the PI3K-adjacent kinase described as a tumor suppressor" without
remembering the gene symbol. The in-memory engine matters even at 100k nodes —
multi-hop neighborhood queries over weighted edges are scan-heavy, and RelateDB's
no-round-trip Cypher makes them interactive rather than batch.

## What it needs

- STRING API export → slice builder (seed proteins, expansion radius, score cutoff)
- Pathway cross-references (KEGG/Reactome TSVs) and drug-target tables
- Edge-weight-aware query helpers (or a stored projection; see the GDS Round-Trip
  idea for score propagation)
- Optional: UniProt/abstract embeddings for the semantic-drift entry point
- A "build my slice" CLI step: seed list in, `.cl` file out

## Lineage & inspiration

- STRING database: https://string-db.org/ (confidence-scored PPIs, API downloads) —
  the API: https://string-db.org/help/api/ and bulk files: https://string-db.org/cgi/download
- BioGRID REST service (interactions by gene/publication, JSON/TSV):
  https://wiki.thebiogrid.org/doku.php/biogridrest
- The embedded-analytics-in-biology precedent — AnnSQL on DuckDB for single-cell
  genomics: https://doi.org/10.1093/bioadv/vbaf105 | dbverse (spatial omics on an
  embedded engine): https://www.duckdb.org/library/dbverse-scales-spatial-omics-analysis-with-embedded-analytical-databases/
- Reactome pathway ontology: https://reactome.org/ | KEGG: https://www.kegg.jp/
- Netzschleuder catalogue (bio-networks and the slice-with-metadata habit):
  https://networks.skewed.de/
- NetworkX applications guides — the notebook tradition these analyses come from:
  https://networkx.org/nx-guides/content/applications/index.html
- Kuzu Graph RAG (embedded graph + vectors for biology-flavored local RAG):
  https://github.com/kuzudb/graph-rag
