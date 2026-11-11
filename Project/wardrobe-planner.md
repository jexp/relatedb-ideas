---
type: Project
name: wardrobe-planner
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/Cladwell]]"
MENTIONS_PERSON:
  - "[[Person/Susie Faux]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Wardrobe Planner

> Items, colors, occasions, weather; one query.

## What

The morning question is a query nobody's closet can answer: "work outfit, 12°C, rain
likely, using the navy blazer, nothing in the wash." This project models the
wardrobe as a graph: `(:Item {type, colorHex, warmth,
formality})-[:PAIRS_WITH]->(:Item)` — pairs edges learned from your own worn history
and color theory alike — plus `(:Occasion)`, `(:Weather {temp})`, and the temporal
layer: `(:Worn {on})` edges that make outfit history first-class. The one-query
morning returns an outfit: items satisfying occasion and weather constraints,
connected by pairs edges, excluding anything worn in three days or sitting in the
laundry basket.

Beyond the morning, the graph answers wardrobe-management questions nothing else
answers honestly: coverage analysis (which bottoms pair with fewer than two tops —
the bottleneck item; the capsule-wardrobe test as a connectivity check); redundancy
(three black sweaters ranked by how interchangeable they actually are); gaps
("formal options for warm evenings: two, both worn recently"); and the archaeology —
what you actually wear vs. what you own, the utilization report, as a temporal
query. Travel mode packs a suitcase as a subgraph selection: n days, one climate,
maximal outfit combinations per garment carried.

## Why RelateDB

The wardrobe is one private `.cl` file — body measurements, what you
own, what you wore are not cloud data, and the morning query should not depend on a
server being up: the phone (WASM build or a C-ABI mobile wrapper) runs it offline in
the closet, sub-second, in-memory. `PAIRS_WITH` is the model: color theory seeds it
as computed edges, worn history validates them — one graph holding both, never a
second source of truth. Temporal types carry worn-on and laundry-cycle state
natively. The `(:Worn)` history rides the WAL — log the outfit in two seconds at the
door, never rebuild — and the Parquet checkpoint keeps the store open and
inspectable. Python bindings ingest closet catalogs (colors from pixel sampling,
warmth from garment specs), and the utilization and coverage reports are the kind of
aggregate Cypher does over a whole life-history in one statement.

## What it needs

- The item model: type/color/warmth/formality, with occasion and
  weather as constraint dimensions
- Pair-edge learning: seeded from color theory, refined from worn-
  history evidence (what you actually combine)
- The morning query as a product: constraints in, outfit path out,
  laundry and recency filters included

## Lineage & inspiration

- The capsule wardrobe method (Susie Faux) and Project 333 — the
  minimal-coverage philosophy the coverage query formalizes:
https://unfancy.com/
- Color theory for pairing rules — the complementary/analogous wheel
that seeds `PAIRS_WITH` before personal evidence exists
- Cladwell and the outfit-combinatorics apps — proof of demand for algorithmic
morning dressing, all subscription-shaped where this is
  a file you own
