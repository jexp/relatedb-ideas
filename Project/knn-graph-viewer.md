---
type: Project
name: knn-graph-viewer
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/GDELT]]"
  - "[[Company/Supabase]]"
RELATED_IDEA:
  - kind: complements
    reason: the million-node rendering path for larger k-NN graphs
    target: "[[Project/a-million-nodes-in-a-tab]]"
  - kind: complements
    reason: the renderer adapters the viewer reuses
    target: "[[Project/d3-sigma-cytoscape-adapters]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Embedding Atlas]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/UMAP]]"
  - "[[Technology/Vector Search]]"
  - "[[Technology/WASM]]"
  - "[[Technology/t-SNE]]"
---

# KNN Graph Viewer

> Vector-search neighborhoods as k-NN graphs; an alternative to t-SNE that stays
> queryable (and label-able) in the original space.

## What

Take a set of embedded documents (or images, or products, or code functions),
compute each item's k nearest neighbors with vector search, and materialize the
result as a *graph*: items are nodes, "is nearest neighbor of" edges connect
them, weights carry similarity. Then explore it as a network — not as a
t-SNE/UMAP cloud. The k-NN graph is honest where projections aren't: distances
are real similarities, clusters are actual connected structures, and every point
can be inspected with its original properties and labels.

The viewer part is the payoff. You can query the graph ("communities via label
propagation, then the medoid of each"), color by any property, click a cluster
and see the actual nearest-neighbor edges that hold it together, and spot the
strange links — the two documents from opposite topics that share a neighbor —
which dimensionality-reduction plots quietly average away. Anomalies, bridging
documents, and mislabeled items pop out because they're structural, not because
a pixel drifted.

The loop compounds: find a cluster, write its members back with a new label,
re-run the layout, watch the view reorganize around your curation.

## Why RelateDB

Vector search is already in the engine — kNN is a native query over stored
embeddings, and hybrid search (`COMBINE`, vector + fulltext) means the
neighborhood definition can mix semantic and keyword similarity in one call.
The in-memory store makes building the graph interactive: re-k for the whole
corpus, or only within a filtered subgraph, and it completes in a moment — this
is a query, not a preprocessing job. Because the k-NN graph is written back as
plain nodes and edges, every downstream tool (the viz adapters, the million-node
tab, the static-site generator) works on it unchanged. The WASM build closes the
loop in-browser: embeddings in a `.cl` file, k-NN computed and rendered in the
tab, fully private — your documents never leave the page.

## What it needs

- A `kNN → edges` materialization query/procedure (or cookbook recipe) with
  batched vector-search calls
- Embedding ingestion: bring-your-own vectors, or a local embedder for demos
- The viewer: cluster coloring, similarity edge weights, click-through to
  original items (reuse the D3/Sigma adapters)
- Write-back loop: label clusters, filter, re-k, re-render
- A worked example dataset (news embeddings, arXiv abstracts, or the GDELT
  story-cluster data)

## Lineage & inspiration

- [GDELT + Gephi story clusters](https://blog.gdeltproject.org/using-the-gsg-document-embeddings-to-visualize-story-clusters-using-gephi/)
  — embeddings → cluster graph → viz; the exact pipeline, made local and queryable
- [Apple Embedding Atlas](https://apple.github.io/embeding-atlas/) — interactive
  visualization of large embedding spaces; the ambition level for this viewer
- [Supabase in-browser semantic search](https://supabase.com/blog/in-browser-semantic-search-pglite)
  — fully client-side embeddings + vector search; the privacy story
- RelateDB's vector + hybrid `COMBINE` search — the neighborhood definition,
  already in the engine
