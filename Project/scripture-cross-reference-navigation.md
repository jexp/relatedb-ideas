---
type: Project
name: scripture-cross-reference-navigation
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: explicitly applies the walked-surface artifact pattern to sacred text
    target: "[[Project/strategy-graphs-as-shipped-artifacts]]"
  - kind: inspired-by
    reason: cited as the walk protocol behind the hill-climb navigation
    target: "[[Project/the-graph-walking-agent-cursor]]"
  - kind: complements
    reason: cited for the scholarship craft the query pack follows
    target: "[[Project/the-hnr-humanities-pack]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/OpenBible]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Scripture Cross-Reference Navigation

> The Bible's cross-reference network — 200k+ typed edges between verses,
> free CC-BY corpora — as a portable navigation artifact: a KJV hill-climb
> where "the graph lists the options; Jev only scores them," and the
  reader walks verse to verse with recorded provenance.

## What

The biblical cross-reference tradition is one of the great handmade graph
corpora: editions and tools (OpenBible's vote-weighted cross-references,
the Treasury of Scripture Knowledge lineage, topical co-occurrence sets)
publish verse-to-verse links — parallel passages, fulfillment citations,
allusion chains, quoted-from edges — at 200k+ edges, free and CC-BY. The
tail built the interaction the corpus deserved: bible-jev-climb
hill-climbs the network — "the graph lists the options; Jev only scores
them" — a verse-to-verse navigation where the reader states the goal and
the *existing edges* are the only legal moves.

This project ships that as an artifact, not a session:

- The corpus as `.cl`: `(:Verse {book, chapter, text})` with typed
  cross-reference edges (`PARALLEL`, `QUOTES`, `FULFILLS`, `ALLUDES_TO`,
  `TOPIC`), vote weights as properties, and the citation network around
  it (verses → commentaries, translations, source editions)
- **Walked navigation**: the hill-climb pattern — options are the verse's
  real edges; scoring against the reader's stated intent; every walk a
  recorded path (the Strategy-Graphs pattern on sacred text)
- **The scholar's queries**: the allusion chain between two books as a
  shortest-annotated-path question; which parallels are *bidirectional*
  (mutual citation — the strongest claims); cluster detection around a
  theme verse; the intertextual neighborhood as a subgraph export (the
  passage-study pack)
- **Reading with provenance**: any published study built from walks
  carries its citation paths — chain of custody for interpretation

## Why RelateDB

The corpus is a few MB — one file, one tab, a phone. Typed-edge,
weight-ranked, path-shaped questions over it are native Cypher; the WASM
tab makes a cross-reference explorer that needs no site, no account, no
server (the sword-study tools exist, none queryable, none graph-native);
the walk-recording gives Bible-study groups and classes a shared
navigation artifact (the GraphGists pattern applied to the most-linked
text in history).

## What it needs

- The corpus loader (OpenBible/TSK-style cross-reference exports, verse
  text, translations) with per-corpus license notes kept in the store
- The walk protocol (the hill-climb: options from the graph, scoring at
  the surface, walks recorded)
- The scholar's query pack: annotated shortest paths, bidirectional-
  parallel detection, theme clustering, neighborhood export
- The study-artifact format: a group's recorded walks over a passage as
  a shareable file

## Lineage & inspiration

- bible-jev-climb — the tail's graph-lists-options hill-climb over KJV
  cross-references (`research/jev-longtail.md`)
- [OpenBible cross-references](https://www.openbible.info/labs/cross-references/)
  — the vote-weighted, free corpus this project ingests; the Treasury of
  Scripture Knowledge — the century-old cross-reference lineage
- [The Strategy Graphs](strategy-graphs-as-shipped-artifacts.md) — the
  walked-surface pattern this applies; [The Graph-Walking Agent
  Cursor](the-graph-walking-agent-cursor.md) — the protocol; [The HNR
  Humanities Pack](the-hnr-humanities-pack.md) — the scholarship craft
- bible-matrix/other verse-graph tools — the incumbent browse-only
  generation this upgrades from links to queries
