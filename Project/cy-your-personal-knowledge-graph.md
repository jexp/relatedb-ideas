---
type: Project
name: cy-your-personal-knowledge-graph
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Amazon]]"
  - "[[Company/Asana]]"
  - "[[Company/Clay]]"
  - "[[Company/Obsidian]]"
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: the agent memory layer over the same personal work graph
    target: "[[Project/graph-native-agent-memory]]"
  - kind: complements
    reason: Obsidian notes as one local queryable graph surface
    target: "[[Project/obsidian-vfs-native]]"
  - kind: same-data
    reason: workspace documents and messages as one shared graph artifact
    target: "[[Project/team-wiki-from-a-shared-file]]"
USES_TECH:
  - "[[Technology/CalDAV]]"
  - "[[Technology/Confluence]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Google Workspace]]"
  - "[[Technology/IMAP]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Slack]]"
---

# Cy — Your Personal Knowledge Graph

> The Amazon-Quick-style clone: pull your Google/MS Workspace, Slack/Teams, Confluence, email and calendar into one knowledge graph that serves *you and your agents* — knowledge work and white-collar tasks over your own data, queried in Cypher, surfaced to agents over MCP, private by default.

## What

Your work life is already a graph — you just can't query it. The decision lives in
a Slack thread, the context in a Confluence page, the deadline in your calendar,
the follow-up in an email. Cy is a local agent that pulls all of it into one
property graph: `(:Person)-[:MENTIONED_IN]->(:Message)`, `(:Page)-[:LINKS_TO]->(:Page)`,
`(:Event)-[:ATTENDED_BY]->(:Person)`, with timestamps on every edge.

A session looks like this: "Who did I promise the Q3 numbers to, and which doc was
that based on?" — one Cypher hop from the message to the thread to the page to the
person, then the agent drafts the follow-up. Or "what did we decide about the
migration, and what changed since?" — a temporal query over the decision's
neighborhood.

The twist is that the graph serves *two* clients at once: you (a small local UI or
`relate query` at the terminal) and your agents (the same store over MCP). The
agent doesn't get a RAG slice of your email; it gets the actual graph and traverses
it — multi-hop questions become plain Cypher.

The concept now has named public proof points. AWS announced Amazon Quick
(October 2026) as "an AI assistant built for work" that consolidates AI,
agents, research, analytics, automation and workflow into one product pulling
from connected applications — the enterprise, tenant-of-someone-else's-assistant
version of this brief. On the personal side, Clay proved people pay for a
relationship graph over their own contacts (its AI helper answers "when did I
last speak to..."), Asana has spent a decade marketing "the work graph" as a
concept, and Patchwork ships the agents-as-teammates workspace — a
self-hostable relay binary with an embedded database and one-directory backup.
Cy is the local, private, queryable version of all three: the workspace graph
as a single file you own, not a row in a vendor's store.

## Why RelateDB

This is the flagship embedded-personal-KG story. The store is a single `.cl` file
plus WAL — your entire work memory is one portable, back-uppable artifact, not a
Postgres server you babysit. `relate serve --mcp stdio` hands the graph to any
MCP-speaking agent with zero setup, and the built-in MCP surface means agents that
learned Neo4j's MCP query RelateDB unmodified. Hybrid search (vector + fulltext,
CIP-278 `COMBINE`) covers the recall half — "find that message about the numbers" —
while Cypher handles the reasoning half. Bi-temporal facts (validity vs ingestion
time) map to RelateDB's native temporal types, so "what did we believe then" is a
time-window query, not a snapshot circus. Python bindings over the C ABI make the
ingest side (Google API, Slack export, IMAP, CalDAV) a scriptable pipeline, and
WAL + Parquet checkpoints keep it durable without an ops footprint.

## What it needs

- Connectors: Google/MS Workspace (Docs/Drive/Sheets, calendar), Slack/Teams
  export, Confluence, IMAP email — each a loader that maps to a shared ontology
- Entity resolution across sources (the "Michael" in Slack vs the attendee vs the
  contact) — graphiti-style, with invalidation-not-deletion on re-ingest
- An agent loop: question → Cypher plan → answer, exposed over MCP
- A small local UI (calendar-with-edges, or `relate serve --http` + a web view)
- Refresh scheduling and a "what's new since yesterday" incremental mode
- Privacy hardening: redaction rules before anything touches a remote LLM

## Lineage & inspiration

This is the user's own clone of Amazon's quick-personal-KG concept: one graph
over your workspace and comms, serving you and your agents for knowledge work.
The public analogs are now verifiable: the [Amazon Quick
announcement](https://press.aboutamazon.com/aws/2026/10/scaling-agentic-ai-across-the-enterprise-with-amazon-quick)
itself ("an AI assistant built for work"), [Clay](https://clay.earth/use-case/personal-relationship-manager)
(the personal-relationship-graph demand), [Asana's Work
Graph](https://asana.com/resources/work-graph) (the vocabulary for work data
as a graph), and [Patchwork](https://patchwork.sh/) (agents-as-teammates over
a self-hosted embedded store).
The research trail behind it
([research/agent-native.md](../research/agent-native.md)): [Graphiti](https://github.com/getzep/graphiti)
/ [zep](https://arxiv.org/html/2501.13956) (bi-temporal edges, edge invalidation —
the semantics to copy), [mem0](https://github.com/mem0ai/mem0) (extraction into
graph memory), [cognee](https://github.com/topoteretes/cognee) (extract-cogitate-
load pipeline), and Obsidian
[Dataview](https://github.com/blacksmithgu/obsidian-datataview) (proof people
desperately want to *query* their own knowledge).
