---
type: Research
name: agent-native
INFORMS:
  - "[[Project/agent-trace-warehouse]]"
  - "[[Project/code-graph]]"
  - "[[Project/graph-native-agent-memory]]"
  - "[[Project/in-browser-knowledge-extraction]]"
  - "[[Project/obsidian-vfs-native]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Hugging Face]]"
  - "[[Company/LangChain]]"
  - "[[Company/Microsoft]]"
  - "[[Company/Neo4j]]"
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: traces and checkpoints are graphs and deserve a first-class store
    target: "[[Project/agent-trace-warehouse]]"
  - kind: complements
    reason: embedded code property graph exposed to coding agents over MCP
    target: "[[Project/code-graph]]"
  - kind: complements
    reason: argues agents need an embedded graph-native memory layer rather than a hosted graph server
    target: "[[Project/graph-native-agent-memory]]"
  - kind: complements
    reason: Dataview-but-Cypher over a markdown vault
    target: "[[Project/obsidian-vfs-native]]"
USES_TECH:
  - "[[Technology/Graphiti]]"
  - "[[Technology/LangGraph]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Obsidian]]"
  - "[[Technology/mem0]]"
  - "[[Technology/transformers.js]]"
---

# Research findings: agent/AI-native database usage

*Collected 2026-10-22 as inspiration research for the relate-ideas list.
Lens: RelateDB is an embedded in-memory property graph, Cypher, single binary,
WASM, built-in MCP + Bolt/HTTP.*

## 1. Agent memory systems

- **mem0** — https://github.com/mem0ai/mem0 — extraction-based memory: an LLM pulls facts/entities/relations out of conversations and writes them as a graph (Neo4j/Memgraph) beside a vector store, with ADD/UPDATE/DELETE/NOOP memory operations (https://docs.mem0.ai/platform/features/graph-memory, paper: https://arxiv.org/html/2504.19413)
- **letta / MemGPT** — https://github.com/letta-ai/letta — OS-style memory hierarchy: editable "core memory blocks" in context, recall + archival memory behind; Postgres/pgvector backend, agents stored as records (https://www.letta.com/blog/memory-blocks/)
- **zep** — temporal knowledge-graph memory architecture; episodes, entities, community nodes, bi-temporal edges (validity time vs ingestion time) so old facts are invalidated, not deleted (paper: https://arxiv.org/html/2501.13956). Note: they later replaced their commercial graph DB backend with their own purpose-built engine, **Konig** — see `research/konig-zep-graph-db.md` for the design and what RelateDB can take from it
- **graphiti** (Zep's open-source core) — https://github.com/getzep/graphiti — temporal KG library: LLM-driven entity resolution, edge invalidation, Neo4j/FalkorDB backends, ships its own MCP server (https://github.com/getzep/graphiti/tree/main/mcp_server, https://neo4j.com/blog/developer/graphiti-knowledge-graph-memory/)
- **cognee** — https://github.com/topoteretes/cognee — "memory as infrastructure": ECL pipeline (extract-cogitate-load) into pluggable graph backends — Neo4j, Kuzu, FalkorDB, NetworkX (https://docs.cognee.ai/setup-configuration/graph-stores)
- **awesome-ai-memory** — https://github.com/topoteretes/awesome-ai-memory — the breadth proof: a whole curated category of memory systems exists
- **mcp-memory-service** — https://github.com/doobidoo/mcp-memory-service — sqlite-vec + knowledge-graph memory served over MCP; Claude-session memory done DIY
- **Mnemoverse / comparison writeups** — https://mnemoverse.com/docs/library/agent-memory-knowledge-graphs-compared , https://aiagentmemory.org/articles/llm-memory-comparison/ — head-to-head evals of memory graphs; the comparison genre itself shows demand
- **Claude Code's own MEMORY.md pattern** (+ ecosystem tools like https://github.com/lludlow/TraceCC , https://claudia.aiadopters.club/) — flat markdown memory with hand-written curation; an obvious "before" picture for graph-native memory

**Transferable idea:** every one of these needs a *separate* Postgres/Neo4j/FalkorDB server just to hold agent memory. RelateDB can be the first **embedded, process-local, graph-native memory layer**: graphiti-style bi-temporal edges and entity resolution, memory retrieval as Cypher multi-hop traversal, contradictions as queryable edge pairs, WAL durability without an ops footprint — importable by a Python agent (`pip install relate`) or a single-binary CLI, and inspectable with `relate query` by a human. "Mem0/letta/zep semantics with sqlite ergonomics" is a real gap in the market.

## 2. Agent workflows, traces, and observability

- **LangGraph checkpointers** — https://docs.langchain.com/oss/python/langgraph/checkpointers — durable agent state: per-thread write-once checkpoint history (SqliteSaver/PostgresSaver/Redis), time-travel replay of agent runs
- **LangGraph Store** — https://docs.langchain.com/oss/python/integrations/long-term-memory — cross-thread long-term memory namespace with a vector index bolted on top of a KV store
- **LangSmith** — https://smith.langchain.com — trace trees (run → child LLM/tool/retriever runs) in Postgres, filterable/annotatable; the data model is literally a DAG per invocation
- **Arize Phoenix** — https://github.com/Arize-ai/phoenix — open-source LLM tracing on OpenTelemetry/OpenInference: spans with LLM/RETRIEVER/TOOL attributes, local app, trace datasets exportable as dataframes (https://arize.com/docs/phoenix/tracing/llm-traces)
- **AgentOps** — https://github.com/AgentOps-AI/agentops — session recording, replays, and a devtools-style UI for agent runs
- **agents_otel_data** — https://github.com/davila7/agents_otel_data — OTEL agent telemetry loaded into a knowledge graph for analysis — agents already being studied *as graphs*
- **Flowise Agentflows** — https://docs.flowiseai.com/agentflowv2 — visual agent DAGs whose state needs a persistence layer
- **Memory layers for every framework** — https://mem0.ai/blog/memory-layer-for-open-source-agent-frameworks — LangGraph/CrewAI/AutoGen all treat memory as a pluggable backend, so a drop-in store can serve all of them
- **LangGraph forum: "transaction log for agent systems"** — https://forum.langchain.com/t/what-is-the-equivalent-of-a-transaction-log-for-agent-systems/3986 — users asking for exactly WAL-like semantics for agents

**Transferable idea:** traces and checkpoints are graphs (runs → child spans, tool calls, retrievals, state diffs) stored in tabular DBs and queried awkwardly. RelateDB as a **first-class trace/checkpoint store**: a `BaseCheckpointSaver` implementation via the Python binding (WAL gives real transaction-log semantics the forum asks for), plus "trace analytics with Cypher" — find the retrieval path that led to a bad answer, detect agent loops as cycles, replay a run as a path query.

## 3. MCP servers for databases

- **@modelcontextprotocol/server-sqlite** — official: schema introspection + read-only queries + a built-in in-memory scratch DB for experimentation
- **@modelcontextprotocol/server-postgres** — official: schema inspection + read-only SQL via connection string (list: https://github.com/modelcontextprotocol/servers)
- **neo4j/mcp** — https://github.com/neo4j/mcp — official Neo4j MCP: read-only Cypher mode, schema exposure, HTTP transport (https://neo4j.com/docs/mcp/current/); plus the older **mcp-neo4j-cypher** — https://github.com/neo4j-contrib/mcp-neo4j/blob/main/servers/mcp-neo4j-cypher/README.md — and a whole family of knowledge-graph-memory MCP servers (https://neo4j.com/developer/genai-ecosystem/model-context-protocol-mcp/)
- **duckdb-mcp** — security model documented as a first-class concern: access modes, path allowlists (https://duckdb-mcp.readthedocs.io/en/latest/guides/security/)
- **mcp-server-neon** — https://github.com/neondatabase/mcp-server-neon — goes beyond reads: branch management + schema migrations from chat
- **supabase-mcp** — DB access + platform management APIs from the agent
- **QueryBear** — https://github.com/spencerpauly/awesome-mcp-databases — managed DB MCP: read-only default, column-level privacy, table allowlists, audit logging
- **mcp-sql-guard / safedb-mcp** — https://github.com/tahasiddiquii/mcp-sql-guard , https://github.com/narekmalk/safedb-mcp — query-validation layers in front of a DB MCP
- **awesome-mcp-databases / awesome-mcp-servers** — https://github.com/spencerpauly/awesome-mcp-databases , https://github.com/punkpeye/awesome-mcp-servers — the discovery surface a RelateDB entry would live on

**Transferable idea:** the established pattern set is: read-only default, schema-introspection tools before query tools, allowlists, audit logs, result caps, and a scratch database. RelateDB's built-in MCP server already fits; the *differentiator demos* are (a) **zero-setup embedded DB MCP** — no server, no connection string, no "is Postgres running?", the TCK-pinned dialect means agents that learned Neo4j's MCP can query RelateDB unmodified; (b) **the in-memory scratch database story** (the official sqlite server ships one for a reason); (c) `lab fs-to-graph`/`git-to-graph` as a "repo knowledge MCP" that no other database ships.

## 4. In-browser LLM apps

- **web-llm (MLC)** — https://github.com/mlc-ai/web-llm — WebGPU LLM inference entirely in the browser, no server
- **transformers.js** — https://github.com/huggingface/transformers.js — embedding/feature-extraction pipelines running client-side (WASM/WebGPU); the standard retrieval half of in-browser AI
- **private-doc-chat** — https://github.com/pranjalmax/private-doc-chat — transformers.js + WebLLM private in-browser doc chat
- **fully-local-pdf-chatbot** — https://github.com/jacoblee93/fully-local-pdf-chatbot — the canonical "RAG with zero backend" demo
- **in-browser-rag** — https://huggingface.co/spaces/johko/in-browser-rag — HF Space walkthrough of the pattern; also https://huggingface.co/blog/rasgaard/on-device-rag
- **sql.js + sqlite-vec in the browser** — https://sql.js.org , https://github.com/asg017/sqlite-vec — SQLite compiled to WASM plus vector search, used for real-time browser retrieval with filters
- **TalaDB / LanceDB-web class** — https://taladb.dev/ — embedded local-first vector+document stores acknowledging that AI apps want DBs that live *in the app*, not behind a server
- **"RAG without a server"** — https://altorlab.dev/blog/rag-without-server — the architecture writeup genre for this space

**Transferable idea:** in-browser AI stacks today have WebGPU LLMs and vector search but **no graph database at all** — RelateDB's WASM build is the missing layer and the only Cypher engine that runs in a tab. Headline demo: **private, offline GraphRAG entirely in the browser** — web-llm + transformers.js for extraction/embeddings, RelateDB-WASM for the graph, hybrid search (CIP-278 COMBINE) for retrieval; nothing leaves the device. Second demo: local knowledge extraction over dropped files with Cypher exploration in the browser.

## 5. GraphRAG and hybrid vector+graph search

- **microsoft/graphrag** — https://github.com/microsoft/graphrag — entity extraction → Leiden community detection → hierarchical community summaries; **local search** (entity-neighborhood retrieval) vs **global search** (map-reduce over community reports) (docs: https://microsoft.github.io/graphrag/, paper: https://arxiv.org/abs/2404.16130)
- **LazyGraphRAG** — https://www.microsoft.com/en-us/research/blog/lazygraphrag-setting-a-new-standard-for-quality-and-cost/ — deferred indexing + concept communities; the cost-driven rethink that made GraphRAG practical
- **DRIFT search** — https://microsoft.github.io/graphrag/query/drift_search/ — hybrid global/local traversal starting from a seed entity
- **nano-graphrag** — https://github.com/gusye1234/nano-graphrag — <1000-LoC reimplementation; proof people want a *simple, embeddable* GraphRAG
- **LightRAG** — https://github.com/HKUDS/LightRAG — dual-level (entity/theme) retrieval over one graph+vector pair, far less ceremony than MS GraphRAG
- **kotaemon** — https://github.com/Cinnamon/kotaemon — open-source RAG UI that plugs GraphRAG in as a backend option
- **awesome-graphrag** — https://github.com/graphrag/awesome-graphrag — ecosystem index; comparisons at https://faun.dev/toolbox/compare-graphrag-engines/
- **Hybrid vector+graph patterns** — the recurring shape across all of the above: vector search for recall, graph traversal for multi-hop reasoning over the retrieved entities (mem0, zep, and LightRAG all converge on it)

**Transferable idea:** MS GraphRAG requires Azure OpenAI + a Neo4j/parquet pipeline; nano-graphrag exists because people want it small. RelateDB can be the **local-first GraphRAG engine**: markdown/PDF in → entities/relations (local or remote LLM) → one embedded graph → local search as bounded Cypher traversal, global search over stored community summaries. Its native hybrid search + vector index removes the "two stores glued together" problem every one of these projects has.

## 6. Local-first / markdown-as-database knowledge systems

- **Obsidian** — https://obsidian.md — markdown files + backlinks; the graph view is the product's signature, but it's non-queryable eye candy
- **Obsidian Dataview** — https://github.com/blacksmithgu/obsidian-datataview — a query language over notes: the single most-loved plugin, proving users want to *query their vault* (guide: https://www.dsebastien.net/the-complete-guide-to-dataview-in-obsidian/)
- **Obsidian Canvas** — spatial card/graph editing, still not queryable
- **Synapses** — https://github.com/qoob23/synapses — AI/semantic layer plugin for Obsidian
- **MemVector Knowledge Engine** — https://community.obsidian.md/plugins/memvector-knowledge-engine — vector+graph memory plugin over a vault
- **logseq** — https://github.com/logseq/logseq — outliner PKM whose graph view is core; notably, its **DB version** moved *away* from markdown files to a real database for performance (https://github.com/logseq/docs/blob/master/db-version.md)
- **Dataview Serializer / obsidio** — https://github.com/dsebastien/obsidian-dataview-serializer — exporting query results back into notes so the vault becomes a self-updating database
- **"Logseq: Personal Knowledge Graphs with DB power"** — https://volodymyrpavlyshyn.medium.com/logseq-personal-knowledge-graphs-with-db-power-85687d17cc4a — the community articulating exactly the need

**Transferable idea:** `relate lab fs-to-graph` is already 80% of "Dataview but Cypher": index a vault/repo of markdown into an embedded graph living *beside the files* (local-first: the files stay the source of truth, the graph is a rebuildable index), then query with Cypher — multi-hop questions Dataview can't express, temporal "when did I write about X after Y", graph-view-as-queries. The WASM build enables an Obsidian-style plugin story; the CLI enables a headless vault-analytics story.

## 7. Coding agents & code intelligence

- **joern** — https://github.com/joernio/joern — the **code property graph**: AST + CFG + data-flow + program-dependence edges in one queried graph (https://docs.joern.io/code-property-graph/); CPG query console for static analysis
- **joern scan / security analytics** — https://docs.joern.io/scan/ — vulnerability patterns as graph queries over the CPG
- **Sourcegraph** — https://sourcegraph.com — "code as data" at fleet scale; security mode = reachability queries over code + dependency graphs (https://sourcegraph.com/solutions/security)
- **GitHub dependency graph / supply-chain security** — https://docs.github.com/en/code-security/concepts/supply-chain-security/dependency-graph — every repo's dependency web as a first-class graph; vulnerability *reachability* is a traversal
- **GH Archive + ClickHouse github-explorer** — https://www.gharchive.org , https://ghe.clickhouse.tech/ — the entire GitHub firehose as a queryable dataset (4B+ events/month) — stored in columns, though it's a natural graph
- **GraphRepo** — https://github.com/the-muses-ltd/GraphRepo — parse any codebase into a Neo4j graph, visualize with D3, query through Claude via MCP — exactly the "code graph + agent" shape, just needing a whole Neo4j
- **Codebase-Memory (tree-sitter KGs via MCP)** — https://arxiv.org/html/2603.27277 — academic confirmation: tree-sitter → knowledge graph → MCP is an emerging pattern for LLM code exploration
- **code-graph-mcp / code-nexus / reposkein** — https://github.com/danweinerdev/code-graph-mcp , https://github.com/snagrecha/code-nexus , https://github.com/reposkein/reposkein — tree-sitter code graphs behind MCP for coding agents; a whole micro-genre
- **clangd source-graph RAG** — https://news.ycombinator.com/item?id=46429604 — C/C++ code graph RAG built on real compiler front-ends
- **Claude Code trace/memory tooling** — https://github.com/lludlow/TraceCC , https://claudia.aiadopters.club/ — the coding-agent ecosystem building its own ad-hoc stores

**Transferable idea:** RelateDB already has `lab git-to-graph` and `lab fs-to-graph`. The ideas-list story: **"the embedded code property graph"** — tree-sitter → nodes/edges in RelateDB, exposed to coding agents over MCP: "which functions transitively call this deprecated API", "what changed around this hot file across the last 50 commits", supply-chain reachability ("is the vulnerable dep actually reachable from an entry point?") — all as Cypher, in the repo itself, no server. Joern proves the query model; GraphRepo/code-graph-mcp prove agents want it; none of them are a single embedded binary with WAL durability.

## The seven transferable ideas distilled

1. **Embedded agent-memory layer** — graphiti/mem0 semantics (bi-temporal edges, entity resolution, invalidation-not-deletion) with sqlite-like ergonomics; every current option needs a DB server.
2. **LangGraph checkpointer + trace store in RelateDB** — WAL = the "transaction log for agent systems" people are asking for; traces as queryable DAGs (path-to-bad-answer, loop detection, replay).
3. **Zero-setup database MCP** — no server, no connection string; agents trained on Neo4j's MCP work unmodified; `fs-to-graph`/`git-to-graph` as a repo-knowledge MCP nobody else ships.
4. **Browser-native GraphRAG** — web-llm + transformers.js + RelateDB-WASM: the only in-tab graph engine; private, offline hybrid vector+graph retrieval.
5. **Local-first GraphRAG engine** — markdown in, one binary, local+global search via native hybrid search; "nano-graphrag but a real database."
6. **"Dataview but Cypher"** — a vault/repo index beside the files, rebuildable, locally queryable multi-hop knowledge; WASM build opens the plugin path.
7. **Embedded code property graph** — tree-sitter CPG + MCP for coding agents and security reachability analysis, in the repo, in one binary.

**Positioning thread:** every ecosystem above is converging on graphs + local-first + agent access, and each one currently pays for it with a heavyweight server (Neo4j/FalkorDB/Postgres) or a hand-rolled JSON/SQLite approximation. RelateDB is the only engine that is simultaneously embedded (like SQLite), graph-native (Cypher, TCK-floored), agent-accessible (built-in MCP), and browser-capable (WASM) — organize the ideas list around the *use cases people already build badly without it*, not around engine features.

*Caveat: compiled from web search summaries plus fetches of the awesome-mcp-databases index; individual project URLs came from search results and weren't each visited — spot-check before publishing.*
