---
type: Project
name: the-graph-walking-agent-cursor
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: one-shot query compilation versus step-by-step walking
    target: "[[Project/instantcypher]]"
  - kind: complements
    reason: records the hops the cursor takes
    target: "[[Project/the-judgment-ledger]]"
  - kind: complements
    reason: tool selection layer beside the data selection cursor
    target: "[[Project/tools-as-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/neo4jev]]"
---

# The Graph-Walking Agent Cursor

> `next_hop(node, goal)` as the MCP tool instead of `run_query`: the
> agent walks real edges, grounded, one typed choice at a time, context
> accumulating — never inventing Cypher, never reading the whole store.

## What

The default agent-access pattern for databases is the wide-open query:
`run_query(cypher)` — powerful, and exactly wrong for most agent loops:
the model generates query text (hallucinated labels, accidental full
scans), the context balloons, and nothing grounds the next step in what
the agent has actually touched. The JEV corpus built a counter-pattern
five separate times: [neo4jev](https://github.com/neo4j-field/jev-graphrag)
walks a graph hop by hop with no Cypher generated at all — typed choices
over *real edges*; jev-social (174★) has Jev pick each next operation
over your actual Instagram/TikTok/LinkedIn graphs in the browser,
reports source-cited; jevgrep (2,849★) walks folder → file → declaration;
the Pokémon route-runners branch on route-reachable choices; and the
tail's scripture hill-climb scores cross-reference edges one hop at a
time.

This project is the pattern as a first-class MCP surface for RelateDB
— the cursor protocol:

- `open(store)` → a positioned cursor: the current node set, its edges,
  the schema vocabulary within one hop
- `next_hop(node, goal)` → the typed choice: the edges that exist (with
  their types, counts, and a sample), scored against the goal — the
  agent picks among *real* options; hallucination is structurally
  impossible because the options came from the store
- `gather(pattern around cursor)` → bounded local reads (the two-hop
  neighborhood, one label's properties) — the anti-full-scan contract
  by construction
- The accumulated walk *is* the context: the path so far, the evidence
  gathered — timosam's evidence-carrying walk, made the protocol's state
- Every hop logged to the judgment ledger — the walk is auditable after
  the fact

The complement, not a replacement: `run_query` stays for the expert
caller; the cursor is the default agent surface — the difference between
giving someone the wheel and giving them a guide.

## Why RelateDB

The engine's in-process latency makes per-hop tool calls cheap (an MCP
round trip per hop is fine when the query side is microseconds), the
WASM build puts the cursor in a tab, and the MCP server already exists —
this is a *tool-shape* project, not an engine one: the cursor as the
opinionated default over the same store the raw query tool exposes. And
it composes with the repo's agent stack: [Tools as Graphs](tools-as-graphs.md)
selects which tools; the cursor selects which *data*; the ledger records
both.

## What it needs

- The cursor tool set (`open`, `next_hop`, `gather`, `walk-summary`) with
  the schema-vocabulary-in-one-hop response shape
- The grounding contract: options only from the store; edge types,
  counts, samples — never generated Cypher
- The walk-state model (accumulated context as protocol state) and the
  ledger hook
- The eval: cursor-walk vs. free-query agents on the same tasks — token
  use, hallucination rate, time-to-answer, published honestly

## Lineage & inspiration

- [neo4jev](https://github.com/neo4j-field/jev-graphrag) — the hop-by-hop
  original ("the model can only choose between options it can read");
  [jev-social](https://github.com/socai-io/jev-social) and the
  [jevgrep](https://github.com/dzhng/jevgrep) family — the head's operation
  and directory walks (`research/jev-ecosystems.md`, `research/jev-head.md`)
- timosam's evidence-carrying walk — the accumulated-context upgrade
  (`research/jev-longtail.md`)
- [Tools as Graphs](tools-as-graphs.md) — the selection layer this
  complements; [The Judgment Ledger](the-judgment-ledger.md) — the
  record of the hops; [InstantCypher](instantcypher.md) — the one-shot
  cousin (compile a whole query) where this is the step-by-step one
- The Graph-Walking agent cursor candidate in `research/jev-ecosystems.md`
  — now an entry
