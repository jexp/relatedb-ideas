---
type: Project
name: running-cycling-hiking-graph
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Garmin]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Strava]]"
RELATED_IDEA:
  - kind: variant
    reason: both put personal route and activity data into a local queryable graph
    target: "[[Project/local-route-brain]]"
  - kind: complements
    reason: shares the geospatial trail/road network modeling substrate
    target: "[[Project/openstreetmap-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/FIT]]"
  - "[[Technology/GPX]]"
  - "[[Technology/Garmin]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Strava]]"
  - "[[Technology/TCX]]"
---

# Running/Cycling/Hiking Graph

> Your tracked activities as a graph of segments and climbs; query personal records as shortest-times per edge.

## What

Years of Strava/Garmin/Fit files are a pile of activities nobody can query — the
apps show one ride at a time. This project decomposes every tracked activity into
a graph: trail/road *segments* as edges between junction-ish waypoints, plus
nodes for climbs, descents, surfaces, and POIs. `(:Segment {grade, surface,
elevation})`, `(:Segment)-[:CLIMB]->(:Hill)`, `(:Activity)-[:COVERED]->(:Segment)`
with your time on each edge.

Personal records fall out immediately: your PR on a segment is
`min(t.durationSeconds)` over one edge across all activities — a leaderboard
with a population of one. Then the questions get fun: "loop routes under 10k with
exactly two climbs", "all segments where I've PR'd that I haven't run this year",
"which climbs got slower as I aged" — trend lines per edge. Compare with friends
by merging their .cl exports: segment-level leaderboards computed locally, no
SaaS.

The graph also recomposes *you*: heatmap-style "segments I've covered" queries,
gap detection ("streets in my neighborhood I've never set foot on"), and
route-invention — chain preferred edges into a candidate route, let the map
render it.

## Why RelateDB

A life of GPX/TCX/FIT is thousands of files of points; the re-modeled graph is
modest and in-memory Cypher makes every one of these questions a sub-second
scan, not an API quota. The store rides on the phone (C ABI → mobile wrappers)
so the "which way now" decision happens offline at the trailhead, or on the
laptop as `--database activities.cl` with CSV/JSON output for the analytics
habit. Temporal types carry activity dates natively — season comparisons and
year-over-year trend queries are property predicates. The single .cl file is
the sharing unit for the friend-leaderboard mode. And where some questions
need fuzzy recall ("that segment with the sheep"), hybrid vector search over
segment descriptions plus graph traversal answers in one query.

## What it needs

- Ingest: FIT/GPX/TCX parsers → activity nodes with raw traces
- Segmentation: map-matching-lite — split traces at junctions, dedupe near-
  identical passages into shared Segment edges (the core algorithmic work)
- Derived nodes: climbs (grade/elevation bands), surfaces, POIs
- Query front end: PR table, gap map, route composer; charts from CLI JSON
  output or a small WASM explorer
- Friend-merge protocol (.cl exchange + MERGE on shared segment keys)

## Lineage & inspiration

From [research/graph-world.md](../research/graph-world.md): the NetworkX
[geospatial network examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
(the trail-network modeling patterns) and [Kuzu](https://github.com/kuzudb/kuzu/)
(embedded graphs going on-device — validated at Apple scale). The
"recommendations from your own history" angle echoes the personal-data lane of
[research/agent-native.md](../research/agent-native.md) — retrieval over your own
records instead of someone else's cohort.
