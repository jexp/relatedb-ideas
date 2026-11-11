---
type: Project
name: board-game-night-matchmaker
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/BoardGameGeek]]"
USES_TECH:
  - "[[Technology/BoardGameGeek]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Board-Game-Night Matchmaker

> "The game we all like that we haven't played in six months" as one
> query.

## What

Board-game night fails the same way every month: forty minutes of shelf-staring, the
same three games suggested, the new player's preferences guessed at, and the shelf
of shame (bought, never played) grows. The matchmaker holds what nobody can hold in
their head: every player's ratings and plays of the whole collection —
`(:Player)-[:RATES {stars}]->(:Game)`, `(:Play {on, players})-
[:INVOLVED]->(:Player)` — merged with BoardGameGeek's catalog (player count,
complexity, duration, mechanics) and the household's constraints (school-night
runtime, table size, the absent player tonight).

The query in the README is the product, one statement: games the players present all
rate above their personal threshold, not played within a window, satisfying
tonight's count and time budget — the answers arriving with their reasons (all four
rate it ≥7, last played in March, plays in 60 minutes at four players). Around it:
the bridging query (which game is adjacent to what the new player already loves —
gateway drug as graph distance); and after the night, the `Play` edge appends —
winner, duration verdict, "never again" notes — so the matchmaker compounds session
after session and the group's taste becomes a documented artifact.

## Why RelateDB

The whole collection's history — plays, ratings, verdicts — is one
`.cl` file a household shares (git, NAS, or just emailed around): the group's taste
as a portable artifact no app owns, with the BGG-import layer keeping the catalog
rich without any of it living in someone's cloud account. The night's query must be
instant — in-memory, sub-second, run on the phone in the shelf room (WASM build,
zero install for the friend who "doesn't install things"). Temporal types carry the
play history (the six-month filter is a native time window, not a date-math hack),
the WAL takes the two-minute post-game entry ritual (one `Play` edge appended, never
a rebuild), and the Python bindings ingest BGG's XML API (collection, plays,
ratings) plus its community dataset for taste-similarity edges. And `serve --http`
at game night makes the pick a shared screen moment — candidates with reasons, the
table votes.

## What it needs

- The BGG import: collection XML API (ratings, plays) + catalog metadata
(count/duration/complexity/mechanics) via Python bindings - The household
layer: players, preferences, constraints (school nights, table size, bans), the
group's play log as temporal edges
- The matcher: threshold-and-window queries that always return reasons; bridging
games for new players by taste distance

## Lineage & inspiration

- BoardGameGeek and its XML API2 + dataset — the catalog, the ratings
  corpus, and the community's obsession that proves the appetite:
  https://boardgamegeek.com/wiki/page/BGG_XML_API2
- The "shelf of shame" — the community's own term for the bought-
never-played backlog this project explains rather than mocks
- Gateway-game culture — the bridging query's thesis: people enter the hobby through
games adjacent to what they already love
