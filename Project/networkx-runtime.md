---
type: Project
name: networkx-runtime
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the procedure catalog is this adapter's named successor project
    target: "[[Project/gds-round-trip]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckPGQ]]"
  - "[[Technology/Graphicle]]"
  - "[[Technology/Neo4j GDS]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
---

# NetworkX Runtime

> `nx.compose(relate_graph("file.cl"))`; your nx algorithms, a Cypher
> backend. (And GDS-style procedures the other direction.)

## What

NetworkX is the lingua franca of graph algorithms in Python — 300+
implementations, a decade of teaching materials, and every data scientist's
muscle memory. But it is pure-Python and RAM-hungry, and its data model is
dicts all the way down. This project gives NetworkX a RelateDB *backend*:
a `Graph` adapter that presents a `.cl` store as an nx graph object, so
`nx.pagerank(relate_graph("wiki.cl"))` runs with the algorithm in Python
but the data living — and staying — in the graph store.

The two-way benefit is the real story. Inbound: the nx algorithm catalog
becomes callable over RelateDB stores, at scale (the adapter streams
neighborhoods rather than materializing dicts wholesale). Outbound: algorithm
*results* — PageRank scores, communities, kNN structures — are written back
as node properties and relationships, queryable in Cypher instead of dying
in a pandas frame.

The other direction of the idea: GDS-style procedures *inside* RelateDB
(the algorithm implemented as a callable), so the same catalog is reachable
from Cypher without Python at all. The adapter is the bridge project; the
procedure catalog is its successor — see the GDS Round-Trip idea.

## Why RelateDB

The Python binding already exists as a DB-API package over the C ABI — the
adapter is a Python-level project, no engine work required. The store side
has everything the adapter needs: schema introspection for node/edge types,
parameterized Cypher for streaming neighborhoods (`MATCH (n)-[r]->(m) WHERE
id(n) IN $batch`), and the CLI's JSON output already shaped for interop.
Because the engine is in-memory, the round trips that kill remote-driver
nx adapters (per-node neighborhood fetches against a server) are cheap
locally — and `:memory:` stores let an nx user keep algorithm-scratch
graph state in the same process.

## What it needs

- A `networkx.Graph` adapter: node/edge views over parameterized Cypher,
  batched neighborhood streaming, type mapping (`CypherValue` ↔ Python)
- Write-back API: scores as `SET n.pageRank = $v` batches; derived structures
  (kNN, communities) as relationships
- A curated port list: start with the 20 most-used algorithms (pagerank,
  connected components, betweenness, louvain, bipartite projections)
- The procedure-catalog successor plan inside the engine

## Lineage & inspiration

- [NetworkX](https://networkx.org/) — the algorithm catalog this project
  meets where it lives
- [Graphicle](https://github.com/wjthomkinson/graphicle) — already has a
  RelateDB port (per the README's lineage note); the adapter precedent
- [duckpgq](https://github.com/cwida/duckpgq) / DuckDB community extensions —
  property-graph reach into an embedded engine's ecosystem
- [Neo4j GDS's projection model](https://neo4j.com/docs/graph-data-science/)
  — compute-over-a-projection with results written back; the semantics to
  match
