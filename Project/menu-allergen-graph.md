---
type: Project
name: menu-allergen-graph
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/European Union]]"
  - "[[Company/FDA]]"
  - "[[Company/NYC Health Department]]"
RELATED_IDEA:
  - kind: complements
    reason: queries the same kitchen ingredient graph from the diner's side
    target: "[[Project/recipe-fork-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MenuStat]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Menu Allergen Graph

> Dishes, ingredients, allergens; "what can I safely eat here?" on
> your phone.

## What

Allergen safety is a graph question every restaurant answers badly: a printed matrix
at the door, a waiter asking the kitchen, a one-line "may contain" that covers
everything. The model is honest structure: `(:Dish)-[:CONTAINS]->(:Ingredient)-
[:IS_ALLERGEN {major}]->(:Allergen)`, plus cross-contact edges (shared fryer, shared
prep surface) and compound ingredients as sub-recipes — the sauce→butter→dairy chain
that text matching keeps missing. The personal profile is one node — allergens with
severity, dietary constraints as typed edges — and the restaurant (or a city's
menus) is a small graph that answers instantly.

The query is the product: "what can I safely eat here" returns the
safe subset *with reasons* (this dish traces to no allergen edge; this one only via
cross-contact — your call given severity). The inverse serves the kitchen: one
ingredient substitution (swap the peanut oil) updates every derived answer for every
profile that queries the menu — the structural point, the graph is the only model
where an ingredient change propagates by construction. And the group question: "a
table of six with three profiles — dishes that work for everyone," the
birthday-dinner query nobody solves without a spreadsheet and an argument.

## Why RelateDB

The whole point is that it runs on the phone, offline, in the
restaurant: WASM build or a C-ABI mobile wrapper, the menu as one
`.cl` file a restaurant publishes (site, door, QR code) and the
allergic diner's profile queries locally — no allergy data sent to any cloud, which
is both the privacy win and the correctness win (severe-allergy users rightly
distrust SaaS round-trips with their life). The graph is tiny and the safety
requirement absolute: in-memory traversal makes every trace-to-allergen path check
instant — and the derivation is what traversal does and what text matching provably
fails at. Python bindings ingest the menus (published, OCR'd, or straight from the
kitchen), a city mode holds them all in one pocketable store, and temporal types
matter more than they seem: "was safe last month" vs. "safe now" is a dated question
when the kitchen changes its oil supplier.

## What it needs

- The bipartite model: dish ↔
ingredient ↔ allergen with compound-ingredient sub-recipes and cross-contact
edges
- Menu ingest: published menus, kitchen-supplied catalogs, or photo/
  OCR pipelines via Python bindings
- The profile layer: personal allergens with severity, dietary
  constraints as typed filters, answers always returning their
  tracing reason

## Lineage & inspiration

- FALCPA's nine major allergens and the EU's 14-allergen regulation —
the standard taxonomies the allergen layer encodes:
https://www.fda.gov/food/food-allergens |
https://food.ec.europa.eu/safety/labelling-and-nutrition/food-information-consumers/allergen-labelling_en
- MenuStat (NYC Health Department) — the public menu corpus proving
  large menu graphs are buildable: https://menustat.org/
- The Recipe Fork Graph (this collection) — the upstream kitchen model whose
ingredient graph this project queries from the diner's side
