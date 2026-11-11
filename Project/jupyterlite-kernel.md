---
type: Project
name: jupyterlite-kernel
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as another teaching artifact that is a notebook in disguise
    target: "[[Project/graph-school]]"
  - kind: complements
    reason: the same shareable-artifact idea in notebook clothes
    target: "[[Project/graphgists-reborn]]"
  - kind: complements
    reason: the algorithm bridge the notebook's interop cells call
    target: "[[Project/networkx-runtime]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB WASM]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The JupyterLite Kernel

> RelateDB-WASM as a zero-install notebook kernel: Cypher cells in the
> browser, pandas/NetworkX interop via Arrow — the scientist's form factor,
> no server, no install, shareable as a URL.

## What

Notebooks are where data people actually work — and the notebook world just
moved to the browser: JupyterLite runs the whole notebook, kernels
included, as WASM in a static page, with no Jupyter server anywhere. DuckDB
has its WASM kernel there; Python-lite (Pyodide) runs beside it. What's
missing from that stack is the graph side.

This project is a RelateDB kernel for JupyterLite: `%cypher`-style cells
(or a full kernel speaking the Cypher REPL protocol) running the WASM
engine in the notebook's own page. A notebook is a URL; the `.cl` data it
queries rides in the notebook's storage (or is fetched/lazily loaded over
HTTP); the whole analysis — data, queries, results, prose — is one file
someone opens with zero setup. Interop stays honest: Arrow in/out means
each Cypher result is also a dataframe for the Pyodide cells beside it, and
NetworkX conversion for the algorithm libraries Cypher doesn't express.

The science-section payoff: every idea file in this repo that says
"notebook" as its natural home (character networks, connectomes, citations,
HNR packs) gets a shareable, reproducible artifact instead of a
my-machine-will-it-notebook.

## Why RelateDB

The WASM build is the whole story: the kernel is a static asset, the
engine runs in the page at memory speed, and the notebook becomes the
graph-teaching artifact this repo keeps reaching for (the Graph School and
GraphGists ideas are both, at bottom, notebooks wearing other clothes).
Arrow conversion already exists (`relate-arrow`), so the
dataframe-boundary is a bridge that's built. And JupyterLite notebooks
being static files means "publish your network analysis" is "commit the
notebook" — the Datasette/static-site pattern applied to scholarship.

## What it needs

- The kernel extension: Cypher cells in JupyterLite over the WASM engine
  (the REPL-protocol variant for a native kernel entry in the launcher)
- Data handling: `.cl` in notebook storage, fetched URLs, or lazily-range-
  loaded remote files
- The Arrow bridge to Pyodide dataframes (results → pandas and back) and
  the NetworkX conversion for algorithm cells
- A gallery: three science-notebook templates (character network, citation
  analysis, temporal interaction graph) ready to remix

## Lineage & inspiration

- [JupyterLite](https://jupyterlite.readthedocs.io/) — WASM Jupyter in a
  static page; the form factor this kernel plugs into
- DuckDB's WASM presence in JupyterLite — the columnar sibling that proved
  embedded engines belong in the notebook page
- [Pyodide](https://pyodide.org/) — the Python side of the in-page stack;
  the interop boundary via Arrow
- [NetworkX Runtime](networkx-runtime.md) — the algorithm bridge this
  kernel's interop cells use
- [GraphGists, Reborn](graphgists-reborn.md) — the same shareable-artifact
  idea in notebook clothes; this is its science-grade version
