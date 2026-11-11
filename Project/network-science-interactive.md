---
type: Project
name: network-science-interactive
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
RELATED_IDEA:
  - kind: complements
    reason: both teach graph concepts through runnable exercises
    target: "[[Project/graph-school]]"
  - kind: complements
    reason: ports the same NetworkX recipe catalog into Cypher
    target: "[[Project/networkx-runtime]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Network Science, Interactive

> Barabási's course and textbook as a live sandbox: generate BA/WS/ER graphs,
> watch degree distributions emerge, overlay centrality heat — every exercise runs
> as Cypher in the browser, no install.

## What

Take [networksciencebook.com](https://networksciencebook.com/) — the free, interactive
network-science textbook that has onboarded a generation of students — and replace
its static figures with live Cypher cells. Chapter 5 explains scale-free degree
distributions; the companion exercise generates a Barabási–Albert graph right there
in the tab, then `MATCH (n)-[]->(m) RETURN n.degree, count(*)` draws the power law as
it emerges from the generative model. Chapter 2's random-graph section does the same
for Erdős–Rényi and Watts–Strogatz, with the student twirling the rewire probability
and watching path length and clustering move in opposite directions.

A session looks like: open the chapter URL, hit "run" on the first cell. The dataset
(or generator) is already there — a preloaded `.cl` store or a `CREATE` loop seeded
from a parameter panel. Change a parameter, re-run, compare histograms side by side.
Then the exercises: every "try it yourself" box is a Cypher query the student edits,
not a Python notebook they install.

The compounding piece is that each exercise's *result* can be stored: a student
generates a BA graph, computes centrality, writes the scores back as node
properties, and the next exercise queries them. The course stops being a sequence
of slides and becomes one growing graph the student owns.

Both anchors verify. networksciencebook.com is Barabási's free online
*Network Science* textbook, and it ships with an interactive visualizations
section — the live-figure culture this project upgrades from "watch the
figure" to "edit the query that produced it". The chatox course is real too,
and its shape is instructive: Universitat Pompeu Fabra's network-science
course publishes theory slides, practicum activities, datasets and past exams
under a CC license, built explicitly on Barabási's book — the course-pack
model. The gap both leave is the store: no student owns the graph their
exercises produced, and no figure's dataset answers follow-up questions.

## Why RelateDB

The WASM build is the whole story: the sandbox is a URL, not an install, and the
engine executes Cypher in the tab at in-memory speed, so generative loops over
thousands of nodes and the aggregation queries over them both feel instant. The
single-file store (WAL + Parquet checkpoint) means a chapter's dataset ships as
one artifact the page fetches once and queries forever — no server, no fetch per
cell. And because it is real Cypher (openCypher TCK 3892/3892), the queries students
write transfer directly to Neo4j or GQL careers later.

## What it needs

- A small static site: chapter pages + embedded WASM engine + result rendering
  (the cookbook's WASM parity build is the template)
- ~10 curated datasets from the book's chapters (co-authorship, internet AS graph,
  protein interactions) as prebuilt `.cl` stores
- Graph generators as Cypher: BA, WS, ER (loops of `CREATE`/`MERGE`, parameterized)
- A plotting layer over query results (histograms, log-log degree plots)
- Centrality exercises: degree/clustering computed in Cypher and written back as
  node properties for the next cell to consume

## Lineage & inspiration

- [Barabási's Network Science book](https://networksciencebook.com/) — the textbook
  this project makes live
- [Netzschleuder](https://networks.skewed.de/) — the network catalogue; source of
  the book's datasets (and hundreds more)
- [chatox's networks-science course](https://chatox.github.io/networks-science-course/)
  — the CC-licensed course-pack (slides, practicum, datasets) built on
  Barabási's book; this project supplies the missing queryable store
- [NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
  — the 300-recipe corpus of "what people actually compute on graphs" to port the
  top ~20 of
