---
type: Project
name: the-movie-graph-all-grown-up
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/GroupLens]]"
  - "[[Company/IMDB]]"
  - "[[Company/Neo4j]]"
  - "[[Company/TMDB]]"
RELATED_IDEA:
  - kind: complements
    reason: same movie store aimed at one evening
    target: "[[Project/the-nothing-to-watch-chooser]]"
  - kind: complements
    reason: movie recommendation domain in the gallery
    target: "[[Project/use-case-gallery]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/IMDB]]"
  - "[[Technology/MCP]]"
  - "[[Technology/MovieLens]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/TMDB]]"
  - "[[Technology/WASM]]"
---

# The Movie Graph, All Grown Up

> TheMovieDB/IMDB imports (the tutorial dataset of the whole graph
> world, now with the full catalog): collaborative filtering as plain
> Cypher ("people who liked what you liked"), and the 2026 twist —
> agents running hybrid search (fulltext + vector `COMBINE`) over
> plots and reviews for recommendations that cite their evidence.

## What

The movies graph is the "hello world" of the entire graph world — every Neo4j
tutorial since 2012 has Tom Hanks in it. This project is that dataset, all grown up:
the full TMDB/IMDB catalog, ratings history layered on, and the recommendation
classics run as plain Cypher — "people who liked what you liked also liked",
co-rating similarity, genre-mood bridges — the tutorial queries everyone learned,
finally against real data at real scale, in one local store.

The 2026 twist is the agent layer: plots and reviews carry vectors, and hybrid
search (fulltext + vector, CIP-278 `COMBINE`) lets an agent answer "something like
*Arrival* but not sad, 90 minutes" with candidates *that cite their evidence* —
matched on plot synopsis, cross-checked against collaborative-filtering paths,
returned with "because you loved *Contact*." The grown-up movie graph is where the
engine's two halves meet: structure says who connects to what, semantics says why —
and the recommendation shows both receipts.

## Why RelateDB

This is the tutorial dataset of the graph world finally on the engine
the tutorials' audience already has installed — one binary, one `.cl` file, no
server-setup ritual between you and "who directed the person who directed *Cloud
Atlas*". The full TMDB import (hundreds of thousands of nodes, millions of edges)
sits in memory, and the `relate-load` path pulls the classic Neo4j
graph-examples movies dataset (and an Aura instance) straight in for side-by-side
runs of the old tutorial queries. Hybrid search — `COMBINE` over fulltext + vector —
is the piece past movie-graph recommendations lacked: content-based and
collaborative, one query syntax, over plots and reviews in the same store. The WASM
build makes it a shareable browser demo (the graph world's first graph, in your
first tab), `serve --bolt` lets existing Neo4j movie-graph tooling run unmodified,
and MCP puts it in agents' hands — recommendations that cite their evidence,
precisely the "agent answers from the graph, not from training data" showcase.

## What it needs

- TMDB/IMDB importer via `relate-arrow` (credits, keywords, plots,
review corpus) plus the `relate-load` Neo4j examples pull for
  the classic 38-node dataset
- Ratings layer: personal history plus a public ratings slice
(MovieLens for the collaborative cold start) - The recommendation pack: co-rating
similarity, genre-mood bridges,
  hybrid `COMBINE` over plots/reviews — every result returning its
evidence path

## Lineage & inspiration
- The neo4j-graph-examples movies dataset — the tutorial dataset of
the entire graph world (research/graph-world.md):
https://github.com/neo4j-graph-examples/movies
- TMDB — the full-catalog source: https://www.themoviedb.org/ |
IMDB datasets: https://developer.imdb.com/
- MovieLens (GroupLens) — the public ratings corpus for the collaborative half:
https://grouplens.org/datasets/movielens/
