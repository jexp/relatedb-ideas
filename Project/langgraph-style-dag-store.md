---
type: Project
name: langgraph-style-dag-store
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/LangChain]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: its recorded-outputs schema pins deterministic replay for forks
    target: "[[Project/agent-trace-warehouse]]"
  - kind: complements
    reason: the graph-native sibling of LangGraph Store's bolted-on memory
    target: "[[Project/graph-native-agent-memory]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/Python]]"
  - "[[Technology/Redis]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
---

# LangGraph-Style DAG Store

> Persist agent workflow state and checkpoints in RelateDB; time-travel
> debugging = jump to checkpoint node and re-run.

## What

LangGraph's checkpointers proved the need: agent workflows are DAGs, and
durable execution means persisting a write-once checkpoint per step so any
run can be resumed, replayed, or forked. Today those checkpoints live in
SqliteSaver/PostgresSaver/Redis — tabular stores serializing the graph
structure away, so "which path did this run take?" means decoding blobs.

This project makes the workflow graph native: nodes for each run, each
execution step, each state snapshot (checkpoint), and each edge decision;
state diffs as relationships from one checkpoint to the next. Time-travel
debugging is then literally navigation: jump to checkpoint node C, query its
subgraph, re-run from there into a `:memory:` fork, and diff the resulting
run against the recorded one. Human-in-the-loop interrupts are just
checkpoints with no successor yet: the durable *pause* is a node whose
continuation is written later.

## Why RelateDB

The WAL is the answer to the community's standing question — "what is the
equivalent of a transaction log for agent systems?" — because that is exactly
what RelateDB's write-ahead log already is: durable, ordered, replayable.
Checkpoints are appends; replay is WAL-shaped by nature. Embedding means the
checkpointer is *inside* the agent process (a `BaseCheckpointSaver`
implementation over the Python binding) with no Postgres to run — the
checkpoint layer becomes zero-ops instead of a second database. In-memory
speed makes re-running a branch interactive, and `:memory:` gives the
what-if fork a sandbox that never touches the durable store. For team runs,
`relate serve --bolt` exposes the checkpoint graph to tools that already
speak Bolt.

## What it needs

- A LangGraph `BaseCheckpointSaver` implementation over the Python C-ABI
  binding (the integration point; checkpoint serialization is the main work)
- Checkpoint schema: Run, Step, Checkpoint nodes; `:NEXT`/`:FORKED_FROM`/
  `:INTERRUPTED_AT` edges; state-diff payloads as properties or child nodes
- A time-travel debugger UI: pick a checkpoint, re-run downstream in
  `:memory:`, diff the two runs
- Adapter hooks for other runtimes (CrewAI/AutoGen) — memory/workflow layers
  are pluggable across frameworks, so one store shape can serve them all
- Fork/merge policy work: deterministic replay needs pinned LLM seeds or
  recorded responses (the Agent Trace Warehouse's recorded-outputs schema)

## Lineage & inspiration

- [LangGraph checkpointers](https://docs.langchain.com/oss/python/langgraph/checkpointers) —
  per-thread write-once checkpoint history, time-travel replay; SqliteSaver/
  PostgresSaver are the "before" picture
- [LangGraph forum: "transaction log for agent systems"](https://forum.langchain.com/t/what-is-the-equivalent-of-a-transaction-log-for-agent-systems/3986) —
  users asking for exactly the WAL semantics RelateDB ships
- [LangGraph Store](https://docs.langchain.com/oss/python/integrations/long-term-memory) —
  cross-thread long-term memory, currently a KV store with a vector index
  bolted on; the *Graph-Native Agent Memory* idea is its graph-native sibling
- [Flowise Agentflows](https://docs.flowiseai.com/agentflowv2) — visual agent
  DAGs needing a persistence layer (research/agent-native.md §2)
