---
type: Project
name: schema-telescope
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
RELATED_IDEA:
  - kind: variant
    reason: same self-describing meta-store pattern applied to the engine itself
    target: "[[Project/cypher-on-cypher]]"
  - kind: variant
    reason: both introspect arbitrary databases into a queryable meta-view
    target: "[[Project/graph-lens-over-any-database]]"
  - kind: complements
    reason: schema-as-stored-graph needs the ontology metagraph layer
    target: "[[Project/rdf-ontology-metagraph]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Bolt]]"
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
---

# Schema Telescope

> Introspect many databases (or many stores) into one meta-graph of labels,
> keys and relationships; the federated data catalog that starts with a folder
> of files.

## What

A catalog you build by pointing at a folder. Every `.cl` store, every database
connection, every Parquet/CSV dataset in a directory gets introspected — its
labels, relationship types, property keys and types, key-ness, cardinalities —
and lands as a subgraph in one meta-store. Node types: `Store`, `Label`,
`PropertyKey`, `RelType`, `Dataset`; edges: `HAS_LABEL`, `HAS_KEY`, `KEY_OF`,
`RELATES`. The catalog queries are traversals: "which stores
have a `Person` label with a `taxId` property?", "find the same entity across
stores: shared key properties under different labels."

It starts with a folder of files — a dataset collection, a team's exports —
because that's how data arrives. The same introspection applies to Bolt
endpoints and the engine's own `system_ontologies`. Cross-store schema
comparison then does real catalog work: coverage ("who has this entity?"),
conflict ("who disagrees about this key?"), and the join map — candidate
cross-store relationships via shared keys, the wiring plan for a federated view
before anyone writes one.

## Why RelateDB

The introspection call already exists: `db.schema.visualization` returns the
schema as virtual nodes + relationships — labels, keys, relationship types —
so per-store introspection is a procedure call, not an analysis project; the
telescope is that output, persisted into a meta-store with provenance edges. The single `.cl` file is the unit of intake: walk a folder, open-introspect-close
per store at embedded speed, no pooling or service accounts. The meta-store
itself is a RelateDB database, so the catalog is queryable in Cypher —
exposed via the CLI, HTTP, Bolt, or MCP to agents as well as humans. The
ontology lineage helps twice over: the document model gives the meta-schema a
validation language, and `system_ontologies` is a working precedent of
"the schema itself is a stored, queryable thing."

## What it needs

- Introspectors per source: `.cl` stores, Bolt endpoints, Parquet/CSV datasets
  (via the Arrow/Parquet path)
- The meta-schema (Store/Label/PropertyKey/RelType + provenance) — one ontology
- Folder-walking CLI (`relate lab catalog DIR`-shape), incremental on change
- Cross-store query pack: coverage, key-type conflicts, shared-key join
  candidates
- MCP exposure: let an agent ask "where would this entity live?" against the
  catalog

## Lineage & inspiration

- RelateDB's `db.schema.visualization` — per-store schema as virtual nodes and
  relationships; the primitive this telescope persists
- The ontology document model and `system_ontologies` — schema-as-stored-graph
  precedent and the validation language for the meta-schema
- [Netzschleuder](https://networks.skewed.de/) — a browsable catalogue of
  hundreds of graphs with metadata; the "folder of files becomes a catalog"
  target experience, and a ready first dataset folder
- [GUAC](https://github.com/guacsec/guac/) — many SBOM sources into one
  queryable graph; the same federation pattern for schemas
