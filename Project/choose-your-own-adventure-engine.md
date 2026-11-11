---
type: Project
name: choose-your-own-adventure-engine
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Choose-Your-Own-Adventure Engine

> The story graph is the database; readers query their own path history,
> authors write branches in Cypher.

## What

Interactive fiction has always secretly been a graph — Twine shows you
exactly that. This project stops pretending otherwise: passages are
`(:Passage {text})`, choices are `-[:LEADS_TO {label, condition}]->`
edges, and story state (flags, inventory, relationship scores) lives as
properties the edges read and write. The reader's session is *also* the
graph: every step appends `(:Session)-[:VISITED {at}]->(:Passage)`, so
"your path" is a query, not a bookmark file — readers ask what endings
branch from where they stand, which choices they never saw, how close
they came to the true ending.

The author side is the part Twine never had: writing branches *in*
Cypher, with the database validating the story as you write. Dead
passages (unreachable from the start), choice-gated passages whose gate
flag is never set, endings no reachable state can achieve — all
structural queries over the story itself. Stats-driven branches become
testable: the author asks the engine to enumerate every state that can
reach the ending, and gets a proof the path exists. Playtest traces
layer on as temporal edges: where readers abandoned, which branches
nobody survives.

## Why RelateDB

The story is the store: one `.cl` file per story — emailable,
committable, attachable to a fan-site post — and the WASM build plays
it in a browser tab with zero install, the whole distribution dream of
the interactive-fiction web. `:memory:` gives each reader session a
disposable world; the durable copy rides the WAL. In-memory
traversal makes the runtime loop trivial: rendering a passage is one
edge hop, and validating reachability after an edit is a query the
editor runs on every save. Python bindings drive the authoring
toolchain, `RETURN mermaid(subgraph)` renders the branch map for the
back cover, and MCP lets an agent co-author or narrate — querying the
actual story graph for consistency instead of hallucinating continuity,
and the reader's actual path instead of asking "where were you again?"

## What it needs

- The story model: Passage/Choice edges with conditions and effects,
  plus session/trace edges for reader history
- The reader runtime: state hop over the WASM build, with path-history
  queries exposed in-game
- The authoring tool: validation queries (unreachable passages,
  unobtainable endings, broken flag gates) on every save; branch map
  via `mermaid()`
## Lineage & inspiration

- Twine — the tool whose passage graph is this project's visual
  heritage, minus the query language: https://twinery.org/
- The Choose Your Own Adventure books — the print graph whose
  numbered-node model this engine makes literal
- Inform 7 and the interactive-fiction tradition — rules, world state
  and prose under one roof since the 90s:
  https://ganelson.github.io/inform-website/
