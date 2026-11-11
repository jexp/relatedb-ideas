---
type: Project
name: csv-to-graph-instantly
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: same embedded loader pipeline for a sibling file format
    target: "[[Project/parquet-to-graph]]"
  - kind: variant
    reason: same tabular-to-graph modeling insight from the spreadsheet side
    target: "[[Project/spreadsheets-are-graphs]]"
  - kind: complements
    reason: editing a table and materializing it as a graph share the model-inference step
    target: "[[Project/table-editor-to-graph]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/JSONL]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
---

# CSV → Graph, Instantly

> Drop a CSV, pick key columns, relationships materialize; the `pull`-style
> pipeline for any tabular source on the web.

## What

The whole job of `LOAD CSV` in Neo4j, minus the server: point a local command at
a CSV (path, glob, or URL), get an interactive Cypher session over the graph it
implies. The tool samples the file, infers types, proposes a model — these
columns look like an entity key, these two share values, want that as a
relationship? — and the user confirms or adjusts with flags. One command later,
the data is nodes and relationships in a `.cl` store, and the prompt drops into
the CLI's query session.

The interesting part is the *modeling* step. Tabular data hides graphs in
joins: an orders CSV plus a customers CSV is already `(Customer)-[:PLACED]->(Order)`
if `customer_id` matches. A single denormalized table is a bipartite graph
waiting to happen — each distinct value in a categorical column becomes a node,
each row becomes the edges through them. The tool makes that implicit structure
explicit, with a preview (`MATCH (n) RETURN labels(n), count(*)`) before you
commit.

The embedded version of the load half already exists in Kùzu: an
embedded property-graph database whose `COPY FROM` loads CSV (and
Parquet/JSON) into declared node and relationship tables — one file or a
whole folder, no server — the modeling-first pattern in an embedded
engine. What no tool does yet is the inference in the other direction:
read the CSV's shape and *propose* the graph model, the way every
tabular profiler wants to but graph loaders don't.

Then it composes: the same pipeline runs over TSV, JSONL, and any URL — because
the `pull` command already proved the shape (fetch from a remote Query API,
generate `CREATE` statements, load into a store). CSV is just the cheapest
possible source dialect.

## Why RelateDB

`relate pull` is the architectural precedent: it already turns a remote
Neo4j/Aura Query API v2 response into `CREATE` statements flowing into a local
store — this project swaps the fetcher for a CSV reader and reuses everything
downstream. The CLI's table/CSV/JSON/JSONL output formatters mean the pipeline
is symmetric: graphs in, tables out, tables in, graphs out. And because the
store is one file (WAL + Parquet checkpoint) and the engine is in-memory, the
whole loop — load, explore, adjust the model, reload — happens at interactive
speed with zero infrastructure, exactly the clickhouse-local "the binary IS
the product" ergonomics.

## What it needs

- A CSV/TSV/JSONL reader (streaming, delimiter sniffing, type inference) —
  or a thin wrapper over `relate-arrow`, which already converts rows
- A model-inference pass: candidate keys, foreign-key matches between files,
  categorical columns → node proposals, with a `--dry-run` preview
- Flags: `--label-col`, `--key`, `--rel a.b=orders.customer_id`, `--batch-size`,
  URL sources alongside paths and globs
- A cookbook recipe per canonical shape: two joined CSVs, one denormalized
  table, a gnarly real-world export

## Lineage & inspiration

- `relate pull` (ADR-0080) — the existing fetch → `CREATE` → store pipeline
  this project generalizes
- [clickhouse-local](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — the masterclass in pointing one binary at local/remote files with format
  auto-detection
- [Neo4j's `LOAD CSV` guide](https://neo4j.com/docs/getting-started/load-import-csv/)
  — the server-side version this makes serverless
- [Kùzu import docs](https://kuzudb.github.io/docs/import/) — `COPY FROM`
  CSV/Parquet/JSON into an embedded property graph; the closest incumbent
