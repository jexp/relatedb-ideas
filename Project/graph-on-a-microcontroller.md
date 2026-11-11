---
type: Project
name: graph-on-a-microcontroller
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: variant
    reason: the Pi-class sibling; this is the next class of hardware down
    target: "[[Project/classroom-server-on-a-35-board]]"
  - kind: complements
    reason: the home-state graph whose local slice the board could host
    target: "[[Project/smart-home-state-graph]]"
  - kind: complements
    reason: the sensor stream feeding the microcontroller hub
    target: "[[Project/the-emergent-interaction-graph]]"
  - kind: complements
    reason: the sync-upward pattern the hub reuses
    target: "[[Project/the-pouchdb-move]]"
USES_TECH:
  - "[[Technology/C ABI]]"
  - "[[Technology/MQTT]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# A Graph on a Microcontroller

> The extreme end of "embedded": the C ABI engine on an ESP32-class board —
> sensor neighborhoods, device inventories, tiny graphs, hundreds of
> kilobytes of RAM — with the honest memory math up front.

## What

The embedded promise gets one final stress test: below the phone, below
the Pi, the microcontroller — a $4 board with WiFi, a few hundred KB of
RAM, and no disk. SQLite gets ported there repeatedly (the community keeps
proving it can be done, with real constraints); the graph question is
whether a property-graph engine earns its footprint at that scale.

The honest scope: this is *not* million-node graphs. It is graphs of a
few thousand nodes and edges — which is still a lot of relationships: a
home's device inventory and dependency rules, a farm's sensor
neighborhoods, a workshop's tool-custody chain, a mesh network's routing
table, a science-fair experiment's observations. The questions at that
scale are exactly the engine's native questions — reachability,
shortest-path, pattern rules ("does this command path touch a safety
interlock?") — executed on-device, offline, in one process, with the
checkland microSD or littlefs as the durable layer.

The interesting version is the *hub*: the MCU as the graph node where the
physical world attaches — sensors as event edges streaming into the WAL,
the board answering local questions and syncing its slice upward (the
PouchDB-move pattern with a microcontroller at the edge of the edge).

## Why RelateDB

The C ABI is already the portability story (one engine, every language
that can call C — and an ESP32 can call C); in-memory-first matches the
hardware (no disk cache to fill, RAM is the store, the checkpoint is the
whole durable footprint). No allocator gymnastics, no async runtime, no
TLS stack needed for the local-only build — the same smallness that makes
the single-binary story work on laptops makes it *measurable* here. And
the memory numbers are the deliverable: a few thousand nodes at, say,
100 bytes each plus edges is tens of KB resident — the feasibility writeup
with real measurements on real boards is itself the contribution.

## What it needs

- The port: C-ABI build for ESP32-class targets (no_std constraints, the
  VFS over littlefs/SPIFFS), and the memory-footprint measurements up
  front — the honest table this idea lives or dies on
- The demo firmware: a sensor-hub or device-inventory app answering graph
  queries locally (LED blink if the pattern matches; MQTT sync upward)
- The boundary writeup: where it stops being viable (node counts, property
  sizes, query classes) — stated, not discovered by users
- The sync story upward: checkpoint export to a parent device

## Lineage & inspiration

- The SQLite-on-microcontroller porting tradition (the community ESP32
  ports and the recurring "can it run on a $4 board" experiments) — the
  precedent that file-format databases keep getting pushed down to the
  smallest silicon (`research/sqlite-everywhere.md`)
- [Classroom Server on a $35 Board](classroom-server-on-a-35-board.md) —
  the Pi-class sibling; this is the next class down
- [The Emergent Interaction Graph](the-emergent-interaction-graph.md) and
  [Smart-Home State Graph](smart-home-state-graph.md) — the sensor-stream
  feeding the hub; [The PouchDB Move](the-pouchdb-move.md) — the sync-up
  pattern
- littlefs/SPIFFS — the durable-layer reality of the target class
