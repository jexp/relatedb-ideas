// Schema of the relatedb-ideas markdown vault.
//
// The store: this folder is the database (ADR-0406). Label = top-level folder,
// key = filename (`name`), note body = the `text` property, relationships are
// wikilink lists in the frontmatter.
//
// Open it with:
//
//   relate --snapshot-format markdown --markdown-body-properties text -d .
//
// The first open records both settings in `.cypherlite/manifest.json`, so later
// opens need neither flag. `.cypherlite/` is gitignored: it is derived state
// (WAL, id maps, the catalog) that is rebuilt from the markdown files.
//
// Run the statement below to (re)declare the schema in a fresh clone:
//
//   relate --snapshot-format markdown -d . < vault-schema.cypher
//
// It is DECLARED, not current. `ALTER CURRENT GRAPH TYPE SET GRAPH TYPE
// ideasGraph` is deliberately not applied: the current type is enforced on every
// write (a write outside it fails with ConstraintValidationFailed), which is
// wrong for a descriptive ideas vault, and it cannot be applied to this data at
// all because several relationship types run between two endpoint-label pairs
// (`RELATED_IDEA` is Project->Project and Research->Project) and one relationship
// type can be declared only once — LABS-1113. Consequence: the plaintext mirror
// `.cypherlite/schema/graph-type.cypher` (ADR-0481) only renders the *current*
// type, so it stays absent here; this file is the schema's versioned source.
//
// Counts at declaration time: 941 nodes / 2,432 relationships
// (Project 180, Research 11, Technology 436, Company 218, Person 79, Category 15,
// Vault 2).

CREATE GRAPH TYPE ideasGraph AS {
  (v:Vault => {name :: STRING NOT NULL, text :: STRING}),
  (p:Project => {name :: STRING NOT NULL, text :: STRING}),
  (r:Research => {name :: STRING NOT NULL, text :: STRING}),
  (t:Technology => {name :: STRING NOT NULL, url :: STRING}),
  (o:Company => {name :: STRING NOT NULL, url :: STRING}),
  (x:Person => {name :: STRING NOT NULL}),
  (c:Category => {name :: STRING NOT NULL}),
  // Declared once each — the Research variants of these four exist in the data
  // and cannot be expressed (LABS-1113).
  (p)-[:IN_CATEGORY]->(c),
  (p)-[:USES_TECH]->(t),
  (p)-[:MENTIONS_ORG]->(o),
  (p)-[:MENTIONS_PERSON]->(x),
  (p)-[e:RELATED_IDEA => {kind :: STRING, reason :: STRING}]->(p),
  (r)-[:INFORMS]->(p)
};
