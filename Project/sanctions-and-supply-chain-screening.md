---
type: Project
name: sanctions-and-supply-chain-screening
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/ICIJ]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Open Ownership]]"
  - "[[Company/OpenCorporates]]"
  - "[[Company/OpenSanctions]]"
RELATED_IDEA:
  - kind: complements
    reason: the ownership-register pipeline this screening tool would ingest
    target: "[[Project/company-ownership-rings]]"
  - kind: same-data
    reason: both build on ICIJ OffshoreLeaks ownership data
    target: "[[Project/icij-in-a-browser-tab]]"
  - kind: complements
    reason: same multi-hop reachability questions over a different supply chain
    target: "[[Project/transitive-dependency-networks]]"
USES_TECH:
  - "[[Technology/BODS]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/FollowTheMoney]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/Linkurious]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/OpenSanctions]]"
  - "[[Technology/RelateDB]]"
---

# Sanctions & Supply-Chain Screening

> Keep an embargo/ownership graph locally, screen counterparties without
> sending sensitive names to any cloud.

## What

Compliance screening has a data problem: the lists (OFAC SDN, EU/UK
consolidated sanctions, export-control entity lists) are public and regularly
updated — but the *counterparties* being screened are not. Every query against
a SaaS screening tool tells a third party who you're about to do business
with; for embargoed jurisdictions the query itself can be the violation. This
project keeps the whole screening workflow local.

The shape: sanctions lists, ownership registers, adverse-media and PEP notes,
and your own counterparty and bill-of-materials data — one local graph,
updated from published list diffs. Screening is then a graph question: is this
counterparty, or any beneficial owner through N layers, a listed entity? Is
any component of this shipment sourced from an embargoed origin or an entity
majority-owned by one? Exposure is reachability — `MATCH
path = (c:Counterparty {id:$id})-[:OWNED_BY|SUPPLIED_BY*1..5]->(e) WHERE
e:Sanctioned RETURN path`.

Because the graph joins your data with the lists, the tool also answers what
screening services charge extra for: which of my 400 counterparties became
newly exposed by this morning's list update (one query against yesterday's
checkpoint), and which supply chain has the deepest ownership opacity.

OpenSanctions has already walked the Neo4j path in public: their offshore-graph
demo repo merges the OpenSanctions Due Diligence dataset with the ICIJ
OffshoreLeaks database into one Neo4j graph — OWNERSHIP and PAYMENT edges,
four- to five-hop traversal queries, Linkurious on top — built for a 2022
webinar, with a WIP community thread on a proper FtM→Neo4j conversion
workflow behind it. The ownership side has a canonical exchange format: Open
Ownership's Beneficial Ownership Data Standard (BODS), already used for UK
register data; OpenCorporates remains the company-data backbone. The pieces
this project composes all exist — the embedded, sensitive-counterparty
workflow does not.

## Why RelateDB

The privacy pitch is structural: an embedded engine with no telemetry, no
account, no network — the store is one `.cl` file on the compliance officer's
machine and screening never leaves it. The lists plus a mid-size counterparty
portfolio and bill-of-materials are comfortably in-memory; multi-hop ownership
traversals run in milliseconds, so screening one counterparty is interactive
and re-screening the whole portfolio is a coffee break. List updates are
`pull`-style loads, and the WAL + checkpoint design makes each update a
durable, dated frame — "newly exposed since yesterday" is a query against the
previous checkpoint, and the write-log is the audit trail. The C ABI and its
wrapped clients (Python/JS/Java/Go) embed this inside an existing pipeline.

## What it needs

- List loaders for the major public regimes (OFAC SDN, EU/UK consolidated,
  export-control entity lists) with regular delta ingestion; provenance and
  list version stamped on every node
- An ownership-register loader (the Company Ownership Rings pipeline) —
  BODS as the importer's format — and a counterparty/BOM import from the
  user's own systems
- The screening query set: direct match, beneficial-owner reachability,
  supply-chain exposure, since-last-checkpoint diff — offshore-graph's
  4–5-hop Cypher as the query precedent
- Careful framing: assists screening, not a compliance program's legal determination

## Lineage & inspiration

- [GUAC (Graph for Understanding Artifact Composition)](https://github.com/guacsec/guac/) — the software-supply-chain knowledge-graph model; the same reachability questions over a different supply chain
- [OpenSanctions offshore-graph](https://github.com/opensanctions/offshore-graph/) — "Loading OpenSanctions into Neo4J and Linkurious": the sanctions + OffshoreLeaks property-graph demo this project embeds
- OpenSanctions community — the WIP FtM → Neo4j conversion workflow: https://discuss.opensanctions.org/t/wip-better-workflow-for-neo4j-data-conversion-property-graph-build-of-followthemoney/64
- [Open Ownership](https://www.openownership.org/en/topics/beneficial-ownership-data-standard/) — the Beneficial Ownership Data Standard: https://standard.openownership.org/
- [OpenCorporates](https://opencorporates.com/) — the company-data backbone of the ownership layer
- Public sanctions regimes' structured data releases (SDN files etc.) and the Company Ownership Rings / ICIJ projects — the downloadable lists and the ownership-traversal, local-artifact disciplines composed here
