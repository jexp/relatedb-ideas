---
type: Project
name: shell-native-cypher
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Ink & Switch]]"
RELATED_IDEA:
  - kind: variant
    reason: same concern for CLI ergonomics and exit-code contracts
    target: "[[Project/agent-cli-ergonomics]]"
  - kind: complements
    reason: cited as the other dataflow cousin of the shell filter mode
    target: "[[Project/cypher-on-cypher]]"
  - kind: complements
    reason: cited as a dataflow cousin; this is its pipe-native form
    target: "[[Project/graph-clipboard]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Unix Pipes]]"
  - "[[Technology/WASM]]"
  - "[[Technology/clig.dev]]"
  - "[[Technology/jq]]"
  - "[[Technology/ratatui]]"
---

# Shell-Native Cypher

> The Unix-filter form factor: `stdin → relate → stdout`, pipelines,
  `tail -f | relate`, and a TUI REPL — every interaction an ad-hoc
> program, the way the shell always worked.

## What

The Unix lesson (Hughes' essay names it): the shell succeeded as an
end-user programming environment because every interaction is an ad-hoc
program — small tools chained by pipes, scripts that are just commands in
a file, copyable and movable like any other file. RelateDB has a CLI; it
doesn't yet have the *shell form factor*:

- **The filter mode**: `cat events.cl | relate query 'MATCH (e:Event)
  WHERE e.at > $t RETURN e' --param t=...` — a `.cl` on stdin, a filtered
  `.cl` (or JSONL) on stdout. Graph queries join the pipe toolbox beside
  `grep`, `jq`, and `awk` — one stage in a pipeline of small tools
- **The stream mode**: `tail -f app.log | relate ingest pattern` —
  append events into a WAL-backed graph as they arrive; the
  live-growing store other windows query
- **The TUI**: a ratatui REPL — buffer of queries, results pane, schema
  sidebar (`db.schema.visualization` rendered ASCII-style), fuzzy history —
  the shell session as the graph workbench for SSH-and-screen people
- **The script form**: query files as first-class shell artifacts (`relate
  run pack.cypher --param k=v`) — the stored-query idea in its most
  Unix-native costume

## Why RelateDB

A single binary with no server, no connection string, no `--url` is the
precondition for being pipe-shaped — the exact property the RDBMS world
lacks and SQLite-class engines have. The formatter family (table, CSV,
JSON, JSONL) is already the output contract a pipeline stage needs; the
`query` command is the engine entry point; the WASM tab is the GUI sibling.
And the TUI is where the engine's millisecond queries pay off most
visibly: no round trip between keystroke and result.

## What it needs

- Filter-mode semantics: `.cl` on stdin, chosen output format on stdout,
  exit codes as contracts (0 rows vs. error vs. empty-match — clig.dev
  conventions, no silent fallbacks)
- The ingest stream mode over the WAL append path
- A ratatui TUI shell with the schema sidebar and query history
- A cookbook of pipeline recipes: `.cl` → filter → `jq` → report; log tail
  → graph → watch window

## Lineage & inspiration

- [clig.dev](https://clig.dev/) — the CLI conventions the filter mode
  follows (also the engine repo's own CLI culture)
- [jq](https://jqlang.github.io/jq/) — the pipe-stage tool this project
  sits beside; the composability bar
- [ratatui](https://github.com/ratatui/ratatui) — the TUI framework the
  REPL shell builds on
- Hughes' Unix analysis in
  [End-user programming](https://www.inkandswitch.com/end-user-programming/)
  — "every interaction is an ad-hoc program"; the shell as the successful
  end-user environment this form factor extends to graphs
- [Graph Clipboard](graph-clipboard.md) and [Cypher on Cypher](cypher-on-cypher.md)
  — the dataflow cousins; this is their pipe-native form
