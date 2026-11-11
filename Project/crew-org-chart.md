---
type: Project
name: crew-org-chart
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/CrewAI]]"
RELATED_IDEA:
  - kind: complements
    reason: budget accounting can be derived from the warehouse's agent spans
    target: "[[Project/agent-trace-warehouse]]"
USES_TECH:
  - "[[Technology/AutoGen]]"
  - "[[Technology/CrewAI]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/YAML]]"
---

# Crew Org Chart

> Multi-agent teams as graphs of roles, tools and permissions; "who may call
> what with which budget" is a policy query, not a config file.

## What

Multi-agent frameworks (CrewAI, AutoGen, LangGraph supervisors) configure
their teams as YAML/Python: roles, allowed tools, model choices, budgets —
a config file that answers "who exists" but not the interesting questions.
Model the crew as a graph instead: Role, Tool, Model, and Data nodes; edges
for `:MAY_USE_TOOL`, `:REPORTS_TO`, `:MAY_READ_DATA`, `:SUPERVISES`, each
carrying constraints (budget, rate limits, time windows) as properties.

Now governance is queries, not config: "which roles can reach the payment
tool?" is a traversal through supervision chains; "who can read customer
data" is a policy query; "which agents share an over-budget tool" joins
usage edges to budget edges. The same graph is documentation, enforcement
source, and audit target: a runtime policy check is `MATCH` before dispatch,
and every actual call is an edge appended to the WAL — so after a run,
*granted* policy vs. *exercised* policy is a diff query. That last one is
the killer feature: drift between what the org chart permits and what the
crew actually did, visible.

## Why RelateDB

The policy engine is just Cypher — permission traversal is exactly the
reachability shape graph queries exist for, evaluated at in-memory speed so
a pre-dispatch check costs effectively nothing. Embedded in the crew
orchestrator process, the org chart is the runtime's own component, not an
external OPA server. WAL history makes every grant and every actual call
durable and ordered — the audit trail *is* the write-ahead log. A `:memory:`
clone of the org chart serves each crew as its private view, and the C ABI /
Python binding plus MCP stdio make the policy store reachable from any
framework without rewiring them.

## What it needs

- A crew schema: Role/Tool/Model/Data nodes; MAY_USE/REPORTS_TO/SUPERVISES/
  MAY_READ edges with budget and constraint properties
- Framework adapters: translate CrewAI/AutoGen/LangGraph team configs into
  the graph on load (CrewAI's config-to-graph mapping is the first target)
- A policy-check hook: MATCH-before-dispatch enforcement in at least one
  runtime
- Call-logging edges appended to the WAL during runs; granted-vs-exercised
  diff queries as the report; budget accounting as edge properties updated
  per call (or derived from the Agent Trace Warehouse's spans)

## Lineage & inspiration

- [CrewAI](https://github.com/crewAIInc/crewAI) / AutoGen / LangGraph
  supervisors — the team-config world this replaces with queries; memory and
  roles are pluggable backends across all of them
  ([mem0's framework memory layers](https://mem0.ai/blog/memory-layer-for-open-source-agent-frameworks)
  prove a drop-in layer can serve every framework)
- [duckdb-mcp](https://duckdb-mcp.readthedocs.io/en/latest/guides/security/),
  [QueryBear](https://github.com/spencerpauly/awesome-mcp-databases) and
  [mcp-sql-guard](https://github.com/tahasiddiquii/mcp-sql-guard) — access
  modes, allowlists, and validation in front of agent DB access
  ([research/agent-native.md](../research/agent-native.md) §3): the same
  policy discipline, lifted from databases to agent teams — the policy
  semantics of RelateDB's own agent-safety feature line
