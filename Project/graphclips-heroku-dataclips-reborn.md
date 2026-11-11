---
type: Project
name: graphclips-heroku-dataclips-reborn
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/Heroku]]"
  - "[[Company/Neo4j]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Datasette]]"
  - "[[Technology/Evidence]]"
  - "[[Technology/Heroku Dataclips]]"
  - "[[Technology/Huey]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# GraphClips (Heroku Dataclips, Reborn)

> Save any query result as a shareable file — but each result *is itself a
> graph*: open the clip in another instance (or in the browser) and keep
> querying it. Results as first-class, queryable artifacts.

## What

Heroku Dataclips captured something small and durable: a saved query whose
result lives at a URL, embeddable in a dashboard or a wiki, refreshable by
anyone who opens it. This project resurrects the idea with one property
Dataclips never had: the result of a Cypher query can carry *structure*. A
`MATCH p = (a)-[:KNOWS*..3]->(b)` result isn't a table — it's a subgraph, and
a GraphClip preserves that. The clip is a `.cl` file: nodes, relationships,
the provenance (source store, query text, parameters, timestamp), and the
result-as-a-graph you can open and query further.

The workflow: you're exploring, find something worth keeping — a suspicious
ownership ring, a clean citation cluster — and `SAVE CLIP` freezes it as a
file. Attach it to the ticket; the recipient drops it into their own RelateDB
(or opens it in a browser tab, WASM, zero install) and runs the follow-up
queries *on the clip*, without access to (or risk from) the original store.
The clip is a result, an artifact, and a sandbox in one.

Live clips close the loop: a clip bound to (source, query, params) can
re-execute on schedule or on open, so "the team's dashboard" is a folder of
self-describing clip files — the Dataclips publishing model where the unit
is a queryable graph.

## Why RelateDB

The single-file store makes the clip *be* a store: saving a result is
generating `CREATE`s into a fresh `.cl` file — the same machinery `pull`
already runs, pointed at a query result instead of a remote. The WASM build
is the universal viewer: any clip opens in a browser tab with a live Cypher
shell, no install, which is the "share it with anyone" property Dataclips
never had. The CLI's JSON/JSONL formatters handle the table-shaped clips, and
`db.schema.visualization` gives every clip a one-shot diagram of what it
contains.

## What it needs

- `SAVE CLIP <name>` in the CLI/HTTP surface: freeze result subgraph +
  provenance metadata into a `.cl` file
- Subgraph extraction: from a result of paths/nodes/relationships to the
  distinct entities and edges (with original IDs kept as properties)
- Clip reader: `relate info/open clip.cl`, plus the WASM drag-and-drop
  viewer with the clip's query and params displayed
- Live clips: refresh-on-open against the source (auth via the existing
  token scheme), with the frozen fallback when the source is unreachable

## Lineage & inspiration

- [Heroku Dataclips](https://devcenter.heroku.com/articles/dataclips) — the
  product being reborn, and proof saved queries are a durable want
- [Datasette](https://github.com/simonw/datasette) — publish-and-share a DB
  artifact read-only, instantly
- [Evidence](https://evidence.dev) — queries-as-prose compiled to shareable
  pages; the publishing discipline. And [Huey](https://github.com/rpbouman/huey)
  — client-side exploration over a shared data file
