---
type: Project
name: every-character-network-ever
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Cornell University]]"
  - "[[Company/Gephi]]"
MENTIONS_PERSON:
  - "[[Person/Mark Newman]]"
RELATED_IDEA:
  - kind: complements
    reason: the optional text-to-cast extraction front end the template calls for
    target: "[[Project/book-nlp-to-graph]]"
  - kind: variant
    reason: standard-schema character graphs compared across fictional works
    target: "[[Project/franchise-genealogy]]"
  - kind: complements
    reason: the same run-it-yourself teaching corpus in another form
    target: "[[Project/network-science-interactive]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Every Character Network Ever

> a template exercise: any book, script, or show into the character graph; the
> Cornell INFO-2040 genre, productized as a notebook.

## What

Every year, hundreds of Cornell INFO-2040 students build a character network:
take a beloved text, list the characters, count pairwise co-appearances, load
it into Gephi, find the protagonist by centrality. The genre repeats across
Harry Potter, Lord of the Rings, Star Wars, Hamilton, the Bible, Grey's
Anatomy — it is *the* on-ramp where non-technical people first discover that a
graph is a thing they can reason with. But every instance is a one-shot
artifact: a spreadsheet and a screenshot, rebuilt from scratch each semester.

This project productizes the template: one notebook-shaped pipeline that takes
any text — book chapters, film/TV scripts, transcripts — and produces the
character graph with a standard schema (`Character`, `APPEARS_IN {chapter,
scene}`, `INTERACTS {weight}`, optional `MENTIONS` and sentiment), plus a
standard query pack (centrality rankings, communities, bridges, the
who-dies-and-why-does-the-network-survive analysis). Every resulting graph is
the same shape, so the final exercise — compare networks across texts, or
against Beveridge's curated benchmark — is a cross-graph query, not a collage
of screenshots.

The genre anchors all check out. The linked INFO-2040 post is real — the course
blog for Cornell's Networks class (cross-listed INFO 2040/CS 2850/Econ 2040/
SOC 2090) — and it walks exactly this exercise: a 21,647-character wiki graph,
degree centrality, disconnected components, missing-link inference. At the
curated end, Beveridge's Network of Thrones keeps extending the same treatment
with published per-book and per-season networks (PageRank, eigenvector,
weighted degree), and Knuth's 1993 Les Misérables co-appearance graph — 77
characters, 254 weighted edges — remains the genre's oldest instance, bundled
with Gephi and hosted in Newman's collection.

## Why RelateDB

The genre is currently tool-fragmented: spreadsheets for construction, Gephi
for layout, screenshots for sharing, nothing for querying. RelateDB
collapses that into one thing: the notebook builds the graph via the Python
bindings, every analysis *is* a Cypher query (so the insight is inspectable —
the centrality list comes with the query that produced it), and the output is
a `.cl` file — the assignment handable-in as a single artifact the instructor
opens and queries, including in a browser tab via the WASM build. The
comparative exercise wants multiple graphs at once, which the embedded model
makes trivial (open a second store, `SAME_AS` the shared-schema nodes), and
the WAL means the inevitable "I found three more characters I missed" fix is
an append, not a redo. Standard schema across the class also makes the whole
semester one aggregate graph of graphs.

## What it needs

- The template pipeline: text → scenes → cast (manual, NLP-assisted, or the
  Book NLP to Graph extraction as an optional front end)
- A standard schema document + starter query pack (centrality iterations,
  community labels, comparative queries) — cookbook-recipe style, tested
- Instructor tooling: open a submitted `.cl` file, run the rubric queries
- Front-end: the WASM explorer as the "look at my graph" view; optional
  cross-text comparison dashboard
- A gallery: the texts already done (Les Mis and GoT exist as data; more welcome)

## Lineage & inspiration

- Cornell INFO-2040 character-network genre — the course blog tradition this
  productizes: https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
- Beveridge's Network of Thrones data — the curated benchmark and model result:
  https://github.com/mathbeveridge/asoiaf | paper:
  https://mathbeveridge.github.io/files/NetworkofThrones.pdf
- Knuth's Les Misérables co-appearance graph (Gephi's bundled datasets) — the
  genre's oldest instance: https://docs.gephi.org/User_Manual/datasets/
- Mark Newman's collection and the NetworkX gallery — canonical small graphs
  and the recipe tradition: https://websites.umich.edu/~mejn/netdata/ |
  https://networkx.org/documentation/stable/auto_examples/index.html
- Interactive network-science course (chatox) — "run it yourself" cells:
  https://chatox.github.io/networks-science-course/
