---
type: Project
name: the-mud-mappers-revenge
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
---

# The MUD Mapper's Revenge

> MUD/MMO worlds (rooms, exits, items, spawn tables, player traces) in one
> queryable .cl file: the world IS the
> graph, the map is a projection.

## What

A MUD world is already a property graph — it always was. Rooms connected
by directional exits, doors with keys, items in containers, mobiles on
spawn tables. In the 90s we flattened that into custom mapper formats
because nothing else could hold it; this project un-flattens it.
`(:Room {vnum, title})-[:EXIT {direction, key}]->(:Room)`,
`(:Area)-[:CONTAINS]->(:Room)`, `(:Item)-[:SPAWNED_BY]->(:SpawnTable)` —
and the map becomes a query projection instead of the source of truth.
The queries the old mappers approximated become exact: shortest path
from temple to bank avoiding locked doors (or returning the key you'd
need and which mobile drops it); rooms reachable only through the
underwater passage; farming loops covering five spawn tables in thirty
moves. Layer player traces — `(:Player)-[:MOVED {at}]->` edges captured
from session logs — and the world tells you things no mapper could:
where players actually go, which exits nobody takes, which corridor
everyone sprints through to reach the dragon.

## Why RelateDB

One `.cl` file holds the entire world — areas, rooms, items, tables —
and opens anywhere: a browser tab over the WASM build for the map view,
the `relate` CLI for exploration, `relate serve` for the guild
forum. The graph *is* the store, so map rendering, `RETURN mermaid()`
exports and text dumps are all projections of one truth. In-memory
traversal outpaces any MUD server's own pathfinding, and the WAL makes
live capture possible: a capture client appends `MOVED`/`KILLED`/
`PICKED_UP` edges as they happen, replayable later. Python bindings
turn the ROM/Diku area-file parser into a weekend script, and `:memory:`
gives throwaway sandboxes for testing area designs before they ship.

## What it needs

- Importers: DikuMUD/ROM `.area` files, MUSH/MUX exits, and MUD client
  log captures into the shared model
- Query pack: doorless routes, key dependency chains, spawn-table tour
  optimization
- A map renderer that lays out rooms from exit direction properties
  (the map as a projection)
- Trace layer: session-log append pipeline into temporal edges, plus
  "replay this session" tooling

## Lineage & inspiration

- The DikuMUD/ROM lineage and its area-file format — worlds as room/exit
  records since 1990: https://en.wikipedia.org/wiki/DikuMUD
- IFM (interactive fiction mapper) — the text-adventure cousin that
  proved map-from-exits works: http://www.sentex.net/~dbell/ifm/ifm.html
- The MUD Connector archives — the ecosystem where custom mappers lived:
  http://www.mudconnector.com/
- RelateDB's own `fs-to-graph`/`git-to-graph` lab commands — the
  "world-as-file, graph-on-open" pattern applied to games
