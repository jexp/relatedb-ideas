---
type: Project
name: gds-round-trip
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: supplies the named projection mechanism this round-trip projects through
    target: "[[Project/cypher-on-cypher]]"
  - kind: complements
    reason: kNN similarity edges are one of the algorithm outputs this writes back
    target: "[[Project/knn-graph-viewer]]"
  - kind: complements
    reason: embeddings written back as graph structure are another write-back leg
    target: "[[Project/node2vec-rebuilt]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j GDS]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/PageRank]]"
  - "[[Technology/RelateDB]]"
---

# GDS Round-Trip

> Graph Data Science as a graph *transformer*: projections in (subgraph →
> algorithm), compute results out (PageRank scores, communities, embeddings,
> kNN graphs, link predictions) written back as graph structure — clustering
> projections land in RelateDB as nodes and edges you can query with everything
> else. (Lineage: Neo4j GDS's projection model, but results land in the same
> embedded store, not a sidecar.)

## What

Neo4j GDS's mental model is a pipeline: project a subgraph → run an algorithm →
write results back. The sidecar cost is that the projection lives in a separate
in-memory compute space with its own lifecycle. This project inverts it: GDS as a
*graph transformer over one store*. A projection is a Cypher query whose result
becomes (or is treated as) a subgraph; the algorithm computes over it; and the
output is written back as ordinary graph structure — PageRank scores as node
properties, community detections as new labels or `MEMBER_OF` edges to
community nodes, kNN results as real similarity edges, link predictions as
scored candidate edges.

The round-trip is the whole idea. Once results land as nodes and edges, they're
queryable with everything else: "show me the highest-PageRank nodes in the
largest community that does *not* touch my churned users" is one query over
data + analytics. Pipelines compose — run PageRank, write it back, project *that* graph into
community detection, write communities back, project again into an embedding —
each stage inspectable, because the intermediates are just graphs.

## Why RelateDB

The embedded, in-memory engine makes the sidecar pointless: there's no cluster
to offload to, and no reason to — an in-memory subgraph projection over resident
data is already the GDS compute shape, so "project" is a query and the algorithm
runs against what's already there at memory speed. Writing results back as
nodes/edges/properties is a plain Cypher write — the same transactional store,
no export/import bridge, no catalog of projection lifetimes to manage. Vector
and hybrid search are already native, so the kNN-graph and similarity legs of
the pipeline call the engine's own search rather than a bolted-on index. The
single-file store means a pipeline's inputs *and* outputs travel as one `.cl`
artifact — open the post-GDS graph and query the communities directly. And a
small algorithm set (PageRank, betweenness, community detection, a couple of
link-prediction heuristics) is a bounded, tractable scope.

## What it needs

- A projection mechanism: named subgraphs from Cypher (result-set-as-graph or
  virtualized views)
- Algorithm procedures over projections: PageRank, Louvain/label-propagation,
  betweenness, kNN-from-vectors, simple link prediction
- Write-back conventions: scores as properties, communities as nodes/labels,
  similarities as typed edges — documented as a style guide
- Pipeline composition: project → compute → write-back → project again, from
  the CLI/REPL

## Lineage & inspiration

- [Neo4j Graph Data Science](https://neo4j.com/docs/graph-data-science/) — the
  projection model this project adopts, minus the sidecar
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — the algorithm corpus to port (top ~20 recipes)
