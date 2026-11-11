---
type: Project
name: the-judgment-ledger
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
RELATED_IDEA:
  - kind: complements
    reason: execution-side twin of the judgment record
    target: "[[Project/agent-trace-warehouse]]"
  - kind: complements
    reason: caller whose decisions the ledger freezes
    target: "[[Project/instantcypher]]"
  - kind: complements
    reason: provenance chains over claims
    target: "[[Project/the-fact-check-engine]]"
  - kind: complements
    reason: audits the recorded walk hops
    target: "[[Project/the-graph-walking-agent-cursor]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JSONL]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# The Judgment Ledger

> Every model call stored as an edge on the data it judged: provenance,
> drift, and escalation as queries — "which facts rest only on
> sub-0.6-confidence calls?" The tail's consensus architecture and the
> head's decision cache, finally joined and traversed.

## What

The JEV corpus independently converged on the same architecture from both
ends: the zero-star tail builds *receipts* (every decision logged with
its inputs, including failures); the head builds *decision caches*
([jevcache](https://github.com/hyperspaceai/jevcache): decisions as pure
functions of model + schema + state, content-addressed fingerprints,
CI-replay for drift; [Canny](https://github.com/qkal/Canny): append-only
facts ledger, "facts go to code, judgments go to the model, only facts can
block"). What *nobody* does — on either end — is **join or traverse the
ledger**: every implementation logs to JSONL or a cache table and reads
it back record-at-a-time.

This project is the ledger as a graph, on the data it judges:

- `(:Judgment {model, question, sha, at, latency, cost})` with
  `[:DECIDED]->` edges to the rows/claims/entities it scored, and
  `[:REUSED]->` the earlier judgment a cache hit derived from
- Provenance queries: "every fact in this report that rests on a judgment
  below 0.6 confidence" — one traversal, the thing no log file answers
- Drift as a query: the same question-hash over time, probability deltas
  as a series; the jevcache CI-replay idea without the CI
- Decision-necessity receipts (the corpus's sharpest question): "what
  fraction of ticks actually needed the model?" — model-call frequency
  vs. frozen-ledger hits, per workflow, as an aggregation
- The pre-baked cache: hot decision chains compiled into the store
  (dungeon-jev's bake-the-weights pattern) so steady-state runs with zero
  model calls

## Why RelateDB

The ledger wants to live *next to* the data it judges, in the same
transactional store, reachable by the same query language — that is the
embedded engine's exact shape (one process, one WAL, provenance
durable with the data). Joining and traversing ledgers is the one move
the corpus hasn't made because record-at-a-time caches can't do it;
paths, series, and per-workflow aggregations are native Cypher. And the
WAL gives the ledger its own audit trail — who wrote which judgment,
when, for what cost — for free.

## What it needs

- The judgment schema (model identity, question hashes, targets,
  confidence, reuse edges) and the client-side interceptor that records
  without changing application behavior
- The query pack: provenance traversal, drift series, necessity ratios,
  escalation-band analysis
- The bake-out tool: hot chains → stored policies/weights (the
  steady-state zero-model-run story)
- An eval harness on a real agent workload: judgments-per-task,
  cache-hit rate, drift events caught

## Lineage & inspiration

- [jevcache](https://github.com/hyperspaceai/jevcache) and
  [Canny](https://github.com/qkal/Canny) — the head's cache/ledger pair
  that logs but never joins (`research/jev-head.md`)
- The tail's receipt architecture (jev-semantic's (subject, question,
  judge) hash-keyed log; dungeon-jev's full-waveform receipts;
  grievance-triage's per-field provenance) — `research/jev-longtail.md`
- Zep/Konig's invalidation-not-deletion bi-temporality
  (`research/konig-zep-graph-db.md`) — the ledger's temporal discipline
- [InstantCypher](instantcypher.md) — the caller whose decisions this
  ledger freezes; [Agent Trace Warehouse](agent-trace-warehouse.md) —
  the execution-side twin; [The Fact-Check Engine](the-fact-check-engine.md)
  — provenance chains for claims
