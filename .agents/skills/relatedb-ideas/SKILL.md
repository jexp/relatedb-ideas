---
name: relatedb-ideas
description: Query and edit the relatedb-ideas repository — a Relate (CypherLite) markdown-vault graph database. Use when working in this repo: reading, searching, adding, or deleting ideas, entities, or relationships, or regenerating its graph artifacts.
---

# relatedb-ideas as a Relate database

This repo is not just markdown: the `.md` files **are** a Relate store
([RelateDB](https://relatedb.ai), source [github.com/relatedb/relate](https://github.com/relatedb/relate)).
Edit it through Cypher, not just file ops.

## Open the vault

```bash
relate --snapshot-format markdown --markdown-body-properties text --database .
```

The first open records both flags in `.cypherlite/manifest.json` (gitignored, re-derivable);
later opens need neither. From then on:

```bash
relate query --database . "MATCH (p:Project) RETURN p.name LIMIT 10"
```

`.cypherlite/` is engine state (WAL, indexes) — never commit, edit, or hand-delete it.

## Codec rules (markdown-vault snapshot format)

- **Label = top-level folder** — `Project/`, `Research/`, `Technology/`, `Company/`, `Person/`,
  `Category/`. Root-level `.md` files get the reserved `:Vault` label.
- **Key = filename** — `Project/foo.md` is `(:Project {name: 'foo'})`.
- **Frontmatter = properties** — `type:` is the primary label; other keys are node properties.
- **Body = the `text` property.**
- **Relationships = frontmatter wikilink lists** — one key per rel type
  (`USES_TECH: - "[[Technology/Arrow]]"`); rels with data use map form
  (`- kind: complements` / `reason: ...` / `target: "[[Project/...]]"`).
- Schema is versioned in `vault-schema.cypher` at the repo root; the graph model and
  enrichment history are in `README.md` ("This Repo Is a Graph Database") and `PLAN.md`.

## Rules for agents

1. Hand-edits re-ingest at the next open; Cypher writes re-render the files at checkpoint —
   both are fine. After a batch of writes, checkpoint so files and store stay in sync
   (`.checkpoint` in the REPL, or just close — the engine checkpoints on exit).
2. Delete nodes with `MATCH (n:Person {name: 'X'}) DETACH DELETE n` — this removes the `.md`
   file **and** the wikilinks in referencing files (prose mentions stay). Never `rm` an entity
   file and leave the store to catch up.
3. Wrap bulk changes in a transaction (`.begin` … `.commit` / `.rollback`), and take a git
   commit or `.checkpoint` first — there is no undo past a checkpoint.
4. Labels and keys compare case-insensitively — a case-only rename is a no-op that corrupts.
   Rename folders/files instead.
5. One writer at a time. To read beside a writer (or render the graph), open read-only:
   `relate.connect(path, read_only=True)` from Python — that is what `ideas-graph.ipynb` does.
6. Use `$parameters`, never interpolated literals. Limit rows (`LIMIT`) — the vault has
   hundreds of nodes, not thousands, but result sets with `text` bodies are large.
7. `relate.viz` (Python, `neo4j-viz`) renders the vault; regenerate `ideas-graph.svg` /
   `ideas-graph.png` by re-running `ideas-graph.ipynb` after structural changes.
