---
type: Project
name: graph-database-in-a-lambda
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Fly.io]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Turso]]"
USES_TECH:
  - "[[Technology/Amazon S3]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Turso]]"
  - "[[Technology/litestream]]"
---

# Graph Database in a Lambda

> Fully serverless RelateDB: the Rust crate in a Lambda handler, WAL on ephemeral
> local storage, Parquet checkpoints + WAL tail in S3 (the Turso-embedded-replicas /
> litestream architecture); cold start pulls the checkpoint and replays — which is
> already RelateDB's recovery path.

## What

Serverless functions are the cheapest hosting there is — and the worst fit for a
database: no process lives between invocations, no disk survives an instance,
and every request pays a cold start. This project makes that fit anyway. The
`relate` Rust crate is compiled into the Lambda handler; on cold start the
handler pulls the latest Parquet checkpoint plus the WAL tail from S3 into
ephemeral local storage and opens the database exactly the way RelateDB always
recovers: load checkpoint, replay WAL. Then the function serves Cypher at local
in-memory speed until the platform reaps it.

Writes fsync to the ephemeral WAL as they happen (correct within the instance),
and a tailing task streams new WAL segments to S3 — the litestream move — with a
Parquet checkpoint pushed whenever the tail grows past a threshold. Warm
invocations cost nothing: the graph is already resident and queries run at scan
speed. The result is a graph database with a per-invocation price — pay only
when someone actually queries, no server to keep alive, no VPC — and a
durability story that is just "checkpoint + WAL in a bucket," inspectable by
any tool that reads Parquet.

The named precedents are documentation, not folklore. litestream is a single
static binary that continuously streams SQLite's WAL pages to S3-compatible
object storage and restores a database by replaying them — its architecture
doc describes exactly the checkpoint-plus-tail loop this project copies for
RelateDB's own artifacts. And Turso's Lambda write-up is the measured proof
of the economics: warm invocations read from a local embedded file in
microseconds, and only the cold start pays the download — per-invocation
pricing works because the graph is resident in the warm instance.

## Why RelateDB

The recovery path already is the architecture. RelateDB's durable form is an
fsync'd WAL plus local Parquet checkpoints — the exact artifacts a litestream
tailer ships and an S3 cold start needs; no new storage engine, just new
coordinates for files it already produces. The Rust crate embeds as a library
(the public `relate::Database` API), so the handler links it directly with
no protocol hop, and the in-memory engine answers queries in microseconds on a
warm instance — the same argument Turso made for embedded SQLite on Lambda.
Single-writer semantics map cleanly onto Lambda's one-instance-per-function
concurrency model.

## What it needs

- A `lambda` example crate: handler wiring, S3 checkpoint/WAL pull on cold
  start, checkpoint compaction policy, WAL-tail streamer (litestream-style)
- Concurrency stance: single-writer via reserved concurrency, or a fleet of
  read-only embedded replicas against one writer
- Cold-start budget: checkpoint size guidance, snapshot caching to keep the
  p100 under the platform's patience
- The serverless/embedded-replicas investigation is tracked in the
  RelateDB backlog

## Lineage & inspiration

- [Turso embedded replicas on Lambda](https://turso.tech/blog/get-microsecond-read-latency-on-aws-lambda-with-local-databases-479db00a)
  and the [embedded-replicas docs](https://docs.turso.tech/features/embedded-replicas/introduction)
  — the proof this architecture gives microsecond reads in serverless
- [litestream](https://litestream.io/) ([source](https://github.com/benbjohnson/litestream),
  [architecture](https://github.com/benbjohnson/litestream/blob/main/docs/ARCHITECTURE.md))
  — continuous WAL streaming to S3; the durability template
- [rqlite](https://github.com/rqlite/rqlite) and [litefs](https://github.com/superfly/litefs)
  — the distributed shells over an embedded engine, if the fleet grows;
  [research/embedded-ecosystems.md](../research/embedded-ecosystems.md) §3
  and the cross-cutting patterns — the findings this project applies
