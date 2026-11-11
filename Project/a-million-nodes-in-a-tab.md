---
type: Project
name: a-million-nodes-in-a-tab
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Graphistry]]"
RELATED_IDEA:
  - "[[Project/d3-sigma-cytoscape-adapters]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Cosmograph]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/cosmos.gl]]"
  - "[[Technology/sigma.js]]"
---

# A Million Nodes in a Tab

> WASM RelateDB + cosmograph-style GPU rendering; load topology first, details on
> hover/zoom — the humane-large-graph experience (Mottin/Mueller's rules) for
> everyday data.

## What

A browser tab that opens a million-node, million-edge graph and stays interactive.
The trick is the split: the GPU renderer only ever needs position + color + size,
so the first payload is a compact columnar dump (Arrow/CSV) of exactly that;
labels, properties, and full rows stream lazily on hover, click, and zoom, fetched
from the WASM engine sitting right there in the same tab — "server round trip"
is a function call.

Verified: CPU force layouts choke around 100,000 nodes and SVG
animation breaks down in the low thousands — the Nightingale
practitioner guide (Rokotyan, 2022) prescribes GPU/WebGL rendering
with the simulation itself on the GPU, naming Cosmograph the browser
exemplar. cosmos.gl, Cosmograph's engine, joined the
[OpenJS Foundation](https://openjsf.org/blog/introducing-cosmos.gl) in
2025 — the rendering model is foundation-hosted, not a startup bet.
And the humane rules have a published name: MetaExp (Behrens, Mottin,
Müller et al., WWW 2018) — explore-and-explain large graphs via
meta-paths instead of dumping the hairball.

The interaction model follows the humane-exploration rules, not the hairball dump:
you arrive through a query ("show me the 2-hop neighborhood of this wallet"),
the view expands from what you're looking at, and everything on screen is
re-derivable — the canvas is literally a rendering of the last Cypher result, so
selection, filter, and drill-down are queries, not UI state. A query bar sits
under the canvas; every visual gesture writes a line of Cypher you can copy.

Target experience: drag a `.cl` file (or a URL) onto the page, get a Cosmograph
canvas in under a second, and spend the evening exploring — on a laptop, offline,
with no account.

## Why RelateDB

The WASM build is the substrate: the engine is already in the tab, so lazy
property fetches execute at in-memory speed with zero network — the "details on
hover" tier is free. The Parquet checkpoint is the natural transport format for
the topology dump (RelateDB's durable form is already columnar Parquet, and the
Arrow conversion crate exists), and the table/CSV/JSON formatters mean the export
path is a query away (`RETURN` + format, no bespoke dump tool). Because the canvas
is query-backed, the same page works from a `:memory:` store, a local `.cl` file,
or a `relate serve` HTTP/Bolt endpoint — one front end, three deployment modes.

## What it needs

- A GPU/WebGL rendering layer (Cosmograph/cosmosgl, or sigma.js + graphology) fed
  by a compact position/color/size frame
- A layout story: precomputed positions in the store vs. force-atlas in a worker —
  decide which ships in v1
- The lazy-detail protocol: hover/click → property fetch from the in-tab WASM
  engine, batched per zoom level
- A query bar under the canvas; every gesture emits editable Cypher
- Drag-and-drop + URL loading of `.cl` files and Parquet checkpoints
- Perf budget work: keeping the WASM engine's memory alongside a 1M-node payload

## Lineage & inspiration

- [Cosmograph / cosmosgl](https://cosmograph.app/) |
  [cosmosgl/graph](https://github.com/cosmosgl/graph) — GPU in-browser rendering
  of million-edge graphs from CSV; the rendering model this project adopts, now
  an [OpenJS Foundation project](https://openjsf.org/blog/introducing-cosmos.gl)
- [How to visualize a graph with a million nodes (Nightingale)](https://nightingaledvs.com/how-to-visualize-a-graph-with-a-million-nodes/)
  — the practitioner guide behind the topology-first approach
- [MetaExp: Interactive Exploration and Explanation of Large Knowledge Graphs](https://meta-exp.github.io/resources/paper.pdf)
  (Behrens, Mottin, Müller et al., WWW 2018; [project page](https://mott.in/projects/graph-exploration/)) — the
  humane-exploration rules: show the relevant subgraph, never the hairball
- [sigma.js + graphology](https://www.sigmajs.org/examples/) — the open fallback
  stack for the renderer ([performance guide](https://www.sigmajs.org/how-to/technical/performance/)
  as the scale-limit reference)
- [El Grapho](https://github.com/ericdrowell/ElGrapho) — another open WebGL
  graph renderer; the engine-agnostic OSS options this project pairs with
- **Graphistry** — the fast GPU renderer cousin, with a licensing caveat that
  decides the architecture: the [JS client](https://github.com/graphistry/graphistry-js)
  and [pygraphistry](https://github.com/pygraphistry) are OSS, but the renderer
  is server-side in their commercial platform (GPU servers render and stream
  to a client canvas — see their
  [architecture docs](https://graphistry-admin-docs.readthedocs.io/en/latest/planning/architecture.html))
  — it cannot be pointed at a local WASM engine. The honest split: Graphistry
  is the *server-rendered* version of this idea; this project is the local
  version, feeding open in-tab renderers instead
