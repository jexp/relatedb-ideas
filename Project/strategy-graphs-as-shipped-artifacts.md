---
type: Project
name: strategy-graphs-as-shipped-artifacts
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: cited as the story-graph ancestor of walked branches
    target: "[[Project/choose-your-own-adventure-engine]]"
  - kind: complements
    reason: cited as the oracle boundary the walking surface shares
    target: "[[Project/instantcypher]]"
  - kind: variant
    reason: applies this shipped walk pattern to a cross-reference corpus
    target: "[[Project/scripture-cross-reference-navigation]]"
  - kind: complements
    reason: cited as the record of the walks
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/jev-tree]]"
  - "[[Technology/jev4pg]]"
---

# Strategy Graphs as Shipped Artifacts

> Decision surfaces — taxonomies, question trees, choice lattices — as
> *portable* `.cl` navigation files: every walk recorded as a probability-
> edge path, analytics as Cypher. The verified gap: every working example
> runs its surface in memory or on a server; none ships a file you can
> open, walk, and keep.

## What

A growing pattern class builds "strategy surfaces" — decision trees,
polyhierarchical taxonomies, question flows a model walks level by level:
jev-tree and usejev walk taxonomies as nested maps; jev4pg maintains a
reviewed "self-developing semantic layer"; the tail's bible-jev-climb
hill-climbs a cross-reference graph ("the graph lists the options; Jev
only scores them"); the tarot lattice (78 cards × orientations × domains
× registers) is the same artifact in an unpitchable costume — with
share links that serialize the *walk*. Every working example holds its
surface in process memory or on a server. None of them is a thing you
can hand to someone.

This project makes the surface itself the shipped artifact:

- **Authored once**: the strategy graph as `.cl` — decision nodes with
  typed options, prerequisite edges, weights (impact ratings, confidence
  bands); versioned by the WAL like any store
- **Walked with context**: an agent (or human) traverses it — the
  decision oracle scores options at each node *against the walker's
  context*; the accumulated path is the context carrier (timosam's
  evidence-carrying walk upgraded to a stored graph)
- **Every walk recorded**: each traversal a `(:Walk)` path with the
  option probabilities chosen against — the analytics that fall out are
  Cypher: hot corridors, abandoned branches, context-conditional
  divergence
- **Replayable and shareable**: a walk serialized as a link or a file —
  the tarot share-link pattern, generalized to any decision surface

The killer demonstrations, one earnest and one unforgettable: the
earnest — a support-triage or policy decision tree shipped as a file,
walked by the agent, audited by the analyst ("which branches did we
never take, and under what context?"). The unforgettable — the tarot
lattice as a `.cl` file: a 78-node content graph walked with context,
every reading a recorded path, the "unpitchable" pattern becoming the
clearest demo of shipped-strategy-graph there is.

## Why RelateDB

The surface is small (hundreds to thousands of nodes), the walks are
paths, the analytics are traversals — the whole lifecycle is one
embedded store: author (writes), walk (parameterized queries + oracle
scoring at the surface), record (WAL-durable walks), analyze (Cypher),
share (one file). The alternative everyone uses — in-memory nested maps
or a server session — can't do any of the last three. And the WASM tab
walks the surface in a browser: the shareable decision artifact.

## What it needs

- The surface schema: decision nodes, typed options, prerequisite and
  impact edges, context bindings
- The walk protocol: context accumulation along the path, oracle scoring
  at each node (post-processing — the InstantCypher boundary rule), walks
  as recorded `(:Walk)` paths
- The analytics pack: corridor heat, abandonment, context divergence
- The two demos: the earnest policy/triage tree; the tarot lattice as
  the unforgettable one

## Lineage & inspiration

- jev-tree, usejev, and jev4pg's reviewed semantic layer — the in-memory
  and server-side surfaces this project makes portable
  (`research/jev-ecosystems.md`, `research/jev-head.md`)
- bible-jev-climb and the tarot content lattice (tarot.trackr.live) —
  the tail's graph-lists-options pattern and the walk-serializing share
  link (`research/jev-longtail.md`)
- [InstantCypher](instantcypher.md) — the oracle boundary both share;
  [The Judgment Ledger](the-judgment-ledger.md) — the record of the
  walks; [Choose-Your-Own-Adventure Engine](choose-your-own-adventure-engine.md)
  — the story-graph ancestor: branches readers walk and query
