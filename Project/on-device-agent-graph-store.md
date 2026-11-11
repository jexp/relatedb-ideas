---
type: Project
name: on-device-agent-graph-store
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Home Assistant]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: the human-app form factor over the same on-device store
    target: "[[Project/phone-app-shell]]"
  - kind: complements
    reason: same embedded graph store pattern for a robot's local context
    target: "[[Project/robot-side-brain]]"
  - kind: complements
    reason: supplies the device and sensor half of the on-device world model
    target: "[[Project/smart-home-state-graph]]"
USES_TECH:
  - "[[Technology/Graphiti]]"
  - "[[Technology/Home Assistant]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# On-Device Agent Graph Store

> The phone/watch/robot as the agent's graph home: personal facts, task state,
> device and sensor relationships, retrieved knowledge snapshots — the
> Apple/Kuzu-shaped niche for every other platform, in RelateDB.

## What

Apple's acquisition of Kuzu (the embedded graph database) settled the premise:
graph-shaped storage is going on-device, because the data an agent needs —
personal context — is naturally a graph. This project is that store for every
platform that isn't Apple's, answering the *content* question: what does a
local agent keep in its graph?

Four kinds of state live here. **Personal facts**: preferences, people, places,
commitments — the durable knowledge layer. **Task state**: active goals as
small DAGs of steps with dependencies and done-markers, so "what am I blocked
on and by whom" is a traversal. **Device and sensor relationships**: this
phone's sensors, paired devices, rooms, HomeAssistant entities — a world model
whose `:IN_ROOM` / `:LAST_REPORTED` edges turn "the device near the front
door" into a query. **Retrieved knowledge snapshots**: pages the agent
fetched and distilled, kept as cited subgraphs rather than opaque embeddings,
so provenance ("*why* do you believe that?") is one hop to a source.

The store is the agent's single persistent organ: private by default,
agent-queryable over MCP stdio, human-inspectable via `relate query`.

## Why RelateDB

This is RelateDB's exact shape: an embedded in-memory engine that links into
an app — via the C ABI for mobile wrappers (Objective-C/Swift, Kotlin/JNI),
or the WASM build for web/hybrid apps — persisting to a local WAL + Parquet
checkpoint with no ops footprint on a battery-powered device. Temporal types
and the WAL give sensor readings and task history real bi-temporal semantics,
and `relate serve --mcp stdio` exposes the store to any conforming agent
runtime without a network listener. A single `.cl` file makes the store
user-portable and user-deletable — the privacy story cloud agent memory
cannot tell.

## What it needs

- Mobile C-ABI wrappers (Swift + Kotlin) with a schema for the four state
  families above
- Ingest adapters: HomeAssistant/MQTT, calendar/contacts importers,
  page-fetch distillation for knowledge snapshots
- An MCP stdio bridge in the host app, agent-side retrieval queries (context
  assembly as a bounded-Cypher walk), and a human inspector (WASM view or
  `relate query`)
- Sync/backup policy: one-file export as the user unit; selective merge later

## Lineage & inspiration

- [Kuzu](https://github.com/kuzudb/kuzu/) and Apple's acquisition of it —
  validation that on-device graph storage is a funded direction
  ([research/graph-world.md](../research/graph-world.md) §1); the
  [Kuzu Graph RAG](https://github.com/kuzudb/graph-rag) and
  [dspy demo](https://github.com/adsharma/kuzu-demo-dspy) — agents using an
  embedded graph as their working organ
- [graphiti](https://github.com/getzep/graphiti) /
  [zep](https://arxiv.org/html/2501.13956) — the episode/entity/fact content
  model, currently implemented only against server backends
- [HomeAssistant](https://www.home-assistant.io/) and the *Smart-Home State
  Graph* / *Robot Side-Brain* ideas — the device/sensor side of the world model
