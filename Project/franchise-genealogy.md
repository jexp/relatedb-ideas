---
type: Project
name: franchise-genealogy
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/Fandom]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: the lineage-plus-events version of that single-book centrality exercise
    target: "[[Project/a-song-of-ice-and-fire-queried]]"
  - kind: variant
    reason: the same character-graph genre expanded to lineages, oaths and eras
    target: "[[Project/every-character-network-ever]]"
  - kind: variant
    reason: real genealogy typed kinship modeling applied to fictional houses
    target: "[[Project/family-tree-but-with-the-awkward-parts]]"
  - kind: complements
    reason: its entity-resolution and merge pattern handles wiki re-import churn
    target: "[[Project/gedcom-importer-merger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Franchise Genealogy

> Family trees for fictional universes at franchise scale: Tolkien's
> lineages, Dune houses, the Godfather clans — "how are Fëanor's
> descendants related to Melkor's lies?" as one query.

## What

Fandom genealogy tools stop at the tree. This project models the full
thing: `(:Character)-[:CHILD_OF]->(:Character)` for the lineages, plus
`(:OATH {era})`, `(:ALLEGIANCE)`, `(:BETRAYED {when})`, `(:MARRIED)` —
the genealogy *and* the event web it lives in, because the interesting
questions are always how lineage interacts with lies, oaths and wars.
Characters carry era appearances, so "how are Fëanor's descendants
related to Melkor's lies?" is a path query from a lineage subgraph into
an event subgraph, filtered by age. The scale is the franchise: the
Silmarillion, the Atreides/Harkonnen/Corrino web across Dune's
millennia, three generations of Corleones. Fandom's arguments become
runnable — every Oath-bound descendant of Fëanor; which houses won
thrones by marriage vs. betrayal, per era; whether Tom Hagen is more
structurally central than the blood family — the *Network of Thrones*
question for houses and oaths instead of scenes.

## Why RelateDB

The whole universe fits in one `.cl` file a fan emails to another fan
— no server, no install ritual, the exact barrier that killed every
past community lore graph. The WASM build makes it a browser tab: open
the file, query the lore, argue with receipts. Fandom wikis are messy
and revised — MERGE-keyed incremental import handles the churn while
the WAL keeps local corrections. Temporal types carry ages and eras
(the Third Age is a filter, not a column). And `relate serve --mcp
stdio` turns the curated file into an agent's lore oracle: fan bots
answer "who is Elrond's brother, again?" from the actual graph with
provenance instead of hallucinating.

## What it needs

- Wiki importers (LOTR Gateway, Dune Wiki, Godfather Wiki) into the
  shared person/oath/event model with MERGE keys
- Era- and lineage-aware query pack: descendants-of, oath-bound,
  allegiance shifts, marriage-vs-betrayal power queries
- Diff/merge for re-import (wiki revised, local corrections kept) —
  the GEDCOM merger's entity-resolution pattern
- A WASM front end, plus a curated seed file for one flagship
  universe (the Silmarillion first)

## Lineage & inspiration

- LOTR Gateway's genealogy pages — the canonical Tolkien trees:
  https://lotr.fandom.com/wiki/Family_trees
- The Dune Wiki house/family web (Atreides, Harkonnen, Corrino):
  https://dune.fandom.com/wiki/Houses
- A Song of Ice and Fire, Queried (this collection) — centrality over
  time for one book; this is the lineage-plus-events version
- The Cornell INFO-2040 character-network genre — the class exercise
  this tooling would productize:
  https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
