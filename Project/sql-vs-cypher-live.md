---
type: Project
name: sql-vs-cypher-live
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: both rebuild a classic teaching artifact as a runnable page
    target: "[[Project/graphgists-reborn]]"
  - kind: variant
    reason: both put a live Cypher surface in the browser tab
    target: "[[Project/instantcypher]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB WASM]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQL]]"
  - "[[Technology/WASM]]"
  - "[[Technology/relate-arrow]]"
---

# SQL vs. Cypher, Live

> The Gremlin "SQL vs. Gremlin" cheat-sheet tradition — the same comparison
> exists as the Neo4j Cypher vs. SQL docs page — rebuilt as a live browser page:
> DuckDB-WASM and RelateDB side by side, the same question answered in both
> languages, both engines running in the tab.

## What

The Gremlin ecosystem had a beloved artifact: the "SQL vs. Gremlin" page —
the same query expressed in both languages, side by side, so relational
people could map what they knew onto the new thing. The author carried the
tradition into Neo4j's docs
([Cypher vs. SQL](https://neo4j.com/docs/getting-started/cypher/cypher-sql/))
— but a docs page can only *show* the text. The live version runs both.

The page: a split REPL in one browser tab — DuckDB-WASM on one side,
RelateDB (WASM) on the other — over the same shared dataset (a graph-shaped
movie set, its tables also loadable as rows). Pick a question from the
cheat sheet (" actors co-starring with X", " top-5 by degree", " the
3-hop neighborhood"): both engines answer it in their own language, live,
with run buttons and result panes. The tabular mind sees JOIN chains melt
into patterns; the graph mind sees what SQL does when the recursion comes.

## Why RelateDB

Both sides of the comparison are now embeddable — DuckDB-WASM proved the
in-browser analytics REPL is the strongest marketing artifact this
ecosystem family knows, and RelateDB's WASM build is its graph twin.
The whole page is static hosting plus two WASM engines: no server, no
sandbox queue, no signup — the exact zero-friction shape a language
comparison needs to actually be *tried*. The `.cl` dataset rides in the
page payload; the same file doubles as the SQL side's input via
relate-arrow (graph → rows for DuckDB's `file()`-style load).

## What it needs

- The side-by-side REPL shell (two panes, shared question picker, run buttons)
- The cheat-sheet content (port the Cypher-vs-SQL docs page's pairs,
  extend with the recursive/path questions where the contrast is sharpest)
- One shared dataset in both engines (relate-arrow exports the graph
  side as the table side's load)

## Lineage & inspiration

- The Gremlin "SQL vs. Gremlin" page — the tradition this revives
- The [Cypher vs. SQL](https://neo4j.com/docs/getting-started/cypher/cypher-sql/) docs page — the content source
- DuckDB-WASM's homepage shell — the strongest precedent for
  engine-in-a-page marketing (see `research/embedded-ecosystems.md`)
