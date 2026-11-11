---
type: Project
name: disaster-response-router
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Geofabrik]]"
  - "[[Company/Humanitarian OpenStreetMap Team]]"
  - "[[Company/OpenStreetMap Foundation]]"
  - "[[Company/Organic Maps]]"
RELATED_IDEA:
  - kind: complements
    reason: the map-rendering layer the responder app needs
    target: "[[Project/graph-overlay-on-leaflet-mapbox]]"
  - kind: variant
    reason: on-device routing over a local road graph with closure state
    target: "[[Project/local-route-brain]]"
  - kind: inspired-by
    reason: the OSM loader this project shrinks from a wedge onto a phone
    target: "[[Project/openstreetmap-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Geofabrik]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/OpenStreetMap]]"
  - "[[Technology/Organic Maps]]"
  - "[[Technology/PBF]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Valhalla]]"
---

# Disaster Response Router

> An OSM extract + road-closure edges on a phone; works without cell towers
> because the graph is local.

## What

When a flood, fire, or earthquake hits, the first thing that fails is
cellular data, and the second is the accuracy of every routing app's
"road closed" knowledge. This project prepares the graph *before* the
disaster: an OSM extract of your region loaded on responders' phones, with
closure modeling built in — a `[:CLOSED {since, source, reason}]` edge or
flagged property that responders toggle from the field (a map tap, or a
note synced whenever any connectivity exists). Routing then runs entirely
on-device: shortest passable route from the staging area to the cut-off
neighborhood, reachable shelter list for a given fuel/ambulance range,
which bridges' closures disconnect which settlements.

The same phone graph answers the *planning* questions: bridge
single-point-of-failure audits for an evacuation zone, shelter coverage by
isochrone, and post-event reconstruction tracking as closures are lifted.

The offline-routing-on-a-phone precedent is concrete. Organic Maps packs
a routing graph into per-country MWM binaries (built straight from OSM
PBF by its generator) and runs bidirectional A* with a landmark heuristic
entirely on-device; Valhalla's tiled routing graph is designed for mobile
embedding (offline routing in the CARTO mobile SDK); GraphHopper runs
offline on Android; OsmAnd routes from its own OBF packs. All prove the
sovereignty — none of them makes the road graph itself queryable: the
router is a black box, and closure state lives in UI toggles, not in a
graph you can audit.

The key property is sovereignty: no cloud routing API can rate-limit or
deprioritize a disaster zone, and no cell tower is required.

## Why RelateDB

The C ABI is the carrier: mobile wrappers (the same product C ABI wrapped
for JS/Java/Go and mobile frameworks) embed the engine in a responder app
on the phone, running in-memory Cypher with no server, no network, and no
runtime dependency on cloud services. Point types keep the routing graph
map-native; variable-length path queries with edge predicates (excluding
`CLOSED`) are the router. The store-as-directory (WAL + Parquet checkpoint)
makes the regional extract a downloadable pack — and makes every field edit
durable offline,
syncing as a file whenever any link exists. The same `.cl` pack runs in the
incident-command laptop's CLI, so the phone and the command post share one
graph format.

## What it needs

- An OSM-extract-to-pack pipeline per region (routable subset,
  emergency-relevant POIs: shelters, hospitals, hydrants, fuel), sized for
  phone storage
- Mobile app shell over the C ABI: offline map rendering, route query,
  closure edit UI that works one-thumb in the rain
- Closure interchange: file/airgap sync plus an SMS/mesh-radio
  serialization so edits propagate peer-to-peer
- Pre-event planning query set: bridge/chokepoint audit, shelter isochrones,
  evacuation-zone reachability

## Lineage & inspiration

- [OpenStreetMap](https://www.openstreetmap.org) / [Geofabrik](https://download.geofabrik.de)
  — the base extracts; [HOT](https://www.hotosm.org) for disaster mapping
- [Organic Maps](https://github.com/organicmaps/organicmaps) and the
  [MWM format deep-dive](https://osm2cdr.com/en/blog/format-mapsme-mwm-deep-dive/)
  — on-device routing over packed per-country graphs; the sovereignty
  precedent
- [Valhalla](https://valhalla.github.io/valhalla/concepts/why-tiles/) —
  tiled routing graphs designed for offline/mobile embedding
- [OpenStreetMap Wedge](openstreetmap-wedge.md) — the loader this project
  shrinks onto a phone
- [NetworkX geospatial examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
  — routing/accessibility analyses to port offline
- Turso's [expo starter](https://github.com/expo-starter/expo-opsqlite-libsql-turso) — the embedded-DB-on-phone pattern, transposed to graphs
