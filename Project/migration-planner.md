---
type: Project
name: migration-planner
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Sourcegraph]]"
  - "[[Company/jQAssistant]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: reuses the same tree-sitter code graph for planning instead of comprehension
    target: "[[Project/code-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Sourcegraph]]"
  - "[[Technology/jQAssistant]]"
  - "[[Technology/tree-sitter]]"
---

# Migration Planner

> Before a framework jump, query every usage of the old API across repos; the migration backlog writes itself as a Cypher result.

## What

The announcement lands: the framework is deprecated, the big-bang rewrite is
due, and the first meeting argues about *how big it even is*. This project
answers that with the code graph: the repos are parsed (tree-sitter layer from
the **Code Graph** project) into function/call/import structure; the
deprecated API is a labeled subgraph (`(:Function {deprecated:true})` or an
imported symbol set); and the migration backlog is a traversal: every
transitive caller of the old API — `(:Site)-[:CALLS*1..]->(:DeprecatedAPI)` —
ranked by depth, fan-in, and each caller's own blast radius.

The backlog writes itself as a result: teams own the leaf functions, sequenced
so nothing blocks anything — callers first, shared utilities last. Run as a
*diff* over rebuilt graphs, the same query shows real progress: the dashboard
is a query, not a spreadsheet someone maintains by hand. And the shape
generalizes — any constraint ("no more `moment.js`") becomes one parameterized
query: plan it, track it, prove it done.

## Why RelateDB

The planning unit is *many repos*, and an embedded engine makes the multi-repo
corpus one store on one disk: sweep the org checkout (each repo's graph
`MERGE`d in, `(:Repo)-[:CONTAINS]->...`) — no shared server to provision for a
one-quarter effort. Reachability and ranking are exactly what in-memory Cypher
does at scan speed, so the "how big is it" meeting gets a live query instead of
an estimate. The rebuilt-vs-rebuilt diff is WAL/checkpoint-shaped: commit the
pre-migration `.cl`, rebuild at any milestone, and the remaining-work delta is
a graph diff. CLI output modes turn the traversal into the backlog artifact —
CSV for the tracker import, JSON for the dashboard, table for the meeting. And
over MCP the coding agents doing the mechanical edits consult the same store:
"is this call site one of the 40 left?" is a query they ask themselves.

## What it needs

- The tree-sitter → code-graph loader from **Code Graph**, plus a multi-repo
  aggregation layer (repo nodes, cross-repo import edges where monorepos or
  internal packages create them)
- An "API definition" format: which symbols/imports constitute the deprecated
  surface (semver range, package, class list) — declarative, versionable in git
- The backlog generator: parameterized traversal with team/owner enrichment,
  exported per format; a burn-down query for progress tracking
- Scheduled rebuilds over the org checkout + diff reporting, feeding ticketing
  from the CSV/JSON output

## Lineage & inspiration

Direct lineage from **Code Graph** in this section — same tree-sitter graph,
applied to planning instead of comprehension. jQAssistant
(https://jqassistant.org) proved
constraint-checking over a code graph is a database question — "which rules
does this artifact violate" — and this is its temporal/migration form.
[Sourcegraph](https://sourcegraph.com) (big-bang-change search at fleet scale),
**CodeGraphContext** (code graphs behind MCP for coding agents), and from
[research/graph-world.md](../research/graph-world.md) §6:
[GUAC](https://github.com/guacsec/guac/) — the same reachability discipline,
aimed at your own API surface instead of your SBOM.
