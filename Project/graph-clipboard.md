---
type: Project
name: graph-clipboard
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the saved-result artifact whose extract-and-serialize machinery this strips to COPY/PASTE
    target: "[[Project/graphclips-heroku-dataclips-reborn]]"
USES_TECH:
  - "[[Technology/C ABI]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Datasette]]"
  - "[[Technology/PGlite]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/sqlite-utils]]"
---

# Graph Clipboard

> COPY a subgraph as a file, PASTE it into another instance; the smallest
> useful data-sharing protocol in existence.

## What

Two verbs, no protocol. You're looking at something in one store — a
subgraph of interest, the blast radius of a node, the result of a query — and
you `COPY` it: a serialized subgraph file on your clipboard-adjacent life
(a temp file, a paste buffer, an attachment). Then, anywhere else — your
laptop's store, a colleague's instance, a fresh `:memory:` sandbox — `PASTE`
materializes it. No export wizard, no CSV ceremony, no schema mapping
meeting. The subgraph keeps its labels, types, and properties; original IDs
ride along as properties so cross-references survive the trip.

The subtlety is identity: pasting the same subgraph twice should be
idempotent (`MERGE` on the carried original IDs), and pasting into a store
that already has some of those nodes should update rather than duplicate.
That one decision — carried IDs + `MERGE` anchors — is the entire protocol,
and it is enough for real work: assembling a shared graph from many
contributions, one clipboard at a time.

Then the platform clipboard integration is pure delight: COPY in a terminal,
PASTE into the browser WASM instance; COPY on your phone's RelateDB (via
the C ABI wrappers), PASTE on the desktop. The Datasette/PGlite lesson: when
the artifact is a file, everything humans already do with files becomes the
distribution mechanism.

## Why RelateDB

This is the GraphClips machinery stripped to its minimum — and every piece
exists: extracting a result subgraph and generating `CREATE`/`MERGE`
statements into a fresh store is exactly what `pull` does (from a remote) and
what the formatter layer already knows how to serialize. The single-file
store makes the clipboard payload a real `.cl` file — openable, queryable,
WASM-loadable — not a bespoke format. And `:memory:` stores make PASTE-into-
a-scratch-sandbox the zero-ceremony default: try the subgraph out before you
commit it to your real store.

## What it needs

- `COPY` in the CLI (and HTTP/MCP surfaces): a subgraph selector (a query
  result, a label set, a neighborhood of a node) → serialized `.cl` payload
- `PASTE`: `MERGE`-anchored ingestion with carried original IDs, idempotent
  on re-paste
- OS clipboard integration for small payloads; file/drag-and-drop for big
- Provenance tags by default: `__source`, `__copied_at` properties
- Size guardrails: streaming serialization + a warning threshold
- The composite story: one graph assembled from many pastes

## Lineage & inspiration

- [sqlite-utils' pipe-friendly CLI](https://github.com/simonw/sqlite-utils)
  — small verbs over files as the sharing mechanism
- [PGlite](https://pglite.dev/) — data-as-file moving between browser and
  shell contexts
- `relate pull` — the existing extract → statements → store machinery,
  re-pointed at a local result
- The Datasette ecosystem — files as the unit people already pass around
