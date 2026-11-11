---
type: Project
name: skills-as-graphs
IN_CATEGORY:
  - "[[Category/Agent Tooling & Memory]]"
RELATED_IDEA:
  - kind: complements
    reason: cited for the subgraph projection mechanics this builds on
    target: "[[Project/cypher-on-cypher]]"
  - kind: complements
    reason: cited for the single-file mechanics this builds on
    target: "[[Project/graph-clipboard]]"
  - kind: complements
    reason: skills are the authored counterpart to extracted agent memory
    target: "[[Project/graph-native-agent-memory]]"
  - kind: variant
    reason: same move of modeling agent-facing capabilities as a graph
    target: "[[Project/tools-as-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Skills as Graphs

> Ship an agent skill as a `.cl` file: instructions, examples and tools as
> nodes (the AIP paper's shape); the agent queries its own skill.

## What

An agent skill today is a folder of markdown: a SKILL.md of instructions,
loose example files, maybe scripts. The structure connecting them — which
example demonstrates which instruction, which tool a step uses, what
prerequisite knowledge a section assumes — lives only in the model's
reading. This project makes the skill itself a graph: instruction, example,
tool, and gotcha nodes; edges for "demonstrates", "prerequisites",
"applies_to_tool".

The AIP reference is real and precise: Blumenfeld & Webber's *AIP: A
Graph Representation for Learning and Governing Agent Skills*
([arXiv 2606.04781](https://arxiv.org/abs/2606.04781); VLDB 2026
Agents+Graphs workshop) proposes the Agent Instruction Protocol — a
skill as a directed execution graph whose nodes are steps backed by
deterministic scripts or natural-language descriptions, whose typed
edges carry inputs and outputs, the whole validated by a schema.
Instructions-as-graph is published; this project is its
queryable-store form. Adjacent lineage: Graph of Thoughts
(Besta et al., AAAI 2024) runs LLM reasoning itself as a graph, and
Voyager's skill library ([arXiv 2305.16291](https://arxiv.org/abs/2305.16291))
made agent skills stored, indexed, reusable units.

Load the skill's `.cl` file and the agent doesn't *read* a document, it
*queries a knowledge base*: "give me the minimal path from this task to the
relevant examples" is a bounded traversal; "which gotchas apply when using
this flag" is one hop; "assemble just the instructions relevant to X" is a
subgraph projection instead of a 5,000-token SKILL.md dump. Skill files
become composable — a task graph joining fragments from several skills —
and auditable: a reviewer queries the skill for coverage ("which tools have
no example?") before shipping it.

## Why RelateDB

This is the single-file story applied to agent packaging: one `.cl` file
carries the whole skill — instructions, examples, tool contracts — as a
portable artifact an agent opens in-process (embedded C ABI / Python) or via
MCP stdio, no server. RelateDB itself already demonstrates the pattern:
its own CLI ships library skills as bundled reference files that must stay
in lockstep with the code — the graph form is the natural evolution, with
drift checkable by query ("every documented flag exists in the tool node,
and vice versa"). `:memory:` lets the agent load the skill, query it, and
drop it per-session, and the WASM build gives skill marketplaces a
browser-tab preview mode for free.

## What it needs

- A skill schema: Instruction/Example/Tool/Gotcha/Reference nodes with
  demonstrates/applies/prerequisites edges
- Authoring path: write the graph directly, or convert existing SKILL.md-style
  bundles (front matter + examples folder → nodes and edges), with a
  coverage-check query pack
- Agent-side loader: open the skill `.cl` file in `:memory:`, expose
  task→relevant-subgraph queries as the retrieval API; port one existing
  library skill as the proof
- Evaluation: measure token spend of query-based skill use vs. whole-file
  SKILL.md injection — the win condition is smaller, more precise context

## Lineage & inspiration

- [The Agent Skills format](https://agentskills.io/specification) / [library-skills.io](https://library-skills.io/) convention — bundled SKILL.md
  + references that ships inside products today (RelateDB's own CLI skill
  bundle, and its Python wheel-bundled skill, are live instances)
- Graphiti/mem0's extraction model (research/agent-native.md §1) — skills
  are exactly the kind of structured knowledge those pipelines produce;
  here it's authored once instead of extracted
- [AIP](https://arxiv.org/abs/2606.04781) — Blumenfeld & Webber: the Agent Instruction
  Protocol, skills as schema-validated typed execution graphs
  ([workshop paper](https://www.vldb.org/2026/Workshops/VLDB-Workshops-2026/Agents+Graphs/AgentGraph26-4.pdf),
  [code](https://github.com/zach-blumenfeld/aip))
- [Graph of Thoughts](https://arxiv.org/abs/2308.09687) and [Voyager's skill library](https://arxiv.org/abs/2305.16291) — reasoning-as-graph and skills-as-stored-units, the instruction-graph prior art
- The *Cypher on Cypher* and *Graph Clipboard* ideas — the subgraph
  projection and single-file mechanics this idea builds on
