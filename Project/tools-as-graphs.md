---
type: Project
name: tools-as-graphs
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Anthropic]]"
  - "[[Company/OpenBMB]]"
RELATED_IDEA:
  - kind: complements
    reason: trace mine that trains the tool graph
    target: "[[Project/agent-trace-warehouse]]"
  - kind: complements
    reason: permission view of the same tool universe
    target: "[[Project/crew-org-chart]]"
  - kind: variant
    reason: same graph representation applied to documents instead of tools
    target: "[[Project/skills-as-graphs]]"
  - kind: complements
    reason: cursor selects data while this selects tools
    target: "[[Project/the-graph-walking-agent-cursor]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Gorilla]]"
  - "[[Technology/JSON Schema]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/ToolBench]]"
---

# Tools as Graphs

> A large MCP toolset is a graph nobody drew: typed data dependencies (one
> tool's output is the next tool's input) plus call-sequence edges mined from
> real agent traces. With tools as nodes, selection, sequencing, parallelism,
> and code-mode composition become queries — not prompt-engineering luck.

## What

Agents meet tool sets as *flat lists*: hundreds of tool descriptions, selected
by semantic similarity between the task text and the description text. But
tools relate to each other in two verifiable ways:

- **Data dependencies** — tool A's output schema feeds tool B's input schema
  (`list_repos` → `Repo[]` → `read_file(Repo)` → `File` → …). The types
  already exist in every MCP tool's JSON Schema; they're just never connected.
- **Usage structure** — real traces show which tools are called in which
  order, which pairs co-occur, which chains recur and which never do. That's
  a learned adjacency, sitting unused in every trace store
  ([Agent Trace Warehouse](agent-trace-warehouse.md) is the mine).

Represent tools as nodes and both relations as edges, and the questions
agents currently answer by guesswork become path queries over the tool
graph:

- **Selection**: "which tools can consume what I have?" is one hop from the
  current value's type — type-reachable candidates instead of
  description-matching a thousand rows
- **Sequencing**: a candidate tool chain is a path; a full plan is a
  subgraph whose topological order *is* the execution order
- **Parallelism**: independent branches of the dependency subgraph are
  independent calls — batch them, the same way coding agents already
  parallelize independent reads
- **Composition for code-mode**: a dependency-complete subgraph compiles to a
  program — the [code-execution-with-MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)
  pattern (the agent writes code that orchestrates tools instead of making
  round-trip tool calls) gets its planning layer: the generated program's
  dataflow *is* the subgraph
- **Efficiency**: hot subgraphs (the recurring chains from traces) are
  precomputable, cacheable, or fuseable into a single combined tool; redundant
  calls across a plan are visible as diamond patterns before execution

## Why RelateDB

Tool selection sits on the hot path of *every* agent loop — an embedded
engine makes the selection query microsecond-cheap instead of another network
hop. The tool graph, the trace history that trains it, and the selection
query run in one process: hybrid search over tool descriptions (recall) +
type/dependency traversal (precision) is exactly the fused-retrieval shape
RelateDB is built for. The tool registry ships as a `.cl` file beside the
MCP server that exposes the tools — the registry, the schema, and the mined
usage stats travel together, versioned by the WAL. And the same graph serves
three consumers at once: the agent (selection queries over MCP), the tool
author (which of my tools never get called? which chain dead-ends?), and
the executor (plan validation before code-mode generation).

## What it needs

- The tool-schema importer: MCP tool definitions → `(:Tool)` nodes with
  typed input/output contract nodes (the JSON Schemas are already there)
- The type-match relation: structural subtyping between output and input
  types (the edge that makes selection one hop) — the hard part; a pragmatic
  v1 is exact/named-type matching with a compatibility-override edge
- Trace mining: loaders from trace stores (LangSmith/Phoenix exports, or the
  trace warehouse's own `.cl`) producing weighted sequence/co-call edges,
  latencies, and failure rates as edge properties
- The selection query pack: type-reachability, plan-subgraph discovery,
  conflict detection, parallel-batch identification
- An eval: graph-guided selection vs. flat description retrieval on a large
  tool corpus (ToolBench-style) — honest numbers before claiming the win

## Lineage & inspiration

- [MCP](https://modelcontextprotocol.io) — the tool ecosystem this indexes:
  every tool already declares the typed schemas that become the graph
- [Code execution with MCP](https://www.anthropic.com/engineering/code-execution-with-mcp)
  (Anthropic) — code-mode: agents writing programs over tools; this project
  is the planning layer that makes the program's dataflow explicit. See also
  [Writing effective tools for AI agents](https://www.anthropic.com/engineering/writing-tools-for-agents)
  — the context-engineering problem (too many flat tool descriptions) this
  project answers structurally
- [ToolBench / ToolLLM](https://github.com/OpenBMB/ToolBench) and
  [Gorilla](https://github.com/ShishirPatil/gorilla) — the tool-selection
  research lineage: large tool corpora, retrieval-based selection; the
  graph is the structural answer to the flat-retrieval question they pose
- LangGraph's typed edges between nodes — the *workflow* view of
  tool orchestration (`research/agent-native.md` §2); this project is the
  *tool* view: the graph of what exists, mined and typed, not the graph of
  one hand-built run
- [Skills as Graphs](skills-as-graphs.md) and the AIP paper's shape — the
  nearest neighbor in this repo; the difference: skills-as-graphs represents
  *documents* for agents to query, this represents *tools and their
  dependencies* for agents to select and compose
- [Agent Trace Warehouse](agent-trace-warehouse.md) — the mining source;
  [Crew Org Chart](crew-org-chart.md) — the permission view of the same
  tool universe
