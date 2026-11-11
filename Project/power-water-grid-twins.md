---
type: Project
name: power-water-grid-twins
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
RELATED_IDEA:
  - kind: complements
    reason: the same cascading-outage reachability work turned into response routing
    target: "[[Project/disaster-response-router]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Power/Water Grid Twins

> Public grid topology as a graph; cascading-failure exercises for policy
> people, not just engineers.

## What

Power and water grids are graphs wearing an SCADA costume. Public topology
exists — the U.S. EPA's water-network datasets, national TSO
substation/line shape files, Enipedia's power-plant data, open grid-model
projects like SciGRID — and importing it into a property graph gives you a
*digital twin lite*: substations, generators, pumps, and consumers as
nodes; lines, pipes, and transformers as typed edges with capacity,
voltage, and length properties.

The exercise everyone should be able to run, not just a grid engineer:
*remove this tower / shut this pump station — who loses power/water, in
what order, and how far does the cascade go?* As a graph, that is iterative
reachability with capacity filtering: start at a node, propagate along
edges, accumulate the unserved load. Run it in a classroom on a city's
water network, as a policy argument over a national grid, or as a what-if
sandbox for regulators.

Cascading failures, restoration sequencing (which line to re-energize
first to serve the most people fastest), and N-1/N-2 contingency screening
are all the same traversal with different stop conditions.

Topology-only is a defended scope, not a shortcut: Albert, Albert &
Nakarado's 2004 PRE paper modeled the North American power grid as a
complex network and located its structural vulnerability — which hubs
carry the cascade — with no load-flow at all; follow-up work connects
that topology to cascade dynamics. The water side has its EPA-grade
tool in WNTR (an open Python package for water-network resilience
simulation — pressure-driven analysis, pipe breaks), the modeling
ceiling this project deliberately stays under, and an Energies 2019
survey compares the open grid models (SciGRID among them) — the place
to crib each dataset's caveats from.

## Why RelateDB

An in-memory embedded engine turns contingency screening from a batch job
into an interactive exercise: *remove a node, watch the reachable-set query
re-answer in milliseconds, remove another* — no simulation server, no
license. The single-file store makes "the Texas grid, public data, 2025" a
committable, shareable artifact for classrooms and policy shops, and the
WAL makes every exercise replayable and diffable (rewind the cascade to
step 3 and try a different restoration order). Point types anchor every
asset on the map for public-communication graphics, and the WASM build
offers a browser twin where a legislator drags a failed substation and
watches the outage propagate in their own tab.

## What it needs

- Loaders for public grid datasets: EPA water networks
  ([WNTR](https://usepa.github.io/WNTR/)),
  SciGRID/energy-model power data, TSO open data where available
- A cascade model: reachability + capacity accounting in queries — honestly
  documented as topology + capacity, not a load-flow solver
- Scenario tooling: named what-ifs as queries, comparison of two runs as a
  graph diff
- Reference packs: 2-3 public networks as `.cl` files with canned exercises

## Lineage & inspiration

- [SciGRID](https://www.scigrid.de) — open European power-grid model from public data
- [U.S. EPA WNTR](https://github.com/USEPA/WNTR) /
  [usepa.github.io/WNTR](https://usepa.github.io/WNTR/) — the water-network
  resilience toolkit and its datasets
- [Structural vulnerability of the North American power grid](https://arxiv.org/abs/cond-mat/0401084)
  — the topology-only cascade precedent (PRE 69, 025103, 2004)
- [Comparison of open-source power grid models (Energies 2019)](https://www.mdpi.com/1996-1073/12/24/4728)
  — SciGRID and friends, honestly compared
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — connectivity/robustness recipes (cut nodes, percolation) to port
- [2021 Texas power crisis coverage](https://en.wikipedia.org/wiki/2021_Texas_power_crisis)
  — the cascade story the public wanted to see simulated, not just narrated
