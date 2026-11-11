---
type: Project
name: dynamic-path-index
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
RELATED_IDEA:
  - kind: complements
    reason: the latency benchmarks are the honest scoreboard for whether the index wins
    target: "[[Project/benchmark-zoo]]"
  - kind: complements
    reason: index consultation versus traversal fallback is a query-planning decision to inspect
    target: "[[Project/query-plan-lab]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# Dynamic Path Index

> A maintained shortest-path/frequency index as a graph *on top of* your graph;
> query the index, not the traversal.

## What

Shortest-path and multi-hop queries are traversals, and traversals get expensive
as the graph grows. The classic database answer is a secondary index — so build
the index as a graph. Landmark-based or hub-labeling distance indexes, frequent-
path caches, per-hop shortcut edges: each is a set of nodes and relationships
*in the same store*, maintained as the data changes, and consulted before (or
instead of) the traversal — "distance from A to B" reads a shortcut edge or a label set.

The interesting design space is maintenance: the WAL already knows exactly what
changed, so incremental updates are event-driven (an edge was added — which
landmark distances could it have shortened?). Stale-but-bounded is a valid mode
too — an index with a recorded staleness frame, corrected on read when it
matters. Both are graph operations: the index has provenance nodes ("built at
LSN N") — you can *see* how the index moved when the data moved.

The payoff is the classic one: O(hops) queries become O(lookup) for the hot
paths (the 2% of origin/destination pairs behind 80% of queries), while cold
queries fall back to plain traversal, unchanged, in the same Cypher.

## Why RelateDB

One in-memory store is what makes a graph-shaped index coherent: the index and
the data are in the same transactional world, so maintaining the index is just
another Cypher write stream, and there's no cross-system consistency problem to
engineer away. The WAL is the maintenance feed — every change is already an
ordered, durable event, so incremental updates don't need triggers or CDC; and
a checkpoint of the store *includes* the index, so the index travels inside the
single `.cl` file rather than as a separate artifact to rebuild. In-memory speed
softens the cold-start problem that kills index-first designs on disk systems:
building a landmark index over resident data is a scan-speed job, so "drop and
rebuild" stays a viable fallback. And because the index
is queryable Cypher-shaped data, its own analytics (which shortcuts are hit
most? how stale is the index?) are just queries — index tuning becomes
exploration, the Benchmark Zoo's lane.

## What it needs

- Index constructions as graph writes: landmark distance tables, hub labels,
  shortcut edges — landmarks first, the tractable v1
- A maintenance loop over WAL events: which changes can invalidate which index
  entries, with bounded-update rules
- Query integration: index consultation with traversal fallback, plus staleness
  bounds surfaced to the caller
- Provenance nodes for index builds (LSN, parameters) and diff tooling
- Benchmarks: the query-latency suite and loadtest baselines as the honest
  scoreboard (does the index actually win?)

## Lineage & inspiration

- Hub labeling / landmark distance literature (e.g., Abram et al., "On Fast
  Approximate Shortest Paths" lineage) and Contraction Hierarchies from road
  routing — the index families to port
- RelateDB's WAL + checkpoint model — the maintenance feed; the index travels
  inside the store
