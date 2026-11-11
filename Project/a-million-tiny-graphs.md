---
type: Project
name: a-million-tiny-graphs
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: synthetic-population benchmarking over the relate-datasets generators
    target: "[[Project/benchmark-zoo]]"
  - kind: same-data
    reason: molecule populations named as a first real corpus for the subgraph benchmark
    target: "[[Project/molecules-as-graphs]]"
USES_TECH:
  - "[[Technology/ClickHouse]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j GDS]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
---

# A Million Tiny Graphs

> RelateDB stores millions of small subgraphs cheaply; benchmark, partition,
> fan-out (map-reduce over subgraphs), cluster them.

## What

Most graph tooling assumes *one big graph*. But the world is full of
populations of small graphs: a million chemical structures, every commit's
file-change graph, each user's session tree, per-patient care pathways, every
game's opening sequence. One store holding all of them — each subgraph tagged
with its source and metadata — turns "graphs as data" into "data about
graphs": query *across* the population instead of within one instance.

The workflow is: bulk-load (each subgraph gets an ID and a `(Root)` anchor
node), then population questions in plain Cypher — which subgraphs contain
this motif, how many are isomorphic to this one, what's the distribution of
sizes/densities/diameters, which ones grew over time. Then map-reduce: a
per-subgraph computation (diameter, centrality, a GDS-style algorithm) fanned
out over the population with results written back as aggregate properties —
map over subgraphs, reduce over the summary table.

That enables the clustering layer: graph kernels or embeddings run over the
population, and the clusters themselves become graph structure — similar
subgraphs linked, outliers flagged — queryable with everything else.

## Why RelateDB

The engine is in-memory and scans are its native speed — motif counting and
per-subgraph aggregation over a million small graphs is exactly the workload
in-memory traversal beats a server round-trip on. The `:memory:` store makes
scratch populations free (load a million, cluster, discard), while the WAL +
Parquet checkpoint form makes the durable population one portable file. And
the fan-out layer reuses the architecture's own shape: `relate-load`
already generates bulk `CREATE` ingestion, and a partition of subgraphs can be
sharded across `:memory:` workers with the CLI's JSONL output piping partial
aggregates between them.

## What it needs

- A bulk loader: per-subgraph anchor nodes, `subgraph_id` property convention,
  batch `CREATE` generation (the `relate-load` pattern)
- Population query helpers: motif-presence, size/density/diameter as
  aggregate views
- Fan-out runner: split by subgraph, spawn per-shard `:memory:` instances,
  merge aggregates
- Clustering: graphlet/graph-kernel or embedding features written back as
  node properties; cluster links as relationships
- Benchmark on synthetic populations (the `relate-datasets` generators
  are the seed) plus one real corpus: molecules, or commit graphs from
  `lab git-to-graph`

## Lineage & inspiration

- [NetworkX](https://networkx.org/) — the small-graphs-as-data worldview
- [GDS's projection model](https://neo4j.com/docs/graph-data-science/) —
  compute-over-a-subgraph, but with results landing in the same store
- [relate-datasets](https://github.com/relatedb/relate) and
  [clickhouse-local's glob fan-out](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — the population generators and the one-binary map-reduce ergonomics
