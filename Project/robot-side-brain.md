---
type: Project
name: robot-side-brain
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Kuzu]]"
RELATED_IDEA:
  - kind: complements
    reason: the same embedded device-side graph store for a different host
    target: "[[Project/on-device-agent-graph-store]]"
  - kind: complements
    reason: supplies the affordance and room vocabulary as queryable structure
    target: "[[Project/rdf-ontology-metagraph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Schema.org]]"
  - "[[Technology/WASM]]"
---

# Robot Side-Brain

> A small device's world model: rooms, objects, tasks, affordances as a
> graph; plans are path queries; the map is the database.

## What

A vacuum, a warehouse AMR, a lawnmower, a lab robot — each carries a
collision-avoidance brain, but none carries a *world model* a person or a
task planner can query. The side-brain project gives one to any small
device: rooms, doors, furniture, objects, chargers, and task states as
labeled nodes; adjacency, containment, and affordance relationships
("kitchen CONNECTS_TO hallway", "cup SITS_ON table", "dock REACHABLE_VIA
corridor") as typed edges, anchored to coordinates via point properties.
The robot's map stops being an opaque occupancy grid and becomes a
queryable description of the home.

Plans then read as graph queries: "find a graspable object that is not on
the floor, reachable without traversing the room where the human is" is a
`MATCH` with containment and adjacency predicates. Task state rides in the
same store: the current task chain, completed steps, and detected anomalies
are nodes and edges, so "why did you skip the kitchen?" is answerable from
the graph — a debuggability gift for robot developers and an
explainability gift for everyone else.

This is a live research line with running systems: MIT SPARK's Hydra
builds 3D scene graphs in real time from SLAM output — places, rooms,
objects as hierarchical, pose-anchored layers (RSS 2022) — and Kimera
extended the same idea to multi-robot 3D *dynamic* scene graphs (agents,
objects, and places as typed layers); Hughes' 2023 survey consolidates
the hierarchical-world-model program. What that line does not have is
the side-brain role: scene graphs live inside a C++ process and vanish
with it — nobody can open yesterday's belief state and ask why the
kitchen was skipped.

## Why RelateDB

The C ABI makes the engine embeddable from C/C++ on device-class hardware —
the same product C ABI the JS/Java/Go and mobile wrappers use — with
in-memory Cypher answering world-model queries on a robot's CPU budget, no
database process. The WAL gives crash-safe task state: a robot that dies
mid-task resumes from the log — exactly the durability a device that gets
its battery pulled needs. Point types anchor every object in the world
frame. And for development, the same store opens on the engineer's laptop
CLI or in the browser (WASM) to replay "what did the robot believe at
14:02" — the world model as an inspectable, diffable artifact rather than
a binary blob.

## What it needs

- Bindings/integration: C ABI from the robot's runtime; a small adapter
  over ROS topics, SLAM landmarks, or kit sensor data
- A world-model vocabulary: room/object/affordance labels (aimed at
  Schema.org / Bot-inspired ontologies where possible)
- Task-state schema: tasks, steps, failures as temporal graph elements on
  the WAL
- A desktop replay/debug companion: open the robot's store, query the
  belief state, export a time slice

## Lineage & inspiration

- [NetworkX geospatial examples](https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html)
  — the graph-as-world-model analytical vocabulary
- [RDF Ontology Metagraph](rdf-ontology-metagraph.md) — the vocabulary
  companion: affordance/room ontologies as first-class queryable structure
- [Hydra (RSS 2022)](https://roboticsproceedings.org/rss18/p050.html) —
  real-time 3D scene-graph construction from SLAM
- [MIT-SPARK/Kimera](https://github.com/MIT-SPARK/Kimera) — 3D dynamic
  scene graphs, multi-robot
- [Foundations of Spatial Perception for Robotics](https://arxiv.org/abs/2305.07154)
  — the survey of the hierarchical world-model program
- [Kuzu](https://github.com/kuzudb/kuzu) and the Apple acquisition —
  graph-shaped storage on small devices is where the industry is heading;
  this project rides RelateDB into that niche
- RelateDB's `lab fs-to-graph` — the ingest-everything, query-the-result
  pattern, applied to sensor streams
