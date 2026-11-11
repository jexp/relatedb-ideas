---
type: Project
name: query-plan-lab
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Arize AI]]"
  - "[[Company/LangChain]]"
RELATED_IDEA:
  - kind: complements
    reason: renders the plan-tree diffs the lab produces
    target: "[[Project/diff-view-for-graphs]]"
  - kind: complements
    reason: the meta-graph engine this incident-correlation mission builds on
    target: "[[Project/query-plans-as-graphs]]"
USES_TECH:
  - "[[Technology/Arize Phoenix]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/LangSmith]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/RelateDB]]"
---

# Query-Plan Lab

> Collect `EXPLAIN` trees from every tool in your org into one graph; find the plan patterns that correlate with incidents.

## What

Every query engine prints an `EXPLAIN`/`PROFILE` tree; every DBA reads them one
at a time, in a tab, during an incident. Nobody aggregates them. This project
does: every tool in the org — Postgres `EXPLAIN (FORMAT JSON)`, Neo4j `PROFILE`,
DuckDB, the internal query engine — ships its plan trees into one meta-graph.
Each plan is a tree of operator nodes with typed edges (`OPERATOR`, `INPUT`),
wrapped in a `(:Query {sql, source_repo, app, timestamp})` and linked to the
`(:Incident)` records and `(:Service)` that issued it.

Now plan mining is a graph discipline: "which queries produce a Cartesian
product feeding a sort?" is one pattern. "Which production queries have plans
that changed shape in the last month?" — plan-tree diff. "Which services run
the anti-pattern that correlated with the last three pagers?" — join plan
pattern to incident graph, instead of a war-room someone's memory.

The endgame: the plans themselves searchable like code, org-wide.

## Why RelateDB

Plans are trees with recurring operator vocabularies — a textbook graph
ingest, and in-memory Cypher makes anti-pattern matching (scan feeding sort
feeding join, sub-tree isomorphism approximations) an interactive query over
millions of plan nodes rather than an offline batch. JSON `EXPLAIN` output
from every major engine maps directly to nodes/edges; the CLI's JSON/JSONL
output handles bulk export of the mined results. The single binary + `.cl`
file means the lab runs on a laptop or in CI collecting plans per deploy, and
WAL durability means the plan history is append-only by construction — a
regression in plan shape between deploys is a graph diff of consecutive WAL
windows. Serving the lab to a team is `relate serve --http` (gzip +
chunked streaming for the big results), and the MCP surface hands the plan
graph to agents doing incident triage: "find the queries behind this pager."

## What it needs

- Adapters per engine: Postgres/Neo4j/DuckDB/etc. JSON plan → operator nodes
  with a shared operator vocabulary (normalization is the real work —
  `Seq Scan` vs `AllNodesScan` need a common taxonomy)
- Plan-shape canonicalization (hash of the operator tree modulo literal
  values) so "same shape" is comparable across queries and time
- Collector hooks: CI job, slow-query log tailers, incident integrations
- Plan-tree diff view (pairs with the Diff View for Graphs rendering idea)
- The query pack: anti-pattern patterns, plan-shape-change detectors,
  incident-correlation joins

## Lineage & inspiration

The sibling idea in this list is **Query Plans as Graphs** (the Meta section) —
every `EXPLAIN` tree collected into one meta-graph, mined and diffed; this file
gives that seedling its incident-correlation mission. From
[research/agent-native.md](../research/agent-native.md) §2: [LangSmith](https://smith.langchain.com)
and [Arize Phoenix](https://github.com/Arize-ai/phoenix) prove the shape —
trace trees stored awkwardly in Postgres, queried by filter, when the data
model is literally a DAG per invocation; plans are that same story for query
engines.
