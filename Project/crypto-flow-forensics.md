---
type: Project
name: crypto-flow-forensics
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Chainalysis]]"
  - "[[Company/Elliptic]]"
  - "[[Company/ICIJ]]"
  - "[[Company/TRM Labs]]"
RELATED_IDEA:
  - kind: complements
    reason: append-only ledger events replayed as timestamped graph edges
    target: "[[Project/event-stream-to-temporal-graph]]"
  - kind: inspired-by
    reason: same case-file-as-one-local-artifact discipline applied to a different corpus
    target: "[[Project/icij-in-a-browser-tab]]"
USES_TECH:
  - "[[Technology/BigQuery]]"
  - "[[Technology/Bitcoin]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Ethereum]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Crypto Flow Forensics

> Import a slice of Bitcoin/Ethereum transactions around a wallet; trace
> laundering paths, cluster mixing services, follow the money — offline, on
> the analyst's laptop.

## What

Chain forensics tools are expensive, cloud-hosted, and watch every query you
run. This project inverts that: an analyst exports a slice of the public
ledger — every transaction within k hops of a wallet of interest — and imports
it into a graph of Wallets and Transactions (`(a:Wallet)-[:SENT {amount, ts}]
->(t:Tx)`), tagged where public attribution data exists. Then everything runs
on the analyst's laptop, offline, with no query telemetry.

The analysis is pure Cypher: find every path from the suspect wallet to any
exchange deposit address within six hops; compute the fan-out where funds
split into a thousand dust outputs (the mixer's signature); find the wallets
that always receive from the mixer and always pay to one exchange
(`MATCH (m:Wallet {tag:'mixer'})-[:SENT]->()<-[:SENT]-(w)-[:SENT]->(x)
RETURN w, count(*) ORDER BY count(*) DESC`); replay the story over time with
the temporal types on every edge — the money moved in lockstep with the hack.

The session is an iterative funnel: start with one address, expand two hops,
tag what you recognize, keep querying — each pass is one query and one
write-back of the tags, in milliseconds, in a plane, on battery.

## Why RelateDB

Wallet-anchored slices are millions of edges, which is small for an in-memory
engine: variable-length path and aggregation queries over that subgraph run at
scan speed, so the trace loop (query, tag, expand) is interactive rather than
overnight. Sensitivity is the other half — an investigation whose subject can
see the queries being run is compromised, and RelateDB never leaves the
machine: the store is one local `.cl` file, no cloud account, no third-party
API after the initial export. Temporal types on every edge make "funds that
moved in this 48-hour window" a property predicate, and when a colleague needs
the case file, the store *is* the handoff — one file with data and tags.

## What it needs

- A slice exporter: wallet-anchored BFS over a block explorer API (or a local
  node / public BigQuery-style ledger dump) → transaction edges with amounts
  and timestamps
- Entity-tag import: known exchange/mixer/sanction tags from public
  attribution lists, applied as node labels or properties
- A flow query gallery: fan-out detection, path-to-exchange, lockstep timing
  windows, recurring counterparties
- Optional: a WASM browser view for sharing a read-only case file with an
  editor or prosecutor

## Lineage & inspiration

- Chainalysis / TRM / Elliptic-style tracing — the workflow this democratizes
  (without the proprietary label set; public attribution lists only)
- Public ledger data itself — Bitcoin/Ethereum transactions as the canonical
  append-only value-flow graph, freely exportable
- The ICIJ in a browser tab project — the same "case file as one artifact,
  nothing in the cloud" discipline for a different corpus
