---
type: Project
name: conflict-of-interest-finder
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/OCCRP]]"
  - "[[Company/Senzing]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: borrows the OCCRP Aleph entity/relationship cross-dataset joining model
    target: "[[Project/aleph-in-a-journalists-pocket]]"
USES_TECH:
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
---

# Conflict-of-Interest Finder

> Join two public registers (research funding + guideline authors) and run one
> query; the story is the intersection.

## What

The classic conflict-of-interest story is two lists that nobody joined:
pharma funding disclosures on one side, the author panels of clinical
guidelines on the other. The story — the guideline author whose own cited
paper was funded by the company whose drug the guideline favors — lives
entirely in the intersection, and the intersection is a graph question.

This project makes the join a one-liner. Two public registers, each loaded as
its own subgraph (Researchers, Institutions, Funders, Papers; Guidelines,
Panels, Recommendations, Citations), bridged by identity nodes for the people
who appear in both. Then the story query: `MATCH (a:PanelAuthor)-[:AUTHORED]->
(g:Guideline)-[:CITES]->(p:Paper)<-[:FUNDED]-(f:Funder)-[:FUNDED]->(a)
RETURN a, g, p, f` — guideline authors citing their own industry-funded work,
with funding amounts and dates on the edges. Related angles fall out too: the
reviewer who is a competitor of the first author; the panel whose shared
funder connects six of nine members; the recommendation whose supporting
citations share one funding source.

Every result is a path, so every result is a diagram for the story — and
because both registers are public, the whole thing is FOIA-free and defensible.

## Why RelateDB

The load is two modest tabular sources — the `pull`-style CSV import lane —
and after the join, every question is a bounded multi-hop traversal, which an
in-memory Cypher engine answers in milliseconds, so a reporter can run a
dozen angles on a Tuesday afternoon. The single-file store is the credibility
wrapper: both registers, the person-resolution links, and every
disambiguation write in one `.cl` file the fact-checker opens and re-runs —
the WAL records exactly what was merged and when. Temporal types let "funded
*during* the authorship window" be a date predicate, and nothing ever needs
a cloud: public registers joined on a laptop, shareable as a WASM file exhibit.

## What it needs

- Register loaders: research-funding disclosures (pharma payment registers,
  national grant registries) and guideline-author/COI sources (per-field;
  often PDF-shaped, alas)
- Person identity resolution across registers — the honest hard part; a
  hand-curated `SAME_AS` bridge layer with provenance
- The story query gallery: self-citation with own funding, shared-funder
  panels, competing-reviewer paths; Mermaid export of the result path

## Lineage & inspiration

- [Senzing + Kuzu entity-resolved knowledge graphs](https://blog.kuzudb.com/post/entity-resolved-knowledge-graphs/)
  — "bring your messy records, get a queryable entity graph"; exactly this
  project's join problem, demonstrated on an embedded engine
- [OCCRP Aleph](https://aleph.occrp.org/) — the entity/relationship
  cross-dataset joining model
- [GIJN training materials](https://gijn.org/stories/power-social-network-analysis-investigative-journalism/)
  — the newsroom-methods frame this tool slots into
