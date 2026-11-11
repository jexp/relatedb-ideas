---
type: Project
name: in-browser-knowledge-extraction
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/Hugging Face]]"
  - "[[Company/Microsoft]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the rendering pattern the extraction demo reuses for the live graph view
    target: "[[Project/a-million-nodes-in-a-tab]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GraphRAG]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Vector Search]]"
  - "[[Technology/WASM]]"
  - "[[Technology/WebGPU]]"
  - "[[Technology/transformers.js]]"
  - "[[Technology/web-llm]]"
---

# In-Browser Knowledge Extraction

> WASM RelateDB + web-llm: read a page, extract entities/relations locally,
> hand them to the graph — private, offline RAG.

## What

Drop a page (or a PDF, a doc, a whole crawled folder) into a browser tab and
watch it become a graph: web-llm runs the extraction model locally on WebGPU,
transformers.js embeds the entities, and the extracted entities and
relations stream into RelateDB-WASM as `MERGE` statements. No server sees
the content — the page, the model, the graph, and the queries all live in
the tab; close it and nothing remains unless you export the `.cl` file.

That is the foundation demo for a whole private-KB product line: a researcher
dragging 40 papers into a tab and querying the synthesized graph ("which
methods are used by which datasets?"), a lawyer building a case knowledge
graph on an air-gapped laptop, a journalist synthesizing entities from leaked
documents. Retrieval over the result is hybrid: vector recall joined with
graph traversal for multi-hop answers — GraphRAG with zero infrastructure
and zero data egress.

## Why RelateDB

RelateDB's WASM build is the only Cypher engine that runs in a browser
tab, which makes it the missing layer of the in-browser AI stack (web-llm
and transformers.js already exist; no graph database does). In-memory Cypher
at WASM speed gives interactive exploration of the freshly built graph;
ephemeral operation inside the tab is itself the privacy guarantee. Hybrid
search (the preview-gated CIP-278 `COMBINE`) does vector + graph retrieval
in one engine instead of the "two stores glued together" setup every
in-browser RAG demo uses today. When the session ends, the graph exports as
a single `.cl` file — portable into the desktop CLI, `relate serve`, or
any other tool in this list. The cookbook's WASM parity build is the
ready-made site template.

## What it needs

- The demo site: file drop → extraction → live graph view (the cookbook's
  WASM parity build + the *A Million Nodes in a Tab* rendering pattern)
- An extraction pipeline over web-llm: entity/relation prompts, JSON output
  parsing, MERGE-based incremental loading with entity resolution
  heuristics; transformers.js embeddings into RelateDB's vector index,
  `COMBINE` hybrid queries as the retrieval API
- PDF/DOCX readers in the browser for non-HTML input; a provenance edge
  convention (every fact cites its source span) so answers stay auditable;
  model-choice guidance for which web-llm sizes extract well — the honest
  performance story for mid-range hardware

## Lineage & inspiration

- [web-llm (MLC)](https://github.com/mlc-ai/web-llm) — WebGPU LLM inference
  entirely in the browser; the extraction half of this idea
- [transformers.js](https://github.com/huggingface/transformers.js) — the
  embedding/feature-extraction half
- [private-doc-chat](https://github.com/pranjalmax/private-doc-chat) and
  [fully-local-pdf-chatbot](https://github.com/jacoblee93/fully-local-pdf-chatbot) —
  the canonical "RAG with zero backend" demos, currently vector-only;
  [sql.js + sqlite-vec](https://sql.js.org) — the embedded-DB precedent
- [Microsoft GraphRAG](https://github.com/microsoft/graphrag) /
  [LightRAG](https://github.com/HKUDS/LightRAG) / [nano-graphrag](https://github.com/gusye1234/nano-graphrag) —
  the GraphRAG pipeline shapes this in-browser version miniaturizes
  ([research/agent-native.md](../research/agent-native.md) §4–5)
