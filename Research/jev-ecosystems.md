---
type: Research
name: jev-ecosystems
INFORMS:
  - "[[Project/instantcypher]]"
  - "[[Project/skills-as-graphs]]"
  - "[[Project/strategy-graphs-as-shipped-artifacts]]"
  - "[[Project/the-graph-walking-agent-cursor]]"
  - "[[Project/the-judgment-ledger]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/TypeSafe AI]]"
MENTIONS_PERSON:
  - "[[Person/Armin Ronacher]]"
  - "[[Person/Diogo Almeida]]"
  - "[[Person/Kervin Hu]]"
  - "[[Person/William Lyon]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: JEV decisions compiled to deterministic Cypher is the empty lane this audit names
    target: "[[Project/instantcypher]]"
  - kind: inspired-by
    reason: neo4jev hop-by-hop navigation becomes a next_hop MCP tool
    target: "[[Project/the-graph-walking-agent-cursor]]"
  - kind: complements
    reason: store the raw judgments as queryable graph edges
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GraphRAG]]"
  - "[[Technology/JEV]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/SQLite]]"
---

# Research findings: the JEV ecosystem — a decision oracle meets graphs where?

*Collected 2026-10-23 as inspiration research for the relate-ideas list.
Question asked: JEV (TypeSafe AI's "System One" model) launched weeks ago and
already has a 415-entry awesome ecosystem. Which of its use-case categories are
genuinely graph-shaped — where the core data is relationships and the questions
are traversals/patterns — and would suit being powered by an embedded graph
database like RelateDB, and where is a flat store or nothing at all already
right? Profile used as the lens: RelateDB is an embedded in-memory
property-graph engine, single binary, fsync'd WAL + Parquet checkpoints,
openCypher TCK dialect, WASM/browser build, MCP server, Bolt/HTTP APIs, C ABI
wrapped by Python/JS/Java/Go clients.*

The honest headline, up front: **JEV is not a data system, and most of its
ecosystem has no graph in it.** JEV is a decision oracle — state plus typed
questions in, calibrated answers out — that persists nothing and stores nothing.
The graph story exists only at the three places JEV *touches* data with
relationship structure: (1) graphs as navigation surfaces the model walks
(taxonomy trees, knowledge-graph hops), (2) graphs as the durable record of its
judgments (entity-resolution edges, assertion-gated KG edges), and (3) graphs as
the substrate its decisions compile into queries over (the SQL-decision pattern
nobody has yet carried to Cypher). The audit below finds **3 graph-native
patterns, 4 graph-adjacent categories, and 9-plus categories that are flat
judgment plumbing where an embedded graph engine adds nothing** — and says so.

## 1. What JEV actually is (from the primary sources)

- **The model and its maker.** JEV (styled "Jev") is TypeSafe AI's flagship and
  first "System One" model — "built to make fast, structured decisions that
  software can use directly" (https://docs.typesafe.ai/introduction). TypeSafe
  AI was founded by Diogo Almeida, an OpenAI researcher who helped build ChatGPT
  and co-invented RLHF, with co-founders Erik Gafni and Sasha Sheng
  (https://techcrunch.com/2026/09/18/a-new-kind-of-ai-model-from-a-chatgpt-inventor-is-thrilling-developers/).
  The model is named for William Stanley Jevons — whose paradox (falling cost
  drives greater use) is the launch thesis — and is trained on synthetic data
  via "reinforcement learning from calibrated decisions" (RLCD), not RLHF.
  TypeSafe was valued at $7.5B weeks after launch
  (https://techcrunch.com/2026/10/09/the-maker-of-non-text-model-ai-model-jev-valued-at-7-5b-just-weeks-after-launch/).
- **The contract.** One endpoint, `POST https://api.typesafe.ai/v1/systemone`:
  a `state` (text or JSON) plus a map of named typed questions, all evaluated in
  parallel against the same state. Three primitives: **Choice** (pick from up
  to 255 named options; returns the choice, per-option probabilities, and a
  confidence), **Score** (a position on 2–10 described levels, with
  probabilities and confidence), and **Noul** (a single calibrated 0–1
  probability that a statement is true). "No text generation, no parsing" —
  code branches on the typed values. Current alias `jev-latest` = `jev-1.13.0`.
- **The economics.** ~$0.042 per million input tokens, output free; 70–500 ms
  typical latency; 64k tokens per request (32k state + longest question).
  The docs' key design push: decompose compound judgments — "ask each factor as
  a separate question, then combine the results with logic in your code."
- **The hard limits, stated by the community list itself**
  (https://github.com/valentynkit/awesome-jev-typesafe): schema-valid ≠
  correct; ~68% on the vendor's four-workflow eval; it cannot count, do
  arithmetic, handle dates, or answer outside your option list; accuracy
  degrades with irrelevant state. Armin Ronacher's noted design trade: the
  model pushes judgment onto the caller, who must decide what to do with a
  50% probability.
- **Why this matters for the audit.** Every JEV use-case is *some program's
  decision step* — classify, verify, dedupe, route, pick, rate — and the
  program keeps the data. The question for RelateDB is never "is the model
  graph-shaped" (it isn't; its own state is usually a JSON blob) but "is the
  data the model is deciding *about* graph-shaped, and do the decisions
  themselves form a graph worth storing and querying."

## 2. The evidence base

- **The awesome lists.** The main catalog
  (https://awesomejev.vercel.app/ → https://github.com/valentynkit/awesome-jev-typesafe,
  maintained by valentynkit, independent of TypeSafe) tracks 415 entries across
  338 repos in 16 sections, 107.6k cumulative stars, links checked weekly, as
  of 2026-10-22. Representative entries: jev-ultrafast (23.4k★, books a flight
  by picking an operation and target element from a pre-indexed DOM table), kev
  (9.4k★, a LoRA adapter on Qwen2.5-0.5B answering many typed questions in one
  prefill), fast-jev-compaction (7.7k★), SemIf (4.9k★, the most-starred
  independent open replica, formerly openjev), jev-trader (3.1k★).
- **The breadth survey.** 0xshin0221's walk through nine awesome lists
  (https://dev.to/0xshin0221/what-people-are-building-with-jev-a-look-through-nine-awesome-lists-30nb,
  snapshot 2026-09-21): 2,108 list memberships collapse to 1,186 distinct repo
  addresses; 63.8% appear in exactly one list — a long-tail ecosystem of small
  tools, not a converged platform. Its regrouped category census (from
  logicrw's directory): "software connections" (90), "work assignment and
  history" (72), "quality and action checks" (55), "information" (34),
  "special-purpose tools" (34), "games" (31), "browser and computer control"
  (27), "creative tools and conversation" (15).
- **Notable coverage.** TechCrunch (above), Forbes
  (https://www.forbes.com/sites/ronschmelzer/2026/09/22/why-everyone-is-talking-about-jev-the-ai-that-doesnt-chat/),
  InfoQ
  (https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/),
  The New Stack
  (https://thenewstack.io/typesafe-jev-system-one/),
  The Stack
  (https://www.thestack.technology/runtime-jev-is-an-llm-without-the-ll/),
  The Latent
  (https://thelatent.co/models/typesafe-introduces-jev-claiming-up-to-200x-faster-decisions-than-frontier-llms),
  runtimewire
  (https://runtimewire.com/article/typesafe-jev-system-one-ai-model-early-access).
  Quoted users: Vercel's Pranit Sharma (5–18x faster than OpenAI's Luna at
  better accuracy, per TechCrunch); Bryo AI's Nikhil Mudholkar (Gemini slightly
  more accurate on email classification but 10–20x pricier).
- **The graph-side primary sources** — the four load-bearing ones for this
  audit:
  1. **Neo4j field engineering, JEV-GraphRAG** — https://github.com/neo4j-field/jev-graphrag
     — "a calibrated decision layer for GraphRAG pipelines on Neo4j," demos +
     a 21-item backlog (ingestion/chunking, extraction/schema,
     retrieval/answering, evaluation/maintenance). The one built demo ports
     neo4j-field/dedup-demo's three-phase entity-resolution pipeline, "same
     three-phase pipeline, same dirty dataset, same APOC merges" — only the
     judge layer differs. Rule: deterministic when certain, Jev for judgment
     calls with a confidence gate, escalate to a full LLM only when uncertain.
  2. **The entity-resolution test** — Kervin Hu (Neo4j),
     https://medium.com/neo4j/i-tested-jev-on-entity-resolution-e7249f219ca6
     (reproducible at https://github.com/Kervin-Hu-Neo4j/jev-neo4j-entity-resolution):
     703 synthetic contact records / 330 people; blocking in Neo4j via shared
     attribute nodes cuts 246,753 pairs to 1,822; each candidate pair judged by
     Jev and four LLMs; each judgment becomes a `SAME_AS` relationship carrying
     probability and model name; Weakly Connected Components in Neo4j GDS
     clusters records into people. Jev hit pairwise F1 0.943 (between Haiku and
     Opus 5) at ~1/100th of Sol's cost and ~1/5th its median latency; the
     confidence-gated hybrid — escalate the 10.6% of pairs scoring 0.3–0.7 to
     Opus — reached F1 0.972 at 17% of Opus's cost. The sharpest design lesson:
     one LLM (Luna) returned schema-valid `{"same_person": false,
     "probability": 0.99}` where the probability meant confidence in the
     boolean, not match likelihood — "the meaning of a valid field, which a
     schema cannot check" — and the graph collapsed 330 people into 197. A
     Noul returns one value with one meaning.
  3. **Knowledge-graph extraction with stored judgments** — William Lyon,
     https://lyonwj.com/blog/typesafe-jev-knowledge-graph-extraction
     (repo: extraction-knowledge-graph-experiments): GLiNER2.5 (local 194M span
     model) extracts entities and candidate relations; Jev adjudicates —
     relation selection via Choice, support via Noul, merge state via Score.
     The load-bearing architecture decision for us: **judgments are stored as
     graph properties rather than consumed at decision time**, so the assertion
     gate becomes a `WHERE` clause and rejected edges remain queryable — a
     graph that drops them "can't answer a question about it." The assertion
     gate lifted KG precision 0.279 → 0.404 at unchanged recall; ~174 ms per
     request. Conclusions worth engraving: "candidate generation and judgment
     are different jobs"; "read the distribution, not the label"; "store the
     raw judgments." One honest negative: escalating uncertain edges to Haiku
     made things worse — "best escalation rate on this corpus is zero."
  4. **Graph navigation by typed choices** — neo4jev,
     https://neo4j.com/blog/genai/navigating-a-neo4j-knowledge-graph-with-jev/
     (reviewed at https://jevlist.ai/projects/neo4jev): walks a Neo4j graph hop
     by hop with **no Cypher generated during traversal** — because generated
     paths/nodes/relationships "might actually not exist" and LLM stepping is
     too slow. Per hop: pull the current node's real in/out edges, present them
     as Choice options with opaque keys mapped back to real edges, ask a Noul
     whether the goal is reached in the same call, follow top-k options
     beam-search style with summed log-probabilities, visited-set and budget
     caps. "The model can only choose between options it can read" — grounded
     (every edge walked exists), inspectable (every distribution recorded),
     cheap (one call per hop). The stated generalizations: query planning,
     workflow routing, tool/model selection.
- **The decision-to-query pattern family** (the lane "InstantCypher" would
  occupy — see §5): IntentSQL (Amine-LG,
  https://calibrateddecisions.com/projects/intentsql) — natural-language
  questions over SQLite answered by "composing small Jev decisions — table,
  column, comparison and operand selection" into "inspectable typed plans,
  deterministic SQL and previewed guarded writes"; JevQL (Hemanth HM,
  https://hemanth.github.io/jevql/) — a "PostgreSQL & Cognitive Query
  Language" with first-class NOUL/CHOICE/SCORE syntax, deterministic
  relational pushdown as an "AST pre-filter" (58 of 100 rows dropped before
  any model call) and a SHA-256 in-tree LRU cache; plus jev4k
  (https://jev4k.com/concepts/), AI2SQL (https://ai2sql.io/jev), and
  "Turn text into SQL decision columns with Jev"
  (https://jevlist.ai/knowledge/jev-text-to-columns). LlamaIndex integration
  exists as rerank/select hooks (WiktorB2004, https://github.com/WiktorB2004/llama-index-jev
  — `JevRerank` postprocessor + `JevSingleSelector`/`JevMultiSelector`;
  reported +0.056 nDCG@5 over MiniLM on BEIR nfcorpus at ~$0.0003/query) —
  note: reranking and routing, **not** knowledge-graph extraction.
- **The taxonomy-walker pattern family** (the "strategy tree as pre-baked
  navigation surface" — see §4): jev-tree (reachjalil,
  https://reachjalil.github.io/jev-tree/ — "the wall is 255. walk around it":
  give Jev a tree, ask one level at a time, fail closed; a 320-leaf taxonomy
  walked in "3 calls × ≤8 options"; on a flat truncate-to-255 question, "Cape
  Town does not exist" and accuracy fell to 50%/0%); hierarchical product
  categorization (https://usejev.dev/use-cases/hierarchical-product-categorization/
  — a 5–6 level, thousands-of-leaves marketplace taxonomy walked level by
  level, beam width 3, geometric-mean path scores computed in code never by
  the model, `none` as an escape at every node, three-way outcome: file at
  leaf / file at parent / route to human review when the top two paths diverge
  near-equally); and TypeSafe's own hierarchical-classification cookbook, cited
  as precedent by both.
- **The evidence-carrying traversal counterpoint** — Timotheos Samartzidis,
  https://timosam.com/blog/let-the-graph-change-the-next-decision.html: the
  inverse of pre-computation — during a live walk, "let the evidence collected
  along a path change the decision at the next junction," keeping per-path
  source facts distinct from a shared evidence ledger; 55 runs over tiny
  authored JSON-graph fixtures; honest scope statements ("it is not evidence
  of a latency or cost win"; "retrieving the evidence and confidently
  recognizing that it is enough are separate tasks"). No graph database used —
  which is itself a data point for the audit.

## 3. The audit — JEV use-case categories, classified honestly

The classification bar, same as the SQLite audit: a category converts to a
graph engine only if its *core data is relationships* and its *hot queries are
multi-hop / traversal / pattern-shaped*. A decision step over a flat list —
emails, findings, rows, moves — does not become graph-shaped because a model
answers it.

### (a) Graph-native — the data is relationships, the work is traversal

1. **Entity resolution / dedup (the proven one).** Both Neo4j-side primary
   sources land here: the Medium test (blocking over shared attribute nodes →
   pair judgments → `SAME_AS` probability edges → WCC clustering) and
   jev-graphrag's dedup demo (confidence gates, review queue instead of
   auto-merge). The shape is pure graph — records, candidate-match edges,
   survivorship, connected components of "same person" — and the confidence
   distribution per edge is exactly the property you want stored and later
   queried ("show me every merge that went through at 0.51"). The embedded
   angle: Jervin's whole three-phase pipeline runs on a laptop for three
   cents; nothing about it needs a server.
2. **Knowledge-graph extraction with judgment provenance.** Lyon's pipeline
   is the generalizable form: extractor proposes, Jev adjudicates, and the
   *judgments live in the graph* — `assertion`, `supported`, `confidence`,
   `priority_score` as properties, rejected edges retained, gates as `WHERE`
   clauses. The graph is not the analysis target; it is the audit surface.
   Every GraphRAG backlog item in jev-graphrag (chunking, schema mapping,
   retrieval, eval) inherits this shape.
3. **Graph navigation / traversal-by-decision.** neo4jev's hop-by-hop walk
   over real edges: the graph supplies grounded candidates, the model only
   ranks. This is the pattern the sources explicitly generalize to query
   planning, workflow routing, and tool/model selection — wherever an agent
   must choose among *actually existing* next steps with context.

### (b) Graph-adjacent — flat or tree today, a graph projection helps some queries

1. **Taxonomy / hierarchical classification** (jev-tree, usejev's product
   categorization). The strategy surface is a tree walked level-by-level —
   pre-baked navigation, yes, but currently an authored nested map in memory.
   A graph store earns the slot only when the surface grows the features the
   nested map handles badly (see §4): polyhierarchy ("Accessories" under many
   parents — a many-to-many the usejev page calls out as a naming hazard),
   versioning, joins with instance data, and querying the accumulated walks.
2. **Routing and gateways / work assignment.** Model routing, email triage,
   queue assignment (jev-router; the survey's "work assignment and history,"
   72 entries) — flat single-hop choices. Adjacent only when the routing
   policy itself is a hierarchy/DAG being walked (jev-tree's region → service
   → failure mode demo) or when routing decisions accumulate into a lineage
   worth traversing ("who has this ticket touched, and what did each decide").
3. **Games, robotics, simulation** (TypeSafe Mario, JevPilot, the survey's
   "games," 31 entries). The world state has topology, but the Jev decisions
   are local (pick a move). A graph helps the *world model*, not the decision
   layer — which is the README's existing World-Model Storage idea, not a new
   one.
4. **Finance and trading** (jev-trader, 3.1k★). The listed projects are
   signal/decision tools over flat series. The graph-shaped member of this
   class would be fraud-ring / counterparty-network alerting — a genuine graph
   workload — but no flagship JEV project found in these sources does it; flag
   it as an opening rather than evidence.

### (c) Not graph-shaped — JEV plus anything flat is already right, say so plainly

The bulk of the 415 entries, and the audit should not flinch:

- **Coding agents** (fast-jev-compaction, tool selection, the Claude
  Code/Codex/Pi/Hermes section) — per-decision choices over diffs and traces;
  flat.
- **Browser and computer use** (jev-ultrafast, 23.4k★) — the pre-indexed DOM
  *table* is the whole trick: operation and target element as Choice options.
  The DOM is a shallow tree the tooling deliberately flattens into an index;
  the hot query is pick-one, not traverse.
- **Open models and replicas** (SemIf, kev, NanoJev) — model infrastructure;
  no data.
- **Code review and quality** (jev-review) — findings are flat lists judged
  per finding.
- **Search, reranking and RAG, the flat half** — the rerank/select hooks
  (llama-index-jev, "every") rank a retrieved list; that is a sort, not a
  traversal. (The GraphRAG half of this category is §3a #2 — the category
  splits.)
- **Data and ops** (pg-jev, filter/label tools) — rows in, labels out.
- **Safety, moderation, verification** (jev-guard) — per-item judgments.
- **Benchmarks, evals, calibration; playgrounds; command line; community
  clients; official SDKs** — infrastructure and evaluation; nothing to store.

Rough count across the awesome list's 16 sections and the survey's 8 regrouped
categories: **3 graph-native patterns, 4 graph-adjacent categories, ~9–11
flat categories.** The ecosystem's center of mass is a cheap judgment call
embedded in ordinary software — the Jevons-paradox play — and a graph database
is a cost, not a win, for most of it.

## 4. The strategies-as-graphs question — pre-baked navigation surfaces

The specific shape asked about: JEV pipelines that *pre-compute*
decision/strategy structures which an agent later *navigates with context* —
the graph as a pre-baked navigation surface, not a post-hoc analysis target.
The sources support exactly this shape, in two directions:

- **Direction one: the surface is authored, the walk is the runtime.**
  jev-tree and the usejev categorizer are precisely pre-baked strategy
  surfaces: a human-authored tree of small choice questions exists before any
  call; at runtime the agent walks it one level per request with the state
  (the ticket, the listing) as context, keeping a beam of paths scored in
  code, backing off weak levels, failing closed ("a guessed leaf is worse than
  a miss"). What is *not* there yet: the surface is an in-memory nested map,
  the walks are not persisted, and the polyhierarchy cases (an item that
  legitimately belongs under several parents) are handled by naming
  workarounds. This is where a persistent property-graph surface genuinely
  changes the game: a taxonomy-as-graph with every walk recorded as a path of
  probability edges — which is §3a #2's "store the raw judgments" applied to
  navigation instead of extraction.
- **Direction two: the surface already exists, the walk is the runtime.**
  neo4jev navigates a pre-existing knowledge graph; timosam's prototype
  carries evidence along the walk so that "the evidence collected along a
  path changes the decision at the next junction" — navigation *with
  accumulated context*, the exact property the flat junction scorers lose.
  Neither needs the graph to be pre-*computed*; both need it to be
  pre-*committed* (real edges, stable schema) so the choices are grounded.

Which surveyed use-cases fit the pre-baked shape: hierarchical
categorization/taxonomy filing (yes, purest fit), graph navigation for
retrieval/task-walking (yes — the surface is the corpus's graph), routing
over an authored policy tree (partially — usually shallow enough that flat
wins), game-state move selection (the surface exists but is the game's, not
prepped), browser-use over a pre-indexed DOM (no — the index is a table on
purpose). Entity resolution and KG extraction do **not** fit — they are
post-hoc analysis targets, the opposite direction; their graph-native claim in
§3a stands on data shape, not navigation.

The honest caveat for all of it: every working example found runs its
navigation surface as an in-memory structure or a server-side Neo4j; none is
shipped as a portable single-file artifact an agent carries. That is a
verified gap, not a forced one.

## 5. Conclusions — what converts, what the list already covers, what's new

**What converts:** the three §3a patterns — entity resolution with stored
confidence edges, KG extraction with judgment provenance, and
traversal-by-decision over a committed graph — plus the §4 pre-baked strategy
surface once it wants persistence, polyhierarchy, or walk history. Everything
in §3c should be left alone, out loud.

**What the repo already covers** (checked against the README): entity
resolution ("Entity Resolution (MDM)" in the Use-Case Gallery, genealogy
dedup with reviewable matches), knowledge-graph extraction ("In-Browser
Knowledge Extraction", "Book NLP to Graph"), GraphRAG-style embedding
(the neo4j-driver-parity entry, line ~393), tool-selection graphs (Agent
Infrastructure), and world models for games ("World-Model Storage"). The
convertible *classes* are covered; the gaps are JEV-specific flavors.

**Genuinely-new candidates** (report only — the parent session decides; five
offered):

1. **InstantCypher — Jev decisions compiled to deterministic Cypher.** The
   natural-language → small-decisions → typed-plan → deterministic-query
   pattern is verified live on SQL three times over (IntentSQL on SQLite,
   JevQL on PostgreSQL with deterministic pre-filter + judgment cache,
   jev4k/AI2SQL), and nobody has built it for Cypher or any graph query
   language — a searched-and-confirmed empty lane. The graph twist the SQL
   versions can't have: the schema itself (labels, relationship types,
   properties, indexes) is a small navigable graph of Choice options, and
   jev-graphrag's backlog already names the safety half of it ("Generated-
   Cypher safety gate" — check text-to-Cypher output against existing labels
   and relationship types). For RelateDB this is also the MCP story: an
   agent that asks in prose, gets an inspectable typed plan, and runs guarded
   Cypher against one portable `.cl` file.
2. **The pre-baked strategy graph as a shipped artifact.** Take the
   jev-tree / usejev taxonomy-walker pattern and make the surface a `.cl`
   file: an authored polyhierarchical strategy/decision tree where each node
   is a Choice question, each edge accumulates its walked probability
   history, `none`-escapes and human-review divergences are recorded, and the
   analytics ("which branches do agents take, where do they stall, where does
   the distribution go flat") are Cypher path queries. Named lineage: jev-tree
   ("the wall is 255"), usejev's three-way filing outcomes. Distinct from
   "Skills as Graphs" (static instructions/examples/tools) — this surface is
   *walked with runtime context and records its walks*.
3. **The judgment ledger — decision provenance as a first-class graph.**
   Lyon's "store the raw judgments" and the Medium test's `SAME_AS` edges
   carrying probability and model name, generalized: every model call (state
   hash, question, full distribution, confidence, model version, cost) becomes
   an edge on the data it judged; rejected/escalated candidates stay queryable;
   gates are `WHERE` clauses; calibration drift and escalation-band analysis
   ("every judgment that later flipped") are queries, not log archaeology.
   Adjacent to "Agent Trace Warehouse" (which stores agent *execution*) — this
   stores model *judgments over data*, with the data.
4. **Confidence-gated entity resolution, embedded.** The Medium result as a
   product shape: Jev scores every candidate pair on an embedded graph,
   0.3–0.7-band pairs escalate to a full LLM, WCC-style clustering runs in the
   engine, and the review queue is a Cypher query over low-confidence edges —
   the whole pipeline in one binary, one file, three cents. The class is
   already in the README's gallery; the *confidence-gated hybrid routing*
   flavor, with the measured F1 0.972-at-17%-of-cost anchor, is not.
5. **Graph-walking agent cursor over MCP.** neo4jev's pattern on RelateDB:
   an MCP tool that exposes not `run_query` but `next_hop(node, goal)` —
   real edges in, Choice options out, goal-checked by Noul, beam and budget
   caps in the tool — so an agent navigates a committed graph grounded in
   existing edges instead of generating Cypher it can't verify. Named lineage:
   neo4jev ("the model can only choose between options it can read"),
   timosam's evidence-carrying walk as the context-accumulation upgrade.

**What does not convert, full stop:** the §3c bulk — coding-agent
compaction, browser/computer use over pre-indexed surfaces, reviews,
moderation, rerank/select hooks, benchmarks, clients. JEV's own Jevons-paradox
thesis is that a trillion cheap flat judgments get embedded in ordinary
software; ordinary software is not a graph, and pretending otherwise would be
the forced list this audit exists to avoid.

## Sources

- https://docs.typesafe.ai/introduction
- https://typesafe.ai/blog/introducing-system-one-models-and-jev
- https://github.com/valentynkit/awesome-jev-typesafe
- https://awesomejev.vercel.app/
- https://dev.to/0xshin0221/what-people-are-building-with-jev-a-look-through-nine-awesome-lists-30nb
- https://techcrunch.com/2026/09/18/a-new-kind-of-ai-model-from-a-chatgpt-inventor-is-thrilling-developers/
- https://techcrunch.com/2026/10/09/the-maker-of-non-text-model-ai-model-jev-valued-at-7-5b-just-weeks-after-launch/
- https://www.forbes.com/sites/ronschmelzer/2026/09/22/why-everyone-is-talking-about-jev-the-ai-that-doesnt-chat/
- https://www.infoq.com/news/2026/10/typesafe-ai-jev-released/
- https://thenewstack.io/typesafe-jev-system-one/
- https://www.thestack.technology/runtime-jev-is-an-llm-without-the-ll/
- https://thelatent.co/models/typesafe-introduces-jev-claiming-up-to-200x-faster-decisions-than-frontier-llms
- https://runtimewire.com/article/typesafe-jev-system-one-ai-model-early-access
- https://github.com/neo4j-field/jev-graphrag
- https://medium.com/neo4j/i-tested-jev-on-entity-resolution-e7249f219ca6
- https://github.com/Kervin-Hu-Neo4j/jev-neo4j-entity-resolution
- https://lyonwj.com/blog/typesafe-jev-knowledge-graph-extraction
- https://neo4j.com/blog/genai/navigating-a-neo4j-knowledge-graph-with-jev/
- https://jevlist.ai/projects/neo4jev
- https://timosam.com/blog/let-the-graph-change-the-next-decision.html
- https://reachjalil.github.io/jev-tree/
- https://usejev.dev/use-cases/hierarchical-product-categorization/
- https://calibrateddecisions.com/projects/intentsql
- https://hemanth.github.io/jevql/
- https://jev4k.com/concepts/
- https://ai2sql.io/jev
- https://jevlist.ai/knowledge/jev-text-to-columns
- https://github.com/WiktorB2004/llama-index-jev
