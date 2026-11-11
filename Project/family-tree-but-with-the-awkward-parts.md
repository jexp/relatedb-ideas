---
type: Project
name: family-tree-but-with-the-awkward-parts
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/FamilySearch]]"
  - "[[Company/Gramps]]"
RELATED_IDEA:
  - kind: variant
    reason: lineage and remarriage modeling applied to a fictional canon
    target: "[[Project/franchise-genealogy]]"
  - kind: complements
    reason: that resolves the people, this keeps their awkward temporal structure
    target: "[[Project/gedcom-importer-merger]]"
  - kind: complements
    reason: dated movement and family edges as a temporal historical graph
    target: "[[Project/history-as-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GEDCOM]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Splink]]"
  - "[[Technology/WASM]]"
---

# Family Tree, But With the Awkward Parts

> Real genealogy with remarriages, adoptions, migrations as temporal
> edges; "are we related, and how?"

## What

Real families are not trees, and every tree-shaped tool lies about it. The
awkward parts are structural: remarriages that make half-siblings, adoptions
that make two sets of parents, migrations that split a family across countries
and spellings, pedigree collapse when cousin marriages loop the tree back on
itself. This project models it as what it is — a temporal graph. `(:Person)-
[:PARENT_OF {kind: biological | adoptive | step, since}]->`,
`(:Person)-[:MARRIED {from, to}]-` with explicit end dates,
`(:Person)-[:MIGRATED {year}]->(:Place)` — and derives the rest: half-siblings
are two `PARENT_OF` edges sharing exactly one parent; step-relations are a hop
through a marriage, not a bloodline; "related" is a path query whose answer
*names its route*.

The DNA-match era makes this load-bearing: "this match shares 340 cM
— through grandmother's first marriage or her second?" should return candidate
paths with the relationship label on each. Queries that embarrass tree tools
are routine here: every ancestor appearing twice in my tree (collapse, loops
included); the migration timeline of one surname 1870–1930 as a movement graph;
who stayed in the village and who left — the diaspora view a reunion wants.

## Why RelateDB

Path queries are the product — "how are we related" needs variable-
length traversals with labels, the exact thing tree tools cannot
express and Cypher exists for. Native temporal types carry marriage
spans, adoption dates and migration windows, so "as of 1912" family structure
is a filter rather than a reconstruction — the remarriage question only makes
sense time-scoped. The store is one `.cl` file, private on the researcher's
laptop, shareable as one attachment, openable in a browser tab (WASM) by
relatives who will never install software. The WAL accepts an evening's
corrections incrementally, and Python bindings make the GEDCOM/birth-register
scrapers plain scripts. It composes with the GEDCOM Importer & Merger — that
resolves the people; this keeps their awkward structure.

## What it needs

- The temporal relationship model: typed `PARENT_OF`, dated `MARRIED`,
  `ADOPTED`, `MIGRATED` edges with start/end validity on all of them
- Derived-relationship helpers: half/step/in-law resolution as query
  functions that label each path they return
- DNA-match integration: cM ranges → candidate relationship paths,
  annotated with confidence

## Lineage & inspiration

- GEDCOM 5.5.1/7.0 (FamilySearch) — the import format whose `FAMC`/
`ADOP` pegs prove even the standard expects the awkward parts:
  https://gedcom.io/
- Gramps' relationship types — the open-source world's most honest
  family model to align with: https://gramps-project.org/wiki/
- Splink's probabilistic linkage for DNA-match candidate generation
  (research/embedded-ecosystems.md):
  https://github.com/moj-analytical-services/splink
