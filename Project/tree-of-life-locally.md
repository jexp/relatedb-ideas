---
type: Project
name: tree-of-life-locally
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/OneZoom]]"
  - "[[Company/Open Tree of Life]]"
MENTIONS_PERSON:
  - "[[Person/Mark Newman]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DateLife]]"
  - "[[Technology/OneZoom]]"
  - "[[Technology/Open Tree of Life]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Tree of Life, Locally

> a phylogeny (e.g. Open Tree of Life subsets) as a graph; MRCA queries, clade pruning,
> trait overlays — for field work without signal.

## What

The tree of life is the largest graph anyone has ever tried to draw — an estimated
~2.3 million described species arranged in a single rooted phylogeny. Nobody loads
all of it, but every biologist loads a *wedge* of it: the land plants, the beetles,
the birds, the clade their paper is about.

This project turns such a wedge into a walkable property graph. Nodes are taxa
(~`Taxon {ott_id, name, rank, source}`), one `PARENT_OF` (or `ANCESTOR_OF`) edge per
taxonomy link, plus `SYNONYM_OF` edges where names disagree and `IN_CLADE` edges for
curated clade definitions. Overlay nodes carry traits: `Trait {karyotype, genome_size,
venomous: true}` linked to the taxa that have them.

Then the classics of phyloinformatics become plain Cypher: most-recent-common-ancestor
is a shortest-path question (walk up from two leaves, intersect ancestor sets);
"every descendant of node X with trait Y" is a single variable-length pattern;
monophyly checks are containment queries. Prune a clade with one `DETACH DELETE`,
then checkpoint the pruned tree as its own file for the supplementary material.

The data — and even the query patterns — are already public. Open Tree of Life
documents v3 web APIs (`/v3/tree_of_life/mrca` for most-recent-common-ancestor,
`/v3/tree_of_life/induced_subtree` for the minimal wedge relating a taxon list,
plus TNRS name matching) and full downloads of its synthetic tree and reference
taxonomy (current releases: synthesis v16.1, OTT v3.7). OneZoom, the 'whole tree
in one browser view' explorer, publishes its own tree APIs and complete
tree-of-life dumps with leaf and node metadata on Zenodo. And DateLife shows the
divergence-date overlay already working as a service: it assembles dated
phylogenies for any list of taxa from the published literature — exactly the
temporal layer this project wants as plain properties.

## Why RelateDB

The field-work framing is the point: a phylogeny wedge is a few hundred thousand nodes,
which fits in memory trivially and persists to a single `.cl` file. A researcher in a
field station (or on a plane, or at a field museum with bad Wi-Fi) opens the file —
no server, no signal, no install. `relate serve` turns one laptop into a shared
MRCA-query service for the whole field course over Bolt or HTTP; the WASM build puts
the same tree in a browser tab for the interactive version of the paper's figure.
Temporal types handle divergence-date estimates; vector/hybrid search lets you find
taxa by *description* ("small brown cave beetle") when you don't remember the Latin
name, and the WAL means every curation edit is durable even on a laptop battery.

## What it needs

- Loader for Open Tree of Life (`ott` dumps / `tnrs` name resolution) → nodes + edges
- Trait overlays from phenotypes or Pantheon-style curated tables (CSV import)
- An MRCA helper (either a stored ancestor-path table or a small procedure — see the
  Dynamic Path Index idea for the general mechanism)
- A clade navigator front-end: a collapsible tree view over a browser WASM instance
- Optional: divergence dates and biogeography (point types) for a "where did this
  clade arise" view

## Lineage & inspiration

- Open Tree of Life — the synthetic tree and its API: https://tree.opentreeoflife.org/
  and the `ott` taxonomy: https://github.com/OpenTreeOfLife/reference-taxonomy;
  developer docs with the v3 services (MRCA, induced subtree, TNRS):
  https://opentreeoflife.github.io/develop/api
- OneZoom — tree APIs and complete tree-of-life dumps (the
  whole-tree-in-a-browser precedent): https://www.onezoom.org/API and
  https://doi.org/10.5281/zenodo.16810117
- DateLife — dated phylogenies for any taxon list from the literature (the
  divergence-date overlay): https://phylotastic.org/datelife/
- Mark Newman's curated network collection (the provenance-checking habit for
  scientific datasets): https://websites.umich.edu/~mejn/netdata/
- Netzschleuder catalogue (where biology graphs like host-parasite webs live):
  https://networks.skewed.de/
- Barabási's *Network Science* (tree/graph basics for the audience):
  https://networksciencebook.com/
