---
type: Project
name: graph-school
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Gephi]]"
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Mark Newman]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Cytoscape]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/sigma.js]]"
---

# Graph School

> A browser-based playground where students load canonical graphs (Karate Club,
> Les Misérables, C. Elegans) and write their first Cypher against them.

## What

Graph School is the "hello, graph" site: a five-minute first experience with a
property graph. The student opens the URL, picks a canonical dataset from a
carousel — Zachary's karate club, Les Misérables, the dolphins of Doubtful Sound,
Florentine families, the C. Elegans connectome — and gets a drawn graph plus a
query bar. The first prompt writes itself: `MATCH (p:Person)-[:KNOWS]->(q) RETURN
p, q LIMIT 25` on Karate Club, rendered as the subgraph, arrows and all.

From there, a stepped track of twenty micro-exercises: find the two highest-degree
characters in Les Mis; count the factions in the karate club; find the shortest
path between Jean Valjean and Javert; filter the dolphins by sex. Each step is a
half-written query the student completes, with the expected drawing shown when they
get it right. Everything runs in the tab — no account, no install, no notebook
kernel.

The pedagogical bet is the same one Neo4j's movies/northwind examples made for
property graphs: people learn graphs by querying a graph they already have
feelings about. Everybody has opinions about Valjean and Javert; nobody has
opinions about `edges.csv`.

The teaching pack is provenance-stable, which keeps the data work trivial.
Gephi's sample-datasets page ships Les Misérables, the dolphins and the
Florentine families; Mark Newman's University of Michigan network-data page is
the collection most of those files originally trace back to; Zachary's karate
club has its canonical NetworkX example; and the aggregated
datasets-for-visualization catalogs list exactly this tier of small,
well-known graphs for teaching. The missing artifact is not the data — it is
the query bar and the exercise track, which is all this project adds.

## Why RelateDB

The canonical graphs are tiny (34–77 nodes), so the WASM build loads them
instantly and every query round-trips at in-memory speed — the graph redraws
fast enough to feel like editing, not submitting. Each dataset is a single `.cl`
file the page fetches; the site itself is fully static. Because RelateDB is a
real Cypher engine (openCypher TCK 3892/3892), the query bar teaches the genuine
language — what a student learns at Graph School works unchanged against a
Neo4j instance years later. And `db.schema.visualization` gives the site a free
"what shape is this data" panel for every dataset, the way Neo4j Browser does.

## What it needs

- A static site: dataset picker, WASM engine, query bar, subgraph rendering
  (sigma.js or Cytoscape is enough at this scale)
- 5–8 canonical graphs pre-bundled as `.cl` stores, provenance recorded
- A ~20-step exercise track with expected results (the cookbook's recorded
  result-block format is the template)
- Schema panel via `db.schema.visualization`

## Lineage & inspiration

- [Zachary's karate club](https://en.wikipedia.org/wiki/Zachary%27s_karate_club)
  and its [NetworkX example](https://networkx.org/documentation/stable/auto_examples/graph/plot_karate_club.html)
  — the most-cited small graph in history; the "hello graph"
- [Gephi's sample datasets](https://docs.gephi.org/User_Manual/datasets/) — Les Mis,
  dolphins, Florentine families; the classic teaching pack
- [Mark Newman's network data page](https://websites.umich.edu/~mejn/netdata/) —
  the curated collection most teaching datasets trace back to (provenance-checked)
- [Neo4j graph examples](https://github.com/neo4j-graph-examples/movies) —
  movies/northwind/recommendations; the first-load demo-database model to port
- [NetworkX guides](https://networkx.org/nx-guides/content/applications/index.html)
  — the guided, notebook-based case-study format
- [Datasets for Visualization Construction](https://visdatasets.github.io/) —
  the aggregated catalog of small canonical teaching graphs
