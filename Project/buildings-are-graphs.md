---
type: Project
name: buildings-are-graphs
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
RELATED_IDEA:
  - kind: complements
    reason: version-to-version IFC comparison rendered as a graph diff
    target: "[[Project/diff-view-for-graphs]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/IFC]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Buildings are Graphs (BIM)

> Building Information Models in the open IFC format imported as graphs
> (walls, slabs, spaces, systems, crews, tasks) for topology analysis,
> clash and filter queries, and version-to-version model comparison.

## What

An IFC file *is* a graph that refuses to admit it. A building model is
thousands of elements — walls, slabs, doors, spaces, pipes — each
connected by explicit relationships: contained-in-storey,
bounded-by-space, part-of-system — a labeled property graph in a STEP
costume. Everyone in BIM feels the mismatch:
the questions architects actually ask — "which rooms does this fire
compartment touch," "which circuits fail if this panel trips" — are
topological, and the file formats make them joins.

The import maps IFC's relationship entities directly to Cypher
relationships: `(:Wall)-[:BOUNDS]->(:Space)`, `(:Pipe)-[:PART_OF]->(:System)`,
`(:Crew)-[:BUILDS]->(:Task)-[:CONSTRUCTS]->(:Element)`. Then the
questions open up: adjacency through the topology; clash queries over
neighbors; and — the one no geometry tool does well — *version
comparison*: "what changed between R14 and R15" as a diff over two
graph snapshots.

## Why RelateDB

A building model is a single-file artifact — one `.ifc` on an
architect's laptop, tens of thousands of elements, never a server
workload. The import lands in one `.cl` file the size of the original;
every query runs in-memory, interactive — no database in the site
cabin. The WAL + Parquet history is the version-comparison substrate:
each revision's import is a durable checkpoint, the diff between
revisions queryable *as* graph history, not text diffs of STEP files. Point types hold coordinates, the WASM
build renders the model in a browser tab, and `relate serve` shares
it with the team — Bolt for engineering tools, `--mcp stdio` so an
agent answers "which walls changed".

## What it needs

- An IFC → graph importer — the STEP entity graph walked into nodes and
  relationships (the ifcOpenShell lineage makes it a mapping problem,
  not a parsing one)
- Geometry as data: bounding boxes as properties for spatial and clash
  pre-filtering
- The query pack: fire-compartment reachability, system dependency, takeoff
  as named Cypher; the [Diff View for Graphs](diff-view-for-graphs.md)
  rendering on top; a 4D schedule/task layer for sequencing

## Lineage & inspiration

- Will Reynolds — topologicBIM (Hoare Lea): the
  [LDAC 2020 presentation](https://linkedbuildingdata.net/ldac2020/files/presentations/LDAC2020_IND2_WillReynolds.pdf)
  and [video](https://www.youtube.com/watch?v=OOihIxbo0dE) — topology as
  the missing layer over BIM
- Ali Ismail — [ifcwebserver](https://github.com/ifcwebserver) and the
  [TU Dresden IFC-to-graph thesis](https://tu-dresden.de/bu/bauingenieurwesen/cib/ressourcen/dateien/publikationen/Projekt-_Diplomarbeiten/Masterarbeit_Ahmed_Nahar_2017.pdf)
  — the import proven feasible years before it was practical
- The [Neo4j community BIM thread](https://community.neo4j.com/t/connecting-neo4j-to-building-information-models/15983d)
  and the Linked Building Data / LDAC community — the demand, unmet
