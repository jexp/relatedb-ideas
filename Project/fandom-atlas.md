---
type: Project
name: fandom-atlas
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Fandom]]"
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: variant
    reason: character graphs mined from fandom texts and wikis
    target: "[[Project/every-character-network-ever]]"
  - kind: complements
    reason: lineage and event modeling over the same fandom wiki sources
    target: "[[Project/franchise-genealogy]]"
  - kind: inspired-by
    reason: the same wiki-as-a-portable-database mechanism with a fandom-first face
    target: "[[Project/wiki-as-a-file]]"
  - kind: variant
    reason: the same wiki import wedge aimed at a different wiki corpus
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Fandom]]"
  - "[[Technology/MCP]]"
  - "[[Technology/MediaWiki API]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Fandom Atlas

> a fandom wiki (or all of them) into nodes and ships; fan theories tested by path
> queries ("has these two ever met on screen?").

## What

Every fandom maintains a wiki whose entire editorial content is entities and
relations: characters, episodes, planets, ships, battles, deaths, and an army of
infobox fields linking them to each other. Fandom.com exposes that structure
APIs-first. This project imports one wiki (or several, for the crossover fans)
into RelateDB: `Character`, `Episode`, `Species`, `Ship`, `Location` nodes
typed by infobox template; `APPEARED_IN`, `CAPTAIN_OF`, `KILLED`, `ALLIANCE`
edges from both infobox fields and categories; and episode-scene citations as
edge provenance.

Then the dormant function of every wiki — *answering arguments* — wakes up.
"Has Picard ever met Q in a non-TNG episode?" is a pattern with episode-series
constraints. "Which characters have died more than twice?" is a property
aggregation over resurrection edges. "The shortest chain of command between
any two captains" is a path query. Crossover wikis make it multi-fandom: the
path from the Enterprise to a galaxy far, far away, through credited crossover
appearances only — with the citation on every hop, because the graph says so.

## Why RelateDB

Wiki-shaped data at fandom scale (tens of thousands of pages) is an easy
in-memory fit, and the `.cl` file is a genuinely new artifact for fandom: a
wiki becomes a *portable database* — download the Star Trek graph, query it on
the plane, no server and no scraping etiquette questions at query time. The
WASM build makes it the browser toy it deserves to be: a wiki page whose
interactive mode is "run Cypher against the fandom", with path queries
rendered as an interactive result. `relate serve --mcp stdio` turns it
into the fan-theory judge for an agent: ask "test my theory", get a query
against the actual graph. And the wiki-as-a-file idea in the Wikis section is
the same mechanism generalized — this is its fandom-first face.

## What it needs

- Fandom/Wikimedia API importer (MediaWiki API + infobox parsing — cargo-export
  endpoints help; honest about infobox schema drift per wiki)
- Citation preservation: every inferred edge keeps the source page/episode
  reference so answers are arguable
- Cross-wiki identity resolution for crossovers (the "same actor/character
  across wikis" reconciliation layer)
- Front-end: browser explorer over the WASM build — character page as a query
  result, path visualizations for theory tests
- Refresh path: re-import on wiki updates through the WAL

## Lineage & inspiration

- MediaWiki API (Fandom runs it): https://www.mediawiki.org/wiki/API:Main_page
  and Fandom's cargo exports: https://community.fandom.com/wiki/Help:Cargo
- Six Degrees of Wikipedia (sdow) — the path-queries-over-a-corporus genre:
  https://github.com/jwngr/sdow
- The Wikipedia Republic of Literary Characters — wiki-mined character networks
  as a research precedent: https://culturalanalytics.org/article/id/1301/
- Cornell INFO-2040 genre (the "test the theory with the graph" exercise):
  https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
- Wiki-as-a-File (this repo's Wikis section) — the same wedge at community scale
