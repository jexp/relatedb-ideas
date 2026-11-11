---
type: Research
name: konig-zep-graph-db
INFORMS:
  - "[[Project/a-million-tiny-graphs]]"
  - "[[Project/decision-journal]]"
  - "[[Project/ephemeral-agent-sandboxes]]"
  - "[[Project/graph-native-agent-memory]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: per-subject graph as the unit of storage access and retention
    target: "[[Project/a-million-tiny-graphs]]"
  - kind: complements
    reason: point-in-time reconstruction of what the agent believed belongs in a decision journal
    target: "[[Project/decision-journal]]"
  - kind: complements
    reason: millions of small cold per-session graphs is the inverse-workload argument
    target: "[[Project/ephemeral-agent-sandboxes]]"
  - kind: complements
    reason: bi-temporal edges and invalidation are the data-model primitive this idea needs
    target: "[[Project/graph-native-agent-memory]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/Konig]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/gRPC]]"
---

# Research findings: Zep's Konig — the bespoke graph DB for agent memory

*Collected 2026-10-23 as inspiration research for the relate-ideas list and
for engine-level ideas worth considering for RelateDB.
Sources: [Why we built a graph database service for agent memory](https://www.getzep.com/blog/why-we-built-a-graph-database-service-for-agent-memory/)
and the [Agent Knowledge Graph platform page](https://www.getzep.com/platform/agent-knowledge-graph/).
The post never names the incumbent engine and never states the implementation
language (Rust is widely reported in community discussion, not claimed in the
post — treat it as unverified).*

## 1. What happened: they replaced a commercial graph DB

Zep ran its agent-memory Graphiti pipeline on an existing commercial graph
database until scale broke it — structurally, not by capacity:

- "The database failed under load, and adding hardware stopped helping because
  the failures were structural."
- "It was slow under our access patterns in ways we could not tune away."
- It "could not express what our customers required: many graphs, per-graph
  isolation, customer-held encryption keys."
- General-purpose engines "assume one large graph: mostly resident in memory,
  traversed by complex queries, against a schema fixed in advance." Their
  framing of the agent-memory workload is the inverse: **"millions of smaller
  graphs, most cold at any moment, each temporal and governed independently."**
- Even clustered, the old database kept the full dataset on every node and
  could not shard the workload — "scaling meant larger machines."

Their own verdict: "The database was good technology built for a different
problem" — and the slow-graph reputation is a fit problem, "not the graph
model itself."

## 2. Konig's design (what the post states)

- **The graph is the unit of everything**: each subject (user, project, team)
  gets its own graph — "the unit of storage, access, encryption, and
  retention." A query touches exactly one graph, so "its latency does not
  depend on the total number of graphs."
- **Adjacency lists as source of truth**: integer-indexed arrays of nodes,
  each with its edge list, taking every write. **CSR matrices built on
  demand** ("in tens of milliseconds or less") for bulk linear-algebra work
  (PageRank and friends), then discarded "after a period of disuse."
- **Tiering**: hot = RAM (microsecond reads); warm = local ephemeral NVMe plus
  object-storage snapshots; cold = object-store snapshot only. Promotion is
  lazy — "no background process warms graphs that are not in use."
- **Durability**: mutations append to a replicated, ordered write-ahead log and
  ack only once durable; per-graph monotonic sequence numbers; write-through
  in-memory updates. Snapshots "collapse tombstones and compress the result,
  with a checksum." Eventually consistent, idempotency instead of exactly-once.
- **Bi-temporality as the data model**: "Every edge, on which a fact is
  materialized, has four timestamps" — two for when the relationship held in
  the world, two for when the system recorded/learned it.
- **Invalidation, not deletion**: "Konig marks the old fact invalid using an
  `invalid_at` date instead of overwriting it, so history is preserved" — for
  audit and for reconstructing what an agent believed in the past.
- **Hybrid search inside the snapshot**: per-graph BM25 and vector indexes
  stored "as companion structures inside its snapshot." Exact kNN with
  AVX-512 SIMD kernels (fp32/bf16/int8) by default; IVF partitioned **by
  scope** for large graphs "so filters cost nothing in recall," maintained
  incrementally with SPFresh/LIRE (background cell splits/merges, no rebuild
  pause).
- **Fusion retrieval**: seeds from lexical, semantic, and pattern signals feed
  BFS and Personalized PageRank, merged via **reciprocal rank fusion**, plus
  optional diversity or LLM reranking. "One query, one ranked answer."
- **No query language**: the API is gRPC-only — "mutate, search, traverse, and
  a small set of lookups." Deliberately "no general-purpose query language
  such as Cypher," hence "no grammar to parse and no query optimizer." Their
  stated lesson: a narrow scope "is far smaller to build and maintain."
- **Governance at the data layer**: ABAC "evaluated at retrieval time on every
  node and edge," per-graph isolation, envelope-encrypted CMEK/BYOK, retention
  schedules, legal hold, deletion as "a tombstone followed by a permanent
  expunge."

## 3. Their numbers

- p95 retrieval < 100 ms; end-to-end Zep latency < 200 ms; p50 unchanged from
  a thousand to tens of millions of graphs.
- Thousands of mutations and queries per second sustained.
- Cold load "low hundreds of milliseconds"; warm reload in low milliseconds.
- Exact vector search "low single-digit milliseconds on most graphs"; PageRank
  "low milliseconds."
- IVF: recall ~0.95 "while scanning a few percent of the corpus," costing "a
  few megabytes per graph."
- Rejected DiskANN: it "duplicated vector data many times over" (order of
  magnitude growth, index builds of "tens of minutes to hours per graph").

## 4. What RelateDB can steal

**Data-model patterns (modeling guidance and idea-file content, not engine
work):**

- **Bi-temporal edges + `invalid_at` overwrites** — already the stated feature
  set of [Graph-Native Agent Memory](../projects/graph-native-agent-memory.md);
  Konig proves it as a *data-model primitive* a production system built its
  whole semantics on. Worth promoting to a cookbook recipe: the four-timestamp
  edge pattern with point-in-time and "what did the agent believe then" queries.
- **Point-in-time reconstruction of agent beliefs** — history preserved so
  "what did the agent know at time T" is a query. Belongs in the memory and
  decision-journal idea files as a first-class query pattern.

**Engine techniques (candidates for Linear tickets / ADR thought, not decided
here):**

- **CSR-on-demand for bulk algorithms** — adjacency lists as source of truth,
  packed CSR built in tens of ms when an algorithm workload needs it, dropped
  after disuse. Maps onto RelateDB's flat vector-search philosophy: pay
  the layout cost only when the workload is columnar/linear-algebra shaped.
- **Exact-first vector search, partitioned only when large** — their tiering
  (exact SIMD kNN for most graphs, scope-partitioned IVF only for big ones,
  "filters cost nothing in recall") independently converges with the
  flat-first approach; their IVF-by-scope detail is a useful
  reference if partitioning is ever added.
- **Tombstone compaction at snapshot time** — checkpoints that "collapse
  tombstones and compress, with a checksum" maps directly onto RelateDB's
  Parquet checkpoint step: compaction as a checkpoint-time concern, not a
  background job.
- **Reciprocal rank fusion over heterogeneous seeds** — RRF as the merge
  primitive when hybrid search gains traversal-seeded retrieval. Cheap,
  rank-based, no score calibration needed across BM25/vector/traversal.

**Positioning (the strategic steal):**

- **Konig validates the workload, not the deployment.** They proved agent
  memory needs a purpose-built graph engine — but their answer is a closed,
  multi-tenant cloud service with CMEK/ABAC/legal-hold governance. The gap
  left open is the **embedded, single-process, open version**: same data
  model (bi-temporal, invalidation-not-deletion), same retrieval idea
  (vector+lexical+traversal fused), none of the fleet. "The open Konig for
  your own process" is a strong sharpening of the
  [Graph-Native Agent Memory](../projects/graph-native-agent-memory.md) pitch.
- **Their inverse-workload quote is the million-tiny-graphs argument, from a
  production system**: "millions of smaller graphs, most cold at any moment,
  each temporal and governed independently" — quote-worthy support for
  [Ephemeral Agent Sandboxes](../projects/ephemeral-agent-sandboxes.md) and
  the repo's graph-per-session entries. In the embedded world, one `.cl`
  file per agent/session is exactly their per-graph unit — without needing
  their sharding.
- **What their no-Cypher choice buys, and what it costs**: dropping the query
  language shrinks the surface enormously ("no grammar to parse and no query
  optimizer") — but it also means their customers get four verbs instead of a
  language. RelateDB's bet is the opposite: the TCK-pinned Cypher dialect
  is the asset (agents already learned it; humans inspect with it). The
  honest lesson is not "drop Cypher"; it is that a fixed, narrow retrieval
  contract (search/traverse/pattern) is what agent-memory clients actually
  call — worth exposing as *procedures* (`db.memory.search(...)`-shaped)
  over the language, which RelateDB can do without giving anything up.

**What does not transfer (be honest):**

- Rendezvous-hash sharding, replicated WAL, leader-elected reconcilers,
  multi-tenant ABAC/CMEK/legal-hold — cloud-fleet machinery; an embedded
  engine's answers are "open the file" and "the OS account is the tenant."
- Global ordering and cross-graph traversal are things Konig explicitly gave
  up; RelateDB doesn't have them either in the per-file model — but an
  embedded engine can cheat (open two files in one process) where they plan
  "a separate, non-real-time workload."

## 5. Sources

- [Why we built a graph database service for agent memory](https://www.getzep.com/blog/why-we-built-a-graph-database-service-for-agent-memory/) — the design post
- [Zep Agent Knowledge Graph (Konig platform page)](https://www.getzep.com/platform/agent-knowledge-graph/) — the feature/API surface
- [Graphiti](https://github.com/getzep/graphiti) — the open-source pipeline that runs above such a store (also in `research/agent-native.md`)
