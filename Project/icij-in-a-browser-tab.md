---
type: Project
name: icij-in-a-browser-tab
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Graphistry]]"
  - "[[Company/ICIJ]]"
  - "[[Company/Neo4j]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphistry]]"
  - "[[Technology/ICIJ Offshore Leaks]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# ICIJ in a Browser Tab

> Offshore/Panama-style ownership networks as a single shareable `.cl` file;
> investigators open the file, no database, no install.

## What

The Panama Papers were the defining graph-database journalism story: 2.6 million
leaked records, modeled by ICIJ as officers, intermediaries, entities and
addresses in a property graph — and the public part of that graph is downloadable
today. This project converts it into a single RelateDB store and ships it as
a file. Investigators open the file in a browser tab (WASM) or on their laptop
(CLI) and run the actual queries that pulled the story out of the data: shortest
path between two officers, everything registered at one address, the neighbor
network of an intermediary, the entities two known players share.

A session: download `offshore.cl`, `relate --database offshore.cl "MATCH
p = shortestPath((a:Officer {name: $a})-[*]-(b:Officer {name: $b})) RETURN p"`,
and the two-degree answer appears in milliseconds — no Docker, no Neo4j
install, no server. The browser version is one step shorter: a link, a search
box, the graph drawn around a name.

The pitch is not a re-analysis — ICIJ already runs their explorer — it is
*possession*: the graph as an artifact any journalist, student or researcher
can hold, commit, diff, and query offline. The Pulitzer queries, un-gated.

## Why RelateDB

ICIJ already publishes downloadable Neo4j data packages — the data is public,
the friction is the database. RelateDB removes it: one `.cl` file (WAL + a
Parquet checkpoint) carries data plus indices; ~800k entities fit in an
in-memory store where shortest-path and neighborhood queries run at scan speed
with no server at all. The WASM build makes the file a browser tab — zero
install for the least-technical audience that matters, the newsroom. For the
CLI-literate, the same file serves over Bolt/HTTP/MCP via `relate serve`,
and the `pull` command (importing from the Neo4j Query API v2 into a local
store) is the natural production tool: a one-time pull from ICIJ's published
packs, then a lifetime of local querying.

## What it needs

- A converter from ICIJ's published CSV data packages to a `.cl` store
  (entities, officers, intermediaries, addresses, edges) — the real work, with
  data-quality checks against ICIJ's own documented model
- A hosted static page (WASM engine + the file) with a name-search and
  shortest-path UI
- A query gallery ported from ICIJ's official Neo4j browser guide — the
  documented example queries are the curriculum
- Licensing/provenance notes on the file itself (ICIJ's terms, download date)

## Lineage & inspiration

- [ICIJ + Neo4j: unraveling the Panama Papers](https://neo4j.com/blog/cypher-and-gql/icij-neo4j-unravel-panama-papers/)
  — the original story this project re-ships as a file
- [ICIJ Offshore Leaks Neo4j browser guide](https://github.com/ICIJ/offshoreleaks-data-packages/blob/main/documentation/icij-offshoreleaks.neo4j-browser-guide)
  — the documented model and example queries; the converter's source of truth
- [Neo4j case study: ICIJ](https://go.neo4j.com/rs/710-RRC-335/images/Neo4j-case-study-ICIJ-EN-US.pdf)
  — the Pulitzer-winning workflow this democratizes
- [Neo4j sandbox walkthrough](https://guides.neo4j.com/sandbox/icij-panama-papers/examples.html)
  — shortest-path storytelling on the same graph, already written
- Graphistry's ICIJ work — the [Implant Files graph-viewer tutorial](https://www.graphistry.com/blog/tutorial-csv-miniapp):
  GPU-scale visual analytics on ICIJ's own leaked datasets, the analyst end
  of this spectrum — this project is the any-laptop end of the same
  investigation toolchain
