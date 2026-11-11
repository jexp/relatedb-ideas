---
type: Project
name: sparse-matrix-meet-graph
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/DuckDB Labs]]"
  - "[[Company/Texas A&M University]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the numeric runtime the export bridge feeds
    target: "[[Project/networkx-runtime]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/Matrix Market]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SciPy]]"
  - "[[Technology/SuiteSparse Matrix Collection]]"
---

# Sparse Matrix, Meet Graph

> Matrices as bipartite graphs; the operations research people didn't know
> they wanted this.

## What

A huge slice of scientific computing lives in sparse matrices — users×items
recommendation matrices, users×permissions, terms×documents, species×sites,
tasks×resources. Every one of them is secretly a bipartite graph: rows are
one node type, columns are another, nonzeros are edges with values. This
project is the loader and the query pack that makes the equivalence
actionable: `relate matrix load ratings.mtx --row User --col Item --weight
rating` and the matrix is a graph, queryable in Cypher.

Then the matrix idioms become graph idioms. Structural sparsity analysis
("which rows have no support in these columns?") is a Cypher pattern match.
Collaborative filtering's "users who liked what you liked" is a two-hop path
through the bipartite graph. Coverage and conflict detection in a
permission/role matrix — every (user, permission) cell reachable through
which roles — is a traversal question, and the *explanations* come free: the
path *is* the derivation, not a post-hoc reconstruction.

The other direction completes the story: export the graph back to Matrix
Market, or hand the bipartite graph to scipy/networkx for the numeric work,
and take the results back as node properties. The matrix people keep their
solvers; they gain a query language for the structure.

## Why RelateDB

The `pull`-style ingest pipeline (a source format → generated `CREATE`
statements → a local store) is already the engine's proven shape, and the
CLI's CSV/JSON/JSONL output formatters make the round-trip back out cheap.
Because the engine is in-memory, structural queries over even dense bipartite
slices (millions of nonzeros) run at scan speed with no server and no
warehouse — the clickhouse-local "point a binary at a numeric file" identity,
but the questions are traversals. And `:memory:` stores make scratch
analysis free: load a matrix, ask a structural question, throw it away.

## What it needs

- Matrix Market (`.mtx`) and coordinate-CSV readers; dense-CSV → sparse
  extraction
- Type flags for bipartite projection: `--row-label`, `--col-label`,
  `--weight-prop`, `--zero-means-absent` vs. explicit
- A query pack: support queries, two-hop recommendation, coverage/conflict
  detection, degree distributions (= row/col sparsity profiles)
- Export: back to `.mtx` / coordinate CSV from a `MATCH` result
- Bridges to scipy/networkx via the export (feeds the NetworkX Runtime idea)

## Lineage & inspiration

- [SuiteSparse Matrix Collection](https://sparse.tamu.edu/) — the canonical
  corpus of real sparse matrices to load
- [NetworkX's bipartite module](https://networkx.org/documentation/stable/reference/algorithms/bipartite.html)
  — the graph↔matrix equivalence, formalized
- [DuckDB in science](https://duckdb.org/science/) — the model of an embedded
  engine owning a scientific workload
- `relate pull` — the source→`CREATE`→store pipeline this loader reuses
