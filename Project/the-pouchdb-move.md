---
type: Project
name: the-pouchdb-move
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Electric SQL]]"
  - "[[Company/Ink & Switch]]"
USES_TECH:
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/WAL]]"
  - "[[Technology/cr-sqlite]]"
  - "[[Technology/sqlsync]]"
---

# The PouchDB Move

> Offline-first RelateDB that syncs to a central store (RelateDB or Neo4j):
> local-first apps that keep working on the subway, merge on reconnect (Ink &
> Switch's ideology, the CouchDB/PouchDB architecture).

## What

PouchDB's killer move was never the API — it was the claim "your database works
offline, and syncs when it can." This project makes the same move for graphs:
a RelateDB store embedded in the app (browser via WASM, desktop via the Rust
crate, phone via the C ABI wrappers) as the *primary* database, with a
background sync engine that pushes and pulls deltas against a central origin —
a `relate serve` instance or a Neo4j.

The app never talks to the server on the request path: every query and write
runs against the local in-memory engine at scan speed, and the UI is reactive
because the data is *there*. The sync engine works from the WAL — local writes
are already an ordered, typed log, and the origin's changes arrive as segments
to replay, so "sync" is WAL exchange between embedded peers. The hard part is
honest conflict handling: two offline edits to the same node need a merge
policy. The CRDT wave (cr-sqlite, sqlsync) shows the convergent end-state —
per-property last-writer-wins registers, set-adds for labels and edges, plus
a reviewable conflict queue — layered over the WAL rather than replacing it.

The precedent is precise, not folkloric. CouchDB's replication is a documented
protocol: peers exchange a change sequence with `_rev` generation counters,
conflicts persist as a revision tree for application-side resolution, and
checkpoints let replication resume incrementally — PouchDB proved the embedded
half of it in the browser for a decade. Ink & Switch's essay names the seven
ideals (fast, multi-device, offline, collaborative, long-lived, private,
user-owned) the sync engine must preserve, and the current wave ships them over
SQLite: cr-sqlite is an Apache-2.0 SQLite extension doing per-row CRDTs, and
sqlsync is an Apache-2.0 "collaborative offline-first wrapper around SQLite"
with eventually consistent replicas, optimistic reads and reactive query
subscriptions. Convergence layered over a plain durable log is the shipped
pattern this project ports to graphs.

## Why RelateDB

The WAL is already the sync artifact: every local write is an ordered,
structured log entry, so the sync engine ships and applies exactly what the
engine persists — no change-data-capture sidecar, no shadow tables. The
embedded engine on every platform (WASM in the browser, Rust on desktop, C ABI
wrappers on mobile) means the *same* sync protocol spans the whole client
fleet, and a Neo4j origin is reachable with the shipped `pull` (Query API v2)
integration. In-memory speed makes the offline experience indistinguishable
from online — the local-first pitch is strongest when local is also the fast
path.

## What it needs

- A sync protocol: WAL-segment exchange between embedded peers and an origin
  (`relate sync configure/push/pull/status`), with per-peer cursors
- Conflict policy: property-level merge rules (LWW / set semantics for labels
  and edges), a persisted conflict queue, and a review UI for manual merges
- An origin adapter: `relate serve` as first-class; Neo4j via the existing
  `pull` pipeline for the read half and delta replay for writes
- Protocol versioning and store-format evolution, since clients will be
  offline for weeks; a flagship local-first app at Linearlite scale as the
  proof demo

## Lineage & inspiration

- [Ink & Switch, "Local-first software: you own your data, in spite of the
  cloud"](https://www.inkandswitch.com/essay/local-first/) — the founding
  manifesto; the seven ideals this project implements for graphs
- [PouchDB](https://pouchdb.com/) / [the CouchDB replication
  protocol](https://docs.couchdb.org/en/stable/replication/protocol.html) —
  the documented offline-first + merge-on-reconnect architecture, proven for
  a decade
- [cr-sqlite](https://github.com/vlcn-io/cr-sqlite) and
  [sqlsync](https://github.com/orbitinghail/sqlsync) — the CRDT-over-WAL wave;
  [Electric](https://electric.ax/) — "an embedded engine gets 10x more
  valuable with one canonical sync story"; the same team ships
  [PGlite](https://github.com/electric-sql/pglite), so embedded engine and
  sync engine arrive as one product there
- [research/embedded-ecosystems.md](../research/embedded-ecosystems.md) §1
  and §6 — the CRDT, sync-engine, and local-first findings this project rides
