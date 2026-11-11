---
type: Project
name: tiny-neural-nets-rendered
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Tiny Neural Nets, Rendered

> A 2-layer net as a weighted graph; animate training by watching edge weights
> change. Education, not infrastructure.

## What

A neuron *is* a node; a synapse *is* a weighted edge. So render a tiny neural
network — a 2-layer MLP, a handful of neurons — as its literal graph, and
animate training on it: each forward/backward pass adjusts edge weights, and
the canvas shows edges thickening, thinning, flipping sign. The input layer
feeds values in, the output layer lights up with its prediction, and the
student *sees* the network learn — which weights carry the signal, which neurons
died, what a vanishing gradient looks like when the edges just stop moving.

The point is size: no more than a couple dozen neurons, trained on toy problems
(XOR, a 2-point cluster) at visible speed, with every scalar inspectable.
Click a neuron and see its activation function, its inputs, the math of its
last step. Because it's a graph database underneath, the pedagogy is queryable:
"show me the top-5 weights by magnitude change this epoch," "find paths from
input to output whose product of weights is largest," "which neuron's outgoing
edges all shrank?" — the debugging questions, asked as Cypher over the training
history.

It ends where it should: the student opens a real notebook and trains a real
model, but now with the mental picture that the matrices are a graph.

## Why RelateDB

The store *is* the rendering model: neurons as labeled nodes, synapses as
weighted relationships — no impedance mismatch between "the network" and "the
thing you query." In-memory Cypher makes the training loop interactive: write
the new weights back per epoch and re-run the analysis queries, and both stay
instant at this scale — a REPL-driven training session, not a batch job. The
WAL means the training run is *recorded*: every epoch's weight set is a
checkpoint-able state, so time-travel to any epoch (and the Timelapse viewer's
scrub mode) applies directly — "show me the weights at the epoch where the loss
flatlined." The WASM build makes it a URL: the whole lab — network, trainer,
queries, canvas — runs in a tab, which is exactly how it gets shared with a
class. And the cookbook format is the course-delivery vehicle: each lesson is a
tested markdown recipe with recorded, replayable results.

## What it needs

- A tiny forward/backward trainer driving Cypher writes (as queries or a small
  script over the Python/JS bindings) — a few hundred lines, deliberately no
  more
- Toy datasets and lesson scripts (XOR, clusters, maybe one dead-neuron
  demonstration)
- Canvas rendering of the weighted graph + weight-change animation (the viz
  adapters, tuned for edge width/sign)
- Epoch history on the WAL; scrub-any-epoch queries
- A cookbook-recipe series: 5 lessons, each runnable in-browser

## Lineage & inspiration

- TensorFlow Playground — the in-browser neural-net teaching demo; this project
  is its graph-native, query-native successor
- RelateDB's WASM build + cookbook format — the URL-shareable,
  recorded-results course medium
