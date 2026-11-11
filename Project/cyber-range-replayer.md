---
type: Project
name: cyber-range-replayer
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Honeynet Project]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
RELATED_IDEA:
  - kind: complements
    reason: time-slider replay of an evolving graph over a different corpus
    target: "[[Project/animated-graph-timelapse]]"
  - kind: complements
    reason: same security graph data read forwards as simulation, backwards as replay
    target: "[[Project/attack-path-simulator]]"
  - kind: inspired-by
    reason: builds directly on the append-only log to temporal graph pattern
    target: "[[Project/event-stream-to-temporal-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/NetFlow]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Sysmon]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Zeek]]"
---

# Cyber Range Replayer

> Turn network/netflow logs into a temporal graph and replay an incident like a
> movie; scrub the timeline with the mouse.

## What

An incident is a story with a timeline: first beacon, first lateral move,
privilege escalation, exfiltration. Load Zeek/netflow/Sysmon/EDF logs into a
temporal property graph — hosts and identities as nodes, connections and
process spawns as timestamped edges — and the incident becomes a path you can
*replay*: a time slider in a browser that re-issues `MATCH` queries restricted
to the visible window, so the analyst watches the blast radius grow frame by
frame.

Scrubbing the timeline is a temporal filter (`WHERE t.ts >= $window_start AND
t.ts < $window_end`), and causal questions become queries: "what did the
compromised host touch in the 10 minutes *before* the alert fired?", "which
host talked to both the C2 domain and the file server?", "what was the first
outbound connection from this user's workstation today?" Post-incident review
becomes shareable: the whole replay — data plus the analyst's query trail — is
one `.cl` file a colleague opens and scrubs themselves.

## Why RelateDB

RelateDB's temporal types (TCK-pinned date/time/duration) make timestamped
edges first-class, and the WAL is literally an append-only record of what
happened in what order — the same shape as the incident log itself. In-memory
scans mean window queries over millions of events answer at interaction speed,
so scrubbing feels like video, not like a data warehouse. The WASM build makes
the replay a shareable browser artifact: open a `.cl` file in a tab and scrub.
`:memory:` stores let you spin up a disposable copy of a log slice for
hypothesis testing without touching the evidence.

## What it needs

- Parsers/loaders for Zeek JSON, netflow v5/v9/IPFIX, Sysmon, firewall exports
  (the `relate pull --query` pipeline is the shape)
- A schema mapping log events to timestamped edges + host/identity nodes
- The browser replay UI: a time slider that re-queries the WASM engine per
  window, rendering the evolving subgraph
- Window-replay helpers (a `graphical`/parametrized time-window query pack)
- Sample incident datasets (Honeynet Project / SecRepo slices) for the demo

## Lineage & inspiration

- The `Event Stream to Temporal Graph` pattern — append-only logs into a
  WAL-backed graph, replay any window
- [GUAC](https://github.com/guacsec/guac/) and
  [Joern](https://github.com/joernio/joern/) (research/graph-world.md §6) —
  security data as queryable graphs, but neither is an incident *timeline*
- Network-science temporal-graph precedent: Barabási's temporal networks
  chapters ([networksciencebook.com](https://networksciencebook.com/)) as the
  teaching layer
- Gephi's timeline slider — the interaction this idea brings to security logs,
  but backed by real queries
