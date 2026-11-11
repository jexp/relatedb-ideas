---
type: Project
name: rdf-ontology-metagraph
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/Apache Software Foundation]]"
  - "[[Company/OBO Foundry]]"
  - "[[Company/W3C]]"
RELATED_IDEA:
  - kind: complements
    reason: the JSON-LD half of shipping ontologies in ordinary pages
    target: "[[Project/json-ld-everywhere]]"
USES_TECH:
  - "[[Technology/Apache Jena]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/OWL]]"
  - "[[Technology/RDF]]"
  - "[[Technology/SPARQL]]"
  - "[[Technology/Turtle]]"
  - "[[Technology/neosemantics]]"
  - "[[Technology/rdflib]]"
---

# RDF Ontology Metagraph

> Load an OWL/RDF ontology into RelateDB and *query the ontology itself*:
> classes, properties, domains, restrictions as first-class nodes (the
> `system_ontologies` shape, done on purpose).

## What

People usually use ontologies — FOAF, Schema.org, OBO Foundry, an
organization's internal OWL model — as schema descriptions to be *applied*.
This project makes the ontology itself the object of study: load an OWL/RDF
ontology so that every `owl:Class`, `owl:ObjectProperty`, domain/range
statement, subclass edge, and restriction becomes a first-class node or
relationship in the graph. Then you query the *shape of the model*: which
classes inherit from more than one parent (a diamond that will haunt your
instance validation), which properties are declared but never used, which
restrictions on the same property contradict each other, where the deepest
subclass chain lives and where it will hurt at query time.

The payoff is ontology-quality tooling that mostly doesn't exist today:
coverage reports (ontology vs. actual instance data — load both into one
store and diff) and drift detection between two versions of the same ontology (the diff
between their graph forms is the review artifact).

The incumbent bridge already argues the mapping choices: Neo4j's
neosemantics (n10s) imports RDF into a labeled property graph with
documented policies — reified n-ary relationships become intermediate
nodes, `handle_vocab` decides how URIs become labels and properties —
but it is a server-bound plugin, where this project ships a standalone,
offline store. And ontology-as-graph demand is proven by WebVOWL, which
renders any OWL ontology as an interactive force-directed graph in the
browser: the *view*, without the *query*.

This is also an honest RDF→property-graph bridge: reification becomes edge
properties, `rdfs:subClassOf` becomes `:SUBCLASS_OF`, blank nodes become
regular nodes — a documented mapping, not a silent import.

## Why RelateDB

RelateDB *ships* an ontology subsystem already: the ontology document
model (ADR-0227), the ontology→graph-type converter (ADR-0226), and the
`db.ontology.*` procedure family (ADR-0378) that exposes a stored ontology
document from the `system_ontologies` namespace, gated behind the
`RELATE_PREVIEW=ontology` opt-in. This project is the *external* version
of that same shape: RDF/OWL in, first-class ontology nodes out, queryable
in the same store as instance data. The rest is standard RelateDB:
in-memory Cypher from the CLI, WASM for in-tab diffs, and the single-file
store making "the ontology" a committable artifact.

## What it needs

- An RDF/OWL parser (N-Triples/Turtle/RDF-XML) → loader with an explicit
  term mapping (reification → edge properties, blank nodes → generated)
- Version-diff queries and a report format (two ontologies in one store)
- Instance-vs-schema coverage: load instance data beside the metagraph and
  join
- A cookbook of ontology-quality queries (diamonds, unused properties,
  orphan classes, depth reports)

## Lineage & inspiration

- [W3C OWL](https://www.w3.org/OWL/) and [RDF](https://www.w3.org/RDF/) —
  the model being made queryable
- [Apache Jena](https://jena.apache.org/) — the incumbent RDF toolkit whose
  SPARQL UX this trades for Cypher + local files
- [rdflib](https://github.com/RDFLib/rdflib) — the Python RDF toolkit;
  parser-side patterns to reuse
- [neosemantics (n10s)](https://neo4j.com/labs/neosemantics/) — the
  incumbent RDF→property-graph bridge and its documented mapping policies
- [WebVOWL](https://github.com/VisualDataWeb/WebVOWL) —
  ontology-as-graph visualization demand, minus the queries
- [OBO Foundry](https://obofoundry.org) — real, large, versioned ontologies
  (GO, CHEBI) to test on
- [Schema.org](https://schema.org) — the ontology everyone already ships in
  their pages (see the JSON-LD Everywhere project)
