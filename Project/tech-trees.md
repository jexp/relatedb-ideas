---
type: Project
name: tech-trees
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/Cornell University]]"
RELATED_IDEA:
  - kind: variant
    reason: both make a game's decision tree an explorable queryable graph
    target: "[[Project/opening-theory-explorer]]"
  - kind: variant
    reason: same prerequisite/search structure made queryable
    target: "[[Project/state-space-puzzle-solver]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JSON]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Tech Trees

> Civilization/tech/research trees as explorable graphs; zoom from the whole game
> to one branch, query prerequisites ("which techs unlock X within 2 steps?").

## What

Every strategy game — Civilization, Stellaris, Factorio, the research trees of
countless others — ships a tech tree that the UI flattens into opaque menus and
tabs. This project makes the tree itself the artifact: a data model with nodes
(Technology), relationships (`:UNLOCKS`, `:REQUIRES`), and properties (era, cost,
effects), loaded into a graph you can explore on any axis.

The session is charm-first. Load "Civ VI, all eras": `CALL
db.schema.visualization()` shows the shape; `MATCH (t:Tech {era: 'Ancient'})
RETURN t` shows the entry points; then the queries that no game UI can answer:
which technologies sit on the critical path to Rocketry (`MATCH path =
(t:Technology {name:'Rocketry'})<-[:REQUIRES*]-(pre) RETURN path`), what does a
beelined strategy skip, which single tech unlocks the most downstream techs,
which is the deepest dependency in the whole tree. Then flip axes: filter by era,
build a hypothetical mod, and `CREATE` a new tech with its edges — the tree
becomes editable, so modders and game-design teachers can test re-balances by
query, not by squinting at wikis.

A second lane is non-game tech trees: the prerequisite DAGs of university degree
programs or engineering certification ladders, where "can I actually take
Quantum II in year 2" is a reachability query.

Part of the data work is already done for at least one game. Factorio ships
its complete tech tree as machine-readable official data — the
`wube/factorio-data` repository on GitHub, `base/prototypes/technology.lua`,
every technology with its prerequisites, research costs and unlocks in Lua —
and the community maintains schema and JSON converters for the whole
`data.raw` blob. That is a loader, not a scraper. The Civilization side
genuinely needs wiki scraping — which is itself evidence: the crowd-maintained
prerequisite tables exist because players care about the tree as such.

## Why RelateDB

The graphs are tiny (tens to hundreds of nodes) and the queries are pure pattern
matching — exactly what in-memory Cypher at scan speed does best; every
prerequisite query answers in milliseconds, so the exploration feels like
conversation. The whole tree plus the game's metadata fits in one `.cl` file a
modder commits next to their mod. The WASM build makes "explore the Civ VI tech
tree" a shareable browser link with no backend, and `db.schema.visualization`
gives the one-call overview panel for free. For modders, the CLI (`relate
--database civ6.cl`) turns tree editing into scripted, diffable Cypher writes.

## What it needs

- Scrapers/converters for 2–3 popular tech trees (game wikis to nodes +
  `REQUIRES`/`UNLOCKS` edges; data quality is the real work)
- A front end: tree/DAG layout with collapse-to-branch zooming (or just the WASM
  engine + a Cypher shell in a web page, given the queries are the fun part)
- A curated query gallery: beeline analysis, critical path, unlock fan-out,
  orphan techs
- Optional: the degree-program/certification-ladder variant with its own loader

## Lineage & inspiration

- Sid Meier's Civilization and the 4X genre's tech trees — the cultural object
  everyone already understands as a directed graph, even if no game lets them
  query it
- Game-wiki communities (the crowd-maintained prerequisite tables this project
  converts) — the data source, and the proof that people want the tree *as such*
- [Factorio's official machine-readable tech tree](https://github.com/wube/factorio-data/blob/master/base/prototypes/technology.lua)
  ([data.raw docs](https://wiki.factorio.com/Data.raw), [JSON
  converter](https://github.com/Lu-233/FactorioDataRaw2Json)) — the game where
  the converter is a loader, not a scraper
- The Cornell INFO-2040 student-graph genre — evidence that "take a structure
  you love, make it a graph, ask it questions" is how people learn graph thinking
