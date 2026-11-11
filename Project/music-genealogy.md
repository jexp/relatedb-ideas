---
type: Project
name: music-genealogy
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Discogs]]"
  - "[[Company/MusicBrainz]]"
  - "[[Company/Neo4j]]"
  - "[[Company/WhoSampled]]"
MENTIONS_PERSON:
  - "[[Person/Paul Tremberth]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Discogs]]"
  - "[[Technology/MusicBrainz]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/WhoSampled]]"
  - "[[Technology/setlist.fm]]"
---

# Music Genealogy

> samples, covers, influences, band memberships; "is there a path from Bach to
> techno?" — yes, and the query proves it.

## What

Music history is a genealogy nobody has traced as one graph: who sampled whom, who
covered whom, who cited whom as an influence, who played in whose band. Each of
those lives in a different dataset — WhoSampled for samples/covers, MusicBrainz
for memberships and release credits, interviews and listicles for stated
influences. Fused into a single property graph, they make the transitive structure
of music audible-as-queryable.

The graph-import heritage is real and documented: Paul Tremberth's "MusicBrainz
in Neo4j" series loaded the full MusicBrainz dump — some 35 million nodes and 72
million relationships — through mbslave plus sql2graph, and the same import lives
on as a Neo4j graphgist. WhoSampled has no official API, but the research world
has done it honestly: the WhoSampled-130k dataset (Music Technology Group) and
its Zenodo record publish 130k sample/cover relations for sample-identification
research, alongside the community scrapers. And the live-music layer has an API
keyed by MusicBrainz MBIDs itself — setlist.fm — so the cross-source join this
project depends on is a solved problem.

This project builds exactly that: `Artist`/`Track` nodes, `SAMPLED`, `COVERED`,
`INFLUENCED_BY`, `MEMBER_OF`, `PRODUCED`, `COLLABORATED_WITH` edges, genres and
eras as nodes and properties, and dates so the genealogy is temporal. The pitch
query — "is there a path from Bach to techno?" — becomes a variable-length
pattern with genre constraints at both ends, and the answer is the *path itself*:
the actual chain of interpolations, covers, and band lineages you can play as a
playlist. Sibling queries: six degrees from Bowie to Dolly, the most-covered
song's mutation tree, the bridge artists between jazz and hip-hop, your favorite
producer's hidden lineage.

## Why RelateDB

A music-genealogy store is medium-sized (Million-song-scale metadata slices are
fine; a curated influence graph is tens of thousands of nodes), intensely
exploratory, and perfect for the browser: load the `.cl` file in the WASM build
and the "Bach to techno" path renders as an interactive, playable chain — with
each hop backed by visible Cypher you can edit to ask your own version. The
in-memory engine makes path-with-constraint queries instant, which matters
because the fun is in iterating the constraints ("no covers", "only pre-2000
hops"). Temporal types keep the genealogy honest (influence edges are dated),
the Python bindings make the WhoSampled/MusicBrainz ingestion a script, and
`relate serve` turns it into a party-game service for a group over Bolt.

## What it needs

- Loaders: WhoSampled data (scraped or contributed), MusicBrainz dump slices,
  Discogs; influence edges from curated lists or interview mining (honest: this
  is the fuzzy part — confidence properties on edges)
- Path-query helpers with hop-type constraints and cycle avoidance
- Playlist export (path → ordered track list)
- Front-end: browser path explorer with playable hops; optional genre/era sliders
  over the WASM build

## Lineage & inspiration

- WhoSampled: https://www.whosampled.com/ | MusicBrainz: https://musicbrainz.org/
  | Discogs data dumps: https://data.discogs.com/
- MusicBrainz in Neo4j — Tremberth's import series (the graph heritage):
  https://neo4j.com/blog/developer/musicbrainz-in-neo4j-part-1/ and the graphgist
  https://neo4j.com/graphgists/a-musicbrainz-import-into-neo4j/
- WhoSampled-130k — a published research dataset of samples/covers:
  https://mtg.github.io/whosampled-130k-dataset/ | Zenodo record:
  https://zenodo.org/records/22679688
- setlist.fm API — live setlists keyed by MusicBrainz MBIDs:
  https://api.setlist.fm/
- Network of Thrones (Beveridge) — the model of "a beloved cultural corpus becomes
  a queryable weighted graph": https://mathbeveridge.github.io/files/NetworkofThrones.pdf
  and https://networkofthrones.com/
- Six Degrees of Wikipedia (sdow) — the transitive-path-as-entertainment genre:
  https://github.com/jwngr/sdow
- Netzschleuder catalogue (collaboration networks, the bipartite-artist-work
  modeling precedent): https://networks.skewed.de/
- Interactive network-science course (chatox) — "run the exploration yourself"
  cells: https://chatox.github.io/networks-science-course/
