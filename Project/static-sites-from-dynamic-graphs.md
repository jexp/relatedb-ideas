---
type: Project
name: static-sites-from-dynamic-graphs
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/GitHub]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as an example content source for a docs site
    target: "[[Project/code-graph]]"
  - kind: complements
    reason: both make a graph file the publishable source artifact
    target: "[[Project/single-file-graph-stories]]"
  - kind: complements
    reason: one crawls a site into a graph, the other generates one from a graph
    target: "[[Project/sitemap-xml-to-site-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Evidence]]"
  - "[[Technology/JSON]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
---

# Static Sites from Dynamic Graphs

> Generate a Hugo/Astro site from graph queries; the graph is the CMS, the pages
> are views, and a rebuild is a query.

## What

A site generator whose content source is a graph database instead of a folder of
markdown. Nodes are content: a `Character` node becomes a character page with its
relationships (allies, houses, kills) rendered as sections and links; a `Paper`
node becomes a bibliography entry that links to the papers it cites. Every page
template is really a query — "give me this node plus one hop of context" — and
the site's navigation, taxonomies, and backlinks are graph traversals, not
hand-maintained front matter.

The build step is: run the queries, render the views, emit static HTML. The
result is a Jekyll/Hugo-shaped artifact — a folder you can host on GitHub Pages,
Netlify, or a USB stick — but with a content model that has real relationships.
"The episodes this character appears in, sorted by air date, with co-stars
filtered to main cast" is not a plugin anymore; it's one Cypher query in the
template.

And because the source of truth is a `.cl` file, the site is regenerable from
data: refresh the graph (a `pull` from an API, an import, a crawl) and rebuild —
the pages update like query results, because they are.

## Why RelateDB

The graph is a single file: the whole CMS is one `.cl` store a build job (or a
local machine, or a CI runner) opens, queries, and closes — no database server
in the build pipeline, no connection strings, no migrations. The JSON formatter
makes query output directly consumable by template engines, and the C ABI /
Python bindings let the generator run inside any SSG's build (an Astro or Hugo
integration can embed RelateDB rather than shell out). In-memory speed means
page-template queries over tens of thousands of nodes execute in a build's noise
floor. And the cookbook format is the proof-of-concept: it is already a
markdown-with-queries → rendered-artifact pipeline with recorded, checked
results — a static-site generator is the same loop pointed at site templates
instead of doc pages.

## What it needs

- A generator: query-per-template, node-per-page (Astro/Hugo integration or a
  standalone builder over the Python/JS bindings)
- Template conventions: how a label maps to a layout, how relationships become
  page sections and links
- An incremental build story — query which nodes changed (WAL/checkpoint
  timestamps) and rebuild only those pages
- Example sites: a character wiki, a museum collection, a docs site from a
  code graph

## Lineage & inspiration

- [Evidence](https://evidence.dev) — reports/dashboards authored in SQL +
  markdown, compiled to static sites; the exact publishing model, one database
  over
- Hugo/Astro — the static-site conventions (content collections, layouts,
  incremental builds) this project rides
- The cookbook pipeline — markdown + queries → tested rendered artifacts, the
  engine-side precedent
