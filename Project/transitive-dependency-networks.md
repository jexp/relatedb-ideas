---
type: Project
name: transitive-dependency-networks
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Google]]"
  - "[[Company/Libraries.io]]"
  - "[[Company/OpenSSF]]"
RELATED_IDEA:
  - kind: complements
    reason: private per-repo lockfile graph plugged into this public ecosystem
    target: "[[Project/dependency-radar]]"
  - kind: complements
    reason: centrality metrics ranking load-bearing packages
    target: "[[Project/gds-round-trip]]"
USES_TECH:
  - "[[Technology/BigQuery]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/OSV]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/deps.dev]]"
---

# Transitive Dependency Networks

> The deps.dev shape: every package ecosystem's transitive graph as one
> store — licenses, maintainers, versions, vulnerabilities (the
> author's own deps.dev example from this week as the seed).

## What

deps.dev — Google's dependency-metadata service — already models the
truth the ecosystem keeps re-deriving: every package version, in every
ecosystem (npm, Maven, PyPI, Go, Cargo, NuGet), linked by *transitive*
`REQUIRES` edges, decorated with licenses, maintainers, provenance, and
OSV advisories. The dataset is downloadable: imported as one graph, the
ecosystem's hard questions become walks. *Is this app exposed to
CVE-XXXX-YYYY?* is a path query from your top-level package through the
transitive chain to the vulnerable version — the exact hops, not a
flat SBOM flag. *Can we ship this?* is a license-compliance walk over
every license node reachable from your entry points.

Verified: deps.dev (branded Open Source Insights) indexes npm, Maven,
PyPI, Go, Cargo, NuGet, and RubyGems, serves its data over an HTTP and
gRPC API, and publishes a public BigQuery dataset
([docs.deps.dev/bigquery](https://docs.deps.dev/bigquery/v1/)) — the
whole ecosystem graph as tables. Advisories come from OSV, and
historical dependency states are retained, so the dataset is already
versioned.

The seed is real: the author imported deps.dev into RelateDB this
week — the full multi-ecosystem graph as one store, queried with plain
Cypher, no server, no rate limits. This file is that import grown into
a project: snapshot pipeline, query pack, version history.

## Why RelateDB

The dataset is a large Parquet/CSV export whose questions are
multi-hop reachability over one snapshot — in-memory, embedded,
single-file. `relate-arrow` and the CSV loaders ingest the deps.dev
export directly; the Python bindings orchestrate the pull-and-load. One
`.cl` file holds the whole ecosystem snapshot; the WAL makes each weekly
re-import an accumulating version history — dependency drift between
snapshots is a diff query, not a re-download. Multi-hop vulnerable-path
queries run at build speed — the check belongs inside CI, where a
five-second embedded answer gates the merge and an API round-trip
never could. `relate serve` exposes the store over HTTP/Bolt/MCP
for teams that need recurring reports, not a gate.

## What it needs

- The importer: deps.dev export → `(:Package)`, `(:Version)`,
  `(:Maintainer)`, `(:License)`, `(:Advisory)` with `:REQUIRES` edges,
  keyed for idempotent weekly re-import (the seed already ran once)
- The lockfile join: your repo's lockfile as `:DEPENDS_ON` edges from a
  `(:Project)` node into the ecosystem graph — [Dependency
  Radar](dependency-radar.md)'s per-repo half on the shared snapshot
- The query pack: vulnerable-transitive-exposure paths, license-policy
  walks, maintainer concentration and bus factor, outdated leaves
- WAL versioning: diff week-over-week, alert on new edges, maintainers, advisories

## Lineage & inspiration

- [deps.dev](https://deps.dev) — Google's package-metadata service and downloadable dataset:
  the model this store imports wholesale; a deps.dev import as the seed
- [Dependency Radar](dependency-radar.md) — the CI-gate sibling: your
  lockfiles as a private graph; this file is the public ecosystem it plugs into
- [GDS Round-Trip](gds-round-trip.md) — centrality and dependency-structure
  metrics, PageRank-ranked "load-bearing packages" written back into the same store
- [OSV](https://osv.dev) and SBOM tooling — the advisory feeds and compliance formats
  this graph answers with paths instead of flags; [OpenSSF Scorecard](https://scorecard.dev/)
  and [Libraries.io](https://libraries.io/) — the prior generation (per-repo security
  checks; a metadata aggregator), neither holding the whole transitive graph as one
  queryable store
