---
type: Project
name: the-low-resource-kit
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
RELATED_IDEA:
  - kind: complements
    reason: shared-server sibling versus per-seat no-server version
    target: "[[Project/classroom-server-on-a-35-board]]"
  - kind: complements
    reason: curriculum content the kit carries
    target: "[[Project/graph-school]]"
  - kind: inspired-by
    reason: lazy-load pattern for bad links
    target: "[[Project/httpfs-for-cl-files]]"
  - kind: complements
    reason: zero-install lessons made hardware-honest
    target: "[[Project/network-science-interactive]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The Low-Resource Kit

> The hand-me-down laptop, the library computer, the school lab with no
> budget and no admin rights: WASM RelateDB running well within tens of
> megabytes and an old browser — the graph stack that runs where the
> hardware poverty is.

## What

Every "runs in a browser" claim quietly assumes a good browser on a good
machine. This idea is the explicit opposite: a kit that makes the whole
stack — engine, dataset, notebook or playground — run *well* on the
machines people actually inherit: a 2014 Chromebook with 2 GB of RAM, a
library public-access terminal with locked-down software and no install
rights, a school lab where "just use the cloud" means an account barrier,
a login wall, and a data plan.

The kit is a discipline, not a product: size budgets for the WASM build
and its data (tens of MB total, not hundreds), streaming/lazy loads so
the first question happens before the whole file arrives (the httpfs
pattern), a compatibility floor (the engine and the shell must run on
browsers several versions old), offline-first storage (the tab keeps
working on the flaky café wifi), and *local persistence* where the
platform allows it (OPFS) so the student's work survives a refresh.

The classroom math is the point: thirty students on whatever the school
has, zero setup by the teacher (a URL or a USB stick of `.cl` files), and
a curriculum unit (the Graph School content) that runs at the bottom of
the hardware distribution instead of the top — the equity version of
"in-memory".

## Why RelateDB

Embedded means the school needs nothing installed — no DB server, no
admin rights, no accounts; WASM means the browser they already have is
the runtime; `.cl` files are small by nature (a teaching dataset is KB-to-
MB, not GB); and the in-memory design makes the old CPU the *interesting*
constraint rather than a wall (a class-sized Karate Club or Les Misérables
graph queries instantly even on a decade-old phone). The WAL-on-OPFS
story gives the lab session durability without any infrastructure. And
the discipline has a payoff for everyone: size budgets and compatibility
floors make the product better at the top of the market too.

## What it needs

- The budget suite: measured WASM footprint, memory ceilings, and
  compatibility matrix on old browsers — published, like the loadtest
  envelopes, so regressions are visible
- The kit bundle: a playground page + curriculum units + datasets that
  fit the budget, verified on real hand-me-down hardware
- The offline/persistence guide: service-worker caching and OPFS
  durability within school-network realities
- A classroom pilot: one real lab, old machines, a teacher who never
  had a graph database before

## Lineage & inspiration

- [Classroom Server on a $35 Board](classroom-server-on-a-35-board.md) —
  the shared-server sibling; this is the per-seat, no-server-at-all
  version
- [Graph School](graph-school.md) and [Network Science,
  Interactive](network-science-interactive.md) — the curriculum content
  the kit carries (their zero-install claims made hardware-honest)
- phiresky's SQLite-over-HTTP work (see [httpfs for `.cl`
  Files](httpfs-for-cl-files.md)) — the lazy-load pattern that makes
  first-interaction latency survivable on bad links
- The public-library/educational-access computing tradition — the
  constraint set this kit takes seriously instead of assuming away
