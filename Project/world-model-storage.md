---
type: Project
name: world-model-storage
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Microsoft]]"
  - "[[Company/Zep]]"
USES_TECH:
  - "[[Technology/C ABI]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/TextWorld]]"
  - "[[Technology/cognee]]"
  - "[[Technology/mem0]]"
---

# World-Model Storage

> Persistent world state for simulation/game agents: rooms, affordances,
> event histories the agent lives in — the frontier where a world model
> needs a real storage engine, not a JSON blob.

## What

Ask an agent to live in a simulated world today and it gets a JSON blob:
a room list, an inventory array, an event log nobody can query. It
re-reads the whole blob every turn, forgets nothing, connects nothing.
This project gives the world a storage engine: `(:Room)-
[:CONTAINS]->(:Object {affordances})`, `(:Door)-[:REQUIRES]->(:Key)`,
`(:Agent)-[:OBSERVED {at}]->(:Event)` — the world model as a live
property graph the agent queries instead of parses. "Where did I last
see the torch?" is an `OBSERVED` lookup. "What changed in the kitchen
since I was last here?" is a temporal diff. "Can I get from the cellar
to the study unseen?" is a path query filtered by which NPCs saw which
doors — perception, movement and consequence in one model.

The frontier part is persistence: worlds that outlive a session. Stale
beliefs get `supersededBy` edges, not deletions, so "what did I believe
then vs. what is true now" is reconstructable — exactly what debugging
a confused agent requires. Game NPCs want the same engine in-process:
two hundred agents' beliefs and grudges in one store, updated at
simulation rate, queried at plan time.

## Why RelateDB

The embedded engine's home turf: the store links into the game or agent
process over the C ABI (Rust directly, Python/JS/Go via wrappers) — no
server, no IPC, no ops; the JSON blob's replacement is a library call.
`:memory:` worlds are disposable sandboxes (one per episode, zero
cleanup); WAL-backed worlds persist, and a world snapshot is one `.cl`
file — resume the exact world, belief state included, on another
machine or another model. In-memory traversal makes plan-time queries
("which rooms before the guard's next patrol") cost microseconds. The
WAL's append shape matches simulation itself: events are the log, the
graph is the replay, and time-travel debugging a bad decision is
jumping to the belief state at the offending tick.

## What it needs

- The core ontology: spaces, objects with affordances, agents, events,
  and belief edges with `supersededBy` (invalidation, not deletion —
  the Graphiti lesson)
- Snapshot/restore and belief-state-at-time-t queries (the debugging
  interface)
- A reference sim harness: text or grid world, one agent living in
  the store through a full episode, replayable
## Lineage & inspiration

- Research/agent-native.md — the agent-memory landscape converging on
  graphs + temporal facts: Graphiti https://github.com/getzep/graphiti,
  mem0 https://github.com/mem0ai/mem0,
  cognee https://github.com/topoteretes/cognee
- The Apple/Kuzu acquisition — graph-shaped storage going on-device;
  the world-model niche validated at scale (research/graph-world.md)
- TextWorld and ALFRED-style embodied environments — the worlds that
  currently run on JSON state: https://github.com/microsoft/TextWorld
