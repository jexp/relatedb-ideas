---
type: Project
name: arxiv-wedge
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
RELATED_IDEA:
  - kind: complements
    reason: community-detection labels land back in the store via the GDS round-trip
    target: "[[Project/gds-round-trip]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Netzschleuder]]"
  - "[[Technology/OpenCitation]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# arXiv Wedge

> pull a topic's arXiv metadata, build the co-citation graph, watch a field fragment
> into communities — reproducible, shareable as a file.

## What

Take a topic — "quantum error correction", "causal inference", "graph neural
networks" — pull every arXiv paper in its category or matching its keywords, and
build the graph of how that literature hangs together: `Paper` nodes with title/
abstract/date, `AUTHORED_BY` edges (weighted when shared), citation edges where
OpenCitation knows them, and co-citation edges computed from reference lists.
Because arXiv metadata is public and timestamped, the graph can be built *as of*
any date — which makes the headline feature possible: replay the field's history
and watch it fragment.

The science-of-science classics all become queries: single-author → multi-author
trend over time; community detection rendered as author-clusters; the paper that
bridged two camps before the camps existed; the "sleeping beauties" cited decades
later. And the whole result — data, queries, and detected communities — is one
`.cl` file anyone can open and interrogate, not a notebook nobody can re-run.

The co-citation idea is half a century old — Small (1973) defined co-citation as
a measure of document relatedness, and White (1981) turned it into the author
co-citation maps this project reprises — so the analysis is textbook; only the
artifact is new. The sources are also better than the file's minimal setup
implies: the Semantic Scholar Academic Graph API serves paper records with
references, citations, and abstracts under a free tier (and its Open Data
Platform paper describes the whole pipeline), while Netzschleuder already
hosts a browsable arXiv citation graph for the wedge-shaped slice.

## Why RelateDB

Reproducibility is the differentiator. Today a field-structure analysis is a
Python notebook with ten library dependencies, seeded layout PNGs, and community
labels nobody can query. As a `.cl` file it becomes an artifact: open it in the
WASM browser build, run `MATCH (p:Paper)-[:AUTHORED_BY]->(a:Author {name: "..."})
RETURN p` against the actual data, and add your own questions. In-memory Cypher
makes temporal slicing (drop edges after date D, re-analyze) interactive rather
than a 20-minute rebuild, since the store reloads from its WAL/Parquet checkpoint
in seconds. Temporal types carry submission dates natively; vector/hybrid search
over abstracts lets you find "the papers that smelled like a new subfield before
it had a name". And `relate serve --mcp stdio` lets an agent answer literature
questions from the real graph.

## What it needs

- arXiv OAI/API metadata fetcher (category or query → papers + authors), respectful
  of rate limits and cached
- OpenCitation/Crossref citation edges; co-citation computed at import (one pass
  over reference lists)
- Community detection — either import labels from an external run (NetworkX /
  leiden) or land results back in the store as community nodes (see the GDS
  Round-Trip idea)
- A time-slider replay front-end over the WASM build; optional "as-of date"
  filtering via temporal properties
- Refresh story: date-stamped re-pulls appended through the WAL

## Lineage & inspiration

- arXiv API: https://info.arxiv.org/help/api/ | OAI-PMH for full metadata harvest
- Semantic Scholar Academic Graph API (free tier; paper, citation, and abstract
  records — the alternative source): https://api.semanticscholar.org/api-docs/graph
- Small (1973), the co-citation paper — the measure this project computes:
  https://doi.org/10.1002/asi.4630240406 | White (1981), author co-citation:
  https://asistdl.onlinelibrary.wiley.com/doi/10.1002/asi.4630320302
- Netzschleuder's arXiv citation network (a ready-made wedge with provenance):
  https://networks.skewed.de/net/arxiv_citation
- OpenCitation COCI: https://opencitations.net/ (arXiv DOI citation edges)
- Barabási's *Network Science* — the science-of-science chapters this analysis
  pattern comes from: https://networksciencebook.com/
- Netzschleuder catalogue (co-authorship and citation networks with metadata —
  the slice-with-provenance model): https://networks.skewed.de/
- Kuzu + dspy (embedded graph as an agent's literature memory, the same lane):
  https://github.com/adsharma/kuzu-demo-dspy
