---
type: Project
name: sports-dynamics
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Hudl]]"
  - "[[Company/Neo4j]]"
  - "[[Company/StatsBomb]]"
MENTIONS_PERSON:
  - "[[Person/Adam Cowley]]"
  - "[[Person/Albert-László Barabási]]"
  - "[[Person/Mark Needham]]"
  - "[[Person/Rik van Bruggen]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the pattern behind the tracking position replay
    target: "[[Project/animated-graph-timelapse]]"
  - kind: variant
    reason: both model sports competition history as a queryable graph
    target: "[[Project/league-historian]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/StatsBomb]]"
  - "[[Technology/WASM]]"
  - "[[Technology/mplsoccer]]"
---

# Sports Dynamics

> passes as edges in a match graph (StatsBomb open data!); xT-style analyses with
> plain Cypher over event streams.

## What

Modern football (soccer) analytics runs on event streams: every pass, carry, shot,
and tackle, timestamped and located on the pitch, tagged to players and teams.
StatsBomb's open data — full event streams for World Cups, Euros, the Messi
collection, the women's game — is the goldmine, and it is already graph-shaped:
players, events, positions, and periods connected by an explicit model.

This project loads a match (or a whole tournament) into RelateDB: `Player` and
`Team` nodes; `Event {type, minute, second, x, y, end_x, end_y, outcome}` nodes
with `EXECUTED_BY`, `NEXT` (the match as a linked event chain), and
`PASSED_TO`/`TACKLED_BY` edges between players. Then the analysis genre of
xT-style expected-threat and network metrics becomes plain Cypher: pass-network
per team as one aggregation; "the five-player core behind Argentina's left-side
overload" as a frequent-subgraph-shaped query; danger entries — passes that cross
into the box — as spatial predicates with point types; and player partnerships
as weighted co-pass counts, all queryable and modifiable in the shell.

The format and the notebook genre are both verified. StatsBomb's open data
repository carries the events specification as a PDF (v4.0.0) plus the open JSON
event files for World Cups, Euros, the women's game, and a Messi career
collection — now mirrored under Hudl's org after the acquisition. The pass-network
analyses this project replaces are a whole notebook subculture: Friends-of-
Tracking's `passing-networks-in-python`, mplsoccer's pass-network gallery recipe,
and the Soccermatics pass-network-and-centralisation lesson — all
pandas-and-matplotlib, all one-match-at-a-time, none queryable.

The match is the smallest unit, not the whole game. The same model scales up
(tournaments: brackets and standings as graphs — every World Cup graph ever
built is this idea at 64 matches) and *down* into the genuinely temporal
substrate: **tracking**. StatsBomb 360's freeze-frames carry all 22 players'
positions per event, which turns the match graph into an animated one —
player movement, carries, and possession handovers as timestamped edges on a
scrubbable timeline; "how did the block shift during the corner" answered by
replaying the subgraph, second by second, in the browser. And the tradition
crosses sports: cricket (the IPL as a boundary-hitting graph), tennis
(rankings as weighted PageRank over head-to-head edges), each with the same
shape — events between participants, on a surface, over time.

## Why RelateDB

The radical move is replacing the pandas/Python notebook layer with the query
layer itself: an event stream is a temporal property graph, and Cypher over it —
at in-memory speed, with no dataframe plumbing — is the fastest path from
"question about a match" to "answer". Temporal types are load-bearing (minutes,
stoppage time, period boundaries; "possession sequences in the last 10 minutes of
a tied knockout game" is a temporal window query). Point types carry pitch
coordinates so zone-entry queries are native predicates. The WASM build makes an
interactive match explorer in the browser (click a player, see the pass network
grow), and a tournament's worth of events as one `.cl` file is a shareable
teaching artifact — a sports-analytics course hands it out like a dataset.

## What it needs

- StatsBomb open data loader (JSON event files → the graph model above; the
  360/freeze-frame position data as the tracking layer)
- The tracking front-end: position replay (scrub the timeline, watch the
  subgraph move — the [Animated Graph Timelapse](animated-graph-timelapse.md)
  pattern at match granularity)
- Lineup and player deduplication across matches (ids differ per dataset)
- Query cookbook: pass networks, sequence detection, pitch-zone predicates —
  written as Cypher, tested like the repo's cookbook recipes
- Optional: xT grid as a property table on zone nodes (precomputed, loaded with
  the data — the honest version of "xT with plain Cypher")
- Front-end: pitch view over the WASM build; otherwise table output suffices

## Lineage & inspiration

- StatsBomb open data (free event-stream matches): https://github.com/statsbomb/open-data
  and the spec: https://github.com/statsbomb/open-data/blob/master/doc/Open%20Data%20Events%20v4.0.0.pdf
- Karim Ghabayen / Friends-of-Tracking ecosystem for the xT lineage:
  https://github.com/Friends-of-Tracking-Data-FoTD — and its canonical
  pass-network notebook:
  https://github.com/Friends-of-Tracking-Data-FoTD/passing-networks-in-python
- mplsoccer pass-network gallery (the plotting recipe this project replaces with
  a query): https://mplsoccer.readthedocs.io/en/latest/gallery/pitch_plots/plot_pass_network.html
- Soccermatics lesson 1 — pass networks and centralisation from event data:
  https://soccermatics.readthedocs.io/en/latest/gallery/lesson1/plot_PassNetworks.html
- Barabási's *Network Science* (pass networks as weighted graphs are a textbook
  genre): https://networksciencebook.com/
- NetworkX applications guides — event-sequence-to-network notebooks this
  modernizes: https://networkx.org/nx-guides/content/applications/index.html
- The Neo4j sports-graph tradition, across sports and years: Mark Needham's
  [World Cup graph](https://github.com/mneedham/neo4j-worldcup) (and the
  [TWIN4j writeup with a GraphQL API on top](https://medium.com/neo4j/twin4j-world-cup-graph-and-graphql-api-tuning-cypher-queries-querying-spatial-datapoints-6e46b8a2b463)
  — the GraphQL-surface pairing, already proven), the
  [Women's World Cup 2019 dataset](https://github.com/neo4j-graph-examples/wwc2019),
  Rik van Bruggen's [WorldCupGraph](https://blog.bruggen.com/2022/11/no-worldcup-without-worldcupgraph.html),
  tennis via [QuickGraph: Australian Open](https://www.markhneedham.com/blog/2020/01/23/quick-graph-australian-open/)
  and [weighted PageRank over head-to-head edges](https://medium.com/neo4j/finding-the-best-tennis-players-of-all-time-using-weighted-pagerank-6950ed5fc98e),
  and Sid Aggarwal's [Boundary Graph](https://github.com/sidagarwal04/boundary-graph)
  (the [IPL through the lens of graphs](https://neo4j.com/blog/developer/boundary-graph-exploring-the-ipl-through-the-lens-of-graphs/))
  — the cricket entry point
- Adam Cowley's [statsbomb-neo4j](https://github.com/adam-cowley/statsbomb-neo4j)
  — StatsBomb event streams loaded into Neo4j, the exact loader this project
  ports to the embedded engine (a "Tournr" attribution couldn't be verified;
  this is the verifiable sports artifact)
- Kuzu comparison: this is the embedded-graph answer to notebook-analyst workflows
