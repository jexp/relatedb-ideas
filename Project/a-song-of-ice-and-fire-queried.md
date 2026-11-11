---
type: Project
name: a-song-of-ice-and-fire-queried
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
  - "[[Person/Andrew Beveridge]]"
  - "[[Person/Mark Newman]]"
RELATED_IDEA:
  - kind: variant
    reason: the Cornell INFO-2040 character-network genre; ASOIAF is its canonical exercise
    target: "[[Project/every-character-network-ever]]"
  - kind: complements
    reason: centrality scores land back in the store via a GDS round-trip import
    target: "[[Project/gds-round-trip]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j GDS]]"
  - "[[Technology/RelateDB]]"
---

# A Song of Ice and Fire, Queried

> the "Network of Thrones" reimagined: character interactions per chapter as a
> temporal graph; who really is the protagonist? (Answer: Tyrion, still — the
> Math Horizons paper proved it.)

## What

Beveridge and Shan's *Network of Thrones* turned *A Storm of Swords* into a
weighted character network and answered the fan question — who is the real
protagonist? — with graph metrics: Tyrion, by every centrality measure, with
Jon and Sansa in the supporting podium. That paper was computed in R, published
as a PDF, and left fans unable to argue back with the data.

This project reimagines it as a live, temporal graph. Beveridge's chapter-by-
chapter edge lists become `Character` nodes and dated interaction edges —
`INTERACTS {weight, chapter, type}` — so the network is not one static snapshot
but a graph that *grows chapter by chapter*. Recompute the centrality story as
of any chapter: watch Daenerys' betweenness spike across the sea, watch the
Stark cluster fragment after the Red Wedding. The "who is the protagonist"
answer becomes a replayable argument fans can interrogate, and each fan theory
("Ned is only central early", "Littlefinger is the hidden bridge") becomes a
time-windowed Cypher query rather than a Reddit assertion.

Every link in this pitch verifies. The Math Horizons paper (Beveridge & Shan,
Vol. 23, No. 4, 2016) is up as a PDF on Beveridge's site; networkofthrones.com
("A Song of Math and Westeros") is live and extends the same treatment
book-by-book and season-by-season with PageRank, eigenvector, and weighted-degree
metrics; and the `asoiaf` GitHub repo publishes the edge lists as clean CSVs —
per-book files plus the all-books combined edge list. The chapter-by-chapter
raw material the temporal model wants is exactly what that repo was built to
hold.

## Why RelateDB

The dataset is tiny and beloved — 107 characters, 353 weighted edges for one
book, the full series still trivially in-memory — which makes the interaction
cost of the WASM browser build the whole point: ship the `.cl` file, open it in
a tab, and every metric query runs instantly with no install. Temporal types
are load-bearing here in a way no static analysis allows: chapter/scene
timestamps turn "the network as of chapter 37" into a filter, and the WAL lets
you extend the dataset with your own re-read annotations without rebuilding.
`relate serve --mcp stdio` even lets an agent answer trivia ("have these
two shared a scene?") against the real graph instead of hallucinating — and
the Python bindings make the chapter-by-chapter extraction reproducible.

## What it needs

- Loader from Beveridge's asoiaf data (chapter-by-chapter interaction matrices,
  per-book edge lists) into the temporal model
- Centrality computations: either in-Cypher iterations (see the PageRank
  experiment idea for the pattern) or a GDS Round-Trip import whose scores land
  back in the store as node properties
- Time-sliced query helpers (network as-of-chapter N; per-POV-window views)
- Front-end: a chapter-slider network explorer over the WASM build — the
  "watch the network grow" experience

## Lineage & inspiration

- Beveridge & Shan, *Network of Thrones* (Math Horizons, Vol. 23, No. 4):
  https://mathbeveridge.github.io/files/NetworkofThrones.pdf
- The Network of Thrones site and data: https://networkofthrones.com/ |
  data page (per-book and per-season networks): https://networkofthrones.com/data/ |
  chapter data: https://github.com/mathbeveridge/asoiaf (per-book edge CSVs, e.g.
  https://github.com/mathbeveridge/asoiaf/blob/master/data/asoiaf-all-edges.csv)
- The Cornell INFO-2040 character-network genre — this dataset is the genre's
  canonical exercise: https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
- Mark Newman's collection (provenance discipline for small famous graphs):
  https://websites.umich.edu/~mejn/netdata/
- Barabási's *Network Science* (the centrality toolbox the paper used):
  https://networksciencebook.com/
