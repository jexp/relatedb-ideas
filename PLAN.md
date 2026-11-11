---
type: Vault
name: PLAN
---

# Plan: Enrich the relatedb-ideas markdown vault as a Relate graph

Store: repo root opened as markdown vault (`RELATE_SNAPSHOT_FORMAT=markdown`,
`--markdown-body-properties text`). Labels from folders: `projects` (180),
`research` (11), `Vault` (README). Key property: `name` (= filename). Body: `text`.

## Graph model

Existing nodes:
- `(:projects {name, text})` — the idea files
- `(:research {name, text})` — research dossiers
- `(:Vault)` — README

New labels (key `name`, stub files under `<Label>/`):
- `(:Category {name})` — fixed vocabulary (~12 domains)
- `(:Technology {name, url?})`
- `(:Company {name, url?})`
- `(:Person {name})`

Relationship types:
- `(p)-[:IN_CATEGORY]->(c:Category)`
- `(p)-[:USES_TECH]->(t:Technology)`
- `(p)-[:MENTIONS_ORG]->(o:Company)`
- `(p)-[:MENTIONS_PERSON]->(x:Person)`
- `(p)-[:RELATED_IDEA {kind, reason}]->(q:projects)` — conceptual, kind ∈ variant|inspired-by|complements|same-data
- `(r:research)-[:INFORMS]->(p:projects)`

Project attribute: `category` (string, mirrors IN_CATEGORY for Obsidian usability).

## Steps

- [10] (done) Open vault, inspect inferred schema — key=name, body=text, 0 rels
- [20] (done) Write test: Technology node + rel + attribute serialize to frontmatter/wikilinks
- [30] (done) 7 extraction agents (haiku) → 191 records in /tmp/vault-enrich/out-*.jsonl
- [40] (done) Reconcile + generate + execute: 436 Technology, 218 Company, 79 Person, 15 Category,
      2432 rels (1290 USES_TECH, 410 MENTIONS_ORG, 391 RELATED_IDEA, 191 IN_CATEGORY, 100 MENTIONS_PERSON, 50 INFORMS)
- [50] (done) Validated: frontmatter wikilink lists + map-form RELATED_IDEA in the .md files
- [55] (done) `projects`→`Project` (files moved to Project/). `research`→`Research` is a no-op:
      labels compare case-insensitively; the attempt corrupted 11 files (junk `type_property`)
      and needed a sidecar reset — folder renamed by hand instead
- [58] (done) `CREATE GRAPH TYPE ideasGraph` (declared, NOT promoted to current — promotion installs constraints)
- [60] (done) relate.viz + NVL: ideas-graph.svg + ideas-graph.png (941 nodes / 2432 rels), notebook committed.
      Open: NVL clustering options did not visibly change the layout in neo4j-viz 1.13
- [62] (done) Categories: dropped the mirror `category` string from Project/Research (nodes only);
      removed a stray `type` property the botched rename had left on the 11 Research nodes
- [64] (done) Graph type: declared `ideasGraph` (incl. `Vault`); NOT promoted — the current type is
      enforced on writes and our data (one rel type over two endpoint-label pairs) cannot be
      expressed at all. Schema versioned as `vault-schema.cypher` in the repo.
- [70] (done) Committed 4798941 and pushed to origin/main (946 files, 8413 insertions)

## Follow-ups (parked)

- relate docs should cover VFS options / markdown mode + Odyssey vault pointer
- graph types — one rel type cannot cover two endpoint-label pairs; promotion
  error names neither the type nor the edge
- NVL clustering options had no visible effect on the layout in neo4j-viz 1.13
- Separate branch: neo4j-graphrag via `relate serve` (Bolt) against this schema for
  entity extraction; investigate disabling the lexical-graph side (Document/Chunk
  nodes + rels) that SimpleKGPipeline writes into the backend db
