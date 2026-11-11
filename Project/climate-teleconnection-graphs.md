---
type: Project
name: climate-teleconnection-graphs
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/ECMWF]]"
  - "[[Company/NOAA]]"
  - "[[Company/Potsdam Institute for Climate Impact Research]]"
MENTIONS_PERSON:
  - "[[Person/Anastasios Tsonis]]"
  - "[[Person/Jürgen Kurths]]"
  - "[[Person/Paul Roebber]]"
RELATED_IDEA:
  - kind: complements
    reason: named as the rendering tier for large climate networks
    target: "[[Project/a-million-nodes-in-a-tab]]"
  - kind: complements
    reason: named as the rewiring-over-time view for the same networks
    target: "[[Project/animated-graph-timelapse]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/ERA5]]"
  - "[[Technology/NOAA]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Climate Teleconnection Graphs

> The climate system's famous long-range couplings — ENSO, the Indian
> Monsoon dipole, atmospheric rivers — as a correlation graph over
> reanalysis grid points: "which regions does this anomaly reach, and by
> what path?" as traversal over publicly downloadable data.

## What

Climate network science is a real, established field that almost nobody
outside it knows about: build a grid of points (temperature, geopotential,
rainfall) from a reanalysis product, compute pairwise correlations, keep
the strong edges, and the climate system's teleconnections — El Niño's
global reach, monsoon couplings, blocking patterns — appear as graph
structure. The field's papers publish static network snapshots and
analyses; the tooling is bespoke Python/R per study; the data (ERA5,
NOAA reanalysis slices) is free.

This project is the regional climate network as an embedded store: grid
points as nodes with location and elevation, correlation edges with
strength and lag (the *directed* correlation that carries the
propagation direction), plus the overlay layers (ENSO index phases,
blocking events, season) as temporal context. The questions become
queries:

- "which regions does a Niño-3.4 anomaly teleconnect to, strongest
  first" — one-hop neighborhood queries, sorted by edge weight
- "the transmission path from the tropical Pacific to European winter"
  — multi-hop paths with the lag budget honored (the lag-labeled
  traversal is the interesting query shape)
- "how did the network rewire during the 2023-24 El Niño" — the
  temporal-diff mode: same network, phase-scoped edges
- drought/deluge fingerprints: the subgraph pattern that precedes a
  regional extreme, found as a query (the early-warning literature's
  question)

The honest scale: global networks at full resolution are cluster-scale —
but regional cuts (the North Atlantic corridor, the Indian Ocean basin,
your continent) are laptop-sized and are exactly what teaching and
regional analysis need.

## Why RelateDB

Lag-labeled temporal edges, path queries with budgets, phase-scoped
subgraphs — the question set is the engine's native query shapes, not
array code. A region's network is a few thousand nodes and a few hundred
thousand edges — one `.cl` file, shareable between climate-science
courses and as a paper's supplementary artifact (the HNR pattern for
climate). The WASM tab makes an explorable climate network — click the
Niño-3.4 box, watch the teleconnection edges glow — the teaching
artifact this field has never had. And the timelapse mode plays a
decade of network rewiring, one season per frame.

## What it needs

- The reanalysis loader: ERA5/NOAA slices → grid → correlation edges
  (with the honest, documented correlation-method choices the field
  argues about)
- The lag-labeled edge convention (directed teleconnection edges with
  lag budgets) and its traversal queries
- Phase overlays: ENSO indices, blocking registers, monsoon onsets as
  temporal context layers
- The gallery: 3-4 regional networks prebuilt as `.cl` files with
  browser guides

## Lineage & inspiration

- [The visual-analytics review of climate networks (NPG 2015)](https://npg.copernicus.org/articles/22/545/2015/)
  — the field's own survey of the method and its displays
- [Evolving climate networks](https://www.pik-potsdam.de/members/kurths/publikationen/2010/evolving%20climate%20networks.pdf)
  (PIK/Kurths lineage) — the time-evolving networks this project makes
  replayable
- The climate-network science literature (Tsonis and Roebber's founding
  coupling analysis onward) — the method whose questions are traversals
- [ERA5 reanalysis data](https://www.ecmwf.int/en/forecasts/dataset/ecmwf-reanalysis-v5)
  — the free data layer; [A Million Nodes in a Tab](a-million-nodes-in-a-tab.md)
  — the rendering tier; [Animated Graph Timelapse](animated-graph-timelapse.md)
  — the rewiring view
