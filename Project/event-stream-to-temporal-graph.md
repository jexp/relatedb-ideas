---
type: Project
name: event-stream-to-temporal-graph
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: window replay visualized as motion over time
    target: "[[Project/animated-graph-timelapse]]"
  - kind: complements
    reason: the security replay UI built directly on this ingestion and replay pattern
    target: "[[Project/cyber-range-replayer]]"
  - kind: same-data
    reason: MQTT sensor events folded into a temporal graph
    target: "[[Project/smart-home-state-graph]]"
  - kind: same-data
    reason: clickstream events land as timestamped edges on a user path
    target: "[[Project/user-journey-recorder]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JSONL]]"
  - "[[Technology/Kafka]]"
  - "[[Technology/MQTT]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/Redis]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/pcap]]"
---

# Event Stream to Temporal Graph

> Append-only logs (logs, clicks, packets) into a WAL-backed graph; replay
> any window and query it as it was.

## What

Clickstreams, application logs, netflow captures, sensor telemetry — the
world's default data shape is an append-only event log. This project is the
tap that turns a live stream into a temporal property graph: each event
enriches and extends the graph (a click adds an edge with a timestamp, a
login creates or updates a node with a validity window), and the graph is
always the current fold of the stream.

The differentiator is *replay*. Because the store is a WAL, the event history
is preserved: "show me the graph as it stood at 14:03 last Tuesday" is a
checkpoint-relative query, and "rebuild the customer's journey window" is a
WAL replay. Incident analysis becomes cinematic — replay the last hour of
requests around the outage, then `MATCH` the paths that only existed during
it.

The ingestion contract is the piece to standardize: a small event schema
(who/what/relates-to/when/valid-until) so adapters are trivial — log shipper,
Kafka/Redis stream, MQTT for the smart-home people, pcap for the forensics
people. Each is a thin translator into the same generated-`CREATE` pipeline.

## Why RelateDB

The durable form is *literally* an append-only, fsync'd WAL with periodic
Parquet checkpoints — the event-sourcing substrate comes for free rather than
being bolted on, the way LiveStore builds an event-sourced framework on
SQLite's log. The in-memory engine means the fold is always current and fast:
live queries over today's stream cost a scan, not a server round trip. And
the `pull` command's stream-of-events → generated `CREATE` → store architecture
is precisely the ingestion shape; the adapters just change where events come
from. `:memory:` stores give ephemeral sandboxes for replay experiments
without touching the durable one.

## What it needs

- An event schema + adapter trait: JSONL tail, Kafka/Redis streams, MQTT,
  pcap — each a translator to generated writes
- Temporal query surface: valid-time filtering, window replay
  (`as-of T`), interval overlap functions (the CIP-eval temporal work is the
  dialect hook)
- Checkpoint-relative "graph as of T" reconstruction over the WAL
- Backpressure/idempotency policy for at-least-once sources (event IDs →
  `MERGE` anchors)
- A demo corpus: one hour of a real app's logs replayed as a timeline

## Lineage & inspiration

- [LiveStore](https://livestore.dev) — event-sourced apps on an in-memory
  embedded engine; the log *is* the state
- [Graphiti](https://github.com/getzep/graphiti) — temporal knowledge graphs
  with validity windows and episode provenance; the query semantics to match
- [rqlite](https://github.com/rqlite/rqlite) — consensus over log segments
  for the later distributed chapter
- `relate pull` + the WAL/checkpoint storage layer — the native pipeline
  this project taps
