---
type: Project
name: gedcom-importer-merger
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/FamilySearch]]"
  - "[[Company/Gramps]]"
RELATED_IDEA:
  - kind: complements
    reason: that keeps the awkward temporal structure after this resolves the people
    target: "[[Project/family-tree-but-with-the-awkward-parts]]"
  - kind: variant
    reason: the same merge and lineage model over fictional universes
    target: "[[Project/franchise-genealogy]]"
  - kind: complements
    reason: reviewable entity resolution is the shared merge primitive
    target: "[[Project/stitch-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GEDCOM]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Splink]]"
  - "[[Technology/WASM]]"
---

# GEDCOM Importer & Merger

> The ancestry play: import standard GEDCOM exports, then merge trees
> from different relatives' research — the entity-resolution problem
> (same person, three spellings, two birth dates) as graph dedup with
> reviewable candidate matches.

## What

Every family has five relatives researching the same ancestors in five tools, each
exporting GEDCOM, each with the same person as "Johanne Geissler", "Johanna Geißler"
and "H. Geisler" — two birth dates, three places, one human. This project makes the
merge the product: import each GEDCOM into the property graph
(`(:Person)-[:CHILD_OF]->`, `(:Person)-[:MARRIED {date, place}]->`, sources and
citations as edges), then run entity resolution as a graph query — candidate matches
on fuzzy names, near dates, nearby places and matching relatives (a shared child is
stronger evidence than a shared birth year) — producing `(:Person)-[:CANDIDATE_MATCH
{score, evidence}]->(:Person)` edges awaiting a human.

The merge is reviewable and reversible: candidates are confirmed by
the user (auto-merged above a threshold, flagged below it), every merged pair keeps
provenance back to both source exports, and conflicts ("two birth dates, both
sourced") are surfaced as first-class results rather than silently resolved.

## Why RelateDB

Family data is the most private dataset most people own — it stays
local, and RelateDB is one `.cl` file with no server, no account, no
cloud; the whole merged tree emails to a cousin as one attachment and
opens in their browser tab over the WASM build, which is how you get non-technical
relatives to actually look. Temporal types carry genealogy's real date semantics
(partial dates, "before/after/about", ranges) without string hacks. The in-memory
engine makes the merge interactive: candidate scoring runs in seconds on tens of
thousands of people — the review queue is a conversation, not a batch job. Python
bindings make the parser and scorer ordinary scripts, the WAL makes the merge
incremental (a new export arrives, only new candidates surface), and the Parquet
checkpoint keeps the durable tree in an open format no vendor can orphan.

## What it needs

- GEDCOM 5.5.1 and 7.0 importers
(person/family/source/citation) with
  round-trip export for relatives still on other tools
- The match engine: fuzzy-name + date/place proximity + shared-kinship
  scoring, emitting ranked `CANDIDATE_MATCH` edges
- A review UI: candidate queue, side-by-side evidence, confirm/reject/
  merge with provenance kept

## Lineage & inspiration

- The GEDCOM specification — 5.5.1 and the 2022 7.0 rewrite
(FamilySearch): https://gedcom.io/ | https://gedcom.io/spec/gedcom70/
- Gramps — the open-source genealogy app whose data model and export
round-trips prove the import surface: https://gramps-project.org/
- Splink — probabilistic record linkage at scale, the matching engine
to borrow (research/embedded-ecosystems.md):
  https://github.com/moj-analytical-services/splink
