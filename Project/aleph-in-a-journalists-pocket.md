---
type: Project
name: aleph-in-a-journalists-pocket
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/DARC]]"
  - "[[Company/ICIJ]]"
  - "[[Company/OCCRP]]"
RELATED_IDEA:
  - kind: variant
    reason: explicitly the dataset-first cousin of the same investigative-graph play
    target: "[[Project/icij-in-a-browser-tab]]"
  - kind: complements
    reason: the claims layer that sits on top of the entity graph
    target: "[[Project/the-fact-check-engine]]"
USES_TECH:
  - "[[Technology/Aleph]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Elasticsearch]]"
  - "[[Technology/FollowTheMoney]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/OpenAleph]]"
  - "[[Technology/RelateDB]]"
---

# Aleph in a Journalist's Pocket

> OCCRP's Aleph — now open-sourced as OpenAleph — is the investigative
> platform: documents, entities, cross-search. The embedded play: its data
> layer beside a local RelateDB for the no-server investigator workflow.

## What

OCCRP's [Aleph](https://aleph.occrp.org/) is what cross-border investigative
journalism actually runs on: a platform that ingests leaked and public
document sets, extracts entities, and lets reporters cross-search everything —
companies, people, documents, and the relationships between them. Its
open-sourcing as [OpenAleph](https://github.com/alephdata/aleph) changed the
game for small newsrooms and solo reporters: the platform itself is no longer
hosted-service-only.

The embedded play: OpenAleph's document store and entity extraction paired
with a **local RelateDB** as the graph layer — the reporter's laptop holds
the investigation (entities, relationships, source documents as first-class
nodes with provenance), offline, shareable as one `.cl` file with a colleague.
The Aleph-derived entities land in the graph; cross-search queries that the
platform sends over an API become local Cypher — and the graph can hold
relationships Aleph does not model (the reporter's own drawn conclusions,
with source citations on every edge).

The graph plumbing upstream is closer than it looks: OpenAleph is now an
independent, MIT-licensed fork of Aleph maintained by the Data and Research
Center (DARC), running the FollowTheMoney schema over an Elasticsearch stack
with a REST API, an ingest-file pipeline (documents, emails, audio/video
transcription), and NLP entity extraction. And FollowTheMoney already ships
graph exports: `ftm export-cypher` streams a Cypher load script for
Neo4j/Memgraph — but the FtM docs candidly flag the modeling gap this project
must solve: FtM edges carry no properties, so Ownership and Membership
"contract" into edges to keep their metadata. The adapter's job is defined:
map FtM's contracted schemas back to relationship nodes carrying provenance,
instead of flattening them again.

## Why RelateDB

An investigation is exactly the shape RelateDB is built for: one researcher
(or a small team), sensitive data that must stay local, entity-relationship
questions, and a server as a liability — both operationally and for source
protection. The single `.cl` file is the hand-off between reporters (and the
archival artifact); the WAL is the investigation's edit history; `serve --http`
makes a quick interactive session when two reporters sit together; hybrid
search finds entities by meaning across extracted names in a dozen
transliterations. See [ICIJ in a Browser Tab](icij-in-a-browser-tab.md) for
the dataset-first cousin and [The Fact-Check Engine](the-fact-check-engine.md)
for the claims layer that sits on top.

## What it needs

- An OpenAleph export adapter (its entities and relationships → typed
  RelateDB nodes/edges with document provenance) — follow FtM's
  edge-contraction convention (Ownership/Membership as edge-carrying
  schemas) so provenance survives the mapping
- OCR'd source documents as nodes (the fs-to-graph / lab ingestion for the
  raw document sets)
- Entity-resolution tooling for cross-set matching (see [Entity Resolution
  (MDM)](../README.md#use-case-gallery) in the gallery); the
  followthemoney-graph precedent (FtM + NetworkX) is the reference

## Lineage & inspiration

- [Aleph](https://aleph.occrp.org/) — OCCRP's investigative platform; the [Aleph docs](https://docs.aleph.occrp.org/developers/followthemoney/ftm/) on its FtM model
- [OpenAleph](https://openaleph.org/) — the independent fork maintained by DARC: the [FAQ](https://openaleph.org/faq/), the [architecture overview](https://openaleph.org/docs/dev-admin-guide/104/architecture/), and the [ingest-file pipeline](https://openaleph.org/docs/lib/ingest-file/pipeline/)
- [FollowTheMoney network graphs](https://followthemoney.tech/docs/graphs/) — `ftm export-cypher` (Neo4j/Memgraph) and `export-gexf`; the schema's edge-property caveat is this adapter's inherited decision
- [opensanctions/followthemoney-graph](https://github.com/opensanctions/followthemoney-graph) — FtM entities merged into a NetworkX graph, the entity-resolution companion
- The [ICIJ Datashare](https://github.com/ICIJ/datashare) precedent — ICIJ integrated Neo4j into their local tool; RelateDB is the no-server version of that same integration
- OCCRP's Solr/Neo4j heritage in `research/graph-world.md` (the Aleph entries)
