---
type: Project
name: single-file-graph-stories
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/Electric SQL]]"
  - "[[Company/Ink & Switch]]"
MENTIONS_PERSON:
  - "[[Person/Simon Willison]]"
RELATED_IDEA:
  - kind: variant
    reason: explicitly framed as GraphGist without the server
    target: "[[Project/graphgists-reborn]]"
  - kind: complements
    reason: both publish a graph as a portable, shareable artifact
    target: "[[Project/static-sites-from-dynamic-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Datasette]]"
  - "[[Technology/GraphGist]]"
  - "[[Technology/PGlite]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/clickhouse-local]]"
---

# Single-File Graph Stories

> One `.cl` file = data + schema + (soon) queries; email it, commit it, attach
> it to a ticket. Datasets as artifacts, not servers.

## What

The insight SQLite rode to world domination: when the database is a file, the
file becomes the sharing unit — and everything humans already do with files
(diffs, PRs, attachments, archives, `scp`) becomes database tooling for free.
This project makes that identity explicit for RelateDB: a `.cl` file as a
first-class *publication format* — data, schema, catalog metadata, and
bundled named queries in one artifact, plus the conventions and tooling that
make it travel well.

A "graph story" is a packaged dataset: the store file, a manifest (labels,
relationship types, counts, provenance, license), a README rendered by
`relate info --database x.cl --json`, and named queries — the analysis
you *meant* people to run — stored inside or beside the file so the consumer
doesn't start from a blank prompt. Think GraphGist without the server: open
the file in the browser (WASM) and the story presents itself, queries and all.

The distribution layer is deliberately boring: commit it (git handles binary
diffs poorly, but checkpoints are append-friendly), attach it to a Linear/GitHub
issue, drop it in a shared drive. `relate info` and the read-only HTTP
publish mode (the Datasette move) are the discovery tools.

## Why RelateDB

The durable form already *is* one file-ish artifact: an fsync'd WAL plus
Parquet checkpoints in a single store — `relate info --database` already
inspects it, and the in-memory engine opens any file instantly with no
attach/recovery ceremony. The catalog (labels, rel types, property keys)
means schema ships inside the artifact, not beside it. And the WASM build
makes the *reader* free: no install, no server — anyone with a browser tab
can open and query the story, which is the property that makes file-as-dataset
compelling rather than just convenient.

## What it needs

- A manifest/spec for what a "story" bundle contains (store + named queries +
  metadata + license)
- Named-query storage inside the store (a `__queries` catalog namespace) and
  `relate query --list/--run name`; `relate info --json` as the
  machine-readable summary (exists); a read-only publish mode over the HTTP surface
- Browser reader: drag a `.cl` file onto a page, get schema + named queries +
  a Cypher shell (WASM)
- Size discipline: streaming open for large files, so email-size stories
  stay the common case

## Lineage & inspiration

- [Datasette](https://github.com/simonw/datasette) — instant read-only
  publishing of a DB file; the tool that made "file as dataset" a movement
- [clickhouse-local](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — the binary-as-product ergonomics around local files
- [PGlite](https://github.com/electric-sql/pglite) — a real engine in the
  browser as the universal reader
- [Ink & Switch, Local-First Software](https://www.inkandswitch.com/local-first/)
  — data as files users own and share, the ideology this makes concrete
