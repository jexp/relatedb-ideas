---
type: Project
name: user-journey-recorder
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_ORG:
  - "[[Company/Obsidian]]"
RELATED_IDEA:
  - kind: complements
    reason: another browser plugin building a private local graph
    target: "[[Project/your-follow-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/PGlite]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# User-Journey Recorder

> A plugin records your own browsing as a temporal graph; "how did I end up
> reading this?" is literally a path.

## What

A browser extension that watches your navigation — every page visit, every
click that led to it, every tab fork, every search that seeded it — and writes
it as a temporal property graph: nodes are pages, edges are "navigated from X
to Y" with timestamps, referrer, dwell time, and the scroll depth as
properties. The back/forward stack becomes visible structure; the random-walk
session where you fell through six Wikipedia articles to a surprise conclusion
is preserved as the actual path you took.

The query is the pitch: "how did I end up reading this?" is
`MATCH p = (start:Page {host:'news.ycombinator.com'})-[:NAVIGATED*..10]->(t:Page
{url:$here}) RETURN p` ordered by timestamp — the provenance of your own
attention. Add the reverse: "what do I always end up reading after visiting
X?" — a personalized most-frequent-path query over your own history.

Everything stays local: the extension talks to a RelateDB store on disk
(through the WASM build in-page, or a local `relate serve` over HTTP), and
the graph is yours — a search engine over your own journey that no cloud
ever sees. Opt-in sharing exports a session as a single `.cl` file: "here's
the reading path that convinced me," attachable to a blog post.

## Why RelateDB

The WASM build runs the engine inside the browser itself, so the extension
needs no native binary — persistence to IndexedDB-style storage via the VFS
layer, queries at in-memory speed over thousands of visited pages. The
WAL-backed durable form means the history is append-only and replayable: any
time window is "the graph as it was then," which is exactly what a journey
recorder wants. And the CLI's `pull`-family pattern (a stream of events →
`CREATE` statements) is the ingestion model; `db.schema.visualization` gives
the journey map for free.

## What it needs

- A browser extension (Chrome/Firefox): navigation events, tab lifecycle,
  referrer capture, dwell-time tracking
- A page-content extractor: title, host, reading time, topic tags
- In-page WASM store or a local `serve` endpoint — both are supported shapes
- Query UI: path-to-here, sessions-as-timelines, "after X I always read Y"
- Session export as a `.cl` file; privacy controls (never-record lists,
  pause, purge)

## Lineage & inspiration

- [User Journey / behavior-flow analytics](https://en.wikipedia.org/wiki/Clickstream)
  — the clickstream-analysis genre, made personal and local
- [PGlite](https://github.com/electric-sql/pglite) — an embedded engine living
  inside the browser as the extension's storage (RelateDB's WASM build is
  the graph analog)
- [Obsidian's graph view](https://obsidian.md) — personal navigation as an
  explorable graph, but live and from real behavior
- [Graphiti](https://github.com/getzep/graphiti) — temporal, episode-based
  graphs as the storage shape for stream-of-behavior data
