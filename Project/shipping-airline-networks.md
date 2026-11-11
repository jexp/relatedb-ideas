---
type: Project
name: shipping-airline-networks
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/GDELT]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: shares re-routing and exposure analysis under disruption
    target: "[[Project/disaster-response-router]]"
  - kind: variant
    reason: both turn public geospatial network data into a local graph artifact
    target: "[[Project/openstreetmap-wedge]]"
  - kind: complements
    reason: same chokepoint and resilience queries over another infrastructure network
    target: "[[Project/power-water-grid-twins]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
---

# Shipping & Airline Networks

> Public schedules and AIS data as graphs; "how exposed is this route to
> this canal closing?" for ops classes and newsrooms.

## What

Container shipping and airline networks are quietly the world's most
consequential graphs, and their data is public: OpenFlights routes and
airports, airline schedules, and AIS vessel-position feeds that reconstruct
port-to-port voyages. Model them directly: `(:Port)-[:CALLS_AT]`,
`(:Airline)-[:OPERATES]->(:Route {frequency, distance}`, `(:Vessel)-
[:VOYAGE {start, end, duration}]->(:Port)`. One year of global AIS or a
full OpenFlights snapshot fits on a laptop.

The headline query is resilience: *when the Suez Canal closes, which routes
from Rotterdam to Singapore lengthen, by how much, and which ports absorb
the overflow?* That's reachability and re-routing done live with Cypher,
not sketched with arrows. The rest follows: hub concentration (what share
of routes transit the top-10 hubs?), chokepoint dependency per carrier,
seasonal network reshuffles, and — over temporal AIS data — congestion
propagation when a port backs up.

The airline half of the literature has verified anchors: Guimerà et
al.'s PNAS 2005 study of the worldwide air-transportation network
(anomalous centrality, community structure, per-city roles) and a 2014
Scientific Reports follow-up on the world airline network — hub
concentration and chokepoint roles are exactly the queries above. The
shipping half just got its Suez literature: a 2023 Journal of Transport
Geography paper analyzed the 2021 canal blockage's network impact, and
the World Bank's Portwatch publishes chokepoint transit counts (Suez,
Bosporus, Bab el-Mandeb) as open data — pre-built exposure inputs.

## Why RelateDB

Point types carry port/airport coordinates natively, so the network graph
is also a map-ready dataset; combined with in-memory Cypher, chokepoint
removal and re-routing analyses over tens of thousands of edges run
interactively — exactly what an embedded, no-server engine is for. The
single-file store means "the global container network, 2025" is a
distributable artifact for a classroom or a newsroom desk. Temporal AIS
ingestion lands on the WAL as an append-heavy, replayable log — replay any
window and query the network *as it was* that week. And the WASM build
offers the reader version: a newsroom-embeddable interactive where readers
click a canal and watch exposure queries run in their tab.

## What it needs

- Loaders: OpenFlights/schedule CSVs → airports/airlines/routes; AIS feeds
  (or historical datasets like MarineCadastre) → voyages via port-call
  detection at anchorages
- Chokepoint/resilience query library: node/edge removal, re-routing with
  distance costs, exposure metrics per carrier/region
- Temporal model: voyage edges with timestamps, replay-window queries
- A few curated snapshots as `.cl` files (a year of Suez traffic, an
  airline alliance map) plus a browser explainer page

## Lineage & inspiration
- Kelvin Lawrence's air-routes dataset in [neo4j-graph-examples](https://github.com/neo4j-graph-examples) —
  originally assembled for Gremlin (the TinkerPop era), later translated to
  Neo4j and GDS; the ready-made import this project should ship as its first
  `.cl` dataset


- [OpenFlights data](https://www.openflights.org/data) — the canonical
  airports/airlines/routes dataset (ODbL; routes frozen at the June 2014
  snapshot — 67,663 routes — but still the standard teaching corpus)
- [The worldwide air transportation network (PNAS 2005)](https://www.pnas.org/doi/10.1073/pnas.0407994102)
  and [Revealing the structure of the world airline network](https://doi.org/10.1038/srep05638)
  — the hub/chokepoint literature this project makes interactive
- [Marine Cadastre](https://hub.marinecadastre.gov/) — public US vessel
  AIS track data; [UNCTAD](https://unctad.org) for the trade framing
- [Suez blockage network-impact analysis (2023)](https://www.sciencedirect.com/science/article/abs/pii/S0964569123003939)
  and World Bank [Portwatch transits on HDX](https://data.humdata.org/dataset/maritime-passageway-transits-during-disruptions)
  — the exposure questions, already asked; here as queries
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — flow/criticality recipes (betweenness, cut nodes) to port into Cypher
- GDELT's chokepoint coverage
  ([example](https://blog.gdeltproject.org/)) — the newsroom appetite for
  exactly this analysis
