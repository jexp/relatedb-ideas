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
- [80] (done) Entity-resolution audit: generation-time dedup was case-insensitive spelling +
      manual ALIAS map only (no semantic resolution). Survivor scan found one real merge:
      clickhouse-local -> ClickHouse. cosmos.gl / Cosmograph left separate (engine vs product).
- [85] (done) Prune single-mention entities (deg <= 1, user-confirmed; first attempt used
      deg <= 2 and was reset via git restore + sidecar rebuild). Deleted: Technology 324,
      Person 70, Company 164 -> 384 nodes / 1,876 rels. `count { ()-[:REL]->(n) }` degree
      pattern beats WITH+count(r) grouping. Verified: node delete removes the .md file
      AND the wikilinks in referencing files; prose mentions stay.

## Follow-ups (parked)

- relate docs should cover VFS options / markdown mode + Odyssey vault pointer (filed internally)
- graph types — one rel type cannot cover two endpoint-label pairs; promotion
  error names neither the type nor the edge (filed internally)
- NVL clustering options had no visible effect on the layout in neo4j-viz 1.13
- Separate branch: neo4j-graphrag via `relate serve` (Bolt) against this schema for
  entity extraction; investigate disabling the lexical-graph side (Document/Chunk
  nodes + rels) that SimpleKGPipeline writes into the backend db

## Open-source cleanup (2026-11-11)

- [110] (done) Leak audit: no emails/keys/paths; removed the Neo4j Slack +
      Twitch dump Drive links (developer-social-networks.md rewritten clean)
      and all internal Linear ticket references
- [120] (done) README: relatedb.ai links, pre-prune entity reference moved to
      the first commit of the rewritten history
- [130] (done) `.agents/skills/relatedb-ideas/SKILL.md` — agent instructions for
      querying the vault with relate
- [140] (done) ideas-graph.svg/png regenerated from the pruned vault (384 nodes)
- [150] (done) History rewritten to two commits: full pre-prune entity set
      (scrubbed), then the cleanup state
