---
type: Project
name: graph-lens-over-any-database
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/DuckDB Labs]]"
  - "[[Company/Neo4j]]"
USES_TECH:
  - "[[Technology/Apache Calcite]]"
  - "[[Technology/Arrow]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/clickhouse-local]]"
---

# Graph Lens over Any Database

> A read-mostly layer over SQLite/DuckDB/Postgres tables via the VFS; graph
> queries without a migration project.

## What

Every organization's data already lives in tables — SQLite apps, DuckDB
analytics, Postgres production. Nobody is going to migrate it to a graph
database next quarter, and they shouldn't have to: the questions are
relational, the storage is fine, only the *query language* is wrong for the
question. This project is a lens: point RelateDB at existing tables and run
Cypher over them — no export, no ETL, no migration.

The mechanism is the VFS layer: a table-backed virtual store where a mapping
(SQL table → node label / relationship type, PK/FK columns → keys and edges)
is declared once, and the lens translates Cypher patterns into reads against
the source. Read-mostly by design — the source of truth stays where it is;
writes stay an explicit, opt-in later chapter (or never: the lens is for
questions, not custody). DuckDB is the flagship target since it already speaks
the analytical-file world; SQLite next; Postgres over the wire for the brave.

The honest framing: this is a federation *query* layer, not a replication
story — for hot data you materialize a subgraph into a real `.cl` store (the
pull pipeline again) and query locally, with the lens as the discovery and
exploration tier over the cold majority.

## Why RelateDB

The storage architecture is already VFS-abstracted (WAL + checkpoints ride
the VFS layer; Native and Memory implementations exist) — a table-backed
virtual store is a new VFS implementation, not an engine rewrite. The
catalog layer already models labels, relationship types, and property keys
as first-class data, which is exactly the metadata a table-mapping needs to
compile into. And `relate-arrow` means the DuckDB path is nearly free:
Arrow RecordBatch is the native interchange both engines already speak.

## What it needs

- A mapping DSL: table → label, join columns → relationships, type coercion,
  with `--explain` showing the inferred graph schema
- VFS-backed scans: push `MATCH` leaf patterns down as table reads (DuckDB
  via Arrow, SQLite via its C API, Postgres via HTTP/Arrow)
- The materialize bridge: `relate lens snapshot --labels A,B` → real
  `.cl` store (reuse the `pull` machinery)
- Benchmarks: pattern depth vs. pushdown effectiveness; where full
  materialization wins
- Guard rails: read-only enforcement at the VFS level, timeouts, connection
  pooling

## Lineage & inspiration

- [clickhouse-local's remote engines](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — one binary querying files and URLs it doesn't own
- [duckpgq](https://github.com/cwida/duckpgq) — property-graph queries over
  columnar tables inside DuckDB; the SQL/PGQ precedent
- [Apache Calcite](https://calcite.apache.org/) — the query-federation
  tradition this project joins
- RelateDB's VFS + catalog layers — the native seams the lens plugs into
