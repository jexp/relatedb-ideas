---
type: Project
name: wordnet-but-queryable
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
RELATED_IDEA:
  - kind: complements
    reason: NetworkX gallery WordNet recipes ported to Cypher
    target: "[[Project/networkx-runtime]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/D3]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/WordNet]]"
---

# WordNet, But Queryable

> The synset/hypernym graph loaded into RelateDB; "shortest path from *dog*
> to *distrust*" as a party trick and a linguistics tool.

## What

Princeton's WordNet is the lexical graph of English: ~155k words mapped into
~117k synsets (meaning groups), joined by a dense web of semantic relations —
hypernymy (is-a), meronymy (part-of), antonymy, entailment. Every existing
interface to it is a browser: you type a word, you see its senses. None of them
let you *ask the graph anything*.

This project loads WordNet into RelateDB and hands you a query bar. The
shortest-path games come first: `MATCH p = shortestPath((:Synset {gloss:'dog'})
-[:HYPONYM|HYPERNYM*]-(s:Synset {gloss:'distrust'})) RETURN p` — the path is the
answer, at party speed, offline. Then it stops being a toy and becomes a
linguistics bench: depth of every noun from the entity root (one aggregation);
the hypernym that maximally splits a word's polysemy; the antonymy subgraph and
its structure; the most polysemous words (`MATCH (w:Word)-->(s) RETURN w,
count(s) ORDER BY count(s) DESC`).

Because it is one file, the linguistics department ships it: exercises are
saved as query galleries, students load the same `.cl` file, homework answers
are queries.

Princeton's site confirms the framing in its own words: WordNet is "a large
lexical database of English" whose 117,000 synsets each express a distinct
concept, joined by labeled semantic relations into a navigable network — no
longer developed, but freely and publicly available, with Open English
WordNet as the community successor. And the browsing demand is proven beyond
the README: Visual Thesaurus's "Visual Wordnet" is a D3-powered
semantic-network explorer over WordNet — clickable synsets with hypernym,
hyponym, meronym and holonym edges. Every precedent treats it as a network to
walk; none as a database to query.

## Why RelateDB

WordNet is exactly the size that embarrasses other deployments and delights
RelateDB: ~117k synsets and ~200k relation edges fit comfortably in an
in-memory store, where shortest-path and neighborhood queries run in
milliseconds with no server at all. The WASM build makes "the whole English
language in a browser tab, queryable" a real page — a parquet-checkpoint-sized
public graph, preloaded once and queried forever. The CLI makes it equally a
laptop tool (`relate --database wordnet.cl`), and the hybrid/fulltext
search lets the front end offer lexical lookup ("glosses mentioning 'canine'")
and exact-sense queries side by side — the vector lane even supports "synsets
near this meaning" exploration.

## What it needs

- A WordNet → `.cl` converter: synsets as nodes (gloss, POS, lexicographer
  file), words as nodes or properties, relation types mapped to relationships;
  provenance and license noted (WordNet 3.1 is open)
- A front end: query bar, path rendering, sense browser for results
  (wordnet-web-style browsing as a bonus layer)
- A curated query gallery: party tricks (dog→distrust), depth analyses,
  polysemy rankings, meronym games
- Optional: the hybrid-search "semantically nearby synset" panel

## Lineage & inspiration

- [Princeton WordNet](https://wordnet.princeton.edu/) — the dataset itself;
  the parquet-checkpoint-sized public lexical graph
- [wordnet-web](https://github.com/rektdeckard/wordnet-web) and
  [Visual Thesaurus's WordNet explorer](https://www.visual-thesaurus.com/wordnet.php)
  — proven demand for browsing the synset graph; this project makes it
  *queryable*, not just browsable
- The NetworkX gallery's WordNet recipes — the computations people already do
  with it, ported to Cypher
