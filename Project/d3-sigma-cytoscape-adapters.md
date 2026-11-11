---
type: Project
name: d3-sigma-cytoscape-adapters
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Andrei Kashcha]]"
RELATED_IDEA:
  - kind: complements
    reason: the rendering-scale story these adapters feed
    target: "[[Project/a-million-nodes-in-a-tab]]"
  - kind: complements
    reason: another renderer front end fed from the same node and edge arrays
    target: "[[Project/vr-xr-overlay]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Cytoscape]]"
  - "[[Technology/D3]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/graphology]]"
  - "[[Technology/sigma.js]]"
---

# D3/Sigma/Cytoscape Adapters

> One graph file, any viz library; the adapter layer is thin because the data is
> already shaped.

## What

A small set of import adapters that turn a RelateDB result (or a whole `.cl`
store) into the graph object each major viz library expects: sigma.js/graphology
graphs, Cytoscape.js elements, C3/D3-ready node-link arrays. Not a framework, not
a product — a docs page and a `npm`/CDN package that makes "open my graph file in
my favorite renderer" a five-minute task instead of a half-day of glue code.

The honest pitch is how little there is to write. Every one of these libraries
consumes `{nodes: [...], edges: [...]}` with per-element data; a Cypher result
set or a Parquet checkpoint is already node/relationship shaped. The adapter is
a mapping layer (id, label, properties, start/end) plus conventions for styling
by label, so the *same* `.cl` file renders in sigma.js with WebGL for scale, in
Cytoscape for analysis plugins, and in D3 for bespoke editorial graphics — pick
the renderer per audience, keep one source of truth.

## Why RelateDB

The data is already shaped: nodes and relationships with properties are the
store's native form, and the table/CSV/JSON/JSONL formatters plus the Arrow
conversion crate mean an adapter never needs to parse or model anything — it
maps typed records onto viz-library element objects. The WASM build lets the
adapter run entirely in the browser against a fetched `.cl` file or an in-tab
`:memory:` store, so "load file → render" demos need no backend at all; the
HTTP/JSON output from `relate serve` covers the same mapping for server-side
rendering. And `db.schema.visualization` gives each adapter a canned demo: its
virtual nodes + relationships render the schema graph through the exact same
adapter, which doubles as the docs example.

## What it needs

- One thin package (or one file per library) mapping result rows → element arrays
  for graphology, Cytoscape.js, and D3 node-link
- Conventions: which properties become size/color/label; styling by label/type
- A whole-store export mode ("not a query — everything") over the checkpoint/
  Arrow path
- Docs page with copy-paste snippets per library, each loading the same demo
  `.cl` file
- Tested examples in CI (the cookbook/parity pattern)

## Lineage & inspiration

- [sigma.js + graphology](https://www.sigmajs.org/examples/) — modular JS graph
  model + WebGL renderer; its CSV→network cookbook examples are the template
- [Cytoscape.js](https://js.cytoscape.org/) — the analysis-workbench renderer
  with the plugin ecosystem
- [D3](https://d3js.org/) — the bespoke-editorial-graphics end of the spectrum
- [G.V() + Kuzu](https://gdotv.com/blog/fast-scalable-graph-querying-and-visualization-with-kuzu-and-g-v/)
  — viz directly over an embedded graph DB; proof the pairing works and is wanted
- [react-force-graph (vasturiano)](https://github.com/vasturiano/react-force-graph)
  — the force-graph component family: 2D, 3D, and VR/XR variants of the same
  renderer, trivially fed from a node/edge array; the reference wiring exists in
  [neo4j-3d-force-graph](https://github.com/jexp/neo4j-3d-force-graph) — the
  demo to steal: driver → query → link objects, here with RelateDB-WASM in
  the same tab and no driver at all
- Andrei Kashcha ([anvaka](https://anvaka.org/),
  [repos by stars](https://github.com/anvaka?tab=repositories&q=&type=&language=&sort=stargazers))
  — the deepest single catalog of graph-rendering genius:
  [VivaGraphJS](https://github.com/anvaka/VivaGraphJS) (the classic WebGL
  graph renderer), the [ngraph](https://github.com/anvaka/ngraph) ecosystem
  (a whole high-performance graph toolkit, layouts and pathfinding included),
  [city-roads](https://github.com/anvaka/city-roads) (OSM road networks
  rendered in-browser), and the
  [graph-drawing-libraries survey](https://github.com/anvaka/graph-drawing-libraries)
  — both a lineage and a study list
