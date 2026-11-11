---
type: Project
name: query-plans-as-graphs
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: same query-the-artifact-not-the-text move aimed at query plans
    target: "[[Project/code-graph]]"
  - kind: complements
    reason: reuses graph diffing for plan-shape diffs between versions
    target: "[[Project/diff-view-for-graphs]]"
  - kind: complements
    reason: this project is the meta-graph engine for the lab's mission
    target: "[[Project/query-plan-lab]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Joern]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/jQAssistant]]"
---

# Query Plans as Graphs

> Every `EXPLAIN` tree collected into one meta-graph; search plans like code,
> diff them between versions, mine them for smells.

## What

`EXPLAIN` already gives you one plan tree as a queryable structure. Now make the
corpus a database: every plan your tools, your org, or your test suite produces
becomes a subgraph — operator nodes, argument properties, child edges — landing
in one meta-graph alongside the statement text, the query type, the result
metadata, and when/where it ran. Thousands of plans later, you interrogate the
plans themselves.

The queries you didn't have before: "which statements produce a CartesianProduct
under three joins?" (smell mining across the whole org); "which of our plan
shapes appear in slow-query incidents but never in fast ones?" (plan patterns as
leading indicators); "what changed in this statement's plan between engine
versions?" (a plan diff — the same tree, two versions, the changed operators
highlighted). Planning-rule testing becomes regression testing: the planner's
expected trees are stored as fixtures, and a planner change re-runs the suite and
diffs the meta-graph against itself.

This is "search plans like code": plans get grep, blame (which release reshaped
this shape?), review (a PR that changes plan shapes for the top-20 workload
queries shows its diff), and refactoring analytics (which operator subshapes
co-occur, and are they a missing rewrite rule?).

## Why RelateDB

EXPLAIN is the feed: RelateDB returns plan trees as structured, queryable
output, so harvesting plans into a meta-graph is a projection, not a parser
project. The meta-graph lives in RelateDB itself — an embedded store is the
natural sidecar (open one next to your workload store, or in the CI runner, or
in a tab), and diffing two versions of the meta-graph reuses the Diff View idea
at the plan level. In-memory Cypher makes "smell mining across 10k plans" an
interactive session: pattern-match operator subshapes, aggregate, drill in — a
server would make this a batch job. The cookbook format pins it down: expected
plan shapes for a corpus of statements recorded and checked, so planner changes
face a regression gate. And the single-file store means the whole plan corpus
of a project travels as one `.cl` artifact alongside the code.

## What it needs

- A harvester: run `EXPLAIN` over a statement corpus (CLI tests, app query logs,
  the TCK/TCK-adjacent suites) and load the trees into the meta-graph
- A canonical operator vocabulary + argument properties (the plan structure,
  stable across versions)
- Diff queries between version-tagged plan sets (plan diff = subgraph diff)
- Smell encodings as Cypher patterns (CartesianProduct, unbounded scans,
  expand-without-limit) — the checkable lint list

## Lineage & inspiration

- RelateDB's `EXPLAIN` — plan trees as queryable structures; the native feed
- Code-graph lineage (jQAssistant, Joern — see the Software & Code Intelligence
  section): the same "query the artifact, not the text" move, aimed at plans
- The Query-Plan Lab idea (Software & Code Intelligence section) — this project
  is its meta-graph engine
