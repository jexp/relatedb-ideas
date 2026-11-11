---
type: Project
name: benchmark-zoo
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/DuckDB Labs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/JSON]]"
  - "[[Technology/RelateDB]]"
---

# Benchmark Zoo

> Every loadtest result as a graph of runs, shapes, and metrics; performance
> engineering becomes exploratory.

## What

Loadtests produce reports; reports get compared pairwise, at best. Instead, make
every run a node: environment, commit, feature flags, the dataset shape, the
envelope of results — ops/s, p50/p99, peak RSS, errors, logical bytes. Each
result row becomes a related node; each query latency a linked record. The zoo
accumulates — every fraud run, identity run, latency suite, memory-shape run,
every CI freeze and every local experiment — and suddenly performance questions
are graph traversals.

"Which shapes regress p99 the most between these two releases?" "Do the
biggest peak-RSS jumps cluster around an environment class?" "Do query latency
regressions co-occur with specific commit areas?" — commits, datasets, shapes,
metrics and thresholds, all one connected store.

An outlier run stops being a row you squint at in a JSON file and becomes a
node connected to its cause candidates. The "why is Q7 slow again?" archaeology
becomes blame: Q7 → its runs → the runs' commits → the touched commit.

The connective tissue is the ontology: runs, shapes, metrics, environments,
commits as node types with fixed relationships — the schema makes the zoo
queryable on day 300, not just day 1.

## Why RelateDB

The engine's own loadtest apparatus already produces exactly the input this
needs: fraud/identity/memory-shape/latency runs with environment classes,
envelopes committed as JSON baselines, and CI-gated comparisons — a steady,
structured feed of runs with rich metadata (the baseline environment and
envelope schemas are the ontology's first draft). An embedded, in-memory store
is the natural home for the zoo: it's an analysis sidecar, open next to the
reports, queried interactively — no server to provision for a dataset that
starts at hundreds of rows and grows by runs, not by queries per second. The
single-file store means the zoo is shareable: paste your runs in, mail the
`.cl` file to the perf discussion; and the WAL means appending each night's
runs is a log write, with the graph's history inspectable. Result metadata
(resolved namespace, query type) that the engine already attaches to results
gives the metric nodes their structure for free.

## What it needs

- A schema for the zoo: Run, Shape, Metric, Environment, Commit, Regression
  nodes and their relationships (a small ontology)
- An ingester: read existing baseline envelopes / latency JSON reports / CI
  artifacts into the graph — one per report format
- The query pack: regression-finder, clustering, blame, trend-window queries,
  shipped as a cookbook recipe set (rendering via the viz adapters)

## Lineage & inspiration

- RelateDB's own loadtest/baseline machinery (fraud, identity, memory-shape,
  query-latency suites and their envelope schemas) — the ready-made feed
- [DuckDB in science](https://duckdb.org/science/) — a curated corpus of
  artifacts as the credibility moat; the zoo is RelateDB's version for its
  own performance history
