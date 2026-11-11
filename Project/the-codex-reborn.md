---
type: Project
name: the-codex-reborn
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Historical Network Research]]"
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Rik van Bruggen]]"
RELATED_IDEA:
  - kind: complements
    reason: cited for the layered source/annotation/interpretation graph
    target: "[[Project/dark-style-multiverse-storage]]"
  - kind: complements
    reason: cited as the political-diplomacy cut of the same modeling
    target: "[[Project/history-as-graph]]"
  - kind: complements
    reason: cited as the community and craft for this class of work
    target: "[[Project/the-hnr-humanities-pack]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
---

# The Codex, Reborn — an Atlas of History

> Events, locations, and people extracted from annotated historical sources — a
> project abandoned when Neo4j proved too heavy for it. The resurrection pitch
> writes itself.

## What

Iian Neill's Codex was an Atlas of History: a graph built from annotated
historical sources, connecting **events**, **locations**, and **people** —
who was where when, what connected to what, sourced from real historiography
rather than cleaned datasets. It was [abandoned in 2016 when the weight of
running Neo4j for it outweighed the project](https://blog.bruggen.com/2016/02/podcast-interview-with-iian-neill-codex.html)
— the classic case of a humanities project that needed a graph engine but
could not carry a server.

The reborn Codex is a research workbench: an annotated corpus (letters,
chronicles, charters, gazetteers) processed into a provenance-carrying graph
— every relationship carries its source: which document, which page, which
editor's annotation. The questions the original wanted: which places did
this person's network touch? Which events connect two regions? Where do two
independent sources disagree about the same event (conflicting dates,
locations, participants) — historiographical disputes as structural
features of the graph, not errors to clean away.

Everything the pitch leans on verifies. The Bruggen interview (12 February 2016)
survives online: Iian Neill, an ASP.NET developer with an art-history background,
describing the Codex as "an atlas of history" — "X meets Y at Place Z" events,
people, places, subject tags, hierarchical taxonomies, optional quantities —
built on Neo4j with the C# client. The gazetteer precedents are live services:
Pleiades (with a places API) and the Pelagios linked-data model for annotating
places in texts, plus Trismegistos data services for the ancient world. And Six
Degrees of Francis Bacon — CMU's reconstruction of early-modern social networks
from the ODNB — is the flagship for exactly this class of graph: a statistical
reconstruction method published in DHQ, downloadable CSV data, a crowdsourced
site.

## Why RelateDB

This is the project RelateDB is *for* — the exact shape that died of
server-weight: one researcher, one laptop, a lifetime's annotated corpus,
zero infrastructure. The single `.cl` file makes the atlas shareable with
other historians and archivable as a research artifact; the WAL + Parquet
durability carries years of curation work; `relate serve` turns a
personal research corpus into a classroom or conference demo in one
command. Temporal types handle period dating (including uncertain/
ranged dates, encoded as properties); the point types hold historical
place coordinates against a gazetteer layer.

## What it needs

- An annotation format: document passages → typed edges with citation
  properties (source, page, editor, confidence)
- Gazetteer import (historical place names with modern coordinates —
  e.g. the Pelagios/Trismegistos model)
- Uncertainty-as-data: conflicting attestations as parallel edges kept
  and queried, not reconciled away
- The layered-graph idea (see [Dark-Style Multiverse Storage](dark-style-multiverse-storage.md)):
  source layer, annotation layer, interpretation layer

## Lineage & inspiration

- [The Codex podcast interview (Rik van Bruggen's blog, 2016)](https://blog.bruggen.com/2016/02/podcast-interview-with-iian-neill-codex.html) — the original project and why it stopped
- [The Codex – an Atlas of Relations (ZfdG Sonderband 4, 2019)](https://zfdg.de/sb004_008)
  — Iian Neill & Andreas Kuczera's scholarly writeup: the architecture the
  reborn project must honor — standoff properties connecting a plain text
  stream to the graph (annotations survive text edits in real time), and
  freely overlapping, commentable annotations carrying *multiple
  interpretations* with every claim traceable to its exact text source
- [Codex: 2019 (video)](https://www.youtube.com/watch?v=nZ64XAUcrnc) — the
  original experience in motion: what the OG actually felt like to edit and
  explore in
- [Demo of the Codex Control Panel (video)](https://www.youtube.com/watch?v=FZjlNonvOcA)
  — the working UI on tape: the control panel demo of the original system
- [Historical Network Research](https://historicalnetworkresearch.org/) — the community doing exactly this class of work (see [The HNR Humanities Pack](the-hnr-humanities-pack.md))
- Pelagios / Trismegistos — the gazetteer and annotation precedents in digital
  humanities: Pleiades (with a places API): https://pleiades.stoa.org/ and
  https://api.pleiades.stoa.org/ | Trismegistos data services:
  https://www.trismegistos.org/dataservices/ | Pelagios LOD tools:
  https://pelagios.org/lod/tools-resources
- The [Six Degrees of Francis Bacon](https://sixdegreesoffrancisbacon.com/) —
  reconstructed early-modern social networks from the ODNB; the method paper:
  https://dhq.digitalhumanities.org/vol/10/3/000244/000244.html
- [Building graph history: the Codex](https://neo4j.com/blog/graph-data-science/building-graph-history-codex/)
  — the documented craft of the original: how edges were dated, how
  as-of-history views were built (and see
  [History as Graph](history-as-graph.md), the political-diplomacy cut of
  the same modeling)
