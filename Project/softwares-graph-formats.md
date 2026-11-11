---
type: Project
name: softwares-graph-formats
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Arize AI]]"
  - "[[Company/Oracle]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the top-layer trace-DAG sibling
    target: "[[Project/agent-trace-warehouse]]"
  - kind: complements
    reason: cited as an adjacent layer in the shared vocabulary
    target: "[[Project/code-graph]]"
  - kind: complements
    reason: cited as the database optimizer's version of the same artifact
    target: "[[Project/query-plans-as-graphs]]"
  - kind: complements
    reason: cited as the deepest-layer sibling of the same stack
    target: "[[Project/the-compilers-sea-of-nodes]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/GraalVM]]"
  - "[[Technology/OpenInference]]"
  - "[[Technology/OpenTelemetry]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
---

# Software's Graph Formats

> The whole software stack already ships graphs: GraalVM's graph-shaped
> output format (loadable, parseable), Java heap snapshots, static class
> graphs, call graphs, dynamic traces in OpenTelemetry/OpenInference —
> one loader family, every layer of the machine queryable.

## What

Every layer of a running system already *emits* a graph — we just never
treat them as one family. GraalVM's ideal-graph dumps are the compiler's
sea of nodes, loadable and parseable. A Java heap snapshot (hprof) is an
object graph: instances, classes, reference edges — the machine's entire
live state as adjacency. Static analysis yields class and call graphs;
dynamic tracing yields spans — OpenTelemetry and OpenInference both
export the trace DAG as data.

And the formats are public, not folklore. GraalVM documents the dump
machinery and the [IGV](https://www.graalvm.org/latest/tools/igv/)
viewer — `-Dgraal.Dump` writes loadable ideal graphs per compilation
phase, and IGV's filter language is a mini-query dialect over the
graph. [OpenTelemetry's specification](https://opentelemetry.io/docs/specs/otel/)
defines the trace as span data with parent-child structure;
[OpenInference](https://github.com/Arize-ai/openinference) extends the
same span model with LLM-specific kinds (`LLM`, `CHAIN`, `TOOL`,
`RETRIEVER`) as an open schema. Heap analysis has been graph traversal
all along: Eclipse MAT's dominator trees, retained sets, and
path-to-GC-roots are queries over the hprof object graph.

The project: one loader family, one shared schema vocabulary (`(:Class)`,
`(:Method)`, `(:Object)`, `(:Span)`, `(:Pass)`), and a `layer` scaffold so
artifacts stack — heap objects join into the class graph, the class graph
into call graphs, the call graph into the spans that observed those calls
at runtime. Then the four-tool, whiteboard questions become single
queries: *this span's method — which class loaded it, which objects did
it retain, which compiler pass shaped its body?* Vertical traversal
through the whole machine, one hop type at a time.

## Why RelateDB

These artifacts are build-time and per-machine: a heap dump from last
night's incident, an IR dump from this build, a trace export on disk —
an embedded, in-memory workload. `relate-arrow` converts Parquet/
Arrow dumps, the CSV loaders take the text formats (hprof histograms,
javap output, OTLP JSON exports), and the Python bindings host the
binary-format parsers (hprof, ideal-graph XML). One `.cl` file per
incident or build holds the whole stack snapshot; the WAL makes
repeated imports durable versioned history.
Multi-hop reachability — *which retained objects are reachable from
this span's thread?* — runs interactively in memory; `relate serve`
puts the layered store behind HTTP/Bolt/MCP for the whole team.

## What it needs

- Format readers: GraalVM ideal-graph output, hprof (class histogram at
  minimum, full object graph at ambition), OpenTelemetry/OpenInference span exports
- The shared vocabulary and `layer` scaffold so artifacts join on
  stable identity — class FQNs, method signatures, trace/span IDs
- The query pack: span→method→class→retained-object verticals,
  cross-layer diffs (heap before/after, trace vs. call graph)
- WASM-tab rendering: the layered machine, drilled from span to IR node

## Lineage & inspiration

- GraalVM's graph IR and tooling (`-Dgraal.Dump`, [IGV](https://www.graalvm.org/latest/tools/igv/)) — proof
  the compiler layer *exports* its graph; expanded as [The Compiler's Sea
  of Nodes](the-compilers-sea-of-nodes.md), the deepest-layer sibling
- [Agent Trace Warehouse](agent-trace-warehouse.md) — the top-layer
  sibling: trace-DAG ingestion for agent runs; [Code Graph](code-graph.md)
  and [Query Plans as Graphs](query-plans-as-graphs.md) — adjacent layers
- [Eclipse MAT](https://eclipse.dev/mat/) and jhat — heap analysis as graph traversal
  (dominator trees, retained sets, path to GC roots), one tool per layer;
  [OpenTelemetry's data model](https://opentelemetry.io/docs/specs/otel/) — the
  trace DAG, standardized; [OpenInference](https://github.com/Arize-ai/openinference)
  — its LLM-flavored extension
