---
type: Project
name: node2vec-rebuilt
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
RELATED_IDEA:
  - kind: complements
    reason: computed embeddings land back in the store as structure
    target: "[[Project/gds-round-trip]]"
  - kind: complements
    reason: supplies the starter graphs the walk pipeline runs on
    target: "[[Project/graph-school]]"
  - kind: complements
    reason: another founding graph-learning idea rebuilt as interactive Cypher
    target: "[[Project/the-original-search-index-experiment]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
---

# Node2Vec, Rebuilt

> Random walks as sentences, sentences as embeddings: walk paths through
> the graph, encode them with a language model into topological/structural
> vectors — the node2vec/path2vec pattern (and the GraphSAGE/GNN family)
> reproduced on an engine where the walks are plain Cypher.

## What

node2vec's core move was never deep: sample random walks over a graph,
treat each walk's node sequence as a *sentence*, and run word2vec on the
sentences. The vectors encode topological role — bridges near bridges,
hubs near hubs — and the GraphSAGE/GNN family inherits that substrate.
The walk sampling is a *query* problem — on most stacks, buried inside
special-purpose Java. On RelateDB the walks are literally Cypher — a
variable-length path query with sampling produces the sentences
directly, and tweaking the strategy (node2vec's return/in-out
parameters, path2vec's path-type weighting) is rewriting a query, not
recompiling a library.

The lineage is precisely documented: DeepWalk (Perozzi, Al-Rfou,
Skiena, KDD 2014) ran word2vec over truncated random walks first;
node2vec (Grover & Leskovec, KDD 2016) added the biased return/in-out
sampling; GraphSAGE (Hamilton, Ying, Leskovec, NeurIPS 2017) replaced
walks with sampled neighborhoods, inductively. path2vec is in print
too — Kutuzov et al. (*Sem 2019) embed typed paths through WordNet
rather than plain node sequences.

The rebuild: run the walks as Cypher; ship each walk sequence to a
language-model encoder via the Python bindings; write the embedding
back onto the node — and the store holds structural vectors *on* the
original graph, so hybrid queries fetch nodes by embedding and by
topology in one statement.

## Why RelateDB

RelateDB does the traversal and storage (in-memory
variable-length paths at interactive speed, the sampled walks
streaming out as results); the LM does the encoding, connected
through the Python bindings, its vectors written
into a vector index on the same nodes. The payoff: hybrid search runs
over the walk embeddings *in the same store as their source graph* —
similarity and graph queries compose in one statement, no
graph-database/vector-store round trip. The pipeline is a `.cl` file
plus one Python script; the WASM build explores the vectors in a
browser tab. The walk-as-sentence lineage runs through
node2vec/path2vec — this is that material, rebuilt where the walks are
visible Cypher.

## What it needs

- The walk pack: parameterized variable-length path queries with
  sampling (node2vec's biased walk as query shape; path2vec's variants)
- The encoder loop via the Python bindings: walk sequences out, LM
  encoding, embeddings written back into a vector index
- The GNN stretch: neighborhood sampling as Cypher feeding GraphSAGE-
  style models; starter graphs (Karate Club, Les Misérables — see
  [Graph School](graph-school.md))

## Lineage & inspiration

- [node2vec](https://arxiv.org/abs/1607.00653) — Grover & Leskovec, KDD 2016: biased random walks as word2vec sentences; [path2vec](https://github.com/uhh-lt/path2vec) (Kutuzov et al., *Sem 2019) — path-typed embeddings
- [GraphSAGE](https://arxiv.org/abs/1706.02216) / the GNN family — sampling-and-encoding, inductively; [DeepWalk](https://arxiv.org/abs/1403.6652) (Perozzi et al., KDD 2014) — the word2vec-on-walks ancestor
- [The Original Search-Index Experiment](the-original-search-index-experiment.md) —
  the sibling: another founding graph-learning idea as interactive Cypher
- [GDS Round-Trip](gds-round-trip.md) — computed results landing back in
  the same store as structure
