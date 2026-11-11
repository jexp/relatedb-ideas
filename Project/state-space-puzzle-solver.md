---
type: Project
name: state-space-puzzle-solver
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/The New York Times]]"
MENTIONS_PERSON:
  - "[[Person/John Hughes]]"
  - "[[Person/Lewis Carroll]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the storage shape for millions of small state subgraphs
    target: "[[Project/a-million-tiny-graphs]]"
  - kind: variant
    reason: same search-space-as-graph treatment for a game
    target: "[[Project/opening-theory-explorer]]"
USES_TECH:
  - "[[Technology/A-Star Search]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# State-Space Puzzle Solver

> Game states as nodes, moves as edges; BFS/A* solutions as watchable
> path queries.

## What

Every puzzle with discrete states — the 15-puzzle, Rubik's cube subsets, word
ladders, jar-measuring riddles, the daily NYT Connections — is a directed graph
of states with moves as edges. Solver programs bury this in arrays. This
project makes it the data structure: each state a `(:State {encoding})` node,
each legal move `-[:MOVE {cost}]->`, the solve a shortest-path query, and the
returned path *is* the animated solution. Frontier expansion runs as iterative
Cypher (one BFS layer per query — the same pattern as the PageRank-experiment
idea), or A* with an admissible heuristic scored at expansion time.

The payoff of keeping the graph instead of just the answer is that
intermediate artifacts stay queryable: "which states are exactly N
moves from solved" is a query, dead ends are dangling nodes, and the
parity-unreachable half of the sliding-puzzle state space is literally a
subgraph the solver never visits. For the daily-puzzle genre the graph persists
across days: Connections puzzles as word-partition states, previous solves as
memory, candidate groupings as edges human play confirms or kills.

## Why RelateDB

In-memory generation is the workload: state graphs are built,
traversed and thrown away in one sitting — `:memory:` per solve, WAL
only when a puzzle's history deserves keeping (the daily-puzzle
streak file). Native path queries make the "watchable" part free: the
solution comes back as an ordered path of states, ready to animate, and the
exploration frontier, visited set and layer-by-layer progress are ordinary
query results rather than ad-hoc debug output. The "A Million Tiny Graphs"
idea's storage shape fits directly: millions of small state subgraphs —
per-puzzle, per-day — held cheaply in one store. Python bindings drive the
generators and heuristics, and the Cypher frontier expansion doubles as the
teaching artifact: students watch BFS happen one query at a time instead of
squinting at pseudocode.

## What it needs

- State encoders per puzzle family
(sliding-tile, word ladders, jar
  states, word-partition games) with canonicalization (visited states
  MERGE on normalized form)
- Frontier expansion as iterative Cypher, plus A* hooks (heuristic as
  property, expansion ordered by projected cost)
- The watch layer: solution-path playback and frontier visualization
  over the WASM build

## Lineage & inspiration

- connections.duckdb — NYT Connections solved in SQL, the embedded-analytics
world's beloved proof that daily puzzles want a query
  engine (research/embedded-ecosystems.md)
- The 15-puzzle and BFS/A* — the state-space canon since the 1870s and
  1959 respectively; the genre this project renders inspectable
- Word ladders — Lewis Carroll's *Doublets*, the oldest popular
  state-graph puzzle and the easiest first loader
- [Why Functional Programming Matters](https://www.cs.kent.ac.uk/people/staff/dat/miranda/whyfp90.pdf)
  (John Hughes, 1990) — the search-as-glue inspiration: its lazy game-tree
  section generates exactly the search space it needs and prunes the rest
  without ever materializing it; this project is the deliberate opposite end
  of the same idea — *materialize* the space, so every state, frontier
  layer, and dead end stays inspectable after the answer is found
