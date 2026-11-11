---
type: Project
name: code-cities
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/USI Lugano]]"
MENTIONS_PERSON:
  - "[[Person/Adam Tornhill]]"
  - "[[Person/Richard Wettel]]"
RELATED_IDEA:
  - kind: complements
    reason: shares the churn and complexity graph instead of forking the analysis
    target: "[[Project/software-design-x-rays]]"
USES_TECH:
  - "[[Technology/Cosmograph]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/WebGPU]]"
  - "[[Technology/cosmos.gl]]"
  - "[[Technology/three.js]]"
---

# Code Cities

> The city metaphor rendered from a live graph: buildings are files, districts are modules, height is complexity, decay is churn. Walk your own codebase as a city, in a browser tab.

## What

CodeCity (Wettel) gave software cartography its enduring metaphor: render a
codebase as a city — districts are packages/modules, buildings are files, height
is complexity (or size), and color encodes churn or health. You *walk* the
system: the financial district's towers, the sprawling slums of generated code,
the shiny low-rise of last quarter's rewrite. Spatial memory does the analysis:
the tall, dark building registers before row 4,000 of a complexity CSV ever
would.

This project renders the city from a *live* graph rather than a static export —
the same store as Software Design X-Rays (churn from `git-to-graph`, complexity
as a property). The city is one parameterized query: change the encoding —
height = churn instead of complexity, color = test coverage — and the city
reshapes around a new question. Replay the WAL and it *decays visibly over
time*: watch the hotspot towers grow, one quarter per frame. The WASM build
puts it all in a browser tab: drop the .cl file on a page, walk your codebase —
no server, no data leaving the machine.

## Why RelateDB

The rendering is a *query result*: buildings are a Cypher traversal (files
grouped by module, ordered by a metric), so any metric you can express becomes
a new city view — the graph is the model, the city is a projection, and there's
no separate analysis pipeline to keep in sync. In the tab the whole engine runs
locally: the .cl file loads in-memory, queries run at scan speed, and pan/zoom
re-issues bounded traversals (load the district first, the buildings' details
on approach — the humane-large-graph lesson). WAL-backed time-window replay
gives the timelapse mode, and the CLI produces the same views headlessly
(`--mode json` → the renderer's geometry) so a city regenerates in CI next to
the X-rays report.

## What it needs

- The renderer: a 3D city view (three.js/WebGPU) consuming JSON query output —
  buildings, districts, hover/click → file metadata (a 2D isometric first cut
  is more CodeCity-faithful still)
- Metric views: complexity/churn/coverage/test-density encodings as saved
  queries with tuned legends
- Temporal replay mode over the WAL
- Integration with the Software Design X-Rays data model (share the graph,
  don't fork the analysis)
- Performance care: big repos are thousands of buildings — load districts
  progressively by traversal, not one giant result

## Lineage & inspiration

Richard Wettel's **CodeCity** (PhD thesis, USI Lugano — http://codecity.inf.usi.ch/)
— the original metaphor and renderer; this is CodeCity where the model is a
queryable graph instead of a static snapshot. Adam Tornhill's behavioral
analytics (https://adamtornhill.com — the churn-decay encodings, shared with
the **Software Design X-Rays** project). From
[research/graph-world.md](../research/graph-world.md) §3:
[Cosmograph](https://cosmograph.app/)/[cosmosgl/graph](https://github.com/cosmosgl/graph)
(GPU rendering of huge graphs in a tab — the rendering bar to clear) and
Mottin/Müller's [MetaExp](https://mott.in/publications/publications/metaexp/) —
load what's relevant as you approach; a city walked district by district.
