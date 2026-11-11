---
type: Project
name: argument-mapper-for-debate-prep
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_PERSON:
  - "[[Person/Horst Rittel]]"
  - "[[Person/Stephen Toulmin]]"
USES_TECH:
  - "[[Technology/Argdown]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/IBIS]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Argument Mapper for Debate Prep

> Claims, premises, rebuttals as a typed graph; find your unclosed
> rebuttal paths first.

## What

Debate prep is already graph-shaped in people's notes: contentions rest on premises,
attacks undermine premises, rebuttals undermine attacks. This project makes it
explicit and then useful: `(:Claim)-[:SUPPORTED_BY]->(:Premise)`, `(:Attack)-
[:UNDERMINES]->(:Premise)`, `(:Rebuttal)-[:UNDERMINES]->(:Attack)`, `(:Concession)`
for ceded fights, every node cited. Prep becomes construction, validated by queries:
your unclosed rebuttal paths — attacks with no live rebuttal edge — surface *first*,
ranked by how load-bearing the attacked premise is (one supporting three claims is a
bigger hole than one supporting one).

The structural queries beat a document of notes: single-point-of-
failure premises (attack one, two contentions fall — know them before the opponent
does); shared-premise exposure (both sides resting on one contested fact — the fight
that decides the round); concession survival ("if I cede the second contention,
what's still standing?"); and cross-examination mining — paths from their strongest
claim to their weakest premise. Post-debate, the graph gets adjudicated: which
attacks landed, which rebuttal paths were never reached — prep analytics compounding
every tournament.

## Why RelateDB

The whole round — both cases, every flow annotation — is one `.cl`
file a debater or team passes around and diffs; teams share the
tournament's collective graph, merging with authorship provenance (who wrote which
contention, kept after merge). In-memory queries make the prep loop interactive:
"what am I conceding, and what survives" is a sub-second query between practice
rounds. Typed edges are the semantic win — `UNDERMINES` vs. `PRECLUDES` vs.
`WEAKENS` is the distinction a real argument model needs, and Cypher's typed
traversals carry it. `RETURN mermaid(subgraph)` renders the flow chart; Python
bindings ingest case docs; and MCP gives the coach's agent the graph — "simulate the
strongest cross-ex against our case" starts from the actual unclosed paths, not a
summary.

## What it needs

- The
argument ontology: claim/premise/attack/rebuttal/concession with
  typed undermining edges and citations on every node
- The prep query pack: unclosed rebuttal paths, load-bearing premise
  ranking, shared-premise exposure, concession survival analysis
- A construction surface: fast authoring over the WASM build (or the CLI) with live
"your case has N unclosed paths" validation

## Lineage & inspiration

- Toulmin's argument model (claim/data/warrant/rebuttal) — the classic
  schema this graph formalizes: https://plato.stanford.edu/entries/
argument-epistemology/ (SEP's Toulmin overview)
- IBIS (Issue-Based Information Systems, Kunz & Rittel) — issues,
positions, arguments as a graph since the 1970s: the intellectual
grandparent - Argdown — argument maps as a markdown dialect (proof people want to
  *author* these, and that a query language is the missing layer):
  https://argdown.org/
