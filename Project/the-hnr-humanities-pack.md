---
type: Project
name: the-hnr-humanities-pack
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Historical Network Research]]"
RELATED_IDEA:
  - kind: complements
    reason: network analysis bridge for metrics Cypher cannot express
    target: "[[Project/networkx-runtime]]"
  - kind: complements
    reason: flagship humanities project the pack serves
    target: "[[Project/the-codex-reborn]]"
USES_TECH:
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Cytoscape]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The HNR Humanities Pack

> The Historical Network Research community's world in one format:
> correspondence networks, prosopographies, place-name graphs, kinship and
> trade networks — lightweight humanities graphs as .cl files with shared
> importers and query packs.

## What

The [Historical Network Research](https://historicalnetworkresearch.org/)
community has spent a decade producing exactly the kind of graphs RelateDB
is built for: **lightweight, source-anchored, single-researcher networks** —
correspondence networks (letters as edges, weighted by count and dated),
prosopographies (people with life-event properties), place-name and mobility
graphs, kinship and marriage networks, trade and credit networks. Their
[conference contributions](https://historicalnetworkresearch.org/hnr-events/hnr-conferences/)
are full of datasets that live as CSV exports and Gephi projects — rich
scholarship trapped in tool-specific formats.

The HNR Pack is that world ported to one substrate: shared importers for the
community's common shapes (node/edge CSV with source-citation columns, the
Gephi project export, the Cytoscape exchange formats), a growing library of
`.cl` files for published datasets (with licenses recorded), and **query
packs** — the canonical analyses of the field as reusable Cypher files:
correspondence degree over time, brokerage (betweenness on the social
projection), community detection input, ego networks at a date window.

The point is not a new tool — it is a **common artifact format** for a
community whose members keep re-implementing the same import in every
project. Publish your dataset as a `.cl` file; anyone can query it, extend
it, and cite it.

The community infrastructure verifies. historicalnetworkresearch.org is live
and active — an open-access *Journal of Historical Network Research* (indexed
in DOAJ), a collaborative bibliography past 1,300 titles, membership, Slack
and YouTube channels — and the events archive runs the annual HNR conferences
plus joint gatherings like GrapHNR 2023 in Mainz, whose theme was literally
temporality: modelling changing states, handling vague or incomplete dates —
exactly the dated-edge semantics this pack's query packs encode.

## Why RelateDB

The community's graphs are small by database standards and heavy by
scholarship standards — precisely the scale where a server is absurd and
a single file is honest. The `.cl` bundle makes datasets citable artifacts
(the data plus the model plus the queries, one file, archived with the
paper); `relate query` runs the analysis with no install beyond the
single binary; the WASM build lets a journal page *run* the dataset's
query pack in the reader's browser (the cookbook model applied to
scholarship). Temporal types carry the dated-edge semantics every one of
these networks needs.

## What it needs

- Importers: node/edge CSVs with citation columns; Gephi `.gefx`; the
  Cytoscape JSON exchange
- The query-pack format: named, parameterized Cypher files with prose
  (the cookbook recipe format is the precedent)
- A dataset catalog page with licenses recorded per dataset
- The network-analysis bridge (see [NetworkX Runtime](networkx-runtime.md)
  and the GDS idea in the Meta section) for the metrics Cypher alone does
  not express

## Lineage & inspiration

- [Historical Network Research](https://historicalnetworkresearch.org/) — the
  community; start at their [events archive](https://historicalnetworkresearch.org/hnr-events/)
- The [Journal of Historical Network Research](https://jhnr.net/) — the field's
  open-access journal, where the datasets this pack would port get published
- [GrapHNR 2023 conference](https://historicalnetworkresearch.org/hnr-events/hnr-conferences/graphnr-2023/) — a current cross-section of the field's contributions
- [The Codex, Reborn](the-codex-reborn.md) — the flagship humanities project this pack serves
- Gephi's dataset ecosystem and the Les Misérables/Newman collections (in `research/graph-world.md`) — the existing artifact culture this upgrades
