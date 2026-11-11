---
type: Project
name: openstreetmap-wedge
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Geofabrik]]"
  - "[[Company/OpenStreetMap Foundation]]"
  - "[[Company/Protomaps]]"
MENTIONS_PERSON:
  - "[[Person/Geoff Boeing]]"
RELATED_IDEA:
  - kind: complements
    reason: the rendered map layer for the same OSM-derived street graph
    target: "[[Project/graph-overlay-on-leaflet-mapbox]]"
  - kind: same-data
    reason: both route over street and trail networks stored as a graph
    target: "[[Project/local-route-brain]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Geofabrik]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/OSMnx]]"
  - "[[Technology/OpenStreetMap]]"
  - "[[Technology/Protomaps]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/osmium-tool]]"
---

# OpenStreetMap Wedge

> OSM PBF extract → nodes/ways/relations; a city's walkable graph in one
> file, isochrones and shortest paths in milliseconds.

## What

An OSM extract — a city, a national park, a campus — becomes a walkable
graph: OSM nodes are coordinates (native point properties!), ways become
street/path segments as relationships with `oneway`, `highway` class, and
name as edge properties, and relations (bus routes, river systems) become
higher-order structure. Filter to the routable subset and a mid-size city
lands in one `.cl` file, opening instantly anywhere.

With that, the questions cities actually ask become queries. *Isochrones*:
how far can you walk in 10 minutes from this address? *Detour audits*: the
shortest drive vs. the shortest bike route — where do they diverge? *Barrier
analysis*: how many homes are within 400 m of a pharmacy, and where are the
gaps? *Street-class anatomy*: what fraction of a district's kilometers are
motorway-trunk vs. residential? And because every edge still carries its
geography as a point property, results join back onto the map.

None of the pipeline is speculative. OSMnx — Boeing's JOSS-reviewed
package — has done "named extract → filtered, routable graph with oneway
and class attributes" since 2017 and carried the urban street-network
literature with it; a 2025 Geographical Analysis follow-up extends it
to amenities and urban form, and its development line adds direct OSM
PBF loading. The extract/filter stage is osmium-tool's day job. The
wedge's move is the same pipeline ending in a persistent,
Cypher-queryable store instead of an in-process NetworkX object.

OSM's topology *errors* become queryable too: broken one-way chains, ways
that dead-end into fences, isolated routable islands — data QA for the
local mapping community.

## Why RelateDB

Two native fits. First, point types: RelateDB supports geographic points,
so OSM geometry is a first-class engine value, not stringified coordinates.
Second, embedded scale: an in-memory engine answers shortest-path and
isochrone queries over a city-sized graph in milliseconds, from the CLI or
a Python binding, no server to provision. The single-file store means
"your city, routable" is one committable artifact — hand it to students,
ship it to a phone, load it in a browser tab with the WASM build. The WAL
makes iterative edits safe and replayable.

## What it needs

- An OSM PBF reader (osmium-style filtering) → loader: nodes →
  `(:OSMNode {location: point(...)})`, ways → `[:SEGMENT {oneway}]` edges,
  routable-subset filtering
- A turn-restriction / oneway policy at load time (or as edge properties
  honored by traversal queries)
- Route computation as Cypher (variable-length + cost accumulation), or a
  small set of `local-callables`-style preview procedures
- Reference extracts: 3-5 cities as shipped `.cl` files, with load scripts

## Lineage & inspiration

- [OpenStreetMap](https://www.openstreetmap.org) and
  [Geofabrik extracts](https://download.geofabrik.de) — the data, cut to
  order
- [NetworkX geospatial examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
  — street/river networks as graphs, routing and accessibility analysis;
  the analyses to port from Python notebooks into Cypher
- [OSMnx](https://geoffboeing.com/publications/osmnx-street-networks/) —
  the reference "OSM extract → routable graph" tool this makes file-native;
  see the [JOSS paper](https://joss.theoj.org/papers/10.21105/joss.00215)
- [osmium-tool](https://osmcode.org/osmium-tool/) — the C++ command-line
  PBF filter/extract stage the loader borrows its day job from
- [Protomaps](https://protomaps.com) — the single-file map tile story; the
  graph analog of "your city in one file"
