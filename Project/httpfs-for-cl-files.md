---
type: Project
name: httpfs-for-cl-files
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/DuckDB Labs]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the edge half of the small-slice-cached versus lazily-ranged geometry
    target: "[[Project/edge-workers-graphs]]"
  - kind: complements
    reason: the serverless half of the same published-file geometry
    target: "[[Project/graph-database-in-a-lambda]]"
  - kind: complements
    reason: the shared VFS seam both new virtual stores implement
    target: "[[Project/graph-lens-over-any-database]]"
USES_TECH:
  - "[[Technology/Amazon S3]]"
  - "[[Technology/DuckDB httpfs]]"
  - "[[Technology/HTTP Range Requests]]"
  - "[[Technology/IPFS]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/sql.js-httpvfs]]"
---

# httpfs for `.cl` Files

> A published `.cl` on any static host (GitHub Pages, S3, IPFS) queried
> *in place* over HTTP range requests — load the blocks you need, not the
> file. The sql.js-httpvfs move, for graph files.

## What

phiresky's trick — hosting a SQLite database on GitHub Pages and querying
it from the browser with plain HTTP range requests, loading only the pages
the B-tree walk touches — changed what "publish a dataset" means: a URL
becomes a database, a 670 MiB file becomes a lazy stream, the host is any
dumb static file server. DuckDB's httpfs did the same for Parquet. Graph
files deserve the same deal.

This project is range-request access for `.cl`: the checkpoint is already
columnar Parquet — the pieces (row groups, footers, offsets) that
range-loading wants are the native format. A reader that walks the
checkpoint's metadata over HTTP, pulls only the row groups the query's
labels and relationships touch, and answers the query — without ever
downloading the file. A 2 GB OpenSanctions slice, a Panorama-Papers
export, a genome-scale graph: published once as a URL, queried from any
tab, no server, no cost floor.

The honest boundary: random-range reads are only a win when the query
touches a *bounded* fraction of the file (label scans, neighborhood
lookups, seeded traversals — the pattern-match majority); full-store
analytics over HTTP are just a slow download, and the reader should say so
and offer the fetch-it-once path.

## Why RelateDB

The durable form is already range-shaped (Parquet checkpoints with
block-level metadata), the WASM build is already the in-tab engine, and
the VFS layer is already an abstraction with Native and Memory backends —
an HTTP-range virtual store is one more VFS implementation, the same seam
the table-lens idea targets. Combined with the S3/edge work (the Lambda
and Workers ideas) it completes a geometry: small slices *fully* cached at
the edge, huge datasets *lazily* ranged over — every published `.cl` a URL
with a query interface.

## What it needs

- The HTTP-range VFS: checkpoint metadata reader, row-group fetcher, block
  cache, and byte-range read accounting (the cost display the honest
  boundary needs)
- The block-selection heuristic: which row groups a pattern's labels/types
  touch (the catalog as the index of blocks)
- A `relate query --url https://...` CLI form beside the WASM tab form
- The gallery: three big public datasets published as URLs (the
  use-case-gallery content, now remote)
- Benchmarks: ranges fetched vs. query shapes — where laziness wins, where
  fetch-once wins

## Lineage & inspiration

- [sql.js-httpvfs (phiresky)](https://github.com/phiresky/sql.js-httpvfs)
  and [the blog post](https://phiresky.github.io/blog/2021/hosting-sqlite-databases-on-github-pages/)
  — the move this project transplants: database-on-a-URL, range-requested
- [DuckDB httpfs](https://duckdb.org/docs/current/core_extensions/httpfs/overview)
  — remote Parquet/S3 over ranges; the columnar precedent (and the
  duckdb-wasm parity, `research/embedded-ecosystems.md`)
- [Graph Lens over Any Database](graph-lens-over-any-database.md) — the
  VFS seam this shares; [Edge Workers Graphs](edge-workers-graphs.md) and
  [Graph Database in a Lambda](graph-database-in-a-lambda.md) — the
  geometry this completes
