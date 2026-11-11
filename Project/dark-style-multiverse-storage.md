---
type: Project
name: dark-style-multiverse-storage
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
RELATED_IDEA:
  - kind: variant
    reason: same fictional-character graph pattern over a different canon
    target: "[[Project/every-character-network-ever]]"
  - kind: variant
    reason: character and lineage modeling across a fictional universe
    target: "[[Project/franchise-genealogy]]"
  - kind: complements
    reason: world-scoped entities and time periods as a dimensional graph
    target: "[[Project/history-as-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Dark-Style Multiverse Storage

> Parallel-world story graphs (the Dark TV model): typed world-line edges
> (`-[:IN_WORLD {timeline: 1}]->`), time-travel loops, bootstrap paradoxes —
> the same person at three ages across two worlds stays one node with
> world-scoped paths.

## What

Time-travel stories break every data model except graphs. *Dark*'s caves
connect four families across three time periods and two parallel worlds;
the same person exists at ages 10, 40 and 70, marries someone who is
also their aunt's brother-in-law, and causes their own existence. This
project models it honestly: one `:Person` node per human identity, with
appearances — `(:Appearance {age})-[:IN_WORLD {timeline, year}]->
(:World)` — carrying the world-scoped facts, and marriages, murders and
meetings as edges *between appearances*, so every question is answered
per world and per year: one node per person, the multiverse as a
dimension on the paths, not a forked copy of the graph.

The queries are the ones fans draw on poster boards: every Jonas-Martha
meeting, cross-world; the bootstrap cycles (event paths whose cause is
their own effect — a genuine cycle check, trivial in Cypher, impossible
relationally); who exists in world 2 but not world 1. A consistency
checker runs as queries: every event's cause must live in the same
world-year or connect through an explicit `TRAVELED` edge, so fan
theories with timeline violations surface as dangling paths.

## Why RelateDB

The four-season puzzle fits in memory with room to spare, and the
natural artifact is a single `.cl` file — the Winden board game in
database form, shareable as an attachment, playable in a browser tab
over the WASM build. Temporal types carry the year dimensions natively,
and "the world as it stood on 12 November 1986, timeline 2" is a
filter, not a reconstruction. Cycles and multi-world path constraints
are what a traversal engine is built for. The WAL lets a watch-along
append each episode's reveals, and an agent over `serve --mcp stdio`
can finally answer "who is Charlotte's mother *again*" — with the
actual path.

## What it needs

- The Dark model: Person/Appearance/World, event edges between
  appearances, `TRAVELED` edges as the only cross-world door
- Cycle detection and the bootstrap-paradox query pack (paths whose
  first node is their own cause)
- Consistency checker: cause-in-same-world-or-via-travel validation
  for claimed theories
- A world/timeline selector UI over the WASM build — pick timeline and
  year, the graph re-projects

## Lineage & inspiration

- *Dark* (Netflix, 2017–2020) — the densest bootstrap-paradox canon on
  television and the reference world: https://dark.fandom.com/
- The bootstrap paradox / predestination loop as a graph-cycle problem
  — free to state, hard to state anywhere but a graph
- Fringe's parallel-universe "over there" casting — the second test
  case for the same model
