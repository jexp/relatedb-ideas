---
type: Project
name: the-compilers-sea-of-nodes
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Oracle]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the per-pass scrubbing view
    target: "[[Project/animated-graph-timelapse]]"
  - kind: complements
    reason: cited as the static code structure sibling to compiler decision history
    target: "[[Project/code-graph]]"
  - kind: complements
    reason: cited as the database optimizer's version of the same instinct
    target: "[[Project/query-plans-as-graphs]]"
  - kind: complements
    reason: the layered stack sibling that includes the compiler IR layer
    target: "[[Project/softwares-graph-formats]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GraalVM]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The Compiler's Sea of Nodes

> Modern compilers are graph optimizers: raw code becomes parse graphs
> becomes expression graphs, iteratively deconstructed, reconstructed,
> optimized, and validated (the GraalVM sea-of-nodes IR — Thomas
> Würthinger's thesis publications). Store IR snapshots per pass; query
> why an optimization applied here and not there; diff passes; the
> compiler's decisions as analyzable graph history.

## What

A modern optimizing compiler is a graph machine in a text costume.
Source parses into a tree, lowers into a dataflow graph — the sea of
nodes: values as nodes, dependencies as edges — and every optimization
phase is a graph rewrite: deconstruct, reconstruct, fuse, fold,
re-validate. GraalVM's IR made that architecture famous — but the
tools for asking *questions* about it stalled at dumps and grep.

The lineage is documented end to end: Cliff Click's 1995 Rice
dissertation defined the sea of nodes, and Würthinger et al.'s *One VM
to Rule Them All* (Onward! 2013) is the canonical Graal statement.
GraalVM already ships the graph as data — `-Dgraal.Dump` writes
per-phase ideal-graph dumps — and Shopify's seafoam parses those dumps
(and HotSpot C2's) as a queryable format, not just a screenshot.

The project: instrument a compiler (or your own IR — any
graph-rewriting pipeline) to emit an IR *snapshot* at every
optimization pass, and import each into RelateDB —
`(:ValueNode {op})`, data/control edges, a `(:Pass {name, order})`
scaffold. Now the compiler's decision history is a queryable artifact:
*which nodes did escape analysis eliminate between pass 7 and pass 8?*
is a diff query; *why did inlining apply at this call site but not its
twin two lines down?* is a neighborhood comparison — the reason
sitting in properties you can JOIN across passes.

## Why RelateDB

Per-pass snapshots of a hot function number in the dozens, a whole
module in the hundreds of thousands — and the questions are always
neighborhood-and-diff questions over one compilation, right after a
build: an embedded, in-memory workload. The compiler hook writes
snapshots into a `.cl` file during the build; the WAL + Parquet history
accumulates a *sequence* of compilations as durable, replayable history
— regression hunting becomes a diff across compiler builds. The WASM
build scrubs passes in a browser tab; Python handles the analyses too
exploratory for Cypher.

## What it needs

- A snapshot importer: IR graphs → nodes/edges with pass metadata
  (Graal's ideal-graph logs, or a pipeline's own dump), each snapshot
  on a `Pass` chain so cross-pass diffs align
- The query pack: eliminated-survived diffs, call-site comparison,
  reachability-to-final, cost/size deltas per pass
- Rendering: per-pass frames with scrubbing (the [Animated Graph
  Timelapse](animated-graph-timelapse.md) view); node identity stable
  across passes where the IR keeps it

## Lineage & inspiration

- Cliff Click — [Combining Analyses, Combining Optimizations](https://dl.acm.org/doi/10.1145/201059.201061) (Rice PhD / TOPLAS 1995): the original sea-of-nodes work; Thomas Würthinger — [One VM to Rule Them All](https://lafo.ssw.uni-linz.ac.at/pub/papers/2013_Onward_OneVMToRuleThemAll.pdf) (Onward! 2013) and the [GraalVM publications list](https://www.graalvm.org/latest/community/publications/)
- [IGV](https://www.graalvm.org/latest/tools/igv/) — the dumper/viewer that proved compiler engineers *want* to query the IR; [Shopify's seafoam](https://github.com/Shopify/seafoam) and [Understanding Basic Graal Graphs](https://chrisseaton.com/truffleruby/basic-graal-graphs/) — the modern, parse-and-query take on the same dumps
- [Code Graph](code-graph.md) — the sibling: static code structure as a
  graph; this file adds the compiler's *dynamic decisions* as history.
  [Query Plans as Graphs](query-plans-as-graphs.md) — the database's
  own optimizer, the same instinct
