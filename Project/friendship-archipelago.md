---
type: Project
name: friendship-archipelago
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
MENTIONS_ORG:
  - "[[Company/Clay]]"
RELATED_IDEA:
  - kind: complements
    reason: the archipelago is that project social subgraph standing on its own
    target: "[[Project/cy-your-personal-knowledge-graph]]"
  - kind: variant
    reason: personal relationship graph built from a different set of exports
    target: "[[Project/your-follow-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
---

# Friendship Archipelago

> Merge address book, chats and calendar into one personal-graph file — the "personal CRM" with an actual query language.

## What

The "personal CRM" genre (Monica, Clay, Notion templates) all hit the same wall:
a contacts table pretending to be relationships. This project makes the
archipelago literal: `(:Person)-[:KNOWS_FROM {context}]->(:Group)`,
`(:Person)-[:APPEARS_IN]->(:Chat)`, `(:Person)-[:ATTENDED]->(:Event)`,
`(:Chat)-[:HAPPENED_AROUND]->(:Event)` — your address book, messaging history and
calendar merged into one graph, stored as one .cl file.

Then the neglected-relationship check is a query: "people I've had a 1:1 chat
with but no calendar event for in 90 days", sorted by how long you've known them.
"Who did I meet at the conference last year and never text again?" "Which of my
groups has the most interconnection — and who's the bridge?" The wedding-seating
problem becomes genuinely easy: cluster around `KNOWS_FROM` and minimize
stranger-adjacency.

The honesty is in the edges: the tool doesn't guess relevance like a SaaS
"important contacts" score — you see exactly which chat or meeting created the
edge, and you can correct it. The personal CRM with an actual query language
instead of a proprietary relevance black box.

## Why RelateDB

One `.cl` file plus WAL is the whole CRM: portable, versionable in git,
emailable to yourself as a backup — no server to subscribe to for the privilege
of storing your own friends. Temporal types make "in 90 days" and "how long
since" real queries, not filter hacks. In-memory Cypher keeps the neglected-
friends scan instant even over a decade of chats. The C ABI → Python bindings
make the merge pipeline (Contacts vCard export, chat archives, iCal) a script;
`relate lab fs-to-graph` can sweep exported CSVs/JSON/markdown into candidate
nodes to start from. And when the agent era calls, the same file serves `MCP
stdio` — your assistant can look up "who was that person from the Berlin dinner"
without a cloud CRM in between.

## What it needs

- Loaders: vCard/Contacts export, WhatsApp/Signal/Telegram/iMessage archives,
  iCal/Google Calendar export — each into the shared Person/Group/Chat/Event
  model with source tags and as-of dates
- Identity resolution across sources (the phone-number/email/thread triangle)
- The dashboard: neglected-relationships, group bridges, anniversary-of-met
  reminders — a handful of curated Cypher queries with a friendly front end
- An edge-curation UI (merge/split people, annotate HOW you know them)
- Privacy: it's the most sensitive file you own — encryption-at-rest story

## Lineage & inspiration

From [research/agent-native.md](../research/agent-native.md): [Obsidian
Dataview](https://github.com/blacksmithgu/obsidian-datataview) (users begging to
*query* personal notes — here it's Cypher over life data), [mcp-memory-service](https://github.com/doobidoo/mcp-memory-service)
(personal memory served to
agents over MCP, DIY), and the local-first markdown-as-database crowd (§6 there)
— the files stay the export source of truth, the graph is the queryable
rebuildable index beside them. The personal-KG thread ties it to the **Cy**
project: the archipelago is Cy's social subgraph with standing on its own.
The longitudinal angle now has a flagship corpus behind it: the JEV
chat-assistant family (the most popular consumer class of that ecosystem —
relationship-staged replies, per-message emotion/intent tags, graded
responses, affection curves — all held in flat local files; representation
without storage) is the industrial-strength version of the archipelago's
relationship state, waiting for the store (`research/jev-head.md`).
