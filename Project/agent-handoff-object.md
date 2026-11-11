---
type: Project
name: agent-handoff-object
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/AgentOps]]"
  - "[[Company/LangChain]]"
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the other one-file portability mechanic
    target: "[[Project/graph-clipboard]]"
  - kind: complements
    reason: the DAG-store fork/re-run semantics the handoff object reuses
    target: "[[Project/langgraph-style-dag-store]]"
  - kind: complements
    reason: cited as the one-file portability mechanics
    target: "[[Project/single-file-graph-stories]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Agent Handoff Object

> A session's context (conversation + extracted facts + retrieved artifacts)
> serialized as one graph file; resume anywhere, audit anytime.

## What

Agent sessions today end as a transcript — a flat log of turns that throws
away structure. Every expensive piece of work the session did (entity
extraction, retrieved documents, decisions with their reasoning) is buried in
prose. The handoff object keeps it all: a single graph file containing the
conversation as temporal turn nodes, extracted facts and entities with
validity, retrieved artifacts as cited source nodes, tool calls with their
results, and the session's goals as a task DAG.

That one file is then the universal handoff medium. Resume in a different
runtime: the next agent (or a human on Monday) opens the graph and assembles
context by query — "what was decided, what sources back it, what's still
open" — instead of re-reading or re-retrieving. Audit it: every claim traces
to a turn and, through it, to a source node. Fork it: the *LangGraph-Style
DAG Store* semantics apply — re-run the last step against a different model
and diff the graphs. Email it, commit it, attach it to a ticket: it is one
file.

## Why RelateDB

The single `.cl` file — data + schema together, openable by a bare
`relate query` with no server — is precisely the portability a handoff
object needs; the receiving side needs nothing but the binary (or the WASM
build in a browser). The WAL gives the session's own history:
as-asserted-when, not reconstructed-after. Temporal types carry both
conversation time and validity time. `:memory:` on the receiving side lets a
resume experiment run against a throwaway clone before committing anything
back. And `relate serve --mcp stdio` means a host runtime can mount the
handoff object as an MCP resource, making "resume anywhere" protocol-level
instead of product-specific.

## What it needs

- A handoff schema: Turn/Entity/Fact/Source/ToolCall/Goal nodes with temporal
  edges; a version stamp on the file
- A session-recorder sidecar: hooks into an agent runtime (Claude Agent SDK /
  LangGraph) that mirror turns and tool results into a live RelateDB store
- A context-assembly query pack on the resume side (facts-with-provenance,
  open goals, recent decisions); a human inspector — `relate query`
  first, a WASM browser view as the friendly face
- Privacy tooling: a subgraph export/prune so sensitive turns can be redacted
  before a handoff crosses a trust boundary

## Lineage & inspiration

- [LangGraph checkpointers](https://docs.langchain.com/oss/python/langgraph/checkpointers) —
  durable per-thread state; the handoff object is the same idea freed from one
  runtime (see [research/agent-native.md](../research/agent-native.md) §2)
- [AgentOps](https://github.com/AgentOps-AI/agentops) — session recording and
  replay, currently runtime-bound
- [graphiti](https://github.com/getzep/graphiti) episodes + [zep](https://arxiv.org/html/2501.13956) —
  the episode/entity/fact content model that fills the handoff graph
- Claude Code's own transcript/MEMORY.md pattern — flat session artifacts
  with hand-written curation; the "before" picture this idea replaces
- The *Single-File Graph Stories* and *Graph Clipboard* ideas — the
  one-file portability mechanics
