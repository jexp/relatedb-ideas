---
type: Project
name: code-graph
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/Sourcegraph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Joern]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Sourcegraph]]"
  - "[[Technology/jQAssistant]]"
  - "[[Technology/tree-sitter]]"
---

# Code Graph

> Parse a repo (tree-sitter) into functions/calls/imports; ask "what breaks if I delete this function?" — reachability in Cypher, on your disk.

## What

The codebase already *is* a graph — functions call functions, modules import
modules, types flow through calls — but your tools show it as a file tree. This
project parses a repo with tree-sitter into a property graph — `(:Function)`,
`(:Type)`, `(:Module)`, `CALLS`/`IMPORTS`/`CONTAINS`/`REFERENCES` edges, locations
as properties — living *in the repo's directory*, beside the code, rebuilt on
demand.

Then the questions that IDEs approximate with grep become exact. "What breaks if
I delete this function?" — every `CALLS` path to it, transitively, in one query.
"Which entry points can transitively reach this deprecated API?" — reachability
that grep's transitive blindness never had. "Which functions changed in the same
commits as this one?" — join with git history. The delete/merge review that a
human does by dread and intuition becomes a query with a definitive answer. And
for agents it's the killer surface: the graph behind MCP means a coding agent
doesn't grep blindly — it traverses.

## Why RelateDB

RelateDB already ships `lab fs-to-graph` and `lab git-to-graph` — the file and
history halves of this exact pipeline exist as built-in lab commands; the
tree-sitter layer adds the AST/semantic edges. The store is embedded: the graph
sits in the repo itself (one `.cl` file, WAL-backed, git-ignored or committed as
a rebuildable artifact), no Neo4j server to provision per repo. In-memory Cypher
makes transitive reachability an interactive query, not a batch job.
`relate serve --mcp stdio` exposes it to any coding agent with zero setup —
the same MCP the agent already speaks. The CLI gives the human the same store:
table output for "who calls this", `db.schema.visualization` (which just gained
an options map) for the shape overview.

## What it needs

- Tree-sitter parser per language → Function/Type/Module nodes with locations
- Cross-file resolution (imports → edges, language-aware symbol resolution —
  the hard part; static analysis in dynamic languages is honest work)
- git history edges via the existing `git-to-graph` output (author, commit,
  churn), and incremental rebuild so the graph tracks HEAD
- MCP tool descriptions tuned for agents (entry-point reachability, blast
  radius, neighborhood queries) — and a language roadmap: one language first,
  don't fake multi-language

## Lineage & inspiration

The OG in this space: **jQAssistant** (https://jqassistant.org) — the OG
project in this space, a Neo4j-backed code graph from 2013 that proved
code-as-graph changes how you maintain software.
**Graphicle** already has a RelateDB port — the lineage runs forward, too.
[Sourcegraph](https://sourcegraph.com) (code-as-data at fleet scale,
reachability as a security mode — https://sourcegraph.com/solutions/security),
**CodeGraphContext** (tree-sitter → graph behind MCP for coding agents),
[Joern](https://github.com/joernio/joern) (the full code property graph: AST +
CFG + data-flow edges — the ambition ceiling), and the code-graph-mcp
micro-genre catalogued in [research/agent-native.md](../research/agent-native.md)
§7: [code-graph-mcp](https://github.com/danweinerdev/code-graph-mcp) — all of
which need a whole Neo4j or a hand-rolled store; none are a single embedded
binary with WAL.
