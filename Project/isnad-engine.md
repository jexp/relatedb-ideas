---
type: Project
name: isnad-engine
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_PERSON:
  - "[[Person/Recep Senturk]]"
RELATED_IDEA:
  - kind: complements
    reason: the same narrator identity-resolution craft across name variants and collections
    target: "[[Project/gedcom-importer-merger]]"
  - kind: complements
    reason: "the modern cousin: chain-of-custody and provenance over claims"
    target: "[[Project/the-fact-check-engine]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
  - "[[Technology/WASM]]"
---

# The Isnad Engine

> Hadith transmission science is 1,200 years of narrator-reliability graph
> analysis — chains of transmitters, per-narrator ratings, cross-checked
> for anomalies — still done today with books and spreadsheets. As a
> graph, with the tradition's own questions as queries.

## What

An isnad is the chain of transmission of a reported tradition: A heard from
B, who heard from C, back to the source. Classical Islamic scholarship
built an entire evaluative science on these chains: *ilm al-rijāl* ("the
science of the men") — biographical evaluation of every narrator
(reliability, memory, contemporaneity with their teachers) — and
chain-criticism methods that detect anomalies: a narrator receiving from
a teacher who died before he was born, chains too perfect to be plausible,
transmitters who never met. This is entity resolution, trust propagation,
and temporal consistency checking — on a millennium-old tradition that
did it by hand, at scale (hundreds of thousands of reports, tens of
thousands of narrators).

Modern scholarship is catching up with network methods (Recep Şentürk's
*Anatomy of the Hadith Transmission Network* and the recent SNA papers),
but the tooling is bespoke scripts over static extracts. This project is
the engine for that science:

- `(:Narrator {name, dates, ratings, sect, region})` and
  `(:Report)-[:HAS_CHAIN]->(:Chain)-[:LINKS]->(Narrator)`, with the
  classical ratings as properties from the biographical dictionaries
- The tradition's own checks as queries: contemporaneity violations
  (temporal), "hidden" transmitters, rare-routes vs. mass-transmitted
  chains, common-link analysis (the shared-prefix structure Şentürk
  mapped)
- Cross-collection work: the same report in Bukhari, Muslim, and the
  Shia collections — same-chain dedup and divergence analysis, the
  entity-resolution problem again
- Trust computation: weighted propagation over narrator ratings — the
  PageRank-style question the tradition asked first, stated as a query

## Why RelateDB

The corpus (narrator biographies + chain indices) is public-domain
scholarship, spreadsheet-sized by database standards, and deeply
temporal/multi-relational — the profile where one `.cl` file serves a
research field: citable, shareable, WASM-browsable. The questions are
path queries, temporal predicates, and entity resolution — the engine's
core competencies aimed at a domain the graph industry has never entered.
And the field's own methodology (ratings on narrators, routes, and
collections) maps onto properties and edges without forcing anything.

## What it needs

- The corpus loaders: chain indices from the major collections plus
  the biographical dictionaries (gradually, honestly — start with one
  collection's chains and its narrators' ratings)
- The query pack: the classical checks (contemporaneity, common-link,
  route frequency), each stated with its classical source
- The dedup layer: narrator identity resolution across name variants and
  collections (the GEDCOM problem, properly)
- A scholar's guide: the queries named in the tradition's own vocabulary

## Lineage & inspiration

- [Narrative Social Structure: Anatomy of the Hadith Transmission
  Network (Şentürk, 1998)](https://archive.org/stream/RecepSenturk1998/Narrative%20Social%20Structure%20-%20Anatomy%20of%20the%20Hadith%20Transmission%20Network%2C%20CE%20610-15005%20-%20Recep%20Senturk%20%28PhD%2C%20Columbia%2C%201998%29_djvu.txt)
  — the foundational network anatomy
- [Social network analysis of Hadith narrators](https://www.sciencedirect.com/science/article/pii/S1319157821000215)
  and [SNA of narrators from Sahih Bukhari](https://doi.org/10.1109/besc51023.2020.9348299)
  — the modern methods this project generalizes into a query engine
- The *ilm al-rijāl* biographical tradition ([methods overview](https://www.jcois.uobaghdad.edu.iq/index.php/2075_8626/article/download/2556/1881/8328))
  — the twelve-century-old evaluator science whose checks become queries
- [GEDCOM Importer & Merger](gedcom-importer-merger.md) — the same
  identity-resolution craft; [The Fact-Check Engine](the-fact-check-engine.md)
  — the modern cousin (chain-of-custody over claims)
