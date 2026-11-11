---
type: Project
name: ephemeral-agent-sandboxes
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Anthropic]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Letta]]"
RELATED_IDEA:
  - kind: complements
    reason: per-subagent isolation matches the agent-org structure it models
    target: "[[Project/crew-org-chart]]"
  - kind: complements
    reason: shares the promote-from-ephemeral mechanics
    target: "[[Project/event-stream-to-temporal-graph]]"
  - kind: complements
    reason: the promote and clone mechanics between scratch and durable stores
    target: "[[Project/graph-clipboard]]"
USES_TECH:
  - "[[Technology/CrewAI]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
---

# Ephemeral Agent Sandboxes

> `:memory:` RelateDB as the scratch DB inside each agent execution;
> zero-provision, zero-cleanup, queries at memory speed.

## What

Agents constantly need a scratch database — somewhere to park intermediate
results, join tool outputs, deduplicate entities mid-task, or test a query
before running it against the durable store — and today they improvise:
in-memory lists, JSON files, or a stray SQLite nobody cleans up. This idea
makes the scratch store a first-class convention: every agent execution (or
subagent, or tool session) opens its own `:memory:` RelateDB instance, and
dies with the process.

Because the scratch store speaks the *same* Cypher as the durable one, there
is no impedance step: intermediate tool outputs get `CREATE`d as nodes and
edges, then the agent reasons over them with the identical queries it would
use against real data — deduplication as MERGE, joining search results to
retrieved facts as edges, ranking as Cypher aggregation. If a sandbox's
contents turn out to be worth keeping, one command clones them into a
durable store; otherwise the process exit *is* the cleanup.

## Why RelateDB

`:memory:` ephemeral stores are a native RelateDB mode — no temp file, no
daemon, no setup call beyond open. Zero-provision and zero-cleanup are
exactly the properties an agent runtime wants from a per-execution resource.
In-memory scans mean intermediate-result queries cost microseconds, so
agents can afford to be structured rather than stringly (searching a list
becomes a MATCH). One binary, one language across scratch and durable stores
kills the "two mental models" problem. And because the sandbox runs through
the same C ABI / Python binding / MCP surface, a host runtime can hand each
sandboxed subagent its own instance for hard isolation: one agent's scratch
state is structurally invisible to another's.

## What it needs

- A runtime convention/library: `with relate.open(":memory:") as scratch:`
  helpers for common scratch patterns (entity dedup, result joining,
  plan-as-graph), plus tool-output→graph adapters so payloads land as nodes
  without hand-written CREATE spam
- A promote-to-durable operation: clone the sandbox (or a subgraph of it)
  into a file-backed store on demand
- Sandbox-per-subagent wiring in at least one framework (Claude Agent SDK /
  LangGraph / CrewAI) as the reference
- Docs/recipes: the cookbook's `cypher cell` format is the ready-made test
  harness for these patterns

## Lineage & inspiration

- [MCP server-sqlite](https://github.com/modelcontextprotocol/servers) — the
  official SQLite MCP server ships a built-in in-memory scratch DB *for a
  reason*: experimentation without side effects is an established pattern
  (see [research/agent-native.md](../research/agent-native.md) §3)
- [Kuzu + dspy demo](https://github.com/adsharma/kuzu-demo-dspy) — an
  embedded graph used as agent scratchpad/memory
- [letta / MemGPT](https://github.com/letta-ai/letta) — the OS framing
  (process-scoped memory tiers) that a per-execution scratch store completes
- The *Event Stream to Temporal Graph* and *Graph Clipboard* ideas — the
  promote/clone mechanics this idea reuses
