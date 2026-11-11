---
type: Project
name: use-case-gallery
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/OpenCorporates]]"
  - "[[Company/OpenSanctions]]"
RELATED_IDEA:
  - kind: complements
    reason: graph algorithms pack in the learning track
    target: "[[Project/gds-round-trip]]"
  - kind: complements
    reason: ML set taught on the gallery datasets
    target: "[[Project/node2vec-rebuilt]]"
  - kind: complements
    reason: contact tracing domain included in the gallery
    target: "[[Project/the-emergent-interaction-graph]]"
  - kind: complements
    reason: movie recommendation domain included in the gallery
    target: "[[Project/the-movie-graph-all-grown-up]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQL]]"
  - "[[Technology/WASM]]"
---

# The Use-Case Gallery

> The classic graph domains — the ones every evaluation, every demo request, and
> every tutorial asks for — as ready-to-load `.cl` datasets with query packs.
> Heritage: the Neo4j sandbox library these datasets were proven in, plus
> the author's own developer-social-networks work.

## What

This is the corpus every graph conversation eventually asks for, assembled
as one gallery: each domain as a `.cl` dataset with a query pack (the
cookbook recipe format — the data, the model, and the queries in one
citable file). The domains:

**The enterprise set** — Customer 360 (identity, accounts, products,
interactions, consent) · Financial AML (accounts, transactions, alerts —
fraud rings as dense-subgraph queries) · Financial Payments (settlement
and routing; circular-payment detection) · Entity Resolution/MDM (golden
records, sources, survivorship, match provenance) · Enterprise Knowledge
Graph (OpenCorporates: companies, officers, addresses, beneficial
ownership) · Crunchbase (funding rounds, investors, acquisitions) · Cyber
Security Threat Detection (assets, vulnerabilities, identities, attack
paths) · Data Lineage (impact analysis as reachability) · Supply Chain
(multi-tier disruption exposure) · Healthcare Referrals and Drug
Interactions · Covid/Contact Tracing (proximity events, exposure chains —
see [The Emergent Interaction Graph](the-emergent-interaction-graph.md)) ·
Network & IT Resource Optimization · Movie Recommendations (the tutorial
dataset grown up — [The Movie Graph, All Grown Up](the-movie-graph-all-grown-up.md)) ·
Reco 2.0 hyperpersonalized marketing · Social Network Analysis · Developer
Social Networks (GitHub/Stack Overflow cross-graphs — the author's own
dataset, the [Software Analytics Sandbox](software-analytics-sandbox.md)'s
feed).

**The Learning Track** — a guided curriculum over the gallery: a GQL/SQL
introduction, the graph-algorithms pack (centrality, shortest path,
community detection, GNNs — see [GDS Round-Trip](gds-round-trip.md)), and
the ML set (recommendations, entity resolution, fraud detection, low-rank
models — see [Node2Vec, Rebuilt](node2vec-rebuilt.md)), each taught on its
corresponding gallery dataset.

## Why RelateDB

The gallery's purpose is *evaluation* — and evaluation wants the whole
corpus on one laptop, loadable in seconds, queryable without a server:
the exact case for a single-binary, in-memory engine with `.cl` files.
A prospective user loads the domain they know, runs the query pack they
recognize, and measures their own workload against it — no signup, no
sandbox queue, no CSV wrangling. The WASM build makes the same gallery
run in a browser tab for the zero-install demo; the WAL means a user's
own edits over a gallery dataset are a reviewable diff, not a fork of a
dump.

## What it needs

- One loader per domain sourcing the canonical datasets (OpenCorporates,
  Crunchbase, OpenSanctions, TMDB/MovieLens, BGG/lichess-class feeds where
  applicable, HN/GitHub for the developer graphs) with licenses recorded
- The query-pack format (named, parameterized Cypher with prose — the
  cookbook recipe precedent)
- The learning track's sequencing (which dataset teaches which concept,
  in order)
- An index page: domain → dataset → what it demonstrates → the three
  queries that sell it

## Lineage & inspiration

- The Neo4j sandbox library — where most of these datasets were proven;
  the gallery ports them from hosted sandboxes to loadable files
- The author's developer-social-networks dataset (the seed of the
  developer-graphs entries)
- The neo4j-graph-examples repo — including Kelvin Lawrence's air-routes
  graph (see [Shipping & Airline Networks](shipping-airline-networks.md))
- The Splink/record-linkage lineage for Entity Resolution (in
  `research/embedded-ecosystems.md`)
