---
type: Project
name: agent-trace-warehouse
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Arize AI]]"
  - "[[Company/LangChain]]"
RELATED_IDEA:
  - kind: complements
    reason: named as the cheap first run-DAG viewer
    target: "[[Project/mermaid-as-a-query-result]]"
USES_TECH:
  - "[[Technology/AgentOps]]"
  - "[[Technology/Arize Phoenix]]"
  - "[[Technology/Arrow]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/LangSmith]]"
  - "[[Technology/OpenInference]]"
  - "[[Technology/OpenTelemetry]]"
  - "[[Technology/RelateDB]]"
---

# Agent Trace Warehouse

> Spans, tool calls, prompts and costs as a temporal graph; "which retrieval
> step poisoned this answer?" is a path along the run.

## What

LangSmith, Phoenix, and AgentOps all store the same thing — a trace tree per
agent invocation (LLM spans, tool calls, retrievals, prompts, token counts)
— in tabular databases, then fight the tree back out of rows. This project
makes the trace's native shape the storage shape: every run is a DAG of span
nodes with edges carrying inputs, outputs, latency, and cost; retrieval spans
keep `:RETRIEVED_FROM` edges to the source artifacts; each child span cites
the prompt that produced it.

Then trace *analysis* becomes graph analytics: "which retrieval step poisoned
this answer?" is the path from the bad output back along the run to the
retrieved artifact; agent loops are cycle queries; hallucination forensics is
"which claims in this answer have no `:SUPPORTED_BY` path to a source"; cost
attribution is a sum over the subtree. Because traces are temporal
(WAL-appended, timestamped), whole-fleet questions work too: which tool's
outputs correlate with retry loops this week is a window query, not a
dashboard rebuild.

## Why RelateDB

Traces are write-heavy, query-rare data with natural graph shape — the
perfect embedded-store fit: a `relate` dependency in the agent runtime
rather than a Phoenix deployment, with WAL appends doing the ingestion. In-
memory scans make "follow the path from this span to its evidence"
interactive, even over thousands of runs in one store. A team's trace store
is one `.cl` file (or a served instance via `relate serve --http` for a
dashboard). The WASM build even allows *shipping a trace*: attach the single
subgraph of one bad run and let the recipient scrub it in a browser tab, and
cost/latency numbers land as edge properties, so Cypher's aggregation does
the fleet reporting.

## What it needs

- Span ingestion: an OpenTelemetry/OpenInference-compatible collector that
  writes spans and edges to the WAL (Phoenix's semantic conventions as the
  schema); prompts as nodes with `:PRODUCED` edges and completions with
  token/cost properties
- Query packs: path-to-evidence, loop detection (cycles over tool nodes),
  unsupported-claim forensics, cost subtree sums
- A viewer: run DAG rendered from Cypher results (the *Mermaid as a Query
  Result* idea is the cheap first version), or a small web UI over
  `serve --http`; OTLP JSON / dataframe / Arrow export for existing tooling

## Lineage & inspiration

- [Arize Phoenix](https://github.com/Arize-ai/phoenix) — open-source LLM
  tracing on OpenTelemetry/OpenInference: spans with LLM/RETRIEVER/TOOL
  attributes, trace datasets as dataframes
- [LangSmith](https://smith.langchain.com) — trace trees (run → child LLM/
  tool/retriever runs) in Postgres; the data model is a DAG per invocation
- [AgentOps](https://github.com/AgentOps-AI/agentops) — session recording and
  replays; [agents_otel_data](https://github.com/davila7/agents_otel_data) —
  OTEL telemetry as a knowledge graph: agents already studied *as graphs*
  (research/agent-native.md §2)
