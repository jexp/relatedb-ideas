---
type: Project
name: json-ld-everywhere
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/Google]]"
  - "[[Company/Schema.org]]"
  - "[[Company/Web Data Commons]]"
RELATED_IDEA:
  - kind: complements
    reason: the companion project querying the schema where this one queries the instances
    target: "[[Project/rdf-ontology-metagraph]]"
USES_TECH:
  - "[[Technology/Common Crawl]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/JSON-LD]]"
  - "[[Technology/RDF]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Schema.org]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Web Data Commons]]"
---

# JSON-LD Everywhere

> A page (or a whole crawl's) structured data into the graph; Schema.org
> markup was already a graph — now it's a queryable one.

## What

Most of the interesting web already declares itself as a graph: JSON-LD
blocks in `<script type="application/ld+json">` describe every recipe,
product, event, business, and review with Schema.org types. This project
finishes the thought: extract those blocks, resolve `@context` and `@id`,
follow `@type` to labels and nested references to relationships, and load
the result as a property graph. One page becomes a small subgraph; a whole
crawl becomes a Schema.org knowledge base you can query with joins, paths,
and aggregations the page's own markup never allowed.

The queries write themselves: over a crawl of restaurant sites — *which
places serve both vegan and gluten-free, are rated above 4.5, and sit
within walking distance of a transit stop?* Over event listings — *find
date conflicts between `MusicEvent`s at the same venue*. Over product
pages — *which sellers reference the same `Product` ID*? Because JSON-LD
nodes carry stable `@id` URIs, merging across pages is `MERGE`, and the
graph becomes the deduplicated union of what the web claims about itself.

The crawl-scale version already runs, and its output is downloadable:
Web Data Commons extracts Microdata, JSON-LD, RDFa, and microformats from
the Common Crawl and publishes the result — the Schema.org Table Corpus
(WWW 2023 paper) ships class-specific tables for products, offers,
events, and local businesses, and the newest release counts 97.7 billion
quads from 14.6 million websites. That corpus is this project's dream
input: the web's structured data, already crawled, waiting for a
property-graph loader.

The same loader runs on any dropped JSON-LD file — a crawl export, an API
response, Activity Streams, FHIR, Verifiable Credentials — structured-data
file → queryable graph in one command.

## Why RelateDB

JSON-LD *is* a graph serialization, and RelateDB is a graph engine with
no server in the way: a `relate pull`-style loader plus in-memory
Cypher means a 100k-document crawl loads into one store on a laptop and
answers aggregations instantly. The WASM build makes the browser version
possible — drop a crawl file on a page, query it in the tab, export the
subgraph you found. The single-file store means the resulting Schema.org
graph is shareable as one artifact. And the vector/hybrid search preview is the
second act: "find similar products" becomes hybrid retrieval over the
graph.

## What it needs

- A JSON-LD processor (context expansion, `@id`/`@type` resolution, blank
  nodes) → `MERGE`-based loader; RDF-quad normalization is a fine intermediate
- A crawler or file-ingest side: headless fetch of a URL list, or accept
  JSON/JSON-LD files directly
- Cross-page identity resolution policy (`@id` merge, plus fuzzy matching
  for sites that mint different IDs per page)
- A cookbook of Schema.org query recipes (recipes, events, products,
  local business)

## Lineage & inspiration

- [JSON-LD](https://json-ld.org) and [Schema.org](https://schema.org) — the
  format and vocabulary this project queries
- [Web Data Commons: structured data](https://webdatacommons.org/structureddata/)
  — JSON-LD/Microdata/RDFa extracted from the Common Crawl, published as
  datasets
- [The WDC Schema.org Table Corpus (WWW 2023)](https://dl.acm.org/doi/pdf/10.1145/3543873.3587331)
  — schema.org classes as relational tables from billions of pages
- [Google's Structured Data docs](https://developers.google.com/search/docs/appearance/structured-data) — why the data is already there
- [RDF Ontology Metagraph](rdf-ontology-metagraph.md) — the companion
  project: query the *schema*; this one queries the *instances*
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — co-occurrence/bipartite analyses once pages are graphs
