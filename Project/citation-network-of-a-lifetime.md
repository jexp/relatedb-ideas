---
type: Project
name: citation-network-of-a-lifetime
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Crossref]]"
  - "[[Company/OpenCitations]]"
  - "[[Company/Zotero]]"
MENTIONS_PERSON:
  - "[[Person/Mark Newman]]"
RELATED_IDEA:
  - kind: complements
    reason: the same citation queries at field scale rather than career scale
    target: "[[Project/arxiv-wedge]]"
USES_TECH:
  - "[[Technology/Better BibTeX]]"
  - "[[Technology/CSL-JSON]]"
  - "[[Technology/Crossref]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Netzschleuder]]"
  - "[[Technology/OpenCitation]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Zotero]]"
---

# Citation Network of a Lifetime

> your Zotero/BibTeX library as a citation graph; "papers that cite everyone I cite,
> but that I don't" is one query.

## What

Every researcher already owns the raw material of a private citation graph: years of
Zotero/BibTeX libraries, thousands of entries, each with a `cites` field that
references other entries — and thousands more implicit links through the reference
lists of the papers themselves. Exported as a graph, a career's reading becomes a
map: what you read, what it cites, what cites it, and where the frontier of your
field sits relative to your library.

This project converts a Zotero export into `Paper {doi, title, year, venue}` and
`Author` nodes with `WROTE` edges, `CITES` edges resolved through the local
references (OpenCitation/Crossref fill what the library lacks), tag/collection
nodes as `TOPIC_OF`, and read-date as a temporal property so the graph knows *when*
you read each paper. Then the pitch query — "papers that cite everyone I cite, but
that I don't have" — is a real, single Cypher pattern: candidates whose full
reference list intersects your known set, minus your own nodes. Sibling queries:
"the two camps my library bridges", "what my thesis committee reads that I don't",
"the oldest paper my newest paper leans on".

The citation-data plumbing is verified and open. OpenCitations runs COCI, an index
of open DOI-to-DOI citations from Crossref data, both as a REST API and as a bulk
CSV dump — the reconciliation pass is a plain HTTP fetch, not a license. Zotero
exports through Better BibTeX even expose a JSON-RPC/pull endpoint on a running
library, so the importer can work against the live store. And the classic citation
corpora this project echoes are all public: the KDD Cup 2003 arXiv citation
network, the Physical Review dataset behind Redner's century-of-citations work,
and Netzschleuder's browsable arXiv citation graph.

## Why RelateDB

This is a personal-knowledge workload: private, modest-sized (10k–100k papers), and
question-driven — the exact shape where standing up a Neo4j server is overkill and
a desktop app's search box is too weak. RelateDB as an embedded library (Python
bindings for the Zotero-import script) makes the conversion a `pip install` away;
the WAL keeps incremental re-imports cheap; and the resulting `.cl` file is a
portable backup of your intellectual history — commit it, sync it, or open it in
the browser (WASM) for a visual map of your field. Temporal types carry read dates
for the "what was I reading in 2019" replay, and vector search over titles/
abstracts complements the exact graph queries when you half-remember a paper.

## What it needs

- Zotero/BibTeX/CSL-JSON importer (the `cites` field → resolved `CITES` edges;
  library keys stay stable across re-exports)
- OpenCitation/Crossref reconciliation pass for missing edges (a network step,
  honest about being offline-optional)
- `RELATE_FULL_DATA`-style full/delta import modes for repeat runs
- Optional front-end: a browser viewer of the field map; or just serve MCP and let
  your agent answer "what did I read about X" from the graph

## Lineage & inspiration

- Zotero (better BibTeX export): https://zotero.org/ | CSL-JSON schema |
  Better BibTeX JSON-RPC export endpoint: https://retorque.re/zotero-better-bibtex/exporting/json-rpc/index.html
- OpenCitation COCI (open DOI→DOI citation data): https://opencitations.net/ —
  REST API: https://api.opencitations.net/index/v2 | bulk CSV dump:
  https://figshare.com/articles/dataset/Crossref_Open_Citation_Index_CSV_dataset_of_all_the_citation_data/6741422
- Crossref API: https://api.crossref.org/
- The classic citation-network datasets — KDD Cup 2003 arXiv corpus:
  https://www.cs.cornell.edu/projects/kddcup/datasets | APS Physical Review
  data: https://journals.aps.org/datasets | Netzschleuder's arXiv citation graph:
  https://networks.skewed.de/net/arxiv_citation
- arXiv Wedge idea (this repo) — the same queries at field scale rather than
  career scale
- Mark Newman's collection habit — provenance-checked citation graphs (his
  collaboration-network files are the model): https://websites.umich.edu/~mejn/netdata/
