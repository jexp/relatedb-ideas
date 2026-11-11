---
type: Project
name: local-route-brain
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
RELATED_IDEA:
  - kind: same-data
    reason: both route over GPX trail segments stored as a graph
    target: "[[Project/running-cycling-hiking-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GPX]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Valhalla]]"
---

# Local Route Brain

> Transit networks (GTFS!) or GPX trail networks on your phone; offline routing + "rides like this" recommendations from your own history.

## What

Routing apps need the cloud; you need the route — on the subway, on the trail, in
a foreign country with no SIM. This project puts the network *and* the router on
the phone. GTFS is a ready-made graph: stops, routes, trips, transfers,
schedules — `(:Stop)-[:SEGMENT_OF]->(:Route)`, `(:Trip)-[:CALLS_AT {time}]->(:Stop)`,
transfer edges with walking distances. Load your city's feed once, then route,
explore, and schedule offline with plain Cypher.

The second half is your own history: every ride/hike you've recorded becomes a
subgraph, and "rides like this" becomes a similarity question over segments you
already know. "Which routes did I take that pass through this neighborhood?"
"When's the next tram I could catch that matches my usual evening pattern?"
Recommendations from *your* data, not a server's cohort average.

Trail networks are the same graph with different dignity: GPX tracks → trail
segments with climb/grade properties; "loop hikes under 10km with two good
viewpoints and no road crossings" is one pattern match. The map renders; the
graph decides.

Every format and engine named here is real and documented. GTFS is an open
specification (gtfs.org) whose schedule reference is already the node/edge
model above — agency, routes, trips, stops, stop_times, calendar, transfers,
one CSV per node and edge type. The offline precedent is BRouter: a routing
engine that runs on Android phones and routes over continent-scale networks
entirely from locally stored data — proof that a phone carries the network
*and* the router. Valhalla is the same bet tiled: its routing data is pre-cut
into loadable tiles, designed to run embedded and offline.

## Why RelateDB

RelateDB's C ABI is wrapped by Python, JS, Java, and Go — mobile-capable
bindings that put a TCK-verified Cypher engine on the device. In-memory path
queries on a phone beat round-trips to a maps API: shortest-path, isochrone-
style bounded traversals, and schedule queries (temporal types are native, so
"depart after 17:30" is a property predicate, not string parsing) all run at
scan speed over a city-sized feed. Durable form is the fsync'd WAL + Parquet
checkpoint — one .cl file is the whole city network plus your history,
backed up by copying one file. And when you'd rather not write Cypher on a
phone, `serve --http` on any box (or a laptop at home) exposes the same store;
the queries are identical everywhere.

## What it needs

- GTFS loader: agency/routes/trips/stop_times/calendar into the model above,
  with schedule consolidation (a Route node holding the headway pattern rather
  than a million Trip nodes — design decision)
- Routing layer: shortest path with time-dependent edges; Dijkstra-shaped
  Cypher or a small library function over the embedded store
- GPX ingest + segment matching (snap your recorded tracks to trail segments)
- Mobile front end (map + query templates); offline packaging of feed + history
- Feed update handling: re-load a new GTFS version without losing your history

## Lineage & inspiration

From [research/graph-world.md](../research/graph-world.md): the NetworkX
[geospatial examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
(street/river networks, routing, accessibility analysis — the query catalog),
and [Kuzu](https://github.com/kuzudb/kuzu/) (the embedded-on-device precedent —
now Apple's — that validates local graph storage). The embedded-DB-on-phone
pattern has shipping precedent in
[expo-opsqlite-libsql-turso](https://github.com/expo-starter/expo-opsqlite-libsql-turso);
RelateDB is the graph-native version of that story. Verified format/engine
references: the [GTFS schedule
reference](https://gtfs.org/documentation/schedule/reference/), [BRouter's
offline routing on Android](https://brouter.de/brouter/offline.html)
([source](https://github.com/abrensch/brouter/)), and the [Valhalla routing
API docs](https://valhalla.github.io/valhalla/api/route/overview/).
