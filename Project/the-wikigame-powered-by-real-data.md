---
type: Project
name: the-wikigame-powered-by-real-data
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/Stanford University]]"
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: complements
    reason: another interactive lesson over a real link graph
    target: "[[Project/the-original-search-index-experiment]]"
  - kind: complements
    reason: offline Wikipedia graph for mobile play
    target: "[[Project/wikipedia-in-your-pocket]]"
  - kind: same-data
    reason: Wikipedia link subgraphs powering the puzzles
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SNAP]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Wikipedia]]"
  - "[[Technology/Wikispeedia]]"
---

# The WikiGame, Powered by Real Data

> Load a Wikipedia (sub)graph and play shortest-path games (Six-Degrees-style)
> against the actual article network; path hints, difficulty scoring, and
> "no dead-end articles" as query constraints.

## What

The WikiGame — get from one Wikipedia article to another using only links —
is a beloved browser pastime usually played against the live site, blind.
This project makes the game *legible*: load a Wikipedia subgraph (a language
edition's core articles, or a topical wedge) into a local graph and play with
the engine as referee. Shortest path is a Cypher query. "No dead-end articles"
(no disambiguation pages, no pages with out-degree 0) is a constraint expressible
in the same MATCH. Hints are intermediate nodes from an actual shortest path,
revealed one at a time.

The game becomes a study of the network itself: score a pair by graph distance,
rank daily puzzles by difficulty (distance × branch factor of the start node),
and show the player, post-game, all the shortest paths they *could* have taken.
Leaderboards are just queries over play history stored in the same graph — every
play session a temporal edge from the puzzle node.

The study version already exists as data: Wikispeedia — the research game
behind West & Leskovec's *Human Wayfinding in Information Networks* (WWW
2012) — logged roughly half a million completed human paths through a
4,600-article Wikipedia subgraph, and the released SNAP dataset ships both
the article graph and every player's click trail. Difficulty scoring, hint
design, even bot opponents can be grounded in that corpus: how humans
actually move through the link graph, when they backtrack, and how
hub-heavy their paths turn out to be.

Because the whole thing runs over a local store, it works offline, in a browser
tab, or on a phone — the game follows the data, and the data is one file.

## Why RelateDB

Shortest-path-over-a-real-network at interactive speed is exactly what an
in-memory Cypher engine gives you: variable-length paths and path functions run
in milliseconds over a few hundred thousand nodes, and the WASM build puts the
whole game — engine, data, scorer — in a single browser tab with no backend.
The single `.cl` store means puzzle packs ship as files (one per topic: movies,
philosophy, football). And the WAL makes play history durable in the same store
without any extra persistence machinery.

## What it needs

- A Wikipedia link-graph loader (dump → `(:Article)-[:LINKS_TO]->(:Article)`),
  with dead-end/disambiguation filtering as load-time or query-time rules
- Game front-end: puzzle picker, timer, hint reveal, post-game path overlay —
  a thin page over the WASM engine
- Scoring queries: graph distance, degree-adjusted difficulty, alternate-path
  enumeration
- Puzzle-pack `.cl` files, curated so every start/target has a guaranteed path

## Lineage & inspiration

- [Six Degrees of Wikipedia (sdow)](https://github.com/jwngr/sdow) /
  [sixdegreesofwikipedia.com](https://www.sixdegreesofwikipedia.com/) —
  a preprocessed SQLite link database with shortest paths found live by
  BFS at query time; the reference for what's fun here
- [Wikispeedia (SNAP)](https://snap.stanford.edu/data/wikispeedia.html) and
  [Human wayfinding in information networks](https://doi.org/10.1145/2187836.2187920)
  — ~half a million logged human paths through a 4,600-article subgraph
- [The Wiki Game](https://thewikigame.com) — the multiplayer version against
  live Wikipedia; this project adds the queryable, offline referee
- [Wikipedia:Getting to Philosophy](https://en.wikipedia.org/wiki/Wikipedia:Getting_to_Philosophy)
  — the emergent-link-structure folk experiment the data version can verify
