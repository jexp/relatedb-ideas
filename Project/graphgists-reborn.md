---
type: Project
name: graphgists-reborn
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the large-graph rendering pattern cited for the visualization component
    target: "[[Project/a-million-nodes-in-a-tab]]"
  - kind: complements
    reason: the renderer adapters for the Gist's graph pane
    target: "[[Project/d3-sigma-cytoscape-adapters]]"
USES_TECH:
  - "[[Technology/AsciiDoc]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Evidence]]"
  - "[[Technology/Markdown]]"
  - "[[Technology/Neo4j GraphGists]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/sigma.js]]"
---

# GraphGists, Reborn

> The classic: fenced Cypher in a markdown file renders data + visualization in
> the browser. Cookbooks, but for community stories.

## What

A GraphGist is a markdown document with fenced Cypher blocks where the blocks
actually run: the reader's browser loads the data model, executes each query, and
renders the results — tables and a graph view — inline under the code, exactly
where a static code sample would sit. The original Neo4j GraphGists taught a
generation of graph developers this way; the format died with its server-side
renderer. Reborn, it runs entirely client-side: no account, no sandbox cluster,
no "GraphGist is loading…" — just WASM RelateDB in the tab.

Verified: the originals still live at
[neo4j.com/graphgists](https://neo4j.com/graphgists/) — a browsable
directory of community stories, authored as AsciiDoc files with
declared setup and query blocks (the format is documented in the
[neo4j-contrib/graphgist](https://github.com/neo4j-contrib/graphgist)
tooling repo), rendered by a Neo4j-hosted service against a live
database. The community history is real too: Neo4j ran GraphGist
challenges ("bring your own graph", the Winter Challenge) and a weekly
"GraphGist of the week" spotlight to seed the corpus.

The authoring loop mirrors the cookbook pipeline: write prose, write Cypher
cells, record expected results, publish. But where cookbooks are engine
documentation, GraphGists are *stories* — "how I found the shell company," "the
ASOIAF character network," "my chess opening graph" — community-authored,
one file each, shareable as a URL or a file. A directory of them (or a GitHub
repo rendered through a small site builder) becomes the community's gallery.

Because the engine is in the page, a GraphGist is editable: fork the file, change
a query, see your own results. Reading a GraphGist is a REPL session with
narration.

## Why RelateDB

The cookbook system is the direct ancestor: tested markdown recipes with fenced
Cypher cells, recorded result blocks, a native runner and a WASM parity check —
that is the GraphGist pipeline, already built and already CI-gated. The WASM
build makes the render client-side, which is the thing the original GraphGists
never had: the same site that renders docs runs the queries. And every GraphGist
ships as data-in-a-file: the setup cells create the graph, or the page fetches a
single `.cl` store — one file carries narrative + queries + (with the viz
adapter) the rendered graph. Real Cypher (TCK 3892/3892) means every query in a
Gist is a query the reader can carry to any Cypher system.

## What it needs

- A site builder: markdown + fenced `cypher` cells → HTML with WASM engine,
  executed per cell, results (table + optional viz) inline
- A GraphGist template/skeleton (front matter, setup section, cells) and a
  "record results" mode reused from the cookbook tooling
- A small viz component for the rendered-graph pane (see the D3/Sigma/Cytoscape
  adapters and the Million-Nodes ideas)
- A gallery index and a contribution guide ("PR a markdown file")
- Editorial: seed it with ~10 exemplary Gists across the ideas list's sections

## Lineage & inspiration

- [Neo4j GraphGists](https://neo4j.com/graphgists/) — the original "fenced Cypher in markdown, rendered with data
  + viz in the browser" format this project revives;
  [how to create one](https://neo4j.com/graphgists/how-to-create-a-graphgist/),
  and the [GraphGist challenge](https://neo4j.com/blog/bring-your-own-graph-the-graphgist-challenge/)
  that seeded the community
- RelateDB's cookbook system — tested markdown with recorded results and a
  WASM parity build; the engine-side machinery is already there
- [duckdb-wasm shell](https://shell.duckdb.org/) and [Evidence](https://evidence.dev)
  — queries-as-prose publishing that runs fully client-side; the publishing model
  this format should copy
- [Sigma.js examples](https://www.sigmajs.org/examples/) — cookbook-style runnable
  graph examples, the closest living relative of the Gist UX
