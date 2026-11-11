---
type: Project
name: the-emergent-interaction-graph
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Google]]"
  - "[[Company/MIT Media Lab]]"
RELATED_IDEA:
  - kind: complements
    reason: same WAL plus derived-edge architecture proven for machine traces
    target: "[[Project/agent-trace-warehouse]]"
  - kind: inspired-by
    reason: same append-only stream to temporal graph pattern
    target: "[[Project/event-stream-to-temporal-graph]]"
  - kind: complements
    reason: entity resolution across sources adapted at org scale
    target: "[[Project/gedcom-importer-merger]]"
  - kind: complements
    reason: code-world twin of inferred interaction graphs
    target: "[[Project/software-design-x-rays]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Enron Corpus]]"
  - "[[Technology/ICS]]"
  - "[[Technology/IMAP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SNAP]]"
  - "[[Technology/WASM]]"
---

# The Emergent Interaction Graph

> Temporal knowledge graphs *inferred* from communication streams: email,
> Slack, meeting invites, phone proximity (the COVID contact-tracing
> shape), any sensor log — the graph nobody drew emerging from the
> interactions, with exposure chains, information flow, and
> communities-over-time as temporal queries.

## What

The most important graphs in an organization — and in a life — were
never drawn by anyone. They exist only as the *shadow* of interactions:
who emailed whom, whose phone was near whose
at 14:10. Each stream is a log; the communication topology they jointly
encode — its evolution, its silos — is invisible in any one source. The
COVID era proved the shape: proximity logs *were* a contact graph, and
exposure chains became the world's most urgent query.

The project infers the graph from the streams: interaction *events* are
ingested with timestamps; nodes (people, channels, teams) and temporal
interaction edges are derived as the stream grows — keeping both
layers, the immutable event log and the derived interval edges, the way
WAL and checkpoint relate. The payoff: *who was in the exposure chain
between A and B within 48 hours?* is a time-windowed variable-length
path; *when did this team split into two communities?* is temporal
replay, quarter by quarter.

Both halves have verified anchors. The COVID designs — DP-3T and the
Apple/Google Exposure Notification framework — made proximity logs a
first-class data model (rolling identifiers, exposure windows) while
deliberately *never materializing* the contact graph,
decentralization-first. The email half has its canonical corpus: Enron
(Klimt & Yang, 2004) — about half a million messages — ships as an SNAP
graph with a 2005–2012 analysis lineage, and MIT's sociometric badges
measured face-to-face interaction topology directly: the physical-world
version of the same inference.

## Why RelateDB

Streams are append-only, and so is RelateDB's durability path — a
WAL with periodic checkpoints: ingest is a write, replay is temporal
rewind, any window queryable as it was (the [Event Stream to Temporal
Graph](event-stream-to-temporal-graph.md) pattern, for human streams).
Temporal types carry the intervals natively — every edge has
`from`/`to` — and the [Agent Trace
Warehouse](agent-trace-warehouse.md) is the same architecture, proven
for machine traces. And privacy is the deployment property:
communication logs are an org's most sensitive data — the analysis runs
where the data already sits: one laptop, one `.cl` file.

## What it needs

- Ingest adapters: mailboxes (mbox/IMAP export), Slack exports, calendar
  (ICS), proximity logs — each normalized to a typed event, with derived
  interval edges (channel, intensity)
- Time-scoped variable-length traversal as the workhorse query pattern
- Entity resolution across streams: the same person in email, Slack, and
  calendar (the [GEDCOM Importer & Merger](gedcom-importer-merger.md)
  dedup problem, at org scale)

## Lineage & inspiration

- [DP-3T](https://doi.org/10.3929/ethz-b-000448853) and
  [Apple/Google Exposure Notification](https://www.apple.com/covid19/contacttracing/)
  — proximity logs as a designed (deliberately unmaterialized) graph
- [The Enron corpus (Klimt & Yang 2004)](https://bklimt.com/papers/2004_klimt_ecml.pdf)
  / [SNAP email-Enron](https://snap.stanford.edu/data/email-Enron.html) —
  the canonical email-network dataset, ~half a million messages; its sibling
  corpora for the same loaders: the [Avocado Research Email
  Collection](https://catalog.ldc.upenn.edu/LDC2015T03) (a whole
  corporation's legal-discovery email —
  [compared with Enron](https://aclanthology.org/W17-2408/)) and the
  [Clinton email corpus](https://doi.org/10.1007/s41701-018-0034-2), plus
  the classic
  [threading/name-disambiguation datasets](https://www.cs.cmu.edu/~einat/datasets.html)
  — a ready-made evaluation family
- [Emails as graph (WWW 2012)](https://dl.acm.org/doi/10.1145/2187980.2188210)
  — the communication-topology analysis lineage
- Organizational network analysis (the
  [MIT sociometric badge](https://www.media.mit.edu/publications/enhancing-organizational-communication-using-sociometric-badges/)
  lineage) — communication topology measured, never drawn
- [Agent Trace Warehouse](agent-trace-warehouse.md) and [Event Stream
  to Temporal Graph](event-stream-to-temporal-graph.md) — the same trace
  architecture; [Software Design
  X-Rays](software-design-x-rays.md) — the code-world twin
