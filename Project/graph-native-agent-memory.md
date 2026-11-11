---
type: Project
name: graph-native-agent-memory
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/Zep]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/mem0]]"
---

# Graph-Native Agent Memory

> A memory that is *only* a graph: episodes, entities, facts as nodes with
> timestamps; temporal queries ("what did we agree on before X?") are one hop,
> not RAG guesswork.

## What

Every serious agent-memory system (mem0, letta, zep, graphiti, cognee) has
converged on the same data model — episodes, entities, and facts as a temporal
knowledge graph — and then bolted it onto a *server*: Neo4j, FalkorDB, or
Postgres. This project makes the memory *be* the graph, embedded in the
agent's process, with no server and no connection string.

The model is bi-temporal, as graphiti/zep established: every fact edge carries
**validity time** (when it was true in the world) and **ingestion time** (when
the agent learned it), and correction means *invalidating* an edge, never
deleting it — so contradictions are queryable edge pairs, and the exact
moment a belief was overturned is a stored fact. Retrieval is a bounded-Cypher
traversal over entity neighborhoods, not a vector guess: "what did we agree on
before the deadline moved?" is a time-windowed one-hop query with a cited
episode behind every fact. This is the "mem0/letta/zep semantics with SQLite
ergonomics" gap the research already identified.

Verified in print: the Zep paper ([arXiv 2501.13956](https://arxiv.org/abs/2501.13956))
formalizes exactly this — episodes, entities, and facts as a temporal knowledge
graph with bi-temporal edges, entity resolution, and non-destructive invalidation.
Mem0 ([arXiv 2504.19413](https://arxiv.org/abs/2504.19413)) describes its extraction
as ADD/UPDATE/DELETE/NOOP operations and reports its graph memory beating
full-context and MemGPT baselines at lower latency; MemGPT
([arXiv 2310.08560](https://arxiv.org/abs/2310.08560)) framed memory as
OS-style storage management the agent edits itself.

## Why RelateDB

RelateDB is the only graph-native engine with embedded, process-local
ergonomics: the agent imports `relate` (Python via the C ABI) or embeds
the Rust crate, and memory is a function call, not a network hop. Its WAL
gives the memory **real transaction-log semantics** — the exact thing a
LangGraph forum thread asks for ("what is the equivalent of a transaction log
for agent systems?"): every mutation is durable, ordered, and replayable, so
ingestion time is physical truth, not a property column. Temporal types make
validity windows first-class queries; `relate query` (or MCP stdio)
exposes the memory directly to a human. `:memory:` gives ephemeral sessions
a scratch memory that leaves no trace.

## What it needs

- The memory schema: Episode/Entity/Fact nodes, bi-temporal edges, entity
  resolution keys; an extraction pass (LLM-driven, mem0/graphiti-style) with
  ADD/UPDATE/INVALIDATE/NOOP operations; contradiction and entity-resolution
  queries as a reusable procedure pack
- A Python library exposing `memory.add_conversation()` /
  `memory.recall(entity, at)`, plus an MCP server surface for cross-agent
  memory sharing
- Eval harness: the comparison genre (aiagentmemory.org, mnemoverse) benchmarks

## Lineage & inspiration

- [zep](https://arxiv.org/html/2501.13956) / [graphiti](https://github.com/getzep/graphiti) —
  the temporal KG memory architecture and its open-source core: bi-temporal
  edges (validity time vs ingestion time), entity resolution, edge
  invalidation — but always against a server backend
- Zep's bespoke engine, Konig — they eventually replaced their commercial
  graph DB with one purpose-built for agent memory ("millions of smaller
  graphs, most cold at any moment") — a closed cloud service;
  `research/konig-zep-graph-db.md` covers what it validates and what is
  stealable
- [mem0](https://github.com/mem0ai/mem0) — extraction-based memory with
  ADD/UPDATE/DELETE/NOOP operations ([paper](https://arxiv.org/html/2504.19413))
- [letta / MemGPT](https://github.com/letta-ai/letta) ([MemGPT: Towards LLMs as Operating Systems](https://arxiv.org/abs/2310.08560)) — editable core memory
  blocks; the OS-hierarchy framing; [cognee](https://github.com/topoteretes/cognee)
  and [mcp-memory-service](https://github.com/doobidoo/mcp-memory-service) —
  memory as infrastructure, and DIY MCP memory
  ([research/agent-native.md](../research/agent-native.md) §1)
- The JEV corpus's memory engines — [Jev-Mem](https://arxiv.org/abs/2609.23986)
  (System-One-controlled memory retrieving across semantic/temporal/causal/
  entity relations over explicitly multi-relational memory — the paper
  anchor), NylonME's mesh memory graph with spreading activation, and
  Zilliz's memsearch (skill distillation from memory) — the field
  converging on multi-relational memory stores without the engine
  (`research/jev-head.md`, `research/jev-longtail.md`)
