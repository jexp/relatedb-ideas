---
type: Project
name: cypher-on-cypher
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: variant
    reason: GDS projections are the direct lineage, landed in the same store instead
    target: "[[Project/gds-round-trip]]"
  - kind: inspired-by
    reason: a stored query result as a queryable artifact, here kept live in-store
    target: "[[Project/graphclips-heroku-dataclips-reborn]]"
  - kind: complements
    reason: the pipe-between-invocations UX this projection model is queried through
    target: "[[Project/shell-native-cypher]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JSONL]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j GDS]]"
  - "[[Technology/RelateDB]]"
---

# Cypher on Cypher

> Composability: run a query over another query's result — a projection/
> subgraph fork that can be stored, re-parameterized, and queried again;
> the dataflow-shell for Cypher (pipe, filter, re-shape).

## What

Cypher grew up as a one-shot language: a query goes in, rows come out. But
real analysis is a *pipeline* — filter, transform, re-shape, ask again — and
today the pipeline lives in whatever host language wraps the driver. This
project makes the pipeline a first-class engine concept: a named query
result that is itself a graph you can query.

Concretely: `CREATE PROJECTION explorers AS MATCH (u:User)-[:VISITED]->(p)
WHERE u.activity > 5 RETURN u, p` materializes that subgraph as a queryable
namespace; then every subsequent query runs over `explorers` with the full
language — traversals, aggregations, further projections on top of it. The
result carries its definition (the query and the parameters it was run with),
so it can be re-parameterized (`REFRESH explorers {activity: 10}`) or stored
as an artifact — the GraphClips idea is this, serialized.

The shell framing is the UX: `relate query "MATCH ..." | relate
query -` — pipe results between invocations, Unix-style. And composability
pays off for agents: an MCP-connected agent builds a narrowing chain of
projections instead of one ever-growing ad-hoc query it can't reason about.

## Why RelateDB

The GDS projection model is the direct lineage — but GDS projections land in
a sidecar catalog; here the projection is a subgraph in the same embedded
store, queryable with everything else, because there is only one store.
The in-memory engine makes materializing intermediate results cheap (it's
a copy into a fresh graph, not a server round-trip), and `:memory:` stores
make scratch projections disposable. The WAL + checkpoint form means a saved
projection is durable and diffable like any store. And the CLI already emits
JSON/JSONL — the pipe-between-invocations mode is a formatter away. The
`system_ontologies` namespace machinery (ADR-0116/ADR-0227) is precedent for
statement routing to non-default graph targets inside one store.

## What it needs

- Projection syntax/verbs: `CREATE/DROP/REFRESH PROJECTION name AS <query>`
  with a catalog of defined projections (`SHOW PROJECTIONS`)
- Projection-as-target routing: `FROM explorers MATCH ...` or a namespace
  route, decided against the USE/namespace architecture (ADR-0116)
- Identity policy: how projected nodes/edges map back to originals
- MCP exposure: projections as inspectable, refreshable tools
- An ADR — this is a dialect decision (projection is a statement form)

## Lineage & inspiration

- [Neo4j GDS projections](https://neo4j.com/docs/graph-data-science/current/graph-projecting/)
  — the compute-over-a-subgraph model, kept but landed in-store
- [clickhouse-local in shell pipelines](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — the unix-tool-that-speaks-a-query-language identity
- [PRQL](https://prql-lang.org/) / dbt — query-as-named-artifact with
  lineage; the composability discipline
- Cypher's `CALL { ... }` subquery form (TCK-dialect) — the in-language
  composition seed
