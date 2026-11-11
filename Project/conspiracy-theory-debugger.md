---
type: Project
name: conspiracy-theory-debugger
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Diffbot]]"
  - "[[Company/GDELT]]"
MENTIONS_PERSON:
  - "[[Person/Deb Roy]]"
  - "[[Person/Sinan Aral]]"
  - "[[Person/Soroush Vosoughi]]"
RELATED_IDEA:
  - kind: same-data
    reason: overlays the claimed graph on the Fact-Check Engine's evidence layer and importers
    target: "[[Project/the-fact-check-engine]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Diffbot]]"
  - "[[Technology/GDELT]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Conspiracy-Theory Debugger

> The Fact-Check Engine's cousin for analyzing claimed narratives:
> evidence-strength edges, and missing-edge queries that expose exactly
> where the theory needs unprovable links.

## What

A conspiracy theory is a graph too — it just has weak edges. This project takes the
Fact-Check Engine's evidence layer (the Diffbot/GDELT news graph) and overlays the
theory as a *claimed* graph: each assertion a typed edge classified by support —
`documented` (exists in reporting, cited), `inferred` (drawn from two inspectable
edges), or `unprovable` (no documented edge, no inferable path — the load-bearing
link that can never be checked). The debugger's headline output is exactly that
list: the theory's unsupported links, ranked by how structurally necessary they are
— the edges without which the narrative collapses.

The second output is social: how the claim spread. Claim edges carry
first-seen dates and source attribution, so the spread query shows whether a claim
radiates from one origin cluster (monoculture) or independently surfaced across
unrelated reporters (the actual signature of real news). The third is
charitable-by-construction: it also reports which parts of the theory *are*
documented, because a debunk that admits the true edges is the only one people
accept. Debugging, not dunking.

## Why RelateDB

Missing-edge queries and articulation-point analysis ("which edges
carry the story") are traversal jobs on an in-memory graph — instant,
local, no API spend, which matters when the subject is adversarial and the analysis
private. The evidence layer is one `.cl` file per case (built by the Fact-Check
Engine's importers via `relate-arrow`), the claimed graph overlays it in the
same store, and the comparison is one query over both. Temporal types make the
spread analysis native: first-seen and source-cluster timelines as filters, not
post-processing. Classification lives in edge properties, so re-classification is an
update, not a rebuild — and the WAL keeps retracted claims queryable as retracted.
`serve --mcp stdio` exposes the analysis to agents; WASM puts the "click an edge,
see its support" walkthrough in a browser tab.

## What it needs

- The claim-graph model: typed claimed edges with support classification
(documented / inferred / unprovable) over the Fact-Check Engine's evidence
layer
- The structural pack: load-bearing unsupported links (articulation
  points of the claimed narrative), collapse simulation (which single
  unprovable edge kills the story)
- The spread layer: first-seen, source-cluster provenance, monoculture vs.
independent-surfacing queries

## Lineage & inspiration

- The Fact-Check Engine (this collection) — the evidence layer and
  claim-extraction pipeline this project shares; Diffbot/GDELT lineage
included there
- Vosoughi, Roy & Aral, "The spread of true and false news online" (*Science*,
2018) — the empirical base for the spread queries:
  https://www.science.org/doi/10.1126/science.aap9559
- The Debunking Handbook 2020 — why showing the true edges alongside the false
ones is method, not politeness:
https://www.climatechangecommunication.org/debunking-handbook-2020/
