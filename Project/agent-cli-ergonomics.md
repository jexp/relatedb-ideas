---
type: Project
name: agent-cli-ergonomics
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
MENTIONS_ORG:
  - "[[Company/Anthropic]]"
RELATED_IDEA:
  - kind: complements
    reason: named as the callers this ergonomics serves
    target: "[[Project/graph-native-agent-memory]]"
  - kind: complements
    reason: named as the tool-selection layer above the CLI
    target: "[[Project/tools-as-graphs]]"
USES_TECH:
  - "[[Technology/JSON]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/everything-cli]]"
---

# Agent CLI Ergonomics

> The binary as the agent's favorite tool: structured output by default,
> exit codes as contracts, describe/schema subcommands, and output modes
> sized for a context window — a CLI designed for the caller that reads
> with tokens.

## What

Agents are now the heaviest CLI users there are — and most CLIs still
treat them badly: prose output to parse, ambiguous exit codes, schema
discovery by scraping `--help`, and result sizes with no relation to any
budget. The agent-native CLI is a design discipline, and this project
applies it to `relate`:

- **Machine output by default when the caller is a machine**: JSON with
  stable, documented shapes; `--format` always honored; stdout is data,
  stderr is human commentary (the filter-mode rule, the clig.dev
  conventions enforced for the non-human reader)
- **Exit codes as contracts**: ok-with-rows, ok-empty, error-syntax,
  error-constraint — scripted and agent callers can *branch* without
  parsing text
- **Describe surfaces**: `relate describe graph` (the catalog),
  `describe node <id>`, `describe query <text>` (the plan) — schema
  introspection as first-class commands an agent can discover with, not
  reverse-engineer
- **The token-budgeted output mode**: result formatting that takes a
  budget — column pruning to what matters, row sampling with stated
  bias, aggregation-before-transmission ("1,204 matching rows; top-8
  shown; call `--page 2`") — output *sized for a context window*, the
  formatter equivalent of the hybrid-search result cap
- **Idempotent, atomic operations**: `--param`-driven, no ambient state,
  no surprises on retry — the retry-safety agents need

## Why RelateDB

The CLI already runs the engine locally (no server, no connection string)
and the MCP surface already serves the tool-calling style of access —
this is the *third* access mode, the shell-tool one, and the cheapest to
get right because the formatter family and the error taxonomy already
exist as typed things. The engine's no-silent-failures culture is exactly
the discipline agent ergonomics needs (a structured error an agent can
act on, not a stack trace). And the result-metadata family
(resolved namespace, query type) is already aligned across surfaces — the
agent-facing output inherits it for free.

## What it needs

- The output contract: documented JSON shapes per command, the exit-code
  table, and the stdout/stderr rule — in the CLI spec docs as a stable
  promise
- `describe` commands over the catalog and the planner output
- The budgeted formatter: row/column/byte budgets with stated sampling
  and a machine-readable truncation notice
- An agent cookbook: driving `relate` from a coding agent (the exact
  scripts in docs), plus the tool-definition file an agent host loads

## Lineage & inspiration

- [clig.dev](https://clig.dev/) — the conventions, extended with the one
  rule the list lacks: *the reader may be paying per token*
- [Writing effective tools for AI agents](https://www.anthropic.com/engineering/writing-tools-for-agents)
  (Anthropic) — the tool-design findings this CLI applies at the binary
  level
- The MCP server — the tool-call sibling; [Tools as
  Graphs](tools-as-graphs.md) — the selection layer above it; the
  everything-cli convention family (its account/output discipline as a
  living reference)
- [Graph-Native Agent Memory](graph-native-agent-memory.md) — the callers
  this ergonomics serves
