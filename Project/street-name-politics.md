---
type: Project
name: street-name-politics
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
RELATED_IDEA:
  - kind: same-data
    reason: cited as the street-graph import layer this combines
    target: "[[Project/openstreetmap-wedge]]"
  - kind: same-data
    reason: cited as the honoree-biography source pattern
    target: "[[Project/wikidata-wedge-for-research]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/OpenStreetMap]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/Wikidata]]"
---

# Street-Name Politics

> Who your city honors and the connections between them.

## What

Every city's street names are a commemorative policy hiding in plain sight: honorees
— generals, monarchs, poets, industrialists — with dates, ideologies, and
relationships to each other. This project makes it a graph: streets as edges and
junctions as nodes (the OSM-wedge pattern), each named street carrying a honoree
property linking into a second graph — `(:Honoree {born, died, field})` with the
connections between them layered from biographical sources and Wikidata. The result:
the city's honor roll as a *network*, not a list.

The queries are the civic story: the era histogram of commemorations
(streets named per decade vs. who actually lived then — the politics of *when* the
honoring happened); the gender and field breakdown (the share of the map honoring
women, and whether those streets are ring roads or city centers — Alderman's
address-as-status question); and contested names (renaming a street ripples through
every address, bus route and business registration that touches it). Plus: two
honorees who were bitter enemies at adjacent intersections; half the map
commemorating one dynasty's friends.

## Why RelateDB

The street layer is an OSM extract — the established OSM-wedge
import path — and RelateDB's native point/geospatial types carry
the geometry, so the civic queries (`near the parliament`, `within the old town`)
are spatial filters over the same graph as the biographical ones. The whole city —
streets, honorees, connections — is one `.cl` file: a journalist or history society
publishes the investigation as one attachment, opens in a browser tab (WASM) as an
interactive story map; local-first matters here because the story should outlive the
project. Python bindings drive the OSM/Wikidata scrapers, MERGE keys keep re-imports
idempotent, the WAL accepts local historians' corrections without rebuilds, and
`serve --http` turns the file into a civic-association workshop tool. Temporal types
carry naming and renaming dates so the era histogram — the when question — is native
rather than post-hoc.

## What it needs

- The street layer: OSM extract import (named ways, junctions) with
point/geospatial properties intact - The honoree layer: name → person
resolution (with review — the
  "King Street problem" is not always a monarch) and biographical
  edges from Wikidata/local sources
- The civic query pack: era histogram, gender/field shares with
centrality weighting, address-status analysis, rename blast radius

## Lineage & inspiration

- Derek Alderman's MLK-street research — the geography of what we name
  after King, and the address-as-status finding this project queries
  at city scale (University of Tennessee)
- Mapping Inequality (HOLC redlining maps) — the canonical public
  geodata overlay for who the city honored *where*:
https://dsl.richmond.edu/panorama/redlining/ - The OpenStreetMap Wedge and
Wikidata Wedge projects (this
  collection) — the street-graph import layer and the honoree-
biography source pattern this project combines
