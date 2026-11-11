---
type: Project
name: read-replica-in-your-pocket
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Fly.io]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Turso]]"
RELATED_IDEA:
  - kind: complements
    reason: same local-first replica and push-back sync pattern
    target: "[[Project/the-pouchdb-move]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Turso]]"
  - "[[Technology/litefs]]"
---

# Read Replica in Your Pocket

> Pull a slice of the big Neo4j to your laptop, query it on the plane, push
> back the curation results.

## What

The enterprise graph is on Neo4j/Aura; the interesting questions come to you
on a train. This project is the disciplined slice: a standing configuration
that pulls *a bounded subset* of production — the subgraph for one customer,
one product line, one investigation — into a local `.cl` store, kept fresh
when you're online, fully usable when you're not. The laptop becomes a read
replica of exactly the data you care about, and the plane, the field site,
and the air-gapped room all get the same experience as the office.

The pull is parameterized, not wholesale: `relate replica configure
neo4j://prod --match "MATCH (c:Customer {id:$id})-[:*..2]-(x) RETURN c, x"`.
The slice definition is versioned with the store, so refresh re-runs it —
incrementally, over the WAL, when the remote allows, or wholesale when it
doesn't. Local writes live in a separate, marked layer (a curation delta) so
you query the pulled data *and* your annotations together, without ever
pretending you synced the enterprise.

Then push-back: the curation delta — nodes you added, edges you drew,
properties you corrected — replays against production once you're back on
the network, with a dry-run diff first. The analyst's whole loop in one
file's life: take the data, think offline, return the conclusions as data.

## Why RelateDB

`relate pull` already speaks the Neo4j/Aura Query API v2 and generates
`CREATE` into a local store — the hard integration is shipped. The WAL is
the natural representation of both halves of the story: the refresh deltas
(log segments since the last pull) and the curation layer (your writes since
the last push). The in-memory engine means the local replica queries at full
speed with zero server contact, and the single-file store means the whole
replica — data, slice definition, delta — is one portable artifact. Embedded
replicas (Turso) proved this exact architecture is the killer feature of an
embedded engine: local-speed reads, cloud durability.

The Turso story is documented and matches this project clause for clause: an
embedded replica is a local database file synced from a primary, kept fresh
while online, fully queryable while offline — and their Lambda write-up
measures exactly the local-read economics this project needs on the laptop.
The production precedent is Flipt's edge experiment (October 2023): the
feature-flag service ran locally against a Turso primary with replicas in
IAD, DFW and LHR, and measured the latency win of reading from the nearest
replica — with embedded replicas flagged as the next step. This project keeps
the shape and sharpens the slice: the replica is a *parameterized subgraph*,
not the whole database.

## What it needs

- `relate replica configure/pull/push/status` verbs; the slice
  definition stored in the store's metadata
- Slice language: parameterized Cypher defining the bounded subset + preview count
- Refresh modes: incremental (Query API v2 deltas) or wholesale re-pull + swap
- The curation-delta layer: local writes tracked separately, viewable and
  exportable (`relate replica diff`)
- Push-back: delta replay against the remote with `--dry-run` first
  (auth via the generated-token scheme; read-only creds for pull profiles)

## Lineage & inspiration

- [Turso embedded replicas](https://docs.turso.tech/features/embedded-replicas/introduction)
  and [microsecond reads on AWS
  Lambda](https://turso.tech/blog/get-microsecond-read-latency-on-aws-lambda-with-local-databases-479db00a)
  — the signature architecture: local replica, microsecond reads, offline
  capability, cloud origin
- [litefs](https://github.com/superfly/litefs) — embedded DB + log shipping
  = the replica substrate. And [Flipt](https://blog.flipt.io/experimenting-on-the-edge)
  — a flagship app whose whole design is "origin syncs to an embedded DB"
- `relate pull` (ADR-0080) — the shipped half: Query API v2 → local store
