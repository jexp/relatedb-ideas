---
type: Project
name: sentence-graph-for-language-learning
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
RELATED_IDEA:
  - kind: complements
    reason: shares the graph-as-learning-substrate premise
    target: "[[Project/graph-school]]"
  - kind: complements
    reason: both model language structure as a traversable graph
    target: "[[Project/wordnet-but-queryable]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/relate-arrow]]"
---

# Sentence Graph for Language Learning

> Spaced repetition by graph distance.

## What

SRS apps review words by clock — due dates, intervals, forgetting
curves. This project adds the dimension that actually predicts
difficulty: *distance from what you already know*. Sentences are
nodes, linked by what they share — vocabulary edges (both contain
"gehen"), grammar-point edges (both use the dative case), topic edges,
similarity edges from embeddings. Your knowledge is the subgraph of
sentences you can read; the frontier is its boundary. The next sentence
to learn is the one *one edge beyond* known vocabulary —
comprehensible input (i+1) computed instead of guessed, so the review
session always stretches exactly one step.

Scheduling becomes graph-aware: a word's review priority is its
frontier load (how many near-ready sentences it gates), not just its
age. The bridging query finds the gentle path between things you know
— sentences chaining from "wo ist der Bahnhof" to subjunctive II, each
step one edge. And the progress metric SRS never had: knowledge
coverage of the *language graph* — which grammar points are inside
your subgraph, which clusters (cooking German, news German) are dense
for you, which are one sentence from connecting.

## Why RelateDB

The learner's store is one `.cl` file: their language, their history,
their frontier — private (a decade of what you misunderstood is
nobody's cloud data), portable between phone and laptop, offline by
construction, because the study session that matters is the one on a
plane. In-memory graph distance makes the scheduler instant —
frontier computation and bridging paths are traversal queries, the
exact thing the engine is built for, not a bespoke recommender
service. Embedding-similarity edges ride the vector/hybrid-search
capability, while vocabulary and grammar edges stay exact Cypher
structure — symbolic and semantic in one store. Temporal types carry
the seen/learned timestamps so forgetting-curve scheduling composes
with graph distance rather than replacing it. Tatoeba's corpus
(millions of sentence pairs) imports via `relate-arrow` and the
Python bindings, and MCP exposes the frontier to agents — a tutor
that *traverses your actual graph* before choosing the next sentence.

## What it needs

- A sentence corpus per language: Tatoeba is the seed; your own
  reader/anki history merges in as known-marked nodes
- Edge model: vocabulary, grammar-point (CEFR tags from morphological
  analysis), topic, and embedding-similarity edges
- The frontier scheduler: one-step-beyond selection with frontier-load
  weighting; the bridging-path generator between known nodes
## Lineage & inspiration

- Krashen's comprehensible input (i+1) — the theory this scheduler
  operationalizes; "one edge beyond known" is i+1 made computable
- Tatoeba — the open multilingual sentence corpus, the natural seed
  graph: https://tatoeba.org/
- Anki and the SRS canon (SuperMemo's two-component model) — the time
  axis this project keeps, augmented with the graph axis
