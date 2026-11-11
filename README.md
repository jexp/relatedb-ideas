---
type: Vault
name: README
---

# RelateDB Ideas

> A curated collection of things you can build with [RelateDB](https://relatedb.ai) —
> the embedded, in-memory property graph engine that speaks Cypher, ships as a single binary,
> runs in the browser (WASM), on phones and edge devices, persists to a WAL + Parquet checkpoint,
> and serves Bolt / HTTP / MCP / stdio from one process.

**You don't need a server. You don't need a cluster. You need a graph.**

Every idea below fits RelateDB's shape: embedded (link it, ship it, `:memory:` it),
portable (one file or one folder moves the whole graph), interactive (Cypher at CLI,
HTTP, Bolt, MCP — from a laptop, a phone, a browser tab, an agent sandbox), and
fast (in-memory scans, no round trips).

Have you built something? PRs welcome — pick the closest category, or open a new one.

---

## This Repo Is a Graph Database

The markdown files in this repository *are* a Relate store — [RelateDB](https://relatedb.ai), source at [github.com/relatedb/relate](https://github.com/relatedb/relate). Install the single binary, then open the repo root as a markdown-vault database:

```bash
curl -sSfL https://relatedb.ai/install.sh | bash
relate --snapshot-format markdown --markdown-body-properties text --database .
```

The first open records both settings in `.cypherlite/manifest.json` (gitignored — re-derivable), so later opens need neither flag. From then on you query and edit the vault in Cypher, and changes checkpoint back into the markdown files.

Codec rules (markdown-vault snapshot format, ADR-0406 / ADR-0460):

- **Label = top-level folder.** `Project/`, `Research/`, `Technology/`, `Company/`, `Person/`, `Category/` are the node labels. Root-level `.md` files (this README, `PLAN.md`) get the reserved `:Vault` label.
- **Key = filename.** `Project/arrows-on-relate.md` is the node `(:Project {name: 'arrows-on-relate'})`.
- **Frontmatter = properties.** `type:` is the primary label; every other key is a node property.
- **Body = the `text` property.** The `--markdown-body-properties text` flag makes the note body the node's `text` property.
- **Relationships = wikilink lists.** One frontmatter key per relationship type:

  ```yaml
  USES_TECH:
    - "[[Technology/Arrow]]"
    - "[[Technology/Parquet]]"
  ```

  Relationships that carry data use the map form — `target` plus properties:

  ```yaml
  RELATED_IDEA:
    - kind: complements
      reason: the human-app form factor over the same on-device store
      target: "[[Project/phone-app-shell]]"
  ```

Hand-edits to the files re-ingest at the next open; Cypher writes re-render the files at checkpoint. Deleting a node deletes its file *and* the wikilinks pointing at it (prose mentions stay). Labels and keys compare case-insensitively — a case-only rename is a no-op that corrupts, so rename folders, not labels.

The schema is versioned in [`vault-schema.cypher`](vault-schema.cypher); enrichment history and entity counts are in [`PLAN.md`](PLAN.md). The vault keeps entities that are linked at least twice; the full unpruned entity set (436 Technology, 218 Company, 79 Person files) lives in this repo's **first commit** — `git checkout $(git rev-list --max-parents=0 HEAD) -- Technology/ Company/ Person/` restores any of it.

---

## Contents

1. [Learn & Teach](#learn--teach) — network science, tech trees, direct-manipulation graphs
2. [Investigate & Expose](#investigate--expose) — journalism, ownership rings, crypto flows, lobbying networks
3. [Your Digital Life as a Graph](#your-digital-life-as-a-graph) — social, home, routes, wearables
4. [Software & Code Intelligence](#software--code-intelligence) — code graphs, architecture, design analytics
5. [Cybersecurity](#cybersecurity) — attack paths, forensics, supply chains
6. [Agent Infrastructure](#agent-infrastructure) — memory, DAG runtimes, traces, skills-as-graphs
7. [Science & Humanities](#science--humanities) — tree of life, proteins, citations, museums, WordNet
8. [Narratives & Fandom](#narratives--fandom) — books to graphs, character networks
9. [Wikis, Knowledge & Semantic Web](#wikis-knowledge--semantic-web) — Wikipedia, RDF/JSON-LD, Obsidian-as-VFS
10. [Maps & the Physical World](#maps--the-physical-world) — OpenStreetMap, GIS, shipping, robots, VR
11. [Data Transformation & Import](#data-transformation--import) — CSV/Parquet/Kaggle/HF → graph, sitemaps, matrices
12. [Interop, Sync & Distribution](#interop-sync--distribution) — clone/fork/push, single-file graphs, other databases
13. [Visualization & Rendering](#visualization--rendering) — million-node browsers, Mermaid, GraphGists reborn
14. [Meta: Graphs about Graphs](#meta-graphs-about-graphs) — plans, tiny neural nets, path indexes

---

## Learn & Teach

*(one file per idea: [Project/](Project/))*

- **[Network Science, Interactive](Project/network-science-interactive.md)** — Barabási's course and textbook as a live sandbox:
  generate BA/WS/ER graphs, watch degree distributions emerge, overlay centrality heat —
  every exercise runs as Cypher in the browser, no install.
- **[Graph School](Project/graph-school.md)** — a browser-based playground where students load canonical graphs
  (Karate Club, Les Misérables, C. Elegans) and write their first Cypher against them.
- **[Tech Trees](Project/tech-trees.md)** — civilization/tech/research trees as explorable graphs; zoom from
  the whole game to one branch, query prerequisites ("which techs unlock X within 2 steps?").
- **[History as Graph](Project/history-as-graph.md)** — timelines of dynasties, wars, treaties and successions as
  property graphs; query "who was related to whom at the outbreak of WWI?".
- **[Direct-Manipulation Graph Editor](Project/direct-manipulation-graph-editor.md)** — drag nodes, draw relationships, edit properties
  in-place; every gesture is a Cypher write under the hood. Undo = query log replay.
- **[Node2Vec, Rebuilt](Project/node2vec-rebuilt.md)** — random walks as
  sentences, sentences as embeddings: walk paths through the graph, encode
  them with a language model into topological/structural vectors — the
  node2vec/path2vec pattern (and the GraphSAGE/GNN family) reproduced on an
  engine where the walks are plain Cypher.
- **[SQL vs. Cypher, Live](Project/sql-vs-cypher-live.md)** — the Gremlin
  "SQL vs. Gremlin" cheat-sheet tradition (the same comparison exists as
  the Neo4j [Cypher vs. SQL docs page](https://neo4j.com/docs/getting-started/cypher/cypher-sql/)),
  rebuilt as a live browser page: DuckDB-WASM and RelateDB side by side,
  the same question answered in both languages, both engines running in the tab.
- **[InstantCypher](Project/instantcypher.md)** — plain-language questions compiled to *deterministic, inspectable*
  Cypher by a decision oracle choosing against the real schema as its option set — the pattern the SQL world
  built three times (IntentSQL, JevQL, pg-jev), in its confirmed empty lane: the graph one. The oracle is never
  a built-in: post-processing and judgment materialization first, host-registered callables eventually.
- **[The Original Search-Index Experiment](Project/the-original-search-index-experiment.md)** — recreate the founding PageRank/backlink
  experiment: crawl a web neighborhood (or load a web-graph dataset), build the link
  graph, compute ranking with plain Cypher iterations — and watch the orderings
  emerge, exactly as the 1998 experiment did, but interactively in your browser.
- **[WordNet, But Queryable](Project/wordnet-but-queryable.md)** — the synset/hypernym graph loaded into RelateDB;
  "shortest path from *dog* to *distrust*" as a party trick and a linguistics tool.
- **[Classroom Server on a $35 Board](Project/classroom-server-on-a-35-board.md)** — a Raspberry Pi + `relate serve` gives a whole
  classroom a shared graph database each. Zero setup for the students.
- **[Shell-Native Cypher](Project/shell-native-cypher.md)** — the Unix-filter form factor: `.cl` on stdin, filtered output on
  stdout, `tail -f | relate`, and a TUI REPL — every interaction an ad-hoc program, pipes included.
- **[The Low-Resource Kit](Project/the-low-resource-kit.md)** — the hand-me-down laptop and the locked-down library terminal as
  first-class targets: WASM engine + datasets inside tens of MB, an old-browser floor — the graph stack that runs where the hardware poverty is.

## Investigate & Expose

*(one file per idea: [Project/](Project/))*

- **[ICIJ in a Browser Tab](Project/icij-in-a-browser-tab.md)** — Offshore/Panama-style ownership networks as a single
  shareable `.cl` file; investigators open the file, no database, no install.
  **Datashare, embedded:** ICIJ integrated Neo4j into their local Datashare
  investigation tool — RelateDB is the no-server local option for the same
  workflow, per-journalist, offline.
- **[Policy-Impact Knowledge Graphs](Project/policy-impact-knowledge-graphs.md)** — the evidence graph *behind* a
  policy: housing rules, carbon regulations, grievance systems — with every impact edge carrying its mechanism,
  its studies, and the model version that judged it. "Who is modeled to be affected, through which channel, on
  what evidence" as a traversal; staleness and contested assumptions as review queries.
- **[Company Ownership Rings](Project/company-ownership-rings.md)** — load a company register (CSV from any disclosure
  portal) and query control through layers of shell companies in one Cypher hop.
- **[Crypto Flow Forensics](Project/crypto-flow-forensics.md)** — import a slice of Bitcoin/Ethereum transactions around
  a wallet; trace laundering paths, cluster mixing services, follow the money —
  offline, on the analyst's laptop.
- **[Lobbying & Lawmaking Networks](Project/lobbying-and-lawmaking-networks.md)** — bills ↔ lobbyists ↔ agencies ↔ votes;
  "who influenced this clause?" as a graph query over public data.
- **[Conflict-of-Interest Finder](Project/conflict-of-interest-finder.md)** — join two public registers (research funding +
  guideline authors) and run one query; the story is the intersection.
- **[Sanctions & Supply-Chain Screening](Project/sanctions-and-supply-chain-screening.md)** — keep an embargo/ownership graph locally,
  screen counterparties without sending sensitive names to any cloud.

## Your Digital Life as a Graph

*(one file per idea: [Project/](Project/))*

  Data: [OpenSanctions](https://www.opensanctions.org/) — the open
  embargo/sanctions/PEP corpus, with existing Neo4j import examples as the
  loader lineage.
- **[Aleph in a Journalist's Pocket](Project/aleph-in-a-journalists-pocket.md)** —
  OCCRP's Aleph — now open-sourced as [OpenAleph](https://github.com/alephdata/aleph)
  — is the investigative platform: documents, entities, cross-search. The
  embedded play: its data layer beside a local RelateDB for the
  no-server investigator workflow.
- **[Cy — Your Personal Knowledge Graph](Project/cy-your-personal-knowledge-graph.md)** — the Amazon-Quick-style clone: pull your
  Google/MS Workspace, Slack/Teams, Confluence, email and calendar into one knowledge
  graph that serves *you and your agents* — knowledge work and white-collar tasks over
  your own data, queried in Cypher, surfaced to agents over MCP, private by default.
- **[Your Follow Graph](Project/your-follow-graph.md)** — a browser plugin exports your (and friends', opt-in)
  follower/following graphs; explore 1st/2nd-degree neighborhoods, find bridges
  between communities — all locally.
- **[Home Network Atlas](Project/home-network-atlas.md)** — every device, service, port and VLAN in your LAN as a
  graph; query blast radius ("what can reach the camera?") when something misbehaves.
- **[Smart-Home State Graph](Project/smart-home-state-graph.md)** — HomeAssistant/MQTT events into a temporal property
  graph; "who turned the lights on at 3am and what triggered it" is a path query.
- **[Local Route Brain](Project/local-route-brain.md)** — transit networks (GTFS!) or GPX trail networks on your phone;
  offline routing + "rides like this" recommendations from your own history.
- **[Running/Cycling/Hiking Graph](Project/running-cycling-hiking-graph.md)** — your tracked activities as a graph of segments
  and climbs; query personal records as shortest-times per edge.
- **[Friendship Archipelago](Project/friendship-archipelago.md)** — merge address book, chats and calendar into one
  personal-graph file — the "personal CRM" with an actual query language.

## Software & Code Intelligence

*(one file per idea: [Project/](Project/))*

- **[Code Graph](Project/code-graph.md)** — parse a repo (tree-sitter) into functions/calls/imports; ask
  "what breaks if I delete this function?" — reachability in Cypher, on your disk.
  *Lineage: jQAssistant (the OG — a Neo4j-backed code graph from 2013), Sourcegraph,
  CodeGraphContext, Graphicle — which already has a RelateDB port.*
- **[Architecture Diagram That Never Lies](Project/architecture-diagram-that-never-lies.md)** — services, tables, topics and jobs from
  real configs (k8s manifests, terraform, docker-compose) into one graph; the
  diagram is a *view*, the graph is the truth.
- **[Software Design X-Rays](Project/software-design-x-rays.md)** — Adam Tornhill's method on a WAL-backed temporal
  graph: churn (from git history) × complexity per file; hotspots are one query,
  the trend line is a time-window replay. CodeScene's behavioral analytics —
  summed per module — without the SaaS.
- **[Code Cities](Project/code-cities.md)** — the city metaphor rendered from a live graph: buildings are
  files, districts are modules, height is complexity, decay is churn. Walk your
  own codebase as a city, in a browser tab.
- **[Query-Plan Lab](Project/query-plan-lab.md)** — collect `EXPLAIN` trees from every tool in your org into one
  graph; find the plan patterns that correlate with incidents.
- **[Software Analytics Sandbox](Project/software-analytics-sandbox.md)** — GitHub Archive (GH Events) subsets as graphs;
  bus-factor, orphaned modules, coordination bottlenecks — reproducible, in one file.
- **[Software's Graph Formats](Project/softwares-graph-formats.md)** — the whole
  software stack already ships graphs: GraalVM's graph-shaped output format
  (loadable, parseable), Java heap snapshots, static class graphs, call
  graphs, dynamic traces in OpenTelemetry/OpenInference — one loader family,
  every layer of the machine queryable.
- **[Architecture Graphs in Production](Project/architecture-graphs-in-production.md)** —
  the case studies that proved the pattern: [Amadeus](https://www.youtube.com/watch?v=F1bWm_puNjQ),
  the [Financial Times' field guide](https://neo4j.com/videos/a-field-guide-to-the-financial-times-rhys-evans-financial-times/),
  [Lending Club's fabric of devops](https://neo4j.com/blog/cypher-and-gql/fabric-of-devops-using-neo4j-to-manage-site-infrastructure/),
  [Lyft's Amundsen and Cartography](https://eng.lyft.com/amundsen-lyfts-data-discovery-metadata-engine-62d27254fbb9),
  and the [data-discovery generation at Airbnb et al](https://towardsdatascience.com/how-linkedin-uber-lyft-airbnb-and-netflix-are-solving-data-management-and-discovery-for-machine-9b79ee9184bb)
  — rebuilt embedded, per team, from their own infra.
- **[Transitive Dependency Networks](Project/transitive-dependency-networks.md)** —
  the deps.dev shape: every package ecosystem's transitive graph as one
  store — licenses, maintainers, versions, vulnerabilities (the author's own
  deps.dev example from this week as the seed).
- **[The Compiler's Sea of Nodes](Project/the-compilers-sea-of-nodes.md)** — modern
  compilers are graph optimizers: raw code becomes parse graphs become
  expression graphs, iteratively deconstructed, reconstructed, optimized, and
  validated (the GraalVM sea-of-nodes IR — Thomas Würthinger's thesis
  publications). Store IR snapshots per pass; query why an optimization
  applied here and not there; diff passes; the compiler's decisions as
  analyzable graph history.
- **[Migration Planner](Project/migration-planner.md)** — before a framework jump, query every usage of the old API
  across repos; the migration backlog writes itself as a Cypher result.

## Cybersecurity

*(one file per idea: [Project/](Project/))*

- **[Attack-Path Simulator](Project/attack-path-simulator.md)** — MITRE ATT&CK techniques + your asset inventory;
  purple-team drills as graph queries, red-team findings as paths.
- **[Cyber Range Replayer](Project/cyber-range-replayer.md)** — turn network/netflow logs into a temporal graph and
  replay an incident like a movie; scrub the timeline with the mouse.
- **[Dependency Radar](Project/dependency-radar.md)** — your lockfiles as a graph; CVE news arrives, one query
  tells you if you're exposed and through which path (SBOM ↔ CVE ↔ your code).
- **[Configuration Misconvergence](Project/configuration-misconvergence.md)** — every service's effective config (env, flags,
  k8s overlays) diffed as a graph; "which two services disagree about TLS?".

## Agent Infrastructure

*(one file per idea: [Project/](Project/))*

> Graph-shaped storage is going on-device: Apple acquired Kuzu (the embedded graph
> database) to run graphs locally on its devices. The next question is what *local
> agents* should store in a graph — and the ideas below are the answers.

- **[On-Device Agent Graph Store](Project/on-device-agent-graph-store.md)** — the phone/watch/robot as the agent's graph home:
  personal facts, task state, device and sensor relationships, retrieved knowledge
  snapshots — the Apple/Kuzu-shaped niche for every other platform, in RelateDB.
- **[Graph-Native Agent Memory](Project/graph-native-agent-memory.md)** — a memory that is *only* a graph: episodes, entities,
  facts as nodes with timestamps; temporal queries ("what did we agree on before X?")
  are one hop, not RAG guesswork.
- **[LangGraph-Style DAG Store](Project/langgraph-style-dag-store.md)** — persist agent workflow state and checkpoints in
  RelateDB; time-travel debugging = jump to checkpoint node and re-run.
- **[Agent Trace Warehouse](Project/agent-trace-warehouse.md)** — spans, tool calls, prompts and costs as a temporal
  graph; "which retrieval step poisoned this answer?" is a path along the run.
- **[The Judgment Ledger](Project/the-judgment-ledger.md)** — every model call stored as an edge on the data it
  judged: provenance ("which facts rest only on sub-0.6-confidence calls?"), drift as a series, and
  decision-necessity receipts as queries — the corpus's consensus architecture (jevcache, Canny), finally
  joined and traversed.
- **[Ephemeral Agent Sandboxes](Project/ephemeral-agent-sandboxes.md)** — `:memory:` RelateDB as the scratch DB inside each
  agent execution; zero-provision, zero-cleanup, queries at memory speed.
- **[Skills as Graphs](Project/skills-as-graphs.md)** — ship an agent skill as a `.cl` file: instructions,
  examples and tools as nodes (the AIP paper's shape); the agent queries its own skill.
- **[Agent Handoff Object](Project/agent-handoff-object.md)** — a session's context (conversation + extracted facts +
  retrieved artifacts) serialized as one graph file; resume anywhere, audit anytime.
- **[Crew Org Chart](Project/crew-org-chart.md)** — multi-agent teams as graphs of roles, tools and permissions;
  "who may call what with which budget" is a policy query, not a config file.
- **[Keyhive's Share Menu](Project/keyhive-share-menu.md)** — sharing as a capability: grants are nodes scoped
  to subgraph selections, checked with Cypher at the surface; the ACL rides inside the `.cl` file, and the same
  grants authorize the agents calling over MCP (the IndyKite Agent-Gateway problem, embedded).
- **[Tools as Graphs](Project/tools-as-graphs.md)** — an MCP toolset as a graph: typed data-dependency edges
  plus call sequences mined from agent traces; tool selection, sequencing, parallel-call batching, and
  code-mode composition as queries.
- **[The Graph-Walking Agent Cursor](Project/the-graph-walking-agent-cursor.md)** — `next_hop(node, goal)` as
  the MCP tool instead of `run_query`: the agent walks real edges, one typed choice at a time, context
  accumulating — hallucinated Cypher structurally impossible because the options came from the store.
- **[In-Browser Knowledge Extraction](Project/in-browser-knowledge-extraction.md)** — WASM RelateDB + web-llm: read a page,
  extract entities/relations locally, hand them to the graph — private, offline RAG.
- **[Agent CLI Ergonomics](Project/agent-cli-ergonomics.md)** — the binary as the agent's favorite tool: stable JSON shapes,
  exit codes as contracts, `describe` commands, and token-budgeted output modes — a CLI designed for the caller that pays per token.
- **[Chat-Native Queries](Project/chat-native-queries.md)** — the team's chat window as the query interface: a Slack/Discord/
  Telegram bot over the shared `.cl`; slash commands run stored queries, results render in-channel, and the channel is the access log.

## Science & Humanities

*(one file per idea: [Project/](Project/))*

- **[Tree of Life, Locally](Project/tree-of-life-locally.md)** — a phylogeny (e.g. Open Tree of Life subsets) as a graph;
  MRCA queries, clade pruning, trait overlays — for field work without signal.
- **[Connectome Explorer](Project/connectome-explorer.md)** — small-animal connectomes (C. Elegans to fly) as graphs;
  circuit-tracing queries for students, neuro classes, and papers.
- **[Protein Interaction Sandbox](Project/protein-interaction-sandbox.md)** — STRING/BIOSISDB slices; "which pathways does
  drug X touch within 2 hops" at local speed.
- **[The JupyterLite Kernel](Project/jupyterlite-kernel.md)** — RelateDB-WASM as a zero-install notebook kernel: Cypher
  cells in the browser, Arrow into Pyodide dataframes, NetworkX for the algorithm cells — the scientist's form factor,
  shareable as a URL.
- **[The Khipu Decoder](Project/khipu-decoder.md)** — Andean knotted cords, the 500-year-old graph storage medium, as
  property graphs: cords as edges, knots as typed payloads, the whole 600-artifact Open Khipu Repository corpus in one
  queryable tab — the accounting grammar as a query, narrative khipu as the open problem.
- **[The Isnad Engine](Project/isnad-engine.md)** — hadith transmission science (ilm al-rijāl, twelve centuries of
  narrator-reliability analysis) as a graph engine: chains of transmitters, per-narrator ratings, contemporaneity
  violation checks, and trust propagation as queries over a scholarship tradition that predates PageRank by a
  millennium.
- **[Harris Matrices, Properly](Project/harris-matrices-properly.md)** — archaeological stratigraphy *is* a directed
  graph (the Harris matrix, 1973): the excavation itself as a queryable store — contexts, superposition, cuts, phasing
  as path queries, and the dig's honest controversies as cycle detection.
- **[The Song Diffusion Network](Project/the-song-diffusion-network.md)** — culture in animals as a transmission graph:
  humpback whale song revolutions propagating population-to-population across the South Pacific, bird dialect
  boundaries — the missing-edge questions ("shared migratory corridor, never shared song") as queries.
- **[Climate Teleconnection Graphs](Project/climate-teleconnection-graphs.md)** — the climate network science field
  (correlation graphs over reanalysis grids: ENSO reach, monsoon couplings, blocking) with the query layer it never
  had: lag-labeled traversal, phase-scoped rewiring, regional cuts at laptop scale.
- **[Scripture Cross-Reference Navigation](Project/scripture-cross-reference-navigation.md)** — the Bible's 200k+
  typed cross-reference edges (free CC-BY corpora) as a portable navigation artifact: a hill-climb where the graph
  lists the options and an oracle only scores them — allusion chains, bidirectional parallels, and study walks with
  recorded provenance as queries.
- **[Citation Network of a Lifetime](Project/citation-network-of-a-lifetime.md)** — your Zotero/BibTeX library as a citation graph;
  "papers that cite everyone I cite, but that I don't" is one query.
- **[arXiv Wedge](Project/arxiv-wedge.md)** — pull a topic's arXiv metadata, build the co-citation graph,
  watch a field fragment into communities — reproducible, shareable as a file.
- **[The Codex, Reborn](Project/the-codex-reborn.md)** — an Atlas of History: events, locations, and people
  extracted from annotated historical sources (Iian Neill's project —
  [abandoned when Neo4j proved too heavy for it](https://blog.bruggen.com/2016/02/podcast-interview-with-iian-neill-codex.html)).
  The resurrection pitch writes itself: a single-file, zero-server graph is
  exactly what that project needed — the historiographical annotation layer as
  edges with source provenance on every relationship.
- **[The HNR Humanities Pack](Project/the-hnr-humanities-pack.md)** — the [Historical Network Research](https://historicalnetworkresearch.org/)
  community's world in one format: correspondence networks, prosopographies,
  place-name graphs, kinship and trade networks — lightweight humanities graphs
  (their conference contributions are full of them) as .cl files with shared
  importers and query packs.
- **[Museum as Graph](Project/museum-as-graph.md)** — artworks ↔ artists ↔ patrons ↔ movements ↔ thefts (if you
  must); a museum's collection file becomes a guided-tour generator.
- **[Music Genealogy](Project/music-genealogy.md)** — samples, covers, influences, band memberships; "is there a
  path from Bach to techno?" — yes, and the query proves it. Lineage: the
  MusicBrainz imports from Neo4j in Practice (Chris & Luanne's book) — the
  classic band/member/recording graph, now with WhoSampled/Discogs layering,
  embedded.
- **[Sports Dynamics](Project/sports-dynamics.md)** — passes as edges in a match graph (StatsBomb open data!);
  xT-style analyses with plain Cypher over event streams.
- **[Labanotation Playback](Project/labanotation-playback.md)** — dance scores as temporal graphs: Labanotation's
  movement columns as `(:Movement)` nodes scoped by body part and time-span, the repertoire's motifs and casting as
  queries, folk-dance preservation corpora as the pilot data — a company's whole repertoire as one `.cl` file.

## Narratives & Fandom

*(one file per idea: [Project/](Project/))*

- **[A Song of Ice and Fire, Queried](Project/a-song-of-ice-and-fire-queried.md)** — the "Network of Thrones" reimagined: character
  interactions per chapter as a temporal graph; who really is the protagonist?
  (Answer: Tyrion, still — the Math Horizons paper proved it.)
  *Lineage: Beveridge's Network of Thrones dataset, chapter-by-chapter edges.*
- **[Book NLP to Graph](Project/book-nlp-to-graph.md)** — local LLM extracts characters, mentions and sentiment into
  a graph; a literature class argues about the resulting structure.
- **[Fandom Atlas](Project/fandom-atlas.md)** — a fandom wiki (or all of them) into nodes and ships; fan
  theories tested by path queries ("has these two ever met on screen?").
- **[Every Character Network Ever](Project/every-character-network-ever.md)** — a template exercise: any book, script, or show
  into the character graph; the Cornell INFO-2040 genre, productized as a notebook.

## Wikis, Knowledge & Semantic Web

*(one file per idea: [Project/](Project/))*

- **[Wikipedia Wedge](Project/wikipedia-wedge.md)** — any article's link neighborhood as a graph file; "what
  does the article on *entropy* connect to that *information theory* doesn't?"
  *Lineage: Six Degrees of Wikipedia (sdow) — precomputed paths over ~6M pages.*
- **[The WikiGame, Powered by Real Data](Project/the-wikigame-powered-by-real-data.md)** — load a Wikipedia (sub)graph and play
  shortest-path games (Six-Degrees-style) against the actual article network;
  path hints, difficulty scoring, and "no dead-end articles" as query constraints.
- **[Wikidata Wedge for Research](Project/wikidata-wedge-for-research.md)** — pull a Wikidata topic slice (entities, claims,
  references) into a queryable graph; correlation-mining across fields, provenance
  checks on citations, all offline in one file.
- **[Wikipedia in Your Pocket](Project/wikipedia-in-your-pocket.md)** — offline (sub)graph keeps for mobile: download your
  article neighborhood before a flight, query it on the plane; the C ABI → mobile
  wrappers make the phone a first-class graph host.
- **[RDF Ontology Metagraph](Project/rdf-ontology-metagraph.md)** — load an OWL/RDF ontology into RelateDB and *query
  the ontology itself*: classes, properties, domains, restrictions as first-class
  nodes (the `system_ontologies` shape, done on purpose).
- **[JSON-LD Everywhere](Project/json-ld-everywhere.md)** — a page (or a whole crawl's) structured data into the
  graph; Schema.org markup was already a graph — now it's a queryable one.
- **[Obsidian/VFS Native](Project/obsidian-vfs-native.md)** — a VFS layer where markdown files *are* the storage:
  headings and links become nodes and relationships on open; your vault becomes
  a Cypher database without exporting anything.
- **[Wiki-as-a-File](Project/wiki-as-a-file.md)** — export a wiki (or its dump) to a single `.cl` file; a
  community ships its whole knowledge base as one attachment.

## Maps & the Physical World

*(one file per idea: [Project/](Project/))*

- **[OpenStreetMap Wedge](Project/openstreetmap-wedge.md)** — OSM PBF extract → nodes/ways/relations; a city's walkable
  graph in one file, isochrones and shortest paths in milliseconds.
- **[Graph Overlay on Leaflet/Mapbox](Project/graph-overlay-on-leaflet-mapbox.md)** — the graph holds truth; the map renders it;
  hover a street to see the Cypher behind it (and to edit it).
- **[Shipping & Airline Networks](Project/shipping-airline-networks.md)** — public schedules and AIS data as graphs;
  "how exposed is this route to this canal closing?" for ops classes and newsrooms.
  Heritage: the airline dataset in the neo4j-graph-examples — Kelvin
  Lawrence's air-routes graph, originally assembled for Gremlin and
  translated to Neo4j and GDS — is this idea's ready-made `.cl` import.
- **[Buildings are Graphs (BIM)](Project/buildings-are-graphs.md)** — Building Information Models in the open IFC
  format imported as graphs (walls, slabs, spaces, systems, crews, tasks) for
  topology analysis, clash and filter queries, and version-to-version model
  comparison. Heritage: Will Reynolds' topologicBIM work (Hoare Lea) —
  [LDAC 2020 presentation](https://linkedbuildingdata.net/ldac2020/files/presentations/LDAC2020_IND2_WillReynolds.pdf),
  [video](https://www.youtube.com/watch?v=OOihIxbo0dE); Ali Ismail's
  [ifcwebserver](https://github.com/ifcwebserver) and
  [IFC-to-graph thesis](https://tu-dresden.de/bu/bauingenieurwesen/cib/ressourcen/dateien/publikationen/Projekt-_Diplomarbeiten/Masterarbeit_Ahmed_Nahar_2017.pdf);
  the [Neo4j BIM thread](https://community.neo4j.com/t/connecting-neo4j-to-building-information-models/15983d).
- **[Molecules as Graphs](Project/molecules-as-graphs.md)** — chemical structures as the original graphs: atoms,
  bonds, reactions, and similarity as substructure queries (the cheminformatics
  world — RDKit's lineage — where "graph query" has meant substructure match
  for a century).
- **[Power/Water Grid Twins](Project/power-water-grid-twins.md)** — public grid topology as a graph; cascading-failure
  exercises for policy people, not just engineers.
- **[Disaster Response Router](Project/disaster-response-router.md)** — an OSM extract + road-closure edges on a phone;
  works without cell towers because the graph is local.
- **[The Phone App Shell](Project/phone-app-shell.md)** — a native app whose database *is* a `.cl` file: open with from
  Files/iCloud, share a subgraph out through the share sheet, a stored query as a lock-screen widget — the graph file as
  a first-class mobile citizen.
- **[A Graph on a Microcontroller](Project/graph-on-a-microcontroller.md)** — the extreme end of embedded: the C ABI on
  an ESP32-class board, sensor neighborhoods and device inventories as tiny graphs, littlefs as the durable layer — with
  the honest memory math up front.
- **[Robot Side-Brain](Project/robot-side-brain.md)** — a small device's world model: rooms, objects, tasks,
  affordances as a graph; plans are path queries; the map is the database.
- **[VR/XR Overlay](Project/vr-xr-overlay.md)** — a graph of the game/space/room anchored to poses; "what's
  connected to the machine I'm looking at" — the HUD is a query result.

## Data Transformation & Import

*(one file per idea: [Project/](Project/))*

- **[CSV → Graph, Instantly](Project/csv-to-graph-instantly.md)** — drop a CSV, pick key columns, relationships materialize;
  the `pull`-style pipeline for any tabular source on the web.
- **[Parquet → Graph](Project/parquet-to-graph.md)** — relational/analytical data (Parquet, Arrow) re-modeled as
  graphs: shared keys become edges; graph queries over columnar exports.
- **[Kaggle/HuggingFace GraphLoader](Project/kaggle-huggingface-graphloader.md)** — one click from a dataset card to a `.cl` file;
  the dataset's social graph, citation graph, or co-occurrence graph, ready.
- **[`sitemap.xml` → Site Graph](Project/sitemap-xml-to-site-graph.md)** — any website's sitemap into a URL graph; crawl
  structure, orphan pages, and topical clustering as queries.
- **[User-Journey Recorder](Project/user-journey-recorder.md)** — a plugin records your own browsing as a temporal
  graph; "how did I end up reading this?" is literally a path.
- **[Sparse Matrix, Meet Graph](Project/sparse-matrix-meet-graph.md)** — matrices as bipartite graphs; the operations
  research people didn't know they wanted this.
- **[The Emergent Interaction Graph](Project/the-emergent-interaction-graph.md)** — temporal knowledge graphs *inferred*
  from communication streams: email, Slack, meeting invites, phone proximity
  (the COVID contact-tracing shape), any sensor log — the graph nobody drew
  emerging from the interactions, with exposure chains, information flow, and
  communities-over-time as temporal queries.
- **[A Million Tiny Graphs](Project/a-million-tiny-graphs.md)** — RelateDB stores millions of small subgraphs cheaply;
  benchmark, partition, fan-out (map-reduce over subgraphs), cluster them.
- **[Event Stream to Temporal Graph](Project/event-stream-to-temporal-graph.md)** — append-only logs (logs, clicks, packets)
  into a WAL-backed graph; replay any window and query it as it was.
- **[Cambria for Graphs](Project/cambria-for-graphs.md)** — schema evolution as a stored lens graph: `(:SchemaVersion)`
  nodes with bidirectional lens edges, shortest-path routing between versions — old checkpoints never unreadable,
  and the migration history travels inside the file (the Liquibase / neo4j-migrations timeline upgraded to a
  graph; complements the cross-database lens with a lens across time).

## Interop, Sync & Distribution

*(detail: [Project/interop-and-distribution.md](Project/interop-and-distribution.md))*

- **[Clone, Fork, Pull, Push](Project/clone-fork-pull-push.md)** — `relate clone/pull/push` against other RelateDB
  instances, Neo4j (Bolt), and anything speaking HTTP — the git-shaped graph workflow.
- **[Single-File Graph Stories](Project/single-file-graph-stories.md)** — one `.cl` file = data + schema + (soon) queries;
  email it, commit it, attach it to a ticket. Datasets as artifacts, not servers.
- **[httpfs for `.cl` Files](Project/httpfs-for-cl-files.md)** — a published `.cl` on any static host (GitHub Pages, S3, IPFS)
  queried *in place* over HTTP range requests: load the row groups you need, not the file — the sql.js-httpvfs move, for
  graph files.
- **[NetworkX Runtime](Project/networkx-runtime.md)** — `nx.compose(relate_graph("file.cl"))`; your nx algorithms,
  a Cypher backend. (And GDS-style procedures the other direction.)
- **[Graph Lens over Any Database](Project/graph-lens-over-any-database.md)** — a read-mostly layer over SQLite/DuckDB/Postgres
  tables via the VFS; graph queries without a migration project.
- **[Team Wiki from a Shared File](Project/team-wiki-from-a-shared-file.md)** — a group of friends editing a shared graph on a
  NAS or a git repo; conflicts merge because files are the unit.
- **[GraphClips (Heroku Dataclips, Reborn)](Project/graphclips-heroku-dataclips-reborn.md)** — save any query result as a shareable
  file — but each result *is itself a graph*: open the clip in another instance (or
  in the browser) and keep querying it. Results as first-class, queryable artifacts.
- **[Cypher on Cypher](Project/cypher-on-cypher.md)** — composability: run a query over another query's result —
  a projection/subgraph fork that can be stored, re-parameterized, and queried
  again; the dataflow-shell for Cypher (pipe, filter, re-shape).
- **[Graph Clipboard](Project/graph-clipboard.md)** — COPY a subgraph as a file, PASTE it into another instance;
  the smallest useful data-sharing protocol in existence.
- **[Graph Database in a Lambda](Project/graph-database-in-a-lambda.md)** — fully serverless RelateDB: the Rust crate in
  a Lambda handler, WAL on ephemeral local storage, Parquet checkpoints + WAL tail
  in S3 (the Turso-embedded-replicas / litestream architecture); cold start pulls
  the checkpoint and replays — which is already RelateDB's recovery path.
- **[Edge Workers Graphs](Project/edge-workers-graphs.md)** — the WASM build inside Cloudflare Workers (R2/Durable
  Objects for storage): per-user graph APIs at edge latency with zero servers.
- **[The PouchDB Move](Project/the-pouchdb-move.md)** — offline-first RelateDB that syncs to a central store
  (RelateDB or Neo4j): local-first apps that keep working on the subway, merge on
  reconnect (Ink & Switch's ideology, the CouchDB/PouchDB architecture).
- **[The Driver That Isn't](Project/the-driver-that-isnt.md)** — a Neo4j-driver-shaped client library backed by the
  embedded engine (`GraphDatabase.driver("relate:...")`): GraphRAG packages,
  GraphQL libraries, and every tool already written against the Neo4j driver run
  on an embedded, zero-server RelateDB by swapping one URL (the DuckDB-driver
  pattern; the pglite precedent of "the real protocol, embedded").
- **[GraphQL, Straight from the Engine](Project/graphql-straight-from-the-engine.md)** — the catalog *is* the GraphQL
  schema: labels → types, relationship types → fields, one GraphQL query compiling
  to one Cypher traversal, served in-process beside Bolt/HTTP/MCP — the 2016
  neo4j-graphql direct mapping revived, before the successors made the schema a
  build step; N+1 dissolves because the resolver is the engine.
- **[Read Replica in Your Pocket](Project/read-replica-in-your-pocket.md)** — pull a slice of the big Neo4j to your laptop,
  query it on the plane, push back the curation results.

## Visualization & Rendering

*(one file per idea: [Project/](Project/))*

- **[The `.cl` File Viewer](Project/the-cl-file-viewer.md)** — double-click a graph file, browse and query it in a GUI:
  schema canvas, property browser, query box — the DB Browser for SQLite analog that makes the format usable by
  mortals.
- **[A Million Nodes in a Tab](Project/a-million-nodes-in-a-tab.md)** — WASM RelateDB + cosmograph-style GPU rendering;
  load topology first, details on hover/zoom — the humane-large-graph experience
  (Mottin/Mueller's rules) for everyday data.
- **[Mermaid as a Query Result](Project/mermaid-as-a-query-result.md)** — `RETURN mermaid(path)` — any Cypher result
  renders as a live diagram for docs, issues, and slides.
- **[GraphGists, Reborn](Project/graphgists-reborn.md)** — the classic: fenced Cypher in a markdown file renders
  data + visualization in the browser. Cookbooks, but for community stories.
- **[Static Sites from Dynamic Graphs](Project/static-sites-from-dynamic-graphs.md)** — generate a Hugo/Astro site from graph
  queries; the graph is the CMS, the pages are views, and a rebuild is a query.
- **[D3/Sigma/Cytoscape Adapters](Project/d3-sigma-cytoscape-adapters.md)** — one graph file, any viz library; the adapter
  layer is thin because the data is already shaped.
- **[KNN Graph Viewer](Project/knn-graph-viewer.md)** — vector-search neighborhoods as k-NN graphs; an alternative
  to t-SNE that stays queryable (and label-able) in the original space.
- **[Diff View for Graphs](Project/diff-view-for-graphs.md)** — two checkpoints of the same store, visualized as a
  diff: added/removed/changed nodes and edges. The merge-conflict view for data.
- **[Animated Graph Timelapse](Project/animated-graph-timelapse.md)** — a temporal graph played over time; the rise and
  fall of a community, a market, or a pandemic, one WAL frame at a time.

## Use-Case Gallery

The classic graph domains — the ones every evaluation, every demo request, and
every tutorial asks for — as ready-to-load `.cl` datasets with query packs.
(The lineage: the Neo4j sandbox library these were proven in, plus the public developer-social-networks datasets.)

- **[Customer 360](Project/use-case-gallery.md)** — the canonical enterprise graph: identity, accounts,
  products, interactions, consent
- **[Financial AML](Project/use-case-gallery.md)** — accounts, transactions, counterparties, alerts; fraud
  rings as dense-subgraph queries
- **[Financial Payments](Project/use-case-gallery.md)** — settlement and routing networks; circular-payment
  detection
- **[Entity Resolution (MDM)](Project/use-case-gallery.md)** — golden records, sources, survivorship rules,
  match provenance
- **[Enterprise Knowledge Graph (OpenCorporates)](Project/use-case-gallery.md)** — companies, officers,
  addresses, beneficial ownership
- **[Crunchbase Companies](Project/use-case-gallery.md)** — funding rounds, investors, acquisitions,
  categories
- **[Cyber Security Threat Detection](Project/use-case-gallery.md)** — assets, vulnerabilities, identities,
  attack paths
- **[Data Lineage](Project/use-case-gallery.md)** — sources, transformations, pipelines, dashboards;
  impact analysis as upstream/downstream reachability
- **[Supply Chain](Project/sanctions-and-supply-chain-screening.md)** — suppliers, parts, sites, disruptions; multi-tier exposure
- **[Healthcare Referrals](Project/use-case-gallery.md)** — providers, patients, referrals, outcomes
- **[Healthcare Drug Interactions](Project/use-case-gallery.md)** — drugs, proteins, pathways, interactions
- **[Covid / Contact Tracing](Project/use-case-gallery.md)** — people, places, proximity events, exposure
  chains (see also [The Emergent Interaction Graph](Project/the-emergent-interaction-graph.md))
- **[Network & IT Resource Optimization](Project/use-case-gallery.md)** — devices, links, capacity, paths
- **[Recommendations (Movies)](Project/use-case-gallery.md)** — the tutorial dataset grown up (see
  [The Movie Graph, All Grown Up](Project/the-movie-graph-all-grown-up.md))
- **[Reco 2.0 — Hyperpersonalized Marketing](Project/use-case-gallery.md)** — segments, content, events,
  consent, next-best-action
- **[Social Network Analysis](Project/use-case-gallery.md)** — the classic follower/friend corpora
- **[Developer Social Networks](Project/developer-social-networks.md)** — GitHub/Stack Overflow cross-graphs (see
  [Software Analytics Sandbox](Project/software-analytics-sandbox.md))
- **[The AT Protocol Firehose Graph](Project/atproto-firehose-graph.md)** — Bluesky/ATProto's Jetstream firehose as a
  temporal interaction graph with typed overlays (follow/reply/repost/mention/hashtag) — plus the network's own
  infrastructure (PDSes, relays, AppViews, and the fediverse instance mesh) as a second graph nobody can currently see
  whole.
- **[The Learning Track](Project/use-case-gallery.md)** — a guided curriculum over the gallery: a GQL/SQL
  introduction, the graph algorithms pack (centrality, shortest path,
  community detection, GNNs), and the ML set — recommendations, entity
  resolution, fraud detection, low-rank models — each taught on the
  corresponding gallery dataset

## Authoring & Projection

Everyone draws graphs — on whiteboards, in marketing decks, in spreadsheets.
The complexity was never the graph; it was the *getting it in*.

- **[Whiteboard to Graph](Project/whiteboard-to-graph.md)** — photograph a whiteboard, a slide diagram, or a
  napkin sketch; a vision model (local or not) extracts nodes, edges, and
  labels into RelateDB — the drawing becomes queryable, and the diff from
  the last photo becomes a change log.
- **[Arrows on RelateDB](Project/arrows-on-relate.md)** — Neo4j Labs'
  [arrows.app](https://arrows.app), the interactive graph drawing and editing
  canvas, backed by RelateDB's WASM engine: draw as before, but the drawing
  is a live store — patterns run, results write back, the sketch and the
  data converge.
- **[The Intentional Graph Workbench](Project/the-intentional-graph-workbench.md)** — Charles Simonyi's Intentional
  Workbench vision on a graph engine: one internal graph representation,
  projectional renderers and editors for every shape it can take — table,
  diagram, canvas, tree, timeline — each view a bidirectional editor, the
  mappings between them first-class.
- **[Strategy Graphs as Shipped Artifacts](Project/strategy-graphs-as-shipped-artifacts.md)** — decision surfaces
  (taxonomies, question trees, choice lattices — even a 78-card tarot lattice) as *portable* `.cl` navigation
  files: walked with context, every walk a recorded probability-edge path, analytics as Cypher. Every working
  example today runs in memory or on a server; none ships a file.
- **[Spreadsheets are Graphs](Project/spreadsheets-are-graphs.md)** — Felienne Hermans' research made practical:
  a workbook's formulas, references, and sheets as a graph (dependencies,
  smell detection, "what breaks if I change this cell") — plus the table
  data itself.
- **[Table Editor to Graph](Project/table-editor-to-graph.md)** — Markus Wissing's interactive editing of
  table-shaped data that is *immediately* the graph: edit rows in a grid
  while the graph view updates live — the same store, two projections,
  no import step.
- **[Graph Sheets](Project/graph-sheets.md)** — the linked-record grid as the face of a property graph:
  rows are nodes, linked columns are typed edges, views are stored queries; Adam
  Wiggins' end-user-programming lessons (gradient not chasm, embodiment, living
  system, in-place toolchain) as the design contract — Airtable's front end over
  a real graph engine, shipped as one `.cl` file.

## Play, Games & Simulation

- **[The MUD Mapper's Revenge](Project/the-mud-mappers-revenge.md)** — MUD/MMO worlds (rooms, exits, items, spawn tables,
  player traces) in one queryable .cl file: the world IS the
  graph, the map is a projection.
- **[The Graph Trading Card](Project/graph-trading-card.md)** — a small subgraph as a QR code on a card, a badge, an NFC
  sticker — scan, merge, collect: physical handoff for graph files, the Graph Clipboard's last mile.
- **[LEGO Assembly Graphs](Project/lego-assembly-graphs.md)** — parts, connectors, reference constructions, and the
  provenance manifest as a queryable store (the ldraw-nova architecture, graph-native): substitution checkers,
  build-vs-reference BOM diffs, and "what can I build with what I own" as subgraph-matching over Rebrickable's
  clean public corpora.
- **[Franchise Genealogy](Project/franchise-genealogy.md)** — family trees for fictional universes at franchise scale:
  Tolkien's lineages, Dune houses, the Godfather clans — "how are Fëanor's
  descendants related to Melkor's lies?" as one query.
- **[Dark-Style Multiverse Storage](Project/dark-style-multiverse-storage.md)** — parallel-world story graphs (the Dark TV
  model): typed world-line edges (`-[:IN_WORLD {timeline: 1}]->`), time-travel
  loops, bootstrap paradoxes — the same person at three ages across two worlds
  stays one node with world-scoped paths.
- **[Living Worlds for NPCs](Project/living-worlds-for-npcs.md)** — D&D campaign / MMO NPC state: who met whom, what
  they know, grudges and debts as temporal edges; the game master queries the
  world instead of remembering it.
- **[World-Model Storage](Project/world-model-storage.md)** — persistent world state for simulation/game agents:
  rooms, affordances, event histories the agent lives in — the frontier where a
  world model needs a real storage engine, not a JSON blob.
- **[GEDCOM Importer & Merger](Project/gedcom-importer-merger.md)** — the ancestry play: import standard GEDCOM
  exports, then merge trees from different relatives' research — the entity-
  resolution problem (same person, three spellings, two birth dates) as graph
  dedup with reviewable candidate matches.
- **[Family Tree, But With the Awkward Parts](Project/family-tree-but-with-the-awkward-parts.md)** — real genealogy with remarriages,
  adoptions, migrations as temporal edges; "are we related, and how?"
- **[Decision Journal](Project/decision-journal.md)** (the Obsidian-native one — life choices as graph events; retro decision-quality
  queries ("what did I actually know when I chose?").
- **[Choose-Your-Own-Adventure Engine](Project/choose-your-own-adventure-engine.md)** — the story graph is the database; readers
  query their own path history, authors write branches in Cypher.
- **[State-Space Puzzle Solver](Project/state-space-puzzle-solver.md)** — game states as nodes, moves as edges; BFS/A*
  solutions as watchable path queries.
- **[Escape-Room Builder](Project/escape-room-builder.md)** — locks, keys, puzzles as a dependency DAG; the design
  tool that proves the room is solvable.
- **[The Fact-Check Engine](Project/the-fact-check-engine.md)** — import Diffbot/GDELT slices as the evidence graph;
  paste an article, extract its claims, and query each against the source graph:
  which entities co-occur in reporting, which claimed relationships have no
  documented edge anywhere — fact-checking as missing-edge detection with full
  provenance (which sources say what, and how they're connected).
- **[Conspiracy-Theory Debugger](Project/conspiracy-theory-debugger.md)** — theFact-Check Engine's cousin for analyzing
  claimed narratives: evidence-strength edges, and missing-edge queries that
  expose exactly where the theory needs unprovable links.
- **[Argument Mapper for Debate Prep](Project/argument-mapper-for-debate-prep.md)** — claims, premises, rebuttals as a typed
  graph; find your unclosed rebuttal paths first.
- **[Legal Citation Graphs](Project/legal-citation-graphs.md)** — laws, statutes, court cases, courts, judges,
  parties, and the reference edges between them: precedent chains as citation
  paths ("which decisions did this ruling rely on, and which later overturned
  it"), the argument mapper's grown-up sibling for briefs — every claim in a
  legal memo traceable to its authorities as one query.
- **[Recipe Fork Graph](Project/recipe-fork-graph.md)** — dishes as nodes, substitutions as edges; the kitchen's
  git history. With the flavor layer: ingredients ↔ flavor compounds ↔ taste
  profiles (Ahn et al's flavor network science) — "what pairs with this?" and
  "novel pairings two hops from anything I cook" as graph queries. Lineage: the
  Neo4j community's recipe/food/taste classics (Luanne Misquitta, Rik van
  Bruggen, Mark Needham) — the same genre, embedded.
- **[Stitch Graphs](Project/stitch-graphs.md)** — knitting and weaving patterns are directed graphs (stitches as
  nodes, yarn paths as edges — the CG "stitch meshes" literature proved it): the pattern library, cable braids, and
  graded sizing as constrained graph transforms; the craft's first machine-readable pattern currency.
- **[Reading-List Recommender That Shows Its Work](Project/reading-list-recommender-that-shows-its-work.md)** — explainable paths through
  your own highlights. With real data: the Goodreads datasets (books, authors,
  shelves, ratings — already graph-shaped) as the classic import; the
  published Goodreads graph tutorials are the lineage, embedded this time.
- **[The Movie Graph, All Grown Up](Project/the-movie-graph-all-grown-up.md)** — TheMovieDB/IMDB imports (the tutorial
  dataset of the whole graph world, now with the full catalog): collaborative
  filtering as plain Cypher ("people who liked what you liked"), and the 2026
  twist — agents running hybrid search (fulltext + vector `COMBINE`) over
  plots and reviews for recommendations that cite their evidence.
- **[Karaoke Set-List Weaver](Project/karaoke-set-list-weaver.md)** — songs, keys, tempos, energy as a weighted graph.
- **[Collection Curator](Project/collection-curator.md)** — vinyl/books/sneakers as collaboration graphs; "play me
  a path through my record shelf."
- **[Wardrobe Planner](Project/wardrobe-planner.md)** — items, colors, occasions, weather; one query.
- **[Menu Allergen Graph](Project/menu-allergen-graph.md)** — dishes, ingredients, allergens; "what can I safely
  eat here?" on your phone.
- **[League Historian](Project/league-historian.md)** — fantasy-sport trades and matches as a temporal graph.
- **[Opening-Theory Explorer](Project/opening-theory-explorer.md)** — your chess/Go games as a move-DAG.
- **[Sentence Graph for Language Learning](Project/sentence-graph-for-language-learning.md)** — spaced repetition by graph distance.
- **[Street-Name Politics](Project/street-name-politics.md)** — who your city honors and the connections between them.
- **[Board-Game-Night Matchmaker](Project/board-game-night-matchmaker.md)** — "the game we all like that we haven't played
  in six months" as one query.
- **[The Nothing-To-Watch Chooser](Project/the-nothing-to-watch-chooser.md)** — moods, actors, themes, runtimes; "40 minutes
  and tired" as a weighted query.

## Meta: Graphs about Graphs

*(one file per idea: [Project/](Project/))*

- **[Query Plans as Graphs](Project/query-plans-as-graphs.md)** — every `EXPLAIN` tree collected into one meta-graph;
  search plans like code, diff them between versions, mine them for smells.
- **[Tiny Neural Nets, Rendered](Project/tiny-neural-nets-rendered.md)** — a 2-layer net as a weighted graph; animate
  training by watching edge weights change. Education, not infrastructure.
- **[GDS Round-Trip](Project/gds-round-trip.md)** — Graph Data Science as a graph *transformer*: projections
  in (subgraph → algorithm), compute results out (PageRank scores, communities,
  embeddings, kNN graphs, link predictions) written back as graph structure —
  clustering projections land in RelateDB as nodes and edges you can query with
  everything else. (Lineage: Neo4j GDS's projection model, but results land in the
  same embedded store, not a sidecar.)
- **[Dynamic Path Index](Project/dynamic-path-index.md)** — a maintained shortest-path/frequency index as a graph
  *on top of* your graph; query the index, not the traversal.
- **[Benchmark Zoo](Project/benchmark-zoo.md)** — every loadtest result as a graph of runs, shapes, and metrics;
  performance engineering becomes exploratory.
- **[Schema Telescope](Project/schema-telescope.md)** — introspect many databases (or many stores) into one
  meta-graph of labels, keys and relationships; the federated data catalog that
  starts with a folder of files.

---

## The Pattern

Every idea above is a variation on one theme:

> **Take a real thing, make it a graph, put the graph where the questions are.**

Where the questions are: a browser, a phone, a robot, an agent, a classroom,
a newsroom, a notebook. RelateDB's job is to make the "put it there" part
free — no server, no ops, no export format.

---

## Contributing

- Have an idea? Open an issue with the section and a one-liner.
- Built something? PR with a link + a screenshot/video.
- The detail files in [`Project/`](Project/) expand each idea into a short brief
  (what / why RelateDB / what it needs) — extend them freely.

## License

The content of this repository is CC-BY-4.0. RelateDB itself is Apache-2.0.

*(This list is a living document — seedlings welcome.)*
