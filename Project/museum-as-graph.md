---
type: Project
name: museum-as-graph
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Europeana]]"
  - "[[Company/Metropolitan Museum of Art]]"
  - "[[Company/Rijksmuseum]]"
  - "[[Company/Smithsonian]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/JSON-LD]]"
  - "[[Technology/Linked Art]]"
  - "[[Technology/Met Collection API]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Rijksmuseum]]"
  - "[[Technology/WASM]]"
---

# Museum as Graph

> artworks ↔ artists ↔ patrons ↔ movements ↔ thefts (if you must); a museum's
> collection file becomes a guided-tour generator.

## What

A museum's collection management system is, secretly, a property graph: works,
the artists who made them, the movements they belong to, the patrons who funded
or owned them, the exhibitions they appeared in, and — for the headline-driven —
the thefts and recoveries that mark their provenance. Public collection APIs
(the Met, Rijksmuseum, Cleveland, Smithsonian) publish exactly this data.

This project builds that graph in RelateDB: `Artwork`, `Artist`, `Movement`,
`Patron`, `Exhibition`, and `Location` nodes with `CREATED`, `BELONGS_TO`,
`OWNED_BY`, `SHOWN_IN` edges; provenance chains as temporal edge sequences
(theft included, dated); and object records with medium, dimensions, and image
URLs. Then the guided-tour generator is the payoff: "a 45-minute tour for someone
who loves Van Gogh's palette: works influenced by him, the room they're in, and
one object with a stolen-past story" — a path-finding query over movement
influence and physical location, not a curated-but-static JSON list.

Every named source checks out as a real API: the Met's Collection API
(metmuseum.github.io), Rijksmuseum's linked-data services with bulk historical
dumps (data.rijksmuseum.nl), and Smithsonian Open Access with developer tools
and a GitHub bulk repository. The LOD layer has a community model ready for the
graph too: Linked Art, a JSON-LD profile for cultural-heritage metadata that
includes provenance, descended from the Europeana Data Model. And the crawl
precedent is research tooling, not folklore: ArtScraper (SoDa team, Zenodo DOI)
reproducibly harvests WikiArt and Google Arts & Culture — the latter proving
even the non-API giants are collectable.

## Why RelateDB

The single `.cl` file is the star: a museum's public collection — the Met's open
access is ~500k objects — fits in memory comfortably and becomes one shareable
file. Put it in the browser via the WASM build and every visitor's phone (or the
gallery kiosk) runs the tour generator locally, no API keys, no rate limits, no
connectivity in the basement gallery. Temporal types make provenance timelines
first-class ("who owned this between 1933 and 1945?" — the looted-art question,
as a dated-edge query). Point types pin works to floor plans for the routing
side of tours. And `relate serve` gives an education department a shared
graph that docents and school groups query from laptops — one instance, whole
classroom.

## What it needs

- Loaders for public collection APIs: Met Open Access, Rijksmuseum, Cleveland,
  Smithsonian Open Access (JSON/CSV)
- Provenance chain normalizer (dated ownership edges from messy free-text
  provenance records — honestly the hard part)
- Tour generator: path queries + constraints (time budget, interest seed,
  floor-plan points)
- Front-end: browser WASM explorer (room layout + graph view), or kiosk mode
- Influence edges between movements/artists (curated or computed via embedding
  similarity — vector search over artwork descriptions)

## Lineage & inspiration

- The Met Open Access API: https://metmuseum.github.io/ | Rijksmuseum:
  https://data.rijksmuseum.nl/ | Smithsonian Open Access: https://www.si.edu/openaccess
  (developer tools and bulk data: https://www.si.edu/openaccess/devtools)
- Linked Art — the community JSON-LD data model for museum/cultural-heritage
  metadata, provenance included: https://linked.art/model/
- ArtScraper — the reproducible art-crawl precedent (WikiArt, Google Arts &
  Culture): https://github.com/sodascience/artscraper
- Gephi sample datasets — Les Misérables and the curated-collection habit:
  https://docs.gephi.org/User_Manual/datasets/
- The Cornell INFO-2040 character-network genre — the same "cast of entities with
  weighted ties" analysis, applied to an art collection:
  https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
- MetaExp / Mottin-Müller humane exploration — the relevance-driven subgraph view
  a gallery kiosk needs rather than a hairball: https://mott.in/publications/publications/metaexp/
