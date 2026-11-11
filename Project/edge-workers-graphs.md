---
type: Project
name: edge-workers-graphs
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Cloudflare]]"
  - "[[Company/Turso]]"
RELATED_IDEA:
  - kind: variant
    reason: the same per-request embedded graph deployed to a different serverless runtime
    target: "[[Project/graph-database-in-a-lambda]]"
  - kind: variant
    reason: pushing the same engine into another constrained runtime target
    target: "[[Project/graph-on-a-microcontroller]]"
USES_TECH:
  - "[[Technology/Cloudflare R2]]"
  - "[[Technology/Cloudflare Workers]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Durable Objects]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/WASM]]"
---

# Edge Workers Graphs

> The WASM build inside Cloudflare Workers (R2/Durable Objects for storage):
> per-user graph APIs at edge latency with zero servers.

## What

Cloudflare Workers already run SQLite as a first-class storage engine inside
Durable Objects — an embedded database shipped *into* the edge runtime, because
that turned out to beat every remote-database design for per-user state. This
project does the same move with the graph: the RelateDB WASM build compiled
into a Worker, graph state held in-object, durable form in R2.

The shape: one Durable Object per user (or per tenant, per session, per game),
each holding a RelateDB store in memory. Reads and writes are local method
calls inside the object — sub-millisecond, no network hop, same-isolate
serializability for free. Checkpoints go to R2 as Parquet objects, WAL segments
append to an R2-backed log, and cold starts replay exactly the checkpoint +
WAL recovery path. Per-user graph APIs — a personal knowledge graph, a
campaign state store, an agent memory — become a Workers route instead of a
provisioned server, and the graph lives in the PoP nearest its user, not in a
region.

The platform numbers this design leans on are verified and current. SQLite in
Durable Objects went GA in April 2025 with up to 10 GB of storage per object —
an embedded database as a first-class runtime service. The Workers memory
budget is 128 MB *per isolate*, and it explicitly covers WebAssembly
allocations as well as the JS heap — that single number is this project's
per-user graph ceiling, stated in the limits doc. And R2 is strongly
consistent, read-after-write included, with conditional writes
(`If-None-Match`) evaluated atomically — so the WAL-tail append and the
checkpoint swap are correct as stated, not best-effort.

## Why RelateDB

The WASM build is already shipped and tested — the browser target compiles the
same engine the CLI runs, so the Worker embed is a packaging exercise, not a
port. The durable form (WAL + Parquet checkpoint) maps one-to-one onto the
Durable-Objects + R2 storage model: objects for the checkpoint and the WAL
tail, transactional storage for the coordination bits. In-memory Cypher inside
the isolate means per-user queries answer in microseconds of CPU, and the
single-writer-per-object discipline is exactly the concurrency model RelateDB
already has. The C ABI's JS wrapper gives the same engine to non-Worker JS
runtimes that can't run WASM-in-Worker.

## What it needs

- A Workers example crate: `relate-wasm` bundled into a Worker, DO-per-user
  routing, request → Cypher dispatch
- Storage adapters: R2 checkpoint writer/reader, WAL-tail object, cold-start
  replay against the DO storage API
- Multi-user fan-out: the DO namespace as the partitioning scheme; a
  cross-user query gateway (query N objects, merge) with its cost stated
  honestly
- The 128 MB-isolate budget: checkpoint size guidance and eviction policy for
  big per-user graphs
- CI: a Workers deploy test (wrangler) as the runnable example

## Lineage & inspiration

- [SQLite in Durable Objects](https://blog.cloudflare.com/sqlite-in-durable-objects/)
  — the precedent: an embedded DB as the runtime's own storage engine at the
  edge; the [SQLite-backed DO storage API](https://developers.cloudflare.com/durable-objects/api/sqlite-storage-api/)
  and its [GA with 10 GB per object](https://developers.cloudflare.com/changelog/post/2025-04-07-sqlite-in-durable-objects-ga/)
  — the shipping platform surface
- [Cloudflare Workers limits](https://developers.cloudflare.com/workers/platform/limits/)
  (128 MB per isolate, WASM included) and [R2's consistency
  model](https://developers.cloudflare.com/r2/reference/consistency/) — the
  verified budget and durability semantics the design rides
- [Turso embedded replicas on edge
  platforms](https://turso.tech/blog/deploy-turso-embedded-replicas-to-fly-akamai-koyeb-railway-render)
  — the reference edge-app deployments this project imitates for graphs
- [PGlite](https://pglite.dev/) — "the real engine, compiled to WASM" as a
  deployable artifact; the same positioning for the graph engine
- [research/embedded-ecosystems.md](../research/embedded-ecosystems.md) §1
  (SQLite-in-DO) and §4 — the edge-runtime and WASM findings this applies
