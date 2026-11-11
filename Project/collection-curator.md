---
type: Project
name: collection-curator
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_ORG:
  - "[[Company/Discogs]]"
  - "[[Company/MusicBrainz]]"
RELATED_IDEA:
  - kind: variant
    reason: collection-as-guided-tour for institutions instead of private shelves
    target: "[[Project/museum-as-graph]]"
  - kind: complements
    reason: explicitly shares the MusicBrainz lineage and path-between-artists query
    target: "[[Project/music-genealogy]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Discogs]]"
  - "[[Technology/MCP]]"
  - "[[Technology/MusicBrainz]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Collection Curator

> Vinyl/books/sneakers as collaboration graphs; "play me a path through
> my record shelf."

## What

A collection is already a graph its owner has never been able to query. The curator
builds it from public data — for vinyl: MusicBrainz/Discogs (artists, members,
bands, labels, lineages); for books: authors, translators, publishers, series; for
sneakers: brands, lines, collabs, designers — and merges the personal layer: what
you own, condition, provenance, what you paid, what it's worth now.
`(:Record)-[:BY]->(:Artist)-[:MEMBER_OF]->(:Band)`, `-[:SAMPLED]->`,
`-[:COVERED]->`.

The signature query is the README's: "play me a path through my record shelf" — a
listening route where consecutive records share a musician, a sample, a label or a
cover lineage, so the evening becomes a guided tour of your own collection's hidden
structure. Around it: gaps in the collaboration graph (the bassist on side A whose
band you don't own — the acquisition trail); provenance and valuation edges for the
insurance side (condition history, price history, authenticity chains); and "someone
else's path" — a friend's tour of your shelf, stored as their own path through your
graph.

## Why RelateDB

The personal layer is one `.cl` file — the whole collection,
provenance and valuation included, portable and private (what you own and what you
paid is nobody's cloud business), shareable as one attachment when you sell,
openable in a browser tab (WASM) for the shelf-tour view. The MusicBrainz/Discogs
import is the *Neo4j in Practice* heritage brought home: the book's classic
band/member/recording imports were server rituals; embedded, the same loader is a
script over the Python bindings and the store just *is* your collection — the
lineage the Music Genealogy project shares. `relate-arrow` handles the bulk
dumps, temporal types carry acquisition dates and price-history windows, in-memory
traversal makes the shelf tour instant, and MCP hands the collection to agents:
"curate me tonight's path, nothing I've played this month, end somewhere melancholy"
— from the actual shelf, with the actual route.

## What it needs

- Importers:
MusicBrainz/Discogs dumps via `relate-arrow` for music; Open Library for
books; catalog + collab data for sneakers
- The personal layer: ownership, condition, provenance, shelf
position, valuation history as temporal edges - The path engine:
consecutive-share-a-link tours with constraint
  filters (era, mood, unheard-this-month)

## Lineage & inspiration

- MusicBrainz and Discogs — the collaboration graph sources, and the
  lineage of the *Neo4j in Practice* MusicBrainz imports (the book's
  classic band/member/recording graph, embedded this time — see the
Music Genealogy project in this collection)
- The Music Genealogy project (this collection) — "is there a path
from Bach to techno?"; this project asks the same question of your shelf - The
Museum as Graph project (this collection) — collection as guided
  tour, for institutions instead of attics
