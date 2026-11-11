---
type: Project
name: sitemap-xml-to-site-graph
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/Screaming Frog]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the engine behind the snapshot diff mode
    target: "[[Project/diff-view-for-graphs]]"
  - kind: complements
    reason: both treat a website's structure as a graph artifact
    target: "[[Project/static-sites-from-dynamic-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Datasette]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Screaming Frog]]"
  - "[[Technology/Sitemap XML]]"
---

# `sitemap.xml` → Site Graph

> Any website's sitemap into a URL graph; crawl structure, orphan pages, and
> topical clustering as queries.

## What

Every site that wants to be indexed publishes its own map: `sitemap.xml` is a
machine-readable list of URLs, lastmod dates, and sometimes nested sitemaps.
This project turns that file into a property graph — one node per URL, with
the URL's path segments, date, and priority as properties — then enriches it
with the *actual* link structure by fetching pages and extracting `<a href>`
edges. Now the site is a graph you can interrogate: which sections are deep,
which pages are linked from nowhere but the sitemap (invisible to users,
visible to crawlers), what the hub pages are by in-degree, how the topical
clusters partition by path prefix and cross-linking.

The one-command form is pure `pull`-shape: `relate site
https://example.com/sitemap.xml --depth 1` fetches the sitemap (and nested
sitemaps), creates the nodes, optionally fetches each page for link edges and
title/meta properties. A 10k-URL site becomes a `.cl` store in minutes. Then
the audit queries write themselves: dead zones (`MATCH (p:Page) WHERE NOT
()<-[:LINKS_TO]-(p)`), stale branches (lastmod vs. section neighbors), URL
sprawl (duplicate content by title similarity).

The comparison mode is the killer feature: run it monthly and diff the graphs
— the site's structural churn as added/removed nodes and edges, the SEO
auditor's "what changed and was it good" in one query.

## Why RelateDB

`lab fs-to-graph` already walks a filesystem and materializes a graph of it —
the crawl-and-structure pattern exists in the codebase's family; a sitemap is
a much tidier filesystem. The `pull` command is the URL-fetch → `CREATE`
pipeline precedent, and the CLI's JSON/CSV output makes audit results
scriptable. The single-file store means each crawl snapshot is a dated `.cl`
artifact — diffable, emailable, attachable to the ticket — and the in-memory
engine makes "re-run the crawl comparison on three years of snapshots" a
local, instant operation.

## What it needs

- A sitemap parser (XML, sitemap-index recursion, robots.txt awareness for
  the crawl phase)
- A polite fetcher: rate limiting, `--max-pages`, `--include-external`
- Link extraction + property capture (title, meta description, canonical)
- A small query pack: orphan pages, depth distribution, cluster-by-prefix,
  snapshot diff
- Snapshot diff mode over multiple `.cl` stores (the Diff View idea's engine)

## Lineage & inspiration

- `relate lab fs-to-graph` — the existing walk-a-structure-into-a-graph
  precedent
- `relate pull` — URL → `CREATE` → store, already shipped
- [Screaming Frog](https://www.screamingfrog.co.uk/seo-spider/) — the
  commercial site crawler this replaces for the query-hungry
- [Datasette](https://github.com/simonw/datasette) — publish-the-crawl as an
  explorable artifact, one file
