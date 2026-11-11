---
type: Project
name: parquet-to-graph
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/DuckDB Labs]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: variant
    reason: same load-a-folder-into-a-graph wedge over a different file format
    target: "[[Project/csv-to-graph-instantly]]"
USES_TECH:
  - "[[Technology/Apache Arrow]]"
  - "[[Technology/ClickHouse]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/Polars]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Spark]]"
---

# Parquet → Graph

> Relational/analytical data (Parquet, Arrow) re-modeled as graphs: shared keys
> become edges; graph queries over columnar exports.

## What

Every analytics team has a lake of Parquet exports — event tables, dimension
tables, a data share from a partner — and no way to ask a *relational* question
of them without standing up a warehouse. This project makes RelateDB the
thing you point at the folder: `relate load ./events/*.parquet --model
model.json`, and the columnar data becomes a property graph. Dimension tables
become labeled nodes; fact tables become relationship sources; shared keys
become the edges. Then the questions are traversals, not five-way joins.

The mapping layer is where the value is. A `model.json` declares which Parquet
columns map to node keys, which tables are dimensions, which are facts — the
same declarative shape as a warehouse dbt model, but the output is a graph you
walk. Rebuild is incremental: new Parquet files in the folder are new rows in,
new nodes and edges out, into the WAL-backed store.

The reverse direction matters too: a graph *exported* as Parquet (one row per
node, one per relationship) round-trips through any Arrow-native tool —
pandas, Polars, DuckDB, Spark. Because RelateDB's own checkpoints are
Parquet, the interchange is native, not an afterthought.

The single-binary workflow to port is ClickHouse's: clickhouse-local
reads and writes Parquet with the same engine code as the server
(`DESCRIBE TABLE file('x.parquet')`, `file()`/`s3()` table functions,
glob paths, format conversion in one process — their Parquet deep-dive
walks exactly this loop). And the columnar→graph direction already has
one embedded precedent: Kùzu imports Parquet directly into node and
relationship tables via `COPY FROM` — the nearest existing tool, minus
RelateDB's checkpoint-native interchange.

## Why RelateDB

`relate-arrow` already converts `CypherValue` ↔ Arrow `RecordBatch` — the
 hardest 80% of a Parquet reader is done, since Parquet is just Arrow's
 serialization with a footer. The durable form is itself WAL + Parquet
 checkpoints, so "Parquet is the interchange" is a literal statement about the
 engine, not marketing: reading columnar data and writing columnar checkpoints
 are the same code family. And the in-memory engine means the rebuild loop
 (drop folder → re-model → reload → query) is seconds, not a warehouse
 spin-up.

## What it needs

- An `arrow-rs` Parquet reader (already in the dependency orbit of
  `relate-arrow`) with predicate pushdown on row groups
- The `model.json` schema: table → node/relationship mapping, key columns,
  type coercion, null policy, and a `--explain-model` dry run
- Incremental load: file-level change detection, idempotent `MERGE`-based
  ingestion
- Benchmark against LDBC-style CSV/Parquet fixtures (the loadtest datasets
  already exist in `relate-datasets`)
- Export direction: `relate export --format parquet` for nodes and
  relationships as separate files

## Lineage & inspiration

- [clickhouse-local on Parquet](https://clickhouse.com/blog/apache-parquet-clickhouse-local-querying-writing)
  — inspect, convert, and aggregate Parquet with a single binary; the exact
  workflow to port to graphs
- [DuckDB's Parquet story](https://duckdb.org/docs/data/parquet) — columnar
  files as first-class citizens of an embedded engine
- [Kùzu: Import Parquet](https://kuzudb.github.io/docs/import/parquet/) —
  the direct columnar→property-graph precedent in an embedded engine
- RelateDB's own WAL + Parquet checkpoint durability — the native-interchange
  argument
- [Neo4j's ETL tooling](https://neo4j.com/labs/etl-tool/) — the server-side relational→graph precedent
