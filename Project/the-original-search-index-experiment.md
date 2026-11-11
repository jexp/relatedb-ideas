---
type: Project
name: the-original-search-index-experiment
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Google]]"
  - "[[Company/Stanford University]]"
RELATED_IDEA:
  - kind: complements
    reason: license-clean link corpus for the no-crawler version
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/PageRank]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The Original Search-Index Experiment

> Recreate the founding PageRank/backlink experiment: crawl a web neighborhood
> (or load a web-graph dataset), build the link graph, compute ranking with
> plain Cypher iterations — and watch the orderings emerge, exactly as the 1998
> experiment did, but interactively in your browser.

## What

In 1998, the experiment was simple: take a crawl of the web — pages as nodes,
hyperlinks as edges — and ask what link structure *means*; the answer (backlinks
weighted by their source's importance, iterated until the orderings settle)
became PageRank. This project rebuilds it as an interactive lab: load a web
graph and compute ranking with nothing but plain Cypher, one iteration per cell.

The loop is the lesson. Start with a uniform importance on every page (`SET
n.rank = 1.0`). One hop: `MATCH (a:Page)-[:LINKS_TO]->(b:Page) WITH b,
sum(a.rank) AS incoming SET b.newRank = incoming` (the simplification that makes
the concept visible; damping arrives in the next exercise). Re-render with node
size = rank. Run the cell again: some pages swell, most shrink. Run it ten
times: the orderings stabilize — hubs emerge from pure link structure. A
damping slider and a convergence chart close the exercise.

Two data modes: crawl a real neighborhood (a bounded BFS over a site's links),
or load a classic web-graph dataset (Stanford WebBase slices, a Wikipedia link
neighborhood). The gallery then asks the 1998 questions: who is authoritative,
who is a dead end, which page is the best hub, how much does one inserted
backlink perturb the whole ranking.

## Why RelateDB

The computation is graph-shaped aggregation — `MATCH` the edges, `sum` per
destination, write back — which is exactly what in-memory Cypher at scan speed
does; each iteration over tens of thousands of edges is a sub-second cell run,
so convergence becomes a *watchable* animation instead of a batch job. The WASM
build puts the whole experiment in a browser tab, dataset included — a URL a
lecturer can put on a slide. Writes persist to the WAL, so every iteration's
mutation is durable and diffable between checkpoints ("before and after
iteration 7"), and the single `.cl` file ships the crawl plus the computed
ranks as one artifact (fs-to-graph is the crawler's template).

## What it needs

- Data: a bounded crawler (BFS to depth 2–3, edges only, robots-respecting) plus
  2–3 prebuilt web-graph datasets as `.cl` stores
- The PageRank-as-Cypher exercise loop: parameterized iteration queries,
  rank writes, convergence chart
- A rendering layer: node size / color bound to rank; scrub between iterations
- Honest framing in the material: this is PageRank-as-pedagogy, not a search
  engine

## Lineage & inspiration

- [The Anatomy of a Large-Scale Hypertextual Web Search Engine](http://infolab.stanford.edu/~backrub/google.html)
  — the 1998 BackRub/Google paper this experiment recreates
- Stanford WebBase / early web-graph datasets — the crawlable link-graph corpora
- Barabási's network-science chapters on hubs and scale-free structure — the
  adjacent lesson this lab dovetails into
- The Wikipedia-wedge pattern — a license-clean link-neighborhood corpus for
  the no-crawler version
