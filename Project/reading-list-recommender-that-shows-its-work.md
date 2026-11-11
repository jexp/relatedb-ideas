---
type: Project
name: reading-list-recommender-that-shows-its-work
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/Goodreads]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Readwise]]"
  - "[[Company/UC San Diego]]"
MENTIONS_PERSON:
  - "[[Person/Mengting Wan]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Goodreads Datasets]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Readwise]]"
  - "[[Technology/RelateDB]]"
---

# Reading-List Recommender That Shows Its Work

> Explainable paths through your own highlights. With real data: the
> Goodreads datasets (books, authors, shelves, ratings — already
> graph-shaped) as the classic import; the Neo4j community's Goodreads
> tutorials are the lineage, embedded this time.

## What

Every recommendation engine answers "read this next" with a score, and every reader
wants the one thing the score omits: *why this, for me, now?* This project answers
in paths. Your reading life is a graph — `(:Book)-[:BY]->(:Author)`,
`(:Reader)-[:HIGHLIGHTED]->(:Passage)- [:FROM]->(:Book)`,
`(:Book)-[:NEXT_IN_SERIES]->`, shelves as typed clusters — and a recommendation is
returned as a traversal: "because you highlighted the grief chapters of *A Grief
Observed*, and this author cites its consolation chapters" — an explainable path,
not an embedding. The classic import is the Goodreads datasets — books, authors,
shelves, ratings, the whole UCSD book-graph — so the cold start is real data.

The queries that make it a *list* tool: "authors who connect the three
books I loved most this year" (the bridge-writer query); "the one hop I keep almost
taking" — adjacent authors I've never read, ranked by how many paths lead to them;
and the anti-recommendation: "what does my did-not-finish shelf say about my one-hop
choices".

## Why RelateDB

Explainability is traversal, so the engine whose whole interface is a
traversal language wins by construction — the answer and its reasoning
are the same artifact, a path you can read. The Goodreads dataset is millions of
records, in-memory comfortably, imported columnar via `relate-arrow` (the import
path built for this shape), and the personal layer (highlights, notes, shelves) is
one `.cl` file: your reading life as a single portable, private, git-back-uppable
artifact — the server-based Goodreads tutorials' genre, embedded at last. Hybrid
search over your highlight prose ("find where I underlined the thing about habit")
plus Cypher for the structure; temporal types make "what I actually finish in
winter" a queryable pattern; and MCP lets your agent plan reading from the real
graph — "queue the next five from the bridge-author, skipping what the DNF shelf
warns against" — with citations instead of a black-box score.

## What it needs

- The Goodreads dataset importer via `relate-arrow` (UCSD book
  graph: books/authors/shelves/ratings)
- The personal layer: highlights, notes, DNF and read edges with
  dates — ingest from Kindle/Readwise exports
- The explanation pack: bridge-author, one-hop-unread, path-ranked
  recommendations that always return their route

## Lineage & inspiration

- The UCSD Goodreads datasets (Mengting Wan et al) — books, authors,
  shelves, ratings for 900k books; the classic import:
https://cseweb.ucsd.edu/~jmcauley/datasets/goodreads/
- The Neo4j community's Goodreads tutorials — the lineage this project
embeds: readers' graph analysis and recommendation traversals, the
  *Neo4j in Practice* genre (see research/graph-world.md)
- Readwise — proof that people treat their highlights as a first-class
store worth querying (currently prose-search only): https://readwise.io/
