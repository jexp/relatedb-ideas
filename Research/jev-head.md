---
type: Research
name: jev-head
INFORMS:
  - "[[Project/instantcypher]]"
  - "[[Project/the-graph-walking-agent-cursor]]"
  - "[[Project/the-judgment-ledger]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: pg-jev proves decisions-as-SQL operators while the Cypher lane stays empty
    target: "[[Project/instantcypher]]"
  - kind: variant
    reason: versioned skill libraries and skill distillation are the head version of procedural memory
    target: "[[Project/skills-as-graphs]]"
  - kind: inspired-by
    reason: jevgrep and jev-social walk a hierarchy level by level
    target: "[[Project/the-graph-walking-agent-cursor]]"
  - kind: complements
    reason: jevcache and Canny already keep append-only ledgers but never join or traverse them
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JEV]]"
  - "[[Technology/MCP]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/SQLite]]"
---

# Research findings: the JEV head tier — what the popular projects actually hold

*Collected 2026-10-23 as the second half of the JEV corpus audit; the first half
is [jev-longtail.md](jev-longtail.md) (the zero-star tail), the prior audit is
[jev-ecosystems.md](jev-ecosystems.md). Question asked this pass: the most
popular tier of the JEV/decision-model corpus — which of the popular projects
are interesting, and which have graph fit across storage (relational-shaped
data held in JSON/SQLite/arrays today), representation (the domain itself is
entities-and-relationships), and results (outputs are ranked/merged/scored
sets over relationships). Same honesty rules: "no fit, flat" verdicts are
expected. Spoiler confirmed by the data: **the head is less graph-shaped than
the tail — the head builds infrastructure, and infrastructure is flat on
purpose — with three important exceptions (memory engines, database
integrations, and the Chinese chat-assistant family, which is the single
most popular consumer application of the entire corpus).***

## 1. Where the star boundary actually sits

GitHub search, `jev` corpus, 2026-10-23 (false-positive noise ~5–10% — the
corpus still contains pre-model projects like jEveAssets, JeVois, the Jeva JS
framework and the Russian Jevix typography library, plus personal wedding
sites of people named Jev):

| Star threshold | Repo count |
| --- | --- |
| ≥3,000 | 11 |
| ≥1,000 | 28 |
| ≥500 | 66 |
| ≥100 | 225 |
| ≥20 | **545** |

So the "head" (≥20★) is ~545 repos — roughly the top 5% of the ~11k
model-era `jev`-named repos from the tail report. The coordinator's
20–100★ band is real and thick: ~320 repos between 20★ and 100★, ~160
between 100★ and 300★. The mega-famous tier (>500★) is 66 repos, of which
28 are ≥1,000★.

## 2. The heavyweight tier briefly (>300★, flagged for earlier coverage)

Verified this pass unless noted. Earlier research (jev-ecosystems.md,
jev-longtail.md) already covered: **jev-ultrafast** (23,496★), **kev**
(9,458★), **fast-jev-compaction** (7,742★), **SemIf-OpenJev** (4,877★),
**jev-trader** (3,060★), **awesome-jev-typesafe** (202★ list at
time of prior audit; now larger), **jexp/neo4jev** (180★), **typesafe-mario**
(455★), **rmalde/minecraft-agent** (600★), **christianmat/jev-pokemon**
(130★), **QuantDinger** (13,029★, as the jevlist trading web app),
**memsearch** (2,777★, as a rerank entry).

Not previously covered heavyweights, one line each:

- **NandhaKishorM/laya (33,988★)** — the open-weight System 1 decision
  engine; the single most-starred object in the corpus is an open replica.
- **modelscope/ms-swift (15,915★)** — ModelScope's training framework, now
  supports Jev-style model training; infrastructure.
- **YaoApp/yao (8,180★)** — self-hosted agents-and-workspaces platform with
  a real Jev integration; general agent tooling.
- **jev-chat/jev-chat-jarvis (7,997★)** — see §3(f); the corpus's flagship
  consumer app is a chat-reply advisor.
- **tamaratran/…** cluster (compaction/pruner), **jev-browser-use (1,195★)**,
  **hermes-jev-skills (1,150★)**, **jev-router (618★)**, **jev-codex-router
  (276★)**, **distill (759★)**, **Bodila51/muse-jev-playbook** — the
  coding-agent cost layer; flat by design.
- **zilliztech/memsearch (2,777★)** and **Asymptote-Labs/agent-beacon
  (2,625★)** — the memory cluster; §3(b).
- **TianyuCodings/NanoJev (2,559★)**, **AnyJev (1,472★)**, **ollaya
  (1,382★)**, **reticle (1,263★)**, **rizzo-flow (920★)**, **von (918★)**,
  **feder-cr/jev (893★)**, **Valen (874★)**, **openjev (742★)**,
  **vllm-jev (678★)**, **openjev-sglang (334★)**, **LLM2Jev (460★)**,
  **Heman10x-NGU/openJev-verdict-2.0 (300★)**, **togethercomputer/tev1
  (248★)**, **PostHog/jeeves (430★)** — the open-replica/runtime/research
  block, ~20% of the heavyweights by count. jeeves matters for honesty:
  PostHog's own framing is "Jev-like models give calibrated decision
  probabilities, **but at low accuracy**" — reasoning-when-unsure beats Jev
  0.905 vs 0.857 out-of-domain. tev1: "train your own Jev for $17."
- **contextgem (2,013★)** — extraction with every fact traced back to its
  source line; §3(e).
- **pg-jev (1,209★)** — §3(a); the head's most important graph-adjacent
  artifact.
- **docjev (536★)** — jerryjliu (LlamaIndex's creator): document
  classification/splitting, LiteParse local text extraction, Codex-maintained
  repo; splitting produces ordered categories with page ranges.
- **kyotofin/tax-doc-classifier (512★)** — 261 IRS forms, $0.001/page, 100%
  strict accuracy; the classifier is a JSON file of criteria, no training.
- **jev-chat family: jev-chat-windows (842★), jev-chat-jarvis-mac (509★),
  goutoujunshi-jev-chat (492★)** — §3(f).
- **thruwire/foreman (782★)** — a semantic supervisor over coding agents;
  per-ticket responsibility probabilities (implementation_complete .91,
  requirements_satisfied .79). Flat supervision, nicely done.
- **anteloc/ldraw-nova (467★)** — §3(d); LEGO assembly graphs.
- **kitze/unclutter (382★)** and **kitze/skillbox (272★)** — §3(e) skills.
- **jev-search (543★)** — Jev choosing queries, sources, time windows and
  relevance; flat pipeline.
- **extend-hq/jevbox (738★)** — permission-aware document library, folder
  hierarchy searched with Jev; §3(d).
- **moritzkremb/jev-voice-browser (416★)**, **tiptour-macos (684★)**,
  **savka777/jev-use (126★)** — computer use; flat.
- **mu (536★)**, **qybaihe** — "small judge makes routine calls, big model
  works"; flat.
- **jev-mcp (547★)**, **system-one-connector (354★)**, **jev-skill (643★)** —
  plumbing.

## 3. The head tier (20–100★ plus borderline), cluster by cluster, with verdicts

~35 READMEs read this pass. Format per entry: what it is · stars ·
**storage / representation / results** graph fit.

### (a) Decisions inside the query engine — the Postgres family

- **realZachi/pg-jev (1,209★)** — a PostgreSQL extension (PGXN package
  `jev`): `jev(row, 'the name is European')` as an ordinary boolean SQL
  function; `jev_prob`, `jev_choice`, `jev_score` as filter/rank/classify
  operators; "No index, no embeddings, no vector column." Storage: none —
  stateless per-row judgment. Representation: rows, flat. Results: scored
  row sets. **Verdict: flat — deliberately, brilliantly flat.** Its importance
  is precedent: plain-language predicates as first-class SQL, composing with
  joins and GROUP BY.
- **Sheltercosmo/jev4pg (257★)** — 41 JEV operators for PostgreSQL;
  "explainable embeddings" as named questions + answer probabilities;
  **evidence caching** "with source and evaluator identity checks";
  reviewed definitions and corrections build a "self-developing semantic
  layer." Storage: cache with provenance (source + evaluator identity).
  Representation: the semantic layer is a reviewed, versioned vocabulary.
  Results: ranked sets with explanation. **Verdict: moderate — the cached
  judgments carry provenance nobody queries yet.**
- **giuliosmall/pg_typesafe (84★)** — pre-alpha PG extension for categorical
  classification. Flat.
- The HN 1.14.0 thread's "fuzzy classifier joins as an inlined SQL function"
  and the "Jev as a DuckDB UDF" experiment (from the tail report) complete
  the picture: **the head has converged on decisions-as-query-operators, and
  it chose SQL.** Nobody has done it for Cypher — the InstantCypher lane
  stands, now with a 1,209-star reference implementation to point at.

### (b) Memory engines — the head's most graph-shaped cluster

- **libingzheren/Jev-Mem (229★)** — arXiv 2609.23986, "System-One-Controlled
  Agentic Memory." A lightweight System-One controller "organizes memories
  and guides retrieval across **semantic, temporal, causal, and entity
  relations**" over a "shared multi-relational memory"; System Two answers
  from the evidence it finds. LoCoMo: +11% answer quality, 6.6× faster
  memory construction. **Verdict: graph-native, and published.** This is the
  strongest single graph-fit artifact in the head tier.
- **nylon-memory/NylonME (53★, borderline tail but head-adjacent)** — memory
  as a mesh graph: each memory a braid of filaments (fact/emotion/temporal/
  relation/confidence/frequency), weighted edges, retrieval by spreading
  activation bounded by a global budget, tension-based forgetting. MCP
  server with the engine embedded. **Verdict: graph-native** (mesh graph,
  decayed edges), with full LoCoMo/LongMemEval tables published.
- **zilliztech/memsearch (2,777★)** — Markdown + Milvus persistent memory,
  optional Jev reranking, and "skills from memory": distills repeated
  workflows into installable skills — a third "procedural memory" layer.
  Storage: Markdown + Milvus. **Verdict: moderate** — the *skill distillation
  from repeated sessions* is lineage-shaped; the store is not.
- **Asymptote-Labs/agent-beacon (2,625★)** — captures session history across
  20+ harnesses, turns workflows/corrections/debugging patterns into reusable
  knowledge. **Verdict: moderate** — cross-session correction propagation is
  provenance-shaped; storage is theirs.
- **Avinash-jetwani/jevmem (130★)** — "say it once": saves decisions, rules
  and failed approaches from Claude Code chats as one line each in
  `JEVMEM.md`, Jev decides what is worth keeping, relevant lines injected
  next session. Honest numbers ("a hand-maintained CLAUDE.md did about as
  well: 67 of 72"). Storage: a flat file. **Verdict: flat storage,
  relationship-shaped content** — decisions, rules, and failed approaches
  are exactly the provenance vocabulary; nobody joins them yet.

### (c) Ledgers and caches — judgment provenance, commercialized

- **qkal/Canny (126★)** — supervision layer for coding agents: append-only
  ledger of what the agent actually did; "Facts go to code. Judgments go to
  Jev. **Only facts can block**"; Jev never blocks; `canny replay` proves
  the same session produces the same verdict from the ledger. **Verdict:
  the session ledger is a real append-only provenance store; results are
  replayable. Moderate-to-good fit** — and the sharpest governance rule in
  the corpus.
- **hyperspaceai/jevcache (78★)** — "**The decision ledger for Jev-class
  models**": a decision is (approximately) a pure function of
  (model, schema, state), therefore memoizable; append-only log + in-memory
  map; state redacted and canonicalized before hashing (PII and volatile
  fields never enter the key); deterministic CI replay to catch model drift;
  Rust and TS implementations share byte-identical fingerprints; a hosted
  "commons." **Verdict: this is the prior audit's judgment-ledger candidate,
  already built, minus the graph.** The cache keys *are* content addresses;
  what's missing is the graph over them (which decisions derived from
  which, which flipped under which model version).

### (d) Documents, libraries, assemblies — trees and connectors

- **extend-hq/jevbox (738★)** — permission-aware document library: document
  trees, parsed output, folder hierarchy searched with Jev, source-grounded
  questions with inline citations. **Verdict: moderate** — the hierarchy is
  a tree walked by decision; permissions are an overlay nobody queries
  relationally.
- **jerryjliu/docjev (536★)** — classification and *splitting* of PDF
  packets into ordered component documents with page ranges. Flat per
  page; the split is a sequence. **Verdict: flat.**
- **kyotofin/tax-doc-classifier (512★)** — 261 IRS forms as a JSON criteria
  file; $0.001/page. **Verdict: flat, and the best cost story in the
  corpus.**
- **anteloc/ldraw-nova (467★)** — LEGO models with an AI agent: "ordinary
  JSON plans and LDraw parts; the tools find parts and reference
  constructions, generate editable MPDs, check geometry, render previews and
  compare parts lists"; a manifest ties artifacts to the model revision.
  **Verdict: good fit** — parts with connector metadata and reference
  constructions are an assembly graph; the manifest is provenance; BOM
  comparison is a set-over-relations result. Small project, real shape.
- **ttlequals0/MinusPod (493★)** — self-hosted podcast ad removal:
  transcribes locally, detects ad segments, and "**builds cross-episode ad
  patterns from your corrections so repeat sponsors get caught without
  re-asking the LLM**." **Verdict: moderate** — a sponsor→episode→segment
  pattern graph learned from corrections; domestic, real, unpitched.
- **MCG-NJU/VideoJev (235★)** — academic (arXiv 2610.18615): temporal
  grounding + multiple-choice video QA by direct candidate scoring. Temporal
  grounding = interval decisions over video. **Verdict: flat-ish** (intervals
  over a single stream), but a lab-scale proof the decision-model pattern
  extends to video.

### (e) Skills, routing, semantic search — the head's center of mass (flat)

- **kitze/skillbox (272★)** — self-hosted, **versioned** skills library,
  MCP, optional Jev recommendations. Versioned skills = the README's
  skills-as-graphs idea wearing a file store. Moderate.
- **Dicklesworthstone/skillranker (136★)** — Rust CLI: Jev evaluates live
  session context against available skills, estimates fit for the next
  step. Flat candidate ranking.
- **dzhng/jevgrep (2,849★)** — "find code by asking what it does"; Jev
  judges relevance across folders → files → declarations; 8-of-10
  SWE-bench tasks at ~30% lower cost. The family: jgrep (keltokhy), jegrep
  (can1357), kyu1204/jgrep, nassim-arifette/jevgrep, ellipsis-dev/blink
  (100★), ajbmachon/jev-navigator, XERJ. **Verdict: flat as a search
  result — but the walk is a hierarchy scored level by level**, the same
  graph-walking pattern as bible-jev-climb in a code costume.
- **uehaj/sys1grep (150★)** — grep by meaning; per-line noul with
  threshold; meanings combine with AND/OR/NOT. Flat.
- Routers/compaction/guards: **jev-router (618★), jev-gateway (321★),
  jev-pruner (165★), jev-guard (118★), winnow (115★), quicksilver (125★),
  hermes-jev-skills (1,150★)** — the coding-agent cost layer, all flat by
  design. Kill-or-ship toys: **monteduro/killmyidea (268★)** — 8 scored
  questions → KILL/FIX/SHIP. Flat.
- **mrnugget/jev-shell-history (120★)** — fish-style zsh autosuggestions:
  Jev ranks your last 100 distinct history entries. Flat, charming.
- **socai-io/jev-social (174★)** — browser-grounded social research:
  Instagram/TikTok/LinkedIn → source-cited reports; Jev chooses each next
  operation (search, open this post/profile, read comments, finish), socai
  CLI executes in your real Chrome; 64-second example report with TikTok
  video evidence. **Verdict: representation is the social platform's own
  graph, walked operation-by-operation; results are source-cited. Good
  fit as a *walk*; the store is the platform's, not yours.**

### (f) The chat-assistant family — the corpus's most popular consumer app, and the big surprise of the head

Chinese-language, cross-platform, and huge:

- **jev-chat/jev-chat-jarvis (7,997★)** — "read them first, then reply":
  Jev works out what the other person means, how risky the moment is, and
  how to respond; drafts replies you fill in with one tap; sending is always
  yours. Windows/macOS/Android/iOS (+ jev-chat-windows 842★, -mac 509★,
  -ios 54★), sponsored by Bocha. Per-message judgments; no per-contact
  state. **Verdict: flat per message — the flagship consumer app of the
  entire JEV world is a message judge, and it doesn't remember anything.**
- **shengjidaguai-china/goutoujunshi-jev-chat (492★)** — the same idea plus
  the missing piece: "**带上关系背景**" — suggestions conditioned on the
  *current contact, the relationship stage, and the communication goal*;
  chat-CSV import renders "K线" (candlestick charts) of message direction.
  **Verdict: moderate — per-contact relationship state exists as authored
  context, not as a store; the representation (contacts, stages,
  conversation trajectories) is relationship-shaped.**
- **FerryCorleone/crush-monitor (311★)** — "Crush 好感监控器": WeChat-style
  bubbles, per-message emotion (12 classes) and intent (35 classes) tags,
  an affection score, **your own replies graded SSS→D**, longitudinal
  (analyzed content persists locally; repeat segments deduplicated; long
  records auto-batched). Includes the most honest disclaimer in the corpus
  ("AI doesn't know how you two get along in real life… treat it as
  reference"). **Verdict: moderate** — a longitudinal per-relationship
  judgment trail in browser-local storage; the queries ("how did my reply
  grades trend as the affection score moved") are time-joined — nobody can
  run them today.
- **Nisaka520/JevIntent (71★)**, **Liyucheng1997/332_lab-jev-chat (170★)** —
  the same family lower down.

The head thus **upgrades the tail report's dating/social verdict from
"flat, drop" to "flat today, with the two most popular consumer apps in the
corpus sitting on un-built relationship state**" — per-contact stages,
longitudinal reply grades, message-direction trajectories. Representation:
yes. Storage: no. Results: yes (graded, trended). This is a real README
candidate: *the relationship journal as a graph* — every conversation a
thread, every judgment a timestamped edge, every reply grade a property;
queries no flat store can answer.

### (g) Robotics/embodied — the head has a big one the tail only hinted at

**RomanSlack/jev-drone (282★)** — camera-only autonomous drone in MuJoCo
with Jev in the loop at 2.5 Hz; **YongLD/Multi-UAV-JEV (106★)** — multi-UAV
*pursuit* (multiple agents coordinating); **Dimweaker/jev-libero (83★)** —
fine-grained robot control over LIBERO tasks; **lykycy123/RoboJEV (61★)** —
Franka Panda two-stage control; **benmagnifico/DriveJev (96★)** — a System I
model for autonomous driving; **embodied-jev (320★)** — MuJoCo workbench;
**standardagents/jevpilot (227★)** — playable Three.js driving sim with
Jev autopilot; **quackd (269★)** — multi-robot goal-driving with a Jev
stepper. Plus **uu889/laya-opencv (58★)** — a local workbench that *trains
your own* decision model ("open-source JEV") and pairs OpenCV measurement
pipelines (steel-pipe QC, fruit picking, weed/pest monitoring) with hard
numeric rules feeding text-judgment models —
`image → OpenCV measure → numeric layer as text → decision model →
cross-check`. **Verdict: flat decision layers over simulators** (corroborates
World-Model Storage), **with multi-agent pursuit (Multi-UAV-JEV) as the one
genuinely relational member** — N pursuers vs one evader is a small dynamic
social graph.

## 4. The verdict table (head tier)

| Cluster | Storage | Representation | Results | Verdict |
| --- | --- | --- | --- | --- |
| Open replicas/runtimes (laya, tev1, jeeves, von, ollaya…) | n/a | n/a | n/a | Model infra — not for us |
| Coding-agent cost layer (routers, compaction, guards) | flat | flat | flat | Flat, by design |
| Decisions-as-SQL (pg-jev family) | none (stateless) | rows | scored rows | Flat — but the key precedent for InstantCypher |
| Memory engines (Jev-Mem, NylonME, memsearch, beacon, jevmem) | custom engines / MD + Milvus | **multi-relational (semantic/temporal/causal/entity)** | activated sets | **Strong — the head's graph-native core** |
| Decision ledgers/caches (jevcache, Canny) | append-only logs, content-hash keys | decisions + provenance | replay, drift detection | **Strong** — built, minus the graph |
| Documents (jevbox, docjev, tax-doc) | DB/JSON | trees, page sequences | cited sets | Moderate to flat |
| Assemblies (ldraw-nova, MinusPod) | JSON plans, patterns | **parts+connectors; sponsor+episode** | BOM comparison, ad patterns | **Good** — small, real |
| Semantic code search (jevgrep family) | repo | hierarchy walked | ranked files | Flat result, graph-shaped walk |
| Chat assistants (jev-chat family, goutoujunshi, crush-monitor) | browser-local / none | **relationships, stages, trajectories** | graded replies, trends | **Moderate — representation without storage** |
| Social research (jev-social) | platform's | platform graph walked | cited reports | Walk fit; store is theirs |
| Robotics (jev-drone, Multi-UAV, jevpilot, laya-opencv) | simulators | world (pursuit is social) | actions | Flat; Multi-UAV pursuit relational |
| Trading (QuantDinger, jev-trader, warrenduffer, beebots) | series | flat | picks | Flat |
| Games heads (mario, pokemon, minecraft-agent) | emulator | world model | branch picks | Corroborates World-Model Storage |
| Research (jeeves, VideoJev, tev1, Jev-Mem) | datasets | varies | benchmarks | Jev-Mem aside: flat |

## 5. Head vs tail — what the popular projects do that the weird ones don't

1. **The head is infrastructure; the tail is applications.** Routers,
   compaction, caches, replicas, runtimes, SDKs dominate by count. The head
   converges on ~8 archetypes with many competitors each (5+ semantic-grep
   CLIs, 10+ routers, 15+ replicas); the tail is one-author-one-idea.
2. **The head has companies and labs**: Zilliz (memsearch, vector-graph-rag),
   Together (tev1, "train your own Jev for $17"), PostHog (jeeves), Tencent
   (jev-holdem from the tail report), Extend, Vonage, 1Panel, jerryjliu
   (LlamaIndex), kitze, realZachi. The tail is individuals.
3. **The head invented decision *caching and drift detection*** (jevcache's
   memoization + CI replay; jev4pg's evidence caching with source/evaluator
   identity) — the tail invents receipts and pre-registration. The ledger
   idea exists at both ends in different clothes: the tail's
   "the log is the seed; the graph grows from it" (jev-semantic) vs the
   head's "decisions are pure functions, memoize them" (jevcache). Same
   insight, no graph engine on either side.
4. **The head's storage is heavier**: Postgres, Milvus, Markdown+vector,
   S3, SQLite WAL. The tail's is JSONL and ad-hoc JSON — the tail *would*
   benefit from an embedded store sooner; the head has already picked its
   substrate (and it's Milvus + Markdown, or Postgres).
5. **The most popular consumer application class in the whole corpus is
   Chinese chat-assistants** (jev-chat-jarvis at 7,997★ is #7 overall) —
   relationship reading, longitudinal grading, per-contact context. The
   English-language awesome lists barely index it (usejev.dev explicitly
   lists no dating/relationship entries). Both halves of the audit found
   the same blind spot from opposite directions.
6. **Zilliz's vector-graph-rag (259★) is the graph world's direct
   competitor signal**: "Graph RAG with pure vector search — **no graph
   database needed**" — multi-hop QA by encoding entities and relations as
   vectors with two-stage Jev scoring, explicitly positioned against Neo4j.
   The GraphRAG+Jev lane is real and hot (corroborates the prior audit's
   candidate), but the head's preferred substrate for it is a vector DB,
   not a graph. An embedded graph engine's pitch there has to beat
   "vectors already gave me multi-hop."

## 6. Corroboration / contradiction of the stress-tested candidates

1. **InstantCypher (decisions → deterministic Cypher)** — **strongly
   corroborated, with a reference implementation to cite**: pg-jev (1,209★)
   is plain-language predicates as composable SQL operators; jev4pg (257★)
   is 41 operators + evidence caching + a self-developing semantic layer;
   pg_typesafe (84★); plus the DuckDB-UDF and inlined-SQL-join experiments.
   The head chose SQL and built it three times. The Cypher lane is still
   empty — and the graph twist (schema as navigable option graph) remains
   unclaimed. **One tension to state honestly**: vector-graph-rag's "no
   graph database needed" positioning shows the market's default pull is
   away from graph engines for retrieval.
2. **Pre-baked strategy graph as shipped artifact** — **partially
   corroborated at the head**: skillbox's *versioned* skills library,
   memsearch's "skills from memory" (distills repeated workflows into
   installable skills — distillation of walks into artifacts, the head
   version of dungeon-jev's weight-baking), jev4pg's reviewed-definitions
   semantic layer. Versioning exists; no one ships a walkable portable
   graph yet.
3. **Judgment ledger** — **strongest corroboration yet**: jevcache calls
   itself "the decision ledger for Jev-class models," content-addresses
   decisions over PII-redacted canonical state, replays deterministically
   in CI to catch drift, and cross-ships fingerprints between Rust and TS.
   Canny: append-only session ledger, "only facts can block," replay from
   the ledger. jevmem: JEVMEM.md as a human-readable judgment ledger.
   contextgem: every extracted fact traced to its source line. The ledger
   is now commercial at three levels (cache, supervision, extraction) —
   **none of them join or traverse their ledgers**; that's the embedded
   graph opening, verbatim.
4. **Confidence-gated entity resolution** — still no head-tier evidence
   either way (nothing in the 545-repo head does ER). Unchanged.
5. **Graph-walking agent cursor** — **corroborated with two new instances**:
   jev-social (Jev picks each next operation over real Instagram/TikTok/
   LinkedIn graphs, grounded in your own browser, source-cited reports),
   and the jevgrep family (folder→file→declaration relevance walked level
   by level — 2,849★ for the flagship). Plus jexp/neo4jev (180★) already
   covered. The pattern now has head-scale stars behind it.

## 7. Head-tier candidates for the README (report only)

1. **Multi-relational agent memory on an embedded graph engine.** Jev-Mem
   (arXiv 2609.23986, 229★) needs retrieval over semantic, temporal, causal
   and entity relations; NylonME (53★) builds a mesh memory graph with
   spreading activation and tension forgetting from scratch; memsearch
   (2,777★) is Markdown + Milvus. The head's memory cluster is re-inventing
   a property graph with traversal, edge weights and time decay, per repo.
   Honest fit: **strong** — this is Agent Infrastructure, adjacent to but
   more specific than the README's existing memory entries; the citable
   anchor is a published paper.
2. **The relationship journal as a graph.** The corpus's #7 repo
   (jev-chat-jarvis, 7,997★) and its family judge conversations but forget
   everything; goutoujunshi (492★) and crush-monitor (311★) already
   condition on relationship stage and grade replies longitudinally in
   browser-local storage. A per-contact graph — conversations as threads,
   judgments as timestamped edges, reply grades and stage transitions as
   properties — with queries no flat store answers ("did my reply grades
   move with the affection score"). Honest fit: **moderate-to-good**;
   representation and results are there, nobody builds the store. Fun,
   unpitched, and the flagship's biggest missing feature.
3. **The decision cache as a queryable judgment graph.** jevcache (78★)
   content-addresses decisions; Canny (126★) appends session facts; both
   replay but neither joins. One store that keeps the ledgers *and* the
   derivation edges (which decision informed which, which flipped under
   which model version) turns drift analysis into traversal. Honest fit:
   **strong** — and this is the judgment-ledger candidate with the head's
   own products as lineage, not just the tail's.
4. **LEGO assembly graphs.** ldraw-nova (467★): parts + connector metadata
   + reference constructions + geometry checks + a provenance manifest
   tying artifacts to the model revision. An embedded graph of parts and
   connections with BOM-diff queries. Honest fit: **good**, small, charming
   — the README already has tech trees; this is the physical-toy cousin.
5. **Sponsor graphs for podcasts.** MinusPod (493★): corrections teach
   cross-episode ad patterns so repeat sponsors are caught without another
   LLM call. Honest fit: **moderate** — a small sponsor→episode→segment
   pattern store; domestic and real, but small.
6. **Browser-grounded social-media walks.** jev-social (174★) — Jev picks
   the next operation over the platform's real graph, every report
   source-cited. Honest fit: **moderate** — the walk is the pattern (the
   graph-walking cursor), the store belongs to the platform; a local
   capture of the walk (who/what/where cited) is the graph artifact.

## Sources

GitHub repository search (star thresholds and sorted queries in §1, sampled
2026-10-23). READMEs read in full or in part this pass:
https://github.com/realZachi/pg-jev · https://github.com/Sheltercosmo/jev4pg ·
https://github.com/giuliosmall/pg_typesafe · https://github.com/libingzheren/Jev-Mem ·
https://github.com/nylon-memory/NylonME · https://github.com/zilliztech/memsearch ·
https://github.com/Asymptote-Labs/agent-beacon · https://github.com/Avinash-jetwani/jevmem ·
https://github.com/qkal/Canny · https://github.com/hyperspaceai/jevcache ·
https://github.com/zilliztech/vector-graph-rag · https://github.com/extend-hq/jevbox ·
https://github.com/jerryjliu/docjev · https://github.com/kyotofin/tax-doc-classifier ·
https://github.com/anteloc/ldraw-nova · https://github.com/ttlequals0/MinusPod ·
https://github.com/MCG-NJU/VideoJev · https://github.com/kitze/skillbox ·
https://github.com/Dicklesworthstone/skillranker · https://github.com/dzhng/jevgrep ·
https://github.com/uehaj/sys1grep · https://github.com/monteduro/killmyidea ·
https://github.com/mrnugget/jev-shell-history · https://github.com/socai-io/jev-social ·
https://github.com/jev-chat/jev-chat-jarvis ·
https://github.com/shengjidaguai-china/goutoujunshi-jev-chat ·
https://github.com/FerryCorleone/crush-monitor · https://github.com/PostHog/jeeves ·
https://github.com/togethercomputer/tev1 · https://github.com/shcherbak-ai/contextgem ·
https://github.com/RomanSlack/jev-drone · https://github.com/YongLD/Multi-UAV-JEV ·
https://github.com/uu889/laya-opencv · https://github.com/standardagents/jevpilot ·
https://github.com/thruwire/foreman · https://github.com/YaoApp/yao ·
https://github.com/fhshaik/typesafe-mario · https://github.com/sac-Y/Jev-cu
