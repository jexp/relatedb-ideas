---
type: Project
name: graph-overlay-on-leaflet-mapbox
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/OpenStreetMap Foundation]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: explicitly the same never-lies rendered-view pattern, applied to geography
    target: "[[Project/architecture-diagram-that-never-lies]]"
  - kind: same-data
    reason: supplies the OSM-derived base graph this map renders
    target: "[[Project/openstreetmap-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/OpenStreetMap]]"
  - "[[Technology/RelateDB]]"
---

# Graph Overlay on Leaflet/Mapbox

> The graph holds truth; the map renders it; hover a street to see the Cypher
> behind it (and to edit it).

## What

Standard GIS apps keep their data in shapefiles or PostGIS and render layers
with all the semantic richness of a bitmap. This project inverts the stack:
the graph is the database of record — streets, intersections, closures,
works, incidents, cycle lanes as labeled nodes and typed relationships — and
the Leaflet/Mapbox canvas is just a *view* whose every pixel is backed by a
node you can query. Hover a street segment: the panel beside the map shows
the actual Cypher row — label, properties, and the `MATCH` that produced it.
Click two intersections: the route drawn on the map *is* a query result
streaming edges.

Editing completes the loop: flag a road closed, and the write is a Cypher
`CREATE`/`SET`; every downstream query (isochrones, detours, school-catchment
areas) recomputes against the new truth immediately, because there is no
separate "analysis model" to refresh. The map's own state — view, selection,
layers — can itself be derived by queries ("show only streets modified since
last inspection").

This is the "architecture diagram that never lies" pattern, but for
geography — the rendering cannot drift from the data, and the data is
inspectable, because it is a graph.

Graph layers already exist at the WebGL altitude: deck.gl-community's
GraphLayer renders geolocated node-link diagrams on the same map canvas
(sigma.js underneath), and flowmap.gl built the interactive
origin–destination flow overlay on Leaflet/MapLibre that proved edge
rendering on maps is viable. What those layers consume is a static file
— the rendering half without a query half. This project's move is that
the layer's data source is a live engine, so the map's features are
query results rather than uploads.

## Why RelateDB

The WASM build makes this a pure client-side story: the engine, the data
(one `.cl` file fetched once), and the map tiles run in one browser tab — no
API server, no proxy, no CORS. In-memory Cypher answers hover-time queries
(what am I pointing at?) and edit-time recomputes (all affected bus routes)
with no latency budget to manage. Point types mean geometry lives natively
in the engine, so the mapping from graph to map coordinates is trivial. And
the WAL means every edit on the map is durable immediately — close the tab,
reopen, the closures you flagged are still there.

## What it needs

- A thin bridge layer: query results (with point properties) →
  Leaflet/Mapbox GeoJSON layers, and map gestures (click, drag, hover) →
  parameterized Cypher
- An OSM-derived base graph (see the OpenStreetMap Wedge project) or any
  graph with point properties
- An inspect panel that shows the row and the query behind every rendered
  feature; an edit palette (close road, add incident, edit property)
- Sync story for teams: shared file on a NAS/git, or `relate serve --http`
  for a small group

## Lineage & inspiration

- [Leaflet](https://leafletjs.com) and [Mapbox GL JS](https://docs.mapbox.com/mapbox-gl-js/)
  — the rendering half
- [NetworkX geospatial examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
  — the analyses whose results become overlays
- [OpenStreetMap Wedge](openstreetmap-wedge.md) — the data underneath this
  project
- [Kepler.gl](https://kepler.gl) — the reference "big data on a map"; graph features become queryable, not just filterable
- [deck.gl-community GraphLayer](https://visgl.github.io/deck.gl-community/docs/modules/graph-layers/api-reference/layers/graph-layer)
  — node-link graphs rendered geolocated on the map canvas
- [flowmap.gl](https://flowmap.gl/) — interactive origin–destination flow
  overlays; the edge-on-map precedent
