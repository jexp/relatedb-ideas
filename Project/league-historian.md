---
type: Project
name: league-historian
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
  - "[[Technology/WASM]]"
---

# League Historian

> Fantasy-sport trades and matches as a temporal graph.

## What

Every fantasy league has a decade of lore in scattered screenshots: the 2019
heist, the draft-day reaches, the waiver-wire gem, the championship drought
that defined a friendship. This project stores it as the graph it already is:
`(:Manager)-[:TRADED {at, assets}]->(:Manager)`, `(:Player)- [:DRAFTED_BY
{season, pick}]->`, `(:Team {season})-[:STARTED]-> (:Player {week})`,
`(:Matchup {week})-[:BETWEEN]->(:Team)`, keepers carrying across seasons — the
whole thing temporal, because league memory is year-shaped.

The queries are the trash-talk receipts: the all-time trade ledger
("who has fleeced whom, net asset value per manager, ever"); your
rival's drafting habits ("the three players he's reached on in the first round
for three years — and how each ended"); trophy drought timelines; the single
week that decided the 2022 title (computed, not argued — which lineup decision
moved the most projected points); and the lore objects — longest losing streak,
biggest upset by projected margin, most-traded player in league history. Plus a
Hall of Fame ballot generated from the graph — the fantasy equivalent of the
franchise museum.

## Why RelateDB

A league is one `.cl` file — the entire history, all seasons, all
managers — that the commissioner emails around at the draft, opens on
a laptop at the draft table (WASM: zero install for the guy who
"doesn't do software"), and that next year's commissioner inherits as
a file, not an account: the portability is the succession plan
commercial platforms will never give you (export your league from
Sleeper/ESPN, own it). Ingest rides the Python bindings against the platform
APIs; temporal types carry seasons/weeks natively, so "as of week 12, 2023" is
a filter; the trade ledger and matchup queries are exactly the aggregations
Cypher does in one statement over a whole league's life. The WAL is the weekly
ritual: results append after each week, the history compounding without a
rebuild. And `serve --http` at the draft table makes the lore queries part of
the event — "before you pick, check his first-round history."

## What it needs

- Ingest from Sleeper/ESPN/Yahoo fantasy APIs via the Python bindings (draft
results, transactions, weekly lineups and matchups) - The temporal model:
seasons, weeks, keeper edges across years, the
  trade ledger with asset annotations
- The receipt pack: net trade value, drafting-habit profiles,
  championship-deciding weeks (computed, cited), droughts and streaks

## Lineage & inspiration

- Sleeper's open API — the friendliest fantasy data source and the
  natural first ingest: https://docs.sleeper.app/
- ESPN and Yahoo fantasy APIs/scrapers — the remaining platforms to
  round out the imports
- Trade-analyzer culture (keeptradecut, dynasty-trade calculators) —
  the appetite for valuation receipts this project stores honestly
