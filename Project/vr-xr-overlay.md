---
type: Project
name: vr-xr-overlay
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/W3C]]"
MENTIONS_PERSON:
  - "[[Person/Michela Ledwidge]]"
RELATED_IDEA:
  - kind: complements
    reason: same anchored world graph on the map
    target: "[[Project/openstreetmap-wedge]]"
  - kind: complements
    reason: same anchored world graph on the robot
    target: "[[Project/robot-side-brain]]"
USES_TECH:
  - "[[Technology/CityJSON]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/IFC]]"
  - "[[Technology/MCP]]"
  - "[[Technology/OpenStreetMap]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/WebXR]]"
---

# VR/XR Overlay

> A graph of the game/space/room anchored to poses; "what's connected to the
> machine I'm looking at" — the HUD is a query result.

## What

In VR/XR, the interesting question is almost never "what object is this"
but "what is this *connected to*" — the machine I'm looking at belongs to a
system, a system to a line, a line to a supplier. This project makes the
HUD a query result: a property graph of the game world, factory floor,
server room, or museum, with every node anchored to a 3D pose (position,
orientation, bounds as properties). The headset's gaze/raycast resolves to
a node; a query runs; the result renders as an in-world overlay —
connected machines glow, upstream dependencies draw as animated edges,
"what happens if I switch this off" previews as a subgraph highlight.

The same store serves XR's two audiences at once: the *player* (the game
world's quest chains, factions, and trade routes as an exploratory
overlay: "show me everyone who has met this character") and the
*technician* (maintenance history, safety interlocks displayed exactly
where each fact lives: hover a valve, see its last inspection and the
systems that depend on it).

Because every overlay is a query, XR authoring becomes data work: build
the graph (OSM extract, BIM export, or game state); the visual layer is a
thin renderer over parameterized Cypher.

Immersive graph visualization has a real evaluation lineage to build on:
a 2016 IEEE TVCG study of layout, rendering, and interaction methods for
VR graph view; 2019 work on immersive analytics of large dynamic
networks; and a growing set of domain systems — Graph2VR walks
semantic-web graphs in VR for life-science research, AIDEN visualizes
RDF graphs in VR, and a Semantic Web journal study put historical
knowledge graphs into headsets. All of them render a graph file; none
makes the overlay a *query result* — that is the gap this project takes.

## Why RelateDB

The WASM build means the engine can run in-browser for WebXR — the whole
overlay stack (engine + graph data as one `.cl` file + WebXR renderer) is a
web page, no backend, which is how XR content actually wants to ship.
In-memory Cypher answers gaze-anchored queries inside the frame budget:
raycast → node → one-hop context is a sub-millisecond pattern match. Point properties anchor nodes in the world frame; the WAL
durable-forms the *editing* story (a technician's overlay annotations,
equipment status changes, quest-state updates) without a server round
trip. And `relate serve --mcp` opens agent-driven XR: an assistant that
sees what you see, querying the same shared graph.

## What it needs

- Pose-anchored graph convention: `(:Object {pose, bounds})` plus typed
  dependency edges; a BIM/IFC or game-state importer per domain
- The bridge: engine (WASM, WebXR) → raycast resolution → parameterized
  query → edge/glow overlay rendering
- Authoring tooling: overlays as named queries with anchors, so XR
  experiences are query packs over shared graphs
- Performance validation: frame-budget traces for query-and-render on
  commodity XR hardware

## Lineage & inspiration

- [WebXR](https://www.w3.org/TR/webxr/) — the browser-side runtime that makes a WASM engine the natural graph host
- [OpenStreetMap Wedge](openstreetmap-wedge.md) / [Robot Side-Brain](robot-side-brain.md)
  — the same anchored-world-graph idea, on the map and on the robot
- [MetaExp — humane graph exploration](https://mott.in/projects/graph-exploration/)
  — "show only what is relevant to what you're looking at," in headset form
- [Layout, rendering, and interaction for immersive graph visualization
  (IEEE TVCG 2016)](https://dl.acm.org/doi/10.1109/TVCG.2016.2520921) —
  the evaluation lineage for VR graph view
- [Graph2VR (life-science study)](https://pmc.ncbi.nlm.nih.gov/articles/PMC12090995/)
  — semantic-web graphs explored in VR
- [Immersive analytics of large dynamic networks](https://arxiv.org/abs/1910.06825)
  — overview+detail navigation at graph scale, in headset form
- [CityJSON/IFC BIM models](https://www.cityjson.org) — the real-world
  building data that becomes walkable, queryable overlays
- **Grapho XR / Michela Ledwidge** — spatial graph visualisation and
  storytelling in VR ([Nodes 2024 talk](https://neo4j.com/nodes2024/agenda/spatial-graph-visualisation-and-storytelling-with-grapho-xr/);
  [Neo4j blog on Grapho](https://neo4j.com/blog/graph-visualization/spatial-visualization-grapho/)):
  documentary worlds as navigable graphs —
  [A Clever Label](https://dl.acm.org/doi/10.1145/3532834.3536206), an
  investigative-documentary experience with an open graph API, showed at the
  SIGGRAPH 2022 Immersive Pavilion. The practitioner lineage for this
  project's storytelling audience: real, named work that already puts
  graphs on heads — the embedded step is what it was missing
