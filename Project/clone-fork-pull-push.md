---
type: Project
name: clone-fork-pull-push
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Fly.io]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Turso]]"
MENTIONS_PERSON:
  - "[[Person/Ben Johnson]]"
RELATED_IDEA:
  - kind: complements
    reason: named as the CRDT merge chapter deliberately deferred from v1
    target: "[[Project/team-wiki-from-a-shared-file]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/HTTP]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Turso]]"
  - "[[Technology/litefs]]"
  - "[[Technology/litestream]]"
---

# Clone, Fork, Pull, Push

> `relate clone/pull/push` against other RelateDB instances, Neo4j
> (Bolt), and anything speaking HTTP — the git-shaped graph workflow.

## What

The verbs every developer already knows, applied to graphs. `relate clone
neo4j://prod` materializes a local working copy. `relate push` ships
changes back. `relate fork` branches the store: experiment on the fork,
diff it against the parent, merge or discard. The remote can be another
RelateDB over HTTP, a Neo4j over Bolt, or anything answering Query API v2 —
the operations are protocol-shaped, not source-specific, like git's transports.

Push needs a delta story, and the WAL provides it: a local session's writes
are its log since the clone point, so push is "replay my WAL segment against
the remote" — or, where the remote supports it, ship the Parquet checkpoint
plus deltas wholesale. Conflict policy is explicit and minimal in v1:
last-writer-wins per node, with a `--dry-run` that reports what would collide.
Real merging is deliberately deferred — the Team Wiki / CRDT idea is that
chapter.

The payoff is cultural: "clone my graph and try your query" becomes as casual
as "clone my repo." Datasets, experiments, and curation work start moving as
PRs.

## Why RelateDB

The pieces are unbearably close to shipped: `pull` already speaks the Neo4j
Query API v2 and generates `CREATE` statements into a store, Bolt is already
a transport surface, and HTTP is already served (`relate serve --bolt
--http`). The WAL + Parquet checkpoint is the exact artifact a litefs/litestream
-class replicator ships — log segments for incremental sync, checkpoints for
bulk. And the single-file store makes `clone` a file copy at minimum, before
any delta cleverness.

## What it needs

- `clone`/`fork`/`push` verbs in the CLI (positional-command shape per the
  CLI conventions)
- Remote descriptors: `relate://`, `neo4j://`/`bolt://`, Query API v2
  HTTPS endpoints
- Delta negotiation: WAL-segment replay for push; checkpoint + WAL-delta pull
  for RelateDB remotes (embedded-replica protocol)
- Per-node last-writer-wins conflict policy + `--dry-run` collision report
- Auth: the generated-token basic-auth scheme the network surfaces already
  share
- Diff between fork and parent (`relate diff a.cl b.cl`)

## Lineage & inspiration

- [litefs](https://github.com/superfly/litefs) — embedded DB + log shipping =
  replication; RelateDB's WAL is the same artifact
- [litestream](https://github.com/benbjohnson/litestream) — continuous WAL
  tailing as the backup/replication substrate
- [Turso embedded replicas](https://docs.turso.tech/features/embedded-replicas/introduction)
  — checkpoint + delta sync from origin, the protocol to imitate
- [litetree](https://github.com/aergoio/litetree) — branches for an embedded
  DB; `fork` precedent. And `relate pull` (ADR-0080) — the already-shipped
  half of this workflow
