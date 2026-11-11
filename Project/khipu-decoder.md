---
type: Project
name: khipu-decoder
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
RELATED_IDEA:
  - kind: complements
    reason: the multiple-interpretations ledger pattern reused for rival khipu readings
    target: "[[Project/the-codex-reborn]]"
  - kind: complements
    reason: the humanities-graph craft applied to the Andean corpus
    target: "[[Project/the-hnr-humanities-pack]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The Khipu Decoder

> Andean khipu — knotted cords, a 500-year-old graph storage medium —
> loaded into the graph engine: cords as edges, knots as typed payloads,
> the 600+ surviving artifacts as one queryable corpus.

## What

Khipu (quipu) are the Inca Empire's records: pendant cords hanging from a
main cord, carrying knots that encode numbers by type and position, with
color, spin direction, and attachment encoding what the numbers *mean*.
Around 600 survive (the [Open Khipu Repository](https://github.com/khipulab/open-khipu-repository)
carries machine-readable transcriptions of the whole published corpus —
the [Khipu Database](https://www.unesco.org/en/memory-world/lac/khipu-database-khipu-archives)
is UNESCO Memory of the World registered). Structurally a khipu *is* a
graph: a tree of cords with typed, positioned knot payloads — and the
recent decoding wins (the accounting khipu of Colca Valley tribute) came
from treating them as structured data.

This project loads the corpus as property graphs — `(:Khipu)` → `(:Cord
{index, color, spin, attach})` → `(:Knot {type, value, position})` — and
makes the open questions queryable: structure-clustering to find
khipu "dialects"; the accounting grammar (sum-matching between pendant
cords and top cords, the proven bookkeeping pattern) as a query that
scores candidate interpretations; narrative-vs-accounting classification
as a structural question; and cross-referencing with the Spanish
transcription sources. The corpus is tiny by database standards — the
whole thing fits in a browser tab — and the query language is the part
the field has never had: scholars publish findings; they don't query the
corpus.

## Why RelateDB

The dataset is small, scholarly, and source-anchored — the exact profile
where a single file outperforms a server: one `.cl` corpus, citable,
shipped with the query pack (the HNR-pack pattern applied to the Andes).
Structural queries (tree matching, sum propagation up the cord hierarchy)
are native Cypher traversals; the WASM tab makes it a public exploration
artifact (a museum kiosk or a classroom opening the whole corpus). The
provenance rule from humanities computing applies: every knot ties back
to its transcription source in the repository.

## What it needs

- The Open Khipu Repository loader (transcription format → the cord/knot
  graph, with the repository's metadata preserved as properties)
- The query pack: the sum-matching bookkeeping test, structure-distance
  clustering, color/attachment convention frequency analysis
- The interpretation ledger: candidate readings as graph edits with
  provenance, so rival interpretations coexist (the Codex's
  multiple-interpretations lesson)
- A reading UI: the khipu *rendered as a khipu* (the source of truth is
  visual — the cord layout drawn beside the graph view)

## Lineage & inspiration

- [The Open Khipu Repository](https://github.com/khipulab/open-khipu-repository)
  (code + [Zenodo data](https://zenodo.org/records/6908343)) — the
  machine-readable corpus this project ingests
- [khipukamayuq.com datasets](https://khipukamayuq.com/khipu-datasets/) —
  the continuing Khipu Database Project tradition ([NSF award](https://www.nsf.gov/awardsearch/showAward?AWD_ID=0408324),
  [UNESCO Memory of the World listing](https://www.unesco.org/en/memory-world/lac/khipu-database-khipu-archives))
- The Colca Valley tribute-khipu decoding work — the structured-data
  breakthrough that proved the accounting grammar
- [The Codex, Reborn](the-codex-reborn.md) and [The HNR Humanities
  Pack](the-hnr-humanities-pack.md) — the humanities-graph craft this
  applies to the Andean tradition
