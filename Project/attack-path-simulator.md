---
type: Project
name: attack-path-simulator
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/FalkorDB]]"
  - "[[Company/MITRE]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/FalkorDB]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/Joern]]"
  - "[[Technology/MITRE ATT&CK]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/STIX]]"
  - "[[Technology/TAXII]]"
---

# Attack-Path Simulator

> MITRE ATT&CK techniques + your asset inventory; purple-team drills as graph
> queries, red-team findings as paths.

## What

Model your environment the way an attacker sees it: assets (hosts, identities,
services, credentials, data stores) as nodes, and *reachability* — network
exposure, trust relationships, credential reuse, execution rights — as
relationships. Overlay the MITRE ATT&CK matrix as technique nodes with
precondition/effect edges, and an attack path becomes a literal Cypher path:
`MATCH path = (entry:Asset {internet_facing: true})-[:ALLOWS*]->(crown:Asset {classification: 'crown_jewel'}) RETURN path`.

Purple-team drills turn into query authorship: "show me every path from the
DMV-exposed web tier to the database credentials" is one statement, not a
spreadsheet exercise. Red-team and pentest findings land as `:EXPLOITED`
edges with technique IDs and timestamps, so the same query that simulated the
attack later reports what was actually exercised — and what is still open.

The simulator is replayable: each drill writes its findings to the WAL, so you
can diff posture between engagements, or answer "which paths did we close
since Q1, and which did we open by adding that new service?"

## Why RelateDB

Path queries are the whole product — the ATT&CK overlay is pure Cypher
traversal, and in-memory scans make interactive "what if we segment this
VLAN?" what-if edits instant. The single `.cl` file makes an environment model
portable: a consultant can carry the client's posture graph, or a red team can
ship the drill results back as one attachment. WAL + Parquet checkpoints give
audit-grade history of every drill. `relate serve --bolt` lets existing
security tooling that speaks Bolt join in, and `--mcp` lets an analyst agent
run drills conversationally. Nothing sensitive ever leaves the laptop —
unlike every cloud-hosted attack-path SaaS.

## What it needs

- Asset-inventory loaders: k8s manifests, AWS/GCP/Azure resource exports,
  nmap/XML, AD/LDAP dumps, service catalogs
- A MITRE ATT&CK data loader (the STIX/Navigator TAXII feeds are the source)
  mapping techniques to precondition/effect edge types
- A path-visualization front end over Bolt/HTTP/WASM (the `db.schema.visualization`
  options map is the template for interactive subgraph views)
- Drill-result schema: `:FINDING` nodes with technique, timestamp, operator
- Policy queries library: canned "top 10 exposed paths" reports

## Lineage & inspiration

- [GUAC](https://github.com/guacsec/guac/) — supply-chain posture as one
  queryable graph; the same discipline applied to infrastructure
- [FalkorDB DepGraph](https://github.com/FalkorDB/DepGraph) — attack-path
  queries over package dependency graphs in an in-memory graph DB
- [MITRE ATT&CK](https://attack.mitre.org/) and ATT&CK Navigator — the
  technique matrix this simulator overlays
- [Joern](https://github.com/joernio/joern/) — vulnerability patterns as graph
  queries over code property graphs (see
  [research/graph-world.md](../research/graph-world.md) §6)
