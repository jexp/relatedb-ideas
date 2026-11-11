---
type: Project
name: wiki-as-a-file
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
MENTIONS_ORG:
  - "[[Company/Kiwix]]"
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: complements
    reason: live markdown storage versus one-shot wiki export
    target: "[[Project/obsidian-vfs-native]]"
  - kind: complements
    reason: offline wiki keeps with a query engine
    target: "[[Project/wikipedia-in-your-pocket]]"
  - kind: variant
    reason: same dump to queryable graph move at wiki scale
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Confluence]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Kiwix]]"
  - "[[Technology/RelateDB]]"
---

# Wiki-as-a-File

> Export a wiki (or its dump) to a single `.cl` file; a community ships its
> whole knowledge base as one attachment.

## What

Every community runs a wiki — a game's fandom, an open-source project, a lab,
a makerspace — and every wiki lives in PHP-and-MySQL mediawiki or a SaaS
subscription, which means the community's knowledge is only readable through
that wiki's interface (or a database dump nobody can open without standing up
the software). This project makes the export trivial: a wiki (MediaWiki XML
dump, DokuWiki pages, Notion export, or a Confluence space) becomes one
`.cl` file — pages as nodes, links/redirects/includes as relationships,
categories and templates as structure, full text as properties.

Then the wiki is *portable* in a way it never was: attach it to a Discord
message and anyone opens it locally, no server, no account; the whole
knowledge base is email-sized for most communities. Old, abandoned wikis
get second lives as queryable archives (discontinued-game wikis vanish
when the host does). New wikis get a local
editing model: edit the text, and the graph follows; or edit through queries
and let the write land in the underlying structure.

The export also doubles as a *migration and analysis* artifact: which pages
are orphans, which redirect chains are more than one hop deep, which
categories have only one member — wiki gardening as Cypher.

## Why RelateDB

The single-file store is the entire pitch: WAL + Parquet checkpoint in one
directory means "the wiki" is an attachment, and the in-memory engine means
a whole mid-size wiki (tens of thousands of pages) opens and queries
instantly on a laptop — or in a browser tab via the WASM build, where the
wiki becomes a zero-deployment archive anyone can browse and search. The
openCypher dialect means wiki-gardening queries are ordinary `MATCH`
statements. And for the editing communities, `relate serve --http/--bolt`
turns the file into a live wiki backend for a small group without a
database server — one binary, one file, done.

## What it needs

- Importers: MediaWiki XML dump (the canonical format), plus DokuWiki/other
  flat-page wikis, and generic markdown folder ingest (the `lab fs-to-graph`
  machinery reused)
- Page → node, link/redirect/includes → relationship mapping, with
  text/summary property handling and a size policy for full-page text
- A browser reader over the WASM build: page view following edges, plus a
  query console for gardeners
- Optionally a static-site generator from query results (`.cl` → HTML)

## Lineage & inspiration

- [MediaWiki XML dumps](https://www.mediawiki.org/wiki/Manual:Dumping_content)
  — the format every wiki can already emit
- [Six Degrees of Wikipedia (sdow)](https://github.com/jwngr/sdow) — dumps become fun graph artifacts, at Wikipedia scale
- [Obsidian/VFS Native](obsidian-vfs-native.md) — the complementary project:
  markdown folders as live storage, vs. this one's one-shot export
- [Kiwix](https://www.kiwix.org) — offline wikis as archives; this project
  adds a query engine to the same instinct
