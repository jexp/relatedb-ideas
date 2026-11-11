---
type: Project
name: wikipedia-wedge
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/DBpedia]]"
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: same-data
    reason: games played over the same link graph
    target: "[[Project/the-wikigame-powered-by-real-data]]"
  - kind: variant
    reason: dump to single file export applied to whole wikis
    target: "[[Project/wiki-as-a-file]]"
  - kind: variant
    reason: same wedge pattern over statements and references
    target: "[[Project/wikidata-wedge-for-research]]"
  - kind: complements
    reason: same data shipped offline to mobile
    target: "[[Project/wikipedia-in-your-pocket]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DBpedia]]"
  - "[[Technology/Kiwix]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Wikimedia Dumps]]"
  - "[[Technology/Wikipedia]]"
---

# Wikipedia Wedge

> Any article's link neighborhood as a graph file; "what does the article on
> *entropy* connect to that *information theory* doesn't?"

## What

Pick any Wikipedia article — *Entropy*, *Kevin Bacon*, *GraphQL* — and pull
everything within N link-hops of it from a dump: articles as nodes,
internal links as `LINKS_TO` relationships, plus categories, summaries, and
infobox fields as properties. The result is a "wedge" of the encyclopedia:
a few thousand pages that fit in a single `.cl` file you can email, commit,
or open in a browser tab.

The interesting queries are the ones Wikipedia's interface can't run: *what
does the article on entropy connect to that information theory doesn't?* is
one anti-join. *Which neighbor is the biggest bridge into the rest of the
encyclopedia?* is a betweenness-shaped aggregation. Because every edge is a
real editorial decision, the wedge is also a dataset about attention: what
does a community of editors consider adjacent?

The preprocessing has proven precedents. sdow — the Six Degrees of
Wikipedia engine — does the dump-side half of this exactly: it trims the
`page`, `pagelinks`, and `redirect` tables from the twice-monthly Wikimedia
SQL dumps down to namespace-0 pages and packs them into a single SQLite
file with per-page incoming/outgoing link lists (a ~4.3 GB compressed dump
becomes a queryable link database in a roughly two-hour build). DBpedia's
extraction framework is the veteran dump→graph pipeline — full wikitext
parsed into typed triples for every language edition. And Wikimedia's own
Clickstream datasets publish monthly counts of reader navigation between
article pairs: the *weighted* first hop of every wedge, free.

Wedges compose: load two side by side and diff their neighborhoods, or load
a whole category tree as a curated reading list that answers "what should I
read next, given what I've read" as a query.

## Why RelateDB

The wedge query model is exactly Cypher's shape — pattern matching over
labeled nodes and typed relationships — and RelateDB runs it at in-memory
speed with zero setup, from the CLI or, decisively, in the browser via the
WASM build: drop a `.cl` file on a page and the wedge is queryable with no
server at all. The single-file store (WAL + Parquet checkpoint) makes the
wedge a distributable artifact — the dataset *is* the attachment. And
`relate serve --mcp` turns a published wedge into a tool an agent can
query directly.

## What it needs

- A dump reader: Wikimedia `pages-articles` XML (or
  [Kiwix](https://www.kiwix.org) ZIM archives) → link table → graph
- A `relate pull`-style loader: `(:Article {title, summary})`,
  `[[Target]]` → `[:LINKS_TO]`, categories as nodes
- Hop-bound slicing (BFS over the dump before load, or post-load
  variable-length `MATCH` then subgraph export)
- A small browser page (WASM build) that fetches a `.cl` file and offers a
  query box with a few canned wedge queries

## Lineage & inspiration

- [Six Degrees of Wikipedia (sdow)](https://github.com/jwngr/sdow) /
  [sixdegreesofwikipedia.com](https://www.sixdegreesofwikipedia.com/) —
  a preprocessed SQLite link database over millions of pages, shortest
  paths found live by BFS at query time; the proof this data is fun
- [DBpedia extraction framework](https://github.com/dbpedia/extraction-framework)
  — the veteran Wikipedia-dump → structured-data pipeline
- [Research:Wikipedia Clickstream](https://meta.wikimedia.org/wiki/Research:Wikipedia_clickstream)
  — monthly reader-navigation counts between articles; weighted edges
- [Wikimedia dumps](https://dumps.wikimedia.org/) — the raw material
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — the ego-graph/hop-neighborhood analyses this data invites
