---
type: Project
name: dependency-radar
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/FalkorDB]]"
  - "[[Company/GUAC]]"
  - "[[Company/GitHub]]"
  - "[[Company/Mimecast]]"
  - "[[Company/Sourcegraph]]"
RELATED_IDEA:
  - kind: complements
    reason: reachability paths as the shared analytical primitive
    target: "[[Project/attack-path-simulator]]"
  - kind: complements
    reason: import-site edges for true reachability come from the code graph machinery
    target: "[[Project/code-graph]]"
  - kind: variant
    reason: the same dependency graph read as structure rather than vulnerability exposure
    target: "[[Project/transitive-dependency-networks]]"
USES_TECH:
  - "[[Technology/CycloneDX]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/NVD]]"
  - "[[Technology/OSV]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SBOM]]"
  - "[[Technology/SPDX]]"
  - "[[Technology/tree-sitter]]"
---

# Dependency Radar

> Your lockfiles as a graph; CVE news arrives, one query tells you if you're
> exposed and through which path (SBOM ↔ CVE ↔ your code).

## What

Every repo you own already contains a complete dependency map: lockfiles
(Cargo.lock, package-lock, go.sum, pip freeze), manifests, and SBOMs. Parse
them into one graph per org: package nodes, `:DEPENDS_ON` edges, repo/owner
nodes above, and — crucially — `:IMPORTED_BY` edges from *your source files*
into the packages' entry surfaces. When a CVE drops, exposure is a
reachability query, not a two-week audit: `MATCH path = (v:CVE)-[:AFFECTS]->(p:Package)<-[:DEPENDS_ON*1..8]-(r:Repo {ours: true}) RETURN path` — and the
second question, "is the vulnerable function actually *called*?", is a hop
further into the code-graph edges.

The radar keeps history: CVE feeds land as nodes with publish dates, your
lockfile snapshots land with commit dates, so "were we exposed in the release
we shipped in March?" is a time-windowed query. Guilt by reachability replaces
guilt by transitivity — most CVEs in most trees are dead code, and the graph
proves it in one query.

## Why RelateDB

This is the embedded answer to GUAC/DepGraph-style platforms: no server, no
ingest pipeline, no graph-database cluster. `relate lab fs-to-graph` and
`git-to-graph` already walk a repo's files and commits — the lockfile and
SBOM loaders are the same shape. A per-org store is a single `.cl` file you
can commit, so the "radar" ships *inside the monorepo* and CI can open it,
query it, and fail the build on a reachable CVE — in-memory scans make that
check milliseconds, not an API round trip. WAL history means the exposure
question is answerable retroactively against last quarter's tree.

## What it needs

- Lockfile/manifest parsers for the main ecosystems (Cargo, npm, Go, PyPI,
  Maven) plus CycloneDX/SPDX SBOM ingestion
- A CVE feed loader (NVD/OSV JSON) mapping `CVE → affected versions → package`
- Optional code-level edges: import sites from tree-sitter parsing (the
  *Code Graph* idea's machinery) for true reachability
- CI mode: a `relate query` invocation that gates merges on reachability
- Scheduled refresh (OSV feed deltas appended to the WAL)

## Lineage & inspiration

- [GUAC](https://github.com/guacsec/guac/) — software-supply-chain knowledge
  graph: SBOMs + attestations + deps, security posture as graph queries
- [FalkorDB DepGraph](https://github.com/FalkorDB/DepGraph) — package
  dependency graphs in an in-memory graph DB for attack-path discovery
- [mimecast/sbom-graph](https://github.com/mimecast/sbom-graph) — SBOM
  ingestion into a graph DB with vulnerable-path queries
- [GitHub dependency graph / supply-chain security](https://docs.github.com/en/code-security/concepts/supply-chain-security/dependency-graph) —
  dependency webs as first-class graphs; vulnerability reachability as a
  traversal
- [Sourcegraph security mode](https://sourcegraph.com/solutions/security) —
  reachability queries over code + dependency graphs at fleet scale
