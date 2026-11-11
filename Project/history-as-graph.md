---
type: Project
name: history-as-graph
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: complements
    reason: the same dated-edge temporal modeling at document scale; this is the diplomacy cut
    target: "[[Project/the-codex-reborn]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Wikidata]]"
---

# History as Graph

> Timelines of dynasties, wars, treaties and successions as property graphs; query
> "who was related to whom at the outbreak of WWI?".

## What

History is not a list; it is a web of dynasties, marriages, wars, treaties,
successions and alliances. This project models it that way: nodes for persons,
nations, dynasties, treaties and battles; relationships for `MARRIED`,
`CHILD_OF`, `RULED`, `ALLIED_WITH`, `SIGNED`, `FOUGHT_IN`; properties carrying the
dates — reign start/end, treaty dates, birth/death. The temporal property graph
is the whole point: the edges carry *when*.

The demo question sells it immediately: who was related to whom at the outbreak
of WWI? It is a single query — the family web among George V, Wilhelm II and
Nicholas II (`MATCH path = (a)-[:CHILD_OF|SIBLING_OF*]-(b) RETURN path`) — with
the answer being the famous "cousins' war". Then the questions keep coming:
which treaties were still in force on 28 June 1914, who stood to inherit which
throne, what did the diplomatic graph look like one year before the outbreak.

The time-travel version is the killer feature: with a WAL-backed store you can
replay the graph as it *was* at any date — questions of the world as the
participants saw it, not with today's hindsight.

Prior art exists and proves the demand without closing the gap. EverythingGraph
publishes Chinese dynasty timelines (Qin through Qing) and European eras (the
Roman Republic, Byzantium, the Reconquista, the Italian Renaissance, the
Napoleonic Wars) as interactive timelines and relationship graphs — its Dream
of the Red Chamber graph covers 87 characters and 155 relationships — but it
is browse-and-filter, with no query language and no data export. Timelory
does dynasty family trees and empire maps the same way. Histropedia renders
any Wikidata query as an interactive timeline — the closest to queryability,
and only along the time axis. None of them answers the multi-hop, at-date
questions that are the point of modeling history as a property graph.

## Why RelateDB

RelateDB's native temporal types (date/datetime on properties, exercised by
the TCK's temporal scenarios) make "valid at date X" a property predicate, not an
application-layer hack. The in-memory engine answers multi-hop path queries
across a few thousand historical actors instantly, so classroom exploration is
interactive. The durable WAL + checkpoint design means the store is one `.cl`
file — a curriculum unit or a history-club data story is an attachment, and the
WAL gives the replay-any-window capability for the time-travel view. The WASM
build puts the whole thing in a browser tab for a class of thirty students with
zero setup, and `db.schema.visualization` shows the model in one call.

## What it needs

- Data: the real work. Curated, sourced event/person datasets for 2–3 eras
  (e.g. European monarchies 1815–1918, the Italian Renaissance states, the
  Cold War alliance system) — Wikidata slices are the practical source, hand-
  curated for the relationship edges Wikidata under-specifies
- A Wikidata → graph loader (entities/claims → nodes/edges with date properties)
- A path-and-date query gallery: "related at date X", "treaties in force in
  year Y", "recent enemies of nation Z"
- Optional: the checkpoint-replay "world as of date" view over a WAL-written
  store
- A timeline + graph renderer (timeline on top, graph below, scrub the date)

## Lineage & inspiration

- Wikidata as the entity/claim source — the practical extractor pipeline for
  historical persons and events
- [EverythingGraph](https://everythinggraph.com/en/) — dynasty timelines and
  relationship graphs for Chinese and European history, browsable but not
  queryable; [Timelory](https://timelory.com/) — dynasty family trees and
  empire maps; [Histropedia](https://histropedia.com/) — Wikidata results as
  interactive timelines
- The "cousins' war" factoid (George V, Wilhelm II, Nicholas II) — the question
  every audience asks first; proof that history's viral facts are already graph facts
- [The Codex, Reborn](the-codex-reborn.md) — the flagship humanities-scale
  application of exactly this modeling: the same dated-edge, temporal-web
  treatment at document scale, where this file is the political-diplomacy
  cut; [Building graph history: the Codex](https://neo4j.com/blog/graph-data-science/building-graph-history-codex/)
  documents the graph-history craft (dating edges, as-of views) directly
- RelateDB's temporal TCK coverage — the property types that make
  date-filtered edges first-class rather than stringly-typed
