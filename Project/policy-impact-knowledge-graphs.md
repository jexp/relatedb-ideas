---
type: Project
name: policy-impact-knowledge-graphs
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/DeepMind]]"
RELATED_IDEA:
  - kind: complements
    reason: supplies the at-date worldview machinery for belief replay
    target: "[[Project/history-as-graph]]"
  - kind: complements
    reason: connects policy impact edges to the statute and case lineage
    target: "[[Project/legal-citation-graphs]]"
  - kind: complements
    reason: applies the same per-decision provenance discipline to assumptions
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Policy-Impact Knowledge Graphs

> Housing policies, carbon rules, development-finance grievance systems —
> the evidence graph *behind* a policy, with its assumptions made
> explicit and traceable: who is modeled to be affected, through which
> mechanism, resting on which study, at which confidence.

## What

Policy analysis today hides its graph. A housing policy (rent caps,
zoning reform, subsidy programs) touches regions, households, markets,
and prior policies through mechanisms (supply, displacement, access)
whose evidence is a stack of studies nobody can traverse. The corpus
built this under pressure from two directions: SweetHome (a DeepMind
hackathon build) connected housing policies to evidence, regions, and
households in a temporal knowledge graph and simulated household impact
through a decision oracle; jev-grievance-triage ran development-finance
grievance intake as 23 typed questions with *every field traced to a
probability, threshold, rule, and model version* — assumption provenance
as a first-class requirement.

This project is the policy shop's evidence engine:

- `(:Policy {jurisdiction, in-force window})` with `[:AMENDS]`,
  `[:SUPERSEDES]` (the legal lineage) and `[:AFFECTS {channel}]` the
  impact edges to `(:Household)`/`(:Region)` segments
- `(:Assumption)` and `(:Evidence)` nodes: each impact edge *carries* its
  mechanism, the studies behind it, the confidence band, and — the
  grievance-triage lesson — the model version and threshold that judged
  it (the Judgment Ledger discipline applied to policy)
- The question set: "who is modeled to be affected by the cap through
  the displacement channel, and on what evidence" — a traversal; "which
  in-force assumptions rest on studies older than ten years" — the
  staleness audit; "what did we believe about this policy last year" —
  bi-temporal replay (the world-as-they-saw-it view)
- The review interface: contested impact edges as *marked*, with rival
  evidence attached — assumptions argued on the graph, not in email
  threads

## Why RelateDB

A jurisdiction's policy corpus is thousands of policies and tens of
thousands of evidence links — single-file scale, the think-tank-laptop
scale, the council-meeting-laptop scale. The temporal windows (in-force
intervals), the lineage chains (amend/supersede), and the
evidence-heredity questions are the engine's native shapes. The WAL
gives the assumption-ledger its own audit trail; the WASM tab publishes
a policy's evidence graph beside its impact note — the transparency
artifact public comment has never actually had.

## What it needs

- The schema above, with the assumption/evidence discipline enforced by
  loader (no impact edge without provenance)
- The query pack: channel traversal, staleness audit, contested-edge
  review queue, bi-temporal belief replay
- A pilot corpus: one city's housing policy set, one regulation domain
  — small, real, contested, publishable
- The public-comment artifact: the evidence graph as the explorable
  attachment to a policy note

## Lineage & inspiration

- SweetHome (DeepMind hackathon, Korea) — the housing-policy temporal
  KG + household-impact simulation; jev-grievance-triage — the 23-typed-
  question intake with per-field provenance (`research/jev-longtail.md`,
  `research/jev-head.md` for the pattern context)
- [Legal Citation Graphs](legal-citation-graphs.md) — the
  statute/case lineage this connects to; [The Judgment
  Ledger](the-judgment-ledger.md) — the per-decision provenance
  discipline both patterns demand
- [History as Graph](history-as-graph.md) — the at-date worldview
  machinery; Zep/Konig's bi-temporal invalidation
  (`research/konig-zep-graph-db.md`) — beliefs superseded, not deleted
