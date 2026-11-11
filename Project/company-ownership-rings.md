---
type: Project
name: company-ownership-rings
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/ICIJ]]"
  - "[[Company/Kuzu]]"
  - "[[Company/OCCRP]]"
  - "[[Company/Senzing]]"
RELATED_IDEA:
  - kind: complements
    reason: the single-story, CSV-first counterpart to the full investigative platform
    target: "[[Project/aleph-in-a-journalists-pocket]]"
  - kind: same-data
    reason: generalizes the ICIJ Offshore Leaks ownership-network model to any register
    target: "[[Project/icij-in-a-browser-tab]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/ICIJ Offshore Leaks]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/OpenAleph]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Company Ownership Rings

> Load a company register (CSV from any disclosure portal) and query control
> through layers of shell companies in one Cypher hop.

## What

Every disclosure portal — beneficial-ownership registers, Companies House,
OpenCorporates exports, national business registries — publishes the same
shape of tabular data: a row linking an officer to an entity, a row linking an
entity to an address, maybe a row linking an entity to a parent. The graph is in
there, flattened. This project is the un-flattener: drop the CSVs, pick the key
columns, and the `pull`-style loader materializes an ownership graph — officers,
entities, addresses as nodes; `OFFICER_OF`, `REGISTERED_AT`, `PARENT_OF` as
relationships.

Then the question that tabular data cannot answer and one Cypher hop can: who
*controls* this company? Through five layers of shells, the controlling person
is a variable-length path away — `MATCH path = (b:Person {name: $name})
<-[:OFFICER_OF*1..6]-(e:Company {id: $target}) RETURN path` — and the ring
shows itself: the same three officers cycling through the same twelve
interlocking entities at the same registered address. Ring detection is
`MATCH` on cycles; the "shell layer count" is path length; the "who else is in
this network" is one neighborhood query.

The workflow is per-story, not per-platform: pull the register files for the
entities under investigation, load them next to yesterday's, query the union.

## Why RelateDB

The CSV-to-graph load is exactly the shape of the `pull` pipeline (a tabular
source imported into a store as nodes and edges), and once loaded, control
queries are variable-length path traversals — in-memory Cypher at scan speed
does them in milliseconds, so investigators can iterate a hundred hypotheses
in an afternoon. The single-file store means each investigation is one `.cl`
file: email it, commit it to the story folder, open it in a browser tab via
WASM. Nothing leaves the machine — no cloud compliance conversation with the
lawyers — and `relate serve --http/--bolt` turns the same file into a
shared newsroom database for the length of the story.

## What it needs

- A CSV loader (the `pull`-style pipeline): column-picker UI or CLI, key
  columns → `MERGE` keys, per-register import profiles (each portal's schema
  differs; profiles are the tedium)
- A small ring/control query gallery: shortest control path, cycle detection,
  shared-officer networks, registered-at hotspots
- Optional: a browser viz over the WASM build for drawing the ring in the
  story; open-data licensing notes per register (Companies House data is OGL)

## Lineage & inspiration

- ICIJ Offshore Leaks — the ownership-network model this project generalizes
  to any register's own data
- [OCCRP Aleph](https://aleph.occrp.org/) — the follow-the-money platform whose
  entity/relationship model this mirrors, at a single-story scale
  ([architecture](https://docs.aleph.occrp.org/developers/explanation/architecture/))
- [Senzing + Kuzu entity-resolved knowledge graphs](https://blog.kuzudb.com/post/entity-resolved-knowledge-graphs/)
  — "bring your messy records, get a queryable entity graph"; the same pitch
  for an embedded store
