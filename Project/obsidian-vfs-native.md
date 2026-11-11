---
type: Project
name: obsidian-vfs-native
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_ORG:
  - "[[Company/Obsidian]]"
RELATED_IDEA:
  - kind: complements
    reason: both make a personal note vault queryable as a graph
    target: "[[Project/cy-your-personal-knowledge-graph]]"
  - kind: complements
    reason: shares the plain-file-as-source-of-truth, graph-as-index bet
    target: "[[Project/wiki-as-a-file]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Markdown]]"
  - "[[Technology/Obsidian]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Obsidian/VFS Native

> A VFS layer where markdown files *are* the storage: headings and links
> become nodes and relationships on open; your vault becomes a Cypher
> database without exporting anything.

## What

Obsidian's graph view is the product's signature — and it's non-queryable
eye candy. Dataview, the most-loved plugin in the ecosystem, proves users
want to *query* their vault, but it stops at per-note tables. This project
removes the export step entirely: a RelateDB VFS adapter treats a folder of
markdown files as the storage itself. On open, headings become nodes,
`[[wikilinks]]` and inline links become relationships, YAML frontmatter and
tags become properties; on write, Cypher writes land back in the files.
Rename a note and the engine rewrites every backlink.

Queries then go where Dataview can't: multi-hop. "Which notes three hops from
my thesis outline mention the same sources as my failed-experiments log?"
"Show every path from a MOC (map of content) to orphan notes." "When did I
last write about X *after* writing about Y" — temporal via frontmatter
dates and file mtimes as properties. The
vault stays plain markdown the whole time — local-first, tool-agnostic,
greppable — while a full property-graph engine sits *beside* the files as
the live index and query surface.

Both sides of the files-vs-database bet have named precedents. Org-roam
keeps plain-text files and builds a *derived* SQLite index beside them —
md-roam extends it to `.md` vaults — the exact "files are source of
truth, the graph is an index" shape, in Emacs. Logseq's DB version is
the opposite bet: abandon files-first for a real database, because they
hit the query wall Dataview's per-note tables show. This project takes
the third position: files stay, and the derived index is a full
property-graph engine.

## Why RelateDB

RelateDB has a VFS layer as a first-class abstraction (the same one that
runs stores on Native and Memory file systems) — a markdown-vault adapter
is exactly the kind of backend it was shaped for. `relate lab fs-to-graph`
already indexes markdown into a graph today; this project promotes it
into a live, writable, always-on adapter rather than a one-shot export.
In-memory Cypher makes every keystroke-level query instant over
thousands of notes; the WASM build opens the same thing as an
Obsidian-plugin or web-app story. And since the files remain the source of
truth, the graph is a rebuildable index — no lock-in, no migration.

## What it needs

- A VFS adapter implementing RelateDB's storage interfaces over a markdown
  folder: file/heading nodes, link parsing (wikilinks, markdown links,
  embeds), frontmatter → properties
- Write-back semantics: Cypher writes mapped to file edits (and a clear
  policy for writes that don't round-trip to markdown)
- Backlink maintenance and rename refactoring as engine-level consistency,
  not a plugin
- An Obsidian plugin or local web UI over the WASM build; the CLI
  (`relate query --database ~/vault`) for the rest

## Lineage & inspiration

- [Obsidian](https://obsidian.md) — the vault model; graph view as signature
  but non-queryable
- [Obsidian Dataview](https://github.com/blacksmithgu/obsidian-datataview) —
  the proof users want to query notes; this is "Dataview but Cypher, with
  multi-hop"
- [Obsidian Canvas](https://obsidian.md/canvas) and [Synapses](https://github.com/qoob23/synapses) — the demand surface
- [Org-roam](https://github.com/org-roam/org-roam) /
  [md-roam](https://github.com/nobiot/md-roam) — files-as-truth with a
  derived, queryable index; the closest precedent, in Emacs
- [Releasing Org-roam v2](https://blog.jethro.dev/posts/org_roam_v2/) —
  the design notes for that index
- [logseq's DB version](https://github.com/logseq/docs/blob/master/db-version.md)
  — the opposite bet (abandon files for a DB); this project keeps the files
