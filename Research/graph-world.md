---
type: Research
name: graph-world
INFORMS:
  - "[[Project/a-million-nodes-in-a-tab]]"
  - "[[Project/benchmark-zoo]]"
  - "[[Project/network-science-interactive]]"
  - "[[Project/use-case-gallery]]"
  - "[[Project/wordnet-but-queryable]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/ICIJ]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Neo4j]]"
  - "[[Company/OCCRP]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
RELATED_IDEA:
  - kind: same-data
    reason: Network of Thrones is the canonical book-to-character-graph dataset cited
    target: "[[Project/a-song-of-ice-and-fire-queried]]"
  - kind: same-data
    reason: OSM street networks as graphs is the geospatial example this survey cites
    target: "[[Project/openstreetmap-wedge]]"
  - kind: same-data
    reason: Six Degrees of Wikipedia and character networks are the Wikipedia graph lane
    target: "[[Project/wikipedia-wedge]]"
  - kind: same-data
    reason: WordNet is named as a perfect parquet-checkpoint-sized public graph
    target: "[[Project/wordnet-but-queryable]]"
USES_TECH:
  - "[[Technology/Cosmograph]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/WordNet]]"
  - "[[Technology/sigma.js]]"
---

# Research findings: the graph world

*Collected 2026-10-22 as inspiration research for the relate-ideas list.
Lens: RelateDB is an embedded in-memory property-graph engine, single binary,
Cypher, WASM/browser, WAL+Parquet.*

## 1. Kuzu — the closest embedded-graph peer

- **Kuzu (Waterloo Data Systems Group, CIDR 2023)** — embedded columnar property-graph DBMS with Cypher; the "DuckDB of graphs", zero-install single library. https://github.com/kuzudb/kuzu/ | CIDR paper: https://vldb.org/cidrdb/2023/kuzu-graph-database-management-system.html — *Transferable: the embedded, no-server framing and the academic-credibility paper are exactly RelateDB's positioning; the comparison table is the model.* (Update 2025: Apple acquired Kuzu Inc — graph-shaped storage is going on-device; the on-device niche is validated at the largest possible scale.)
- **Kuzu Graph RAG** — official Graph RAG pipeline (Microsoft GraphRAG-style) on an embedded graph, incl. vector search in the DB. https://github.com/kuzudb/graph-rag — *Transferable: embedded graph + vectors = agent/LLM RAG demos that run locally with zero infra.*
- **Senzing + Kuzu entity-resolved knowledge graphs** — entity resolution output loaded into Kuzu for link analysis. https://blog.kuzudb.com/post/entity-resolved-knowledge-graphs/ — *Transferable: "bring your messy records, get a queryable entity graph" is a killer single-binary demo.*
- **BAML + Kuzu: unstructured → graph** — LLM extraction into a graph, end to end. https://github.com/kuzudb/baml-kuzu-demo — *Transferable: document→graph ETL as one CLI run.*
- **Kuzu knowledge-graph MCP server** — graph DB exposed to LLM agents over MCP. https://github.com/SankarPatnaik/kuzu-knowledge-graph-mcp — *Transferable: RelateDB already ships an MCP surface; an "agents query your local graph" showcase is table stakes.*
- **Kuzu + G.V() visualization** — desktop/browser viz directly over embedded Kuzu. https://gdotv.com/blog/fast-scalable-graph-querying-and-visualization-with-kuzu-and-g-v/ — *Transferable: pair the WASM build with a viz front end.*
- **dspy + Kuzu demo** — agentic LLM program using an embedded graph as its memory. https://github.com/adsharma/kuzu-demo-dspy — *Transferable: graph as agent memory / agent scratchpad.*

## 2. NetworkX gallery / use-case domains

- **NetworkX gallery (300+ examples)** — the canonical collection of what people actually compute on graphs: centrality, communities, flows, ego graphs, lattice/knowledge graphs. https://networkx.org/documentation/stable/auto_examples/index.html — *Transferable: port the top ~20 recipes to Cypher as a cookbook of "one query, one insight".*
- **NetworkX guides: Applications** — notebook-based case studies: social network analysis, bipartite projections, co-authorship, infrastructure networks. https://networkx.org/nx-guides/content/applications/index.html — *Transferable: a guided "domain tour" set of runnable notebooks.*
- **Geospatial network examples** — street/river networks from OpenStreetMap as graphs, routing and accessibility analysis. https://networkx.org/documentation/stable/auto_examples/geospatial/extended_description.html — *Transferable: RelateDB has point types; an OSM → graph → route demo is a strong fit.*
- **"Staying with the trouble of networks" (Frontiers)** — reflexive review of how network analysis is applied across science. https://www.frontiersin.org/journals/big-data/articles/10.3389/fdata.2022.510310/full — *Transferable: framing — graphs as a cross-domain lingua franca for the ideas list intro.*

## 3. Large-graph visualization

- **Cosmograph / cosmosgl/graph** — GPU (WebGL) in-browser rendering of million-node/edge graphs from CSV; point-and-click exploration without a server. https://cosmograph.app/ | https://github.com/cosmosgl/graph — *Transferable: the flagship WASM demo — RelateDB WASM exporting CSV/Arrow → Cosmograph = million-edge graph explored in a tab, no backend.*
- **"How to visualize a graph with a million nodes" (Nightingale)** — the practitioner guide behind the Cosmograph approach. https://nightingaledvs.com/how-to-visualize-a-graph-with-a-million-nodes/ — *Transferable: content marketing that doubles as a demo.*
- **sigma.js + graphology** — modular JS graph model + WebGL renderer; cookbook examples include CSV→network, large graphs, cluster labels. https://www.sigmajs.org/examples/ | https://www.sigmajs.org/get-started/load-a-dataset/ — *Transferable: WASM RelateDB + sigma.js = interactive explorer over a local .parquet checkpoint.*
- **MetaExp (Mottin/Müller, HPI → KDD/SIGMOD tutorials)** — "humane" interactive exploration of large knowledge graphs: show only what is relevant/explainable to the user rather than dumping the hairball; Mottin's graph-exploration line continues at Kiel. https://mott.in/publications/publications/metaexp/ | https://mott.in/projects/graph-exploration/ — *Transferable: query-driven relevance — the db.schema.visualization-style "show the relevant subgraph" UX beats the full-graph view.*
- **Gephi (Bellingcat toolkit entry)** — still the OSINT/journalist default for cleaning and laying out medium graphs (modularity, force-atlas 2). https://bellingcat.gitbook.io/toolkit/more/all-tools/gephi — *Transferable: Gephi's "import → detect communities → curate" workflow is the narrative for a browser-side mini-Gephi.*
- **GDELT + Gephi story/cluster mapping** — global news coverage embedded, clustered, and rendered as a network. https://blog.gdeltproject.org/using-the-gsg-document-embeddings-to-visualize-story-clusters-using-gephi/ — *Transferable: embeddings → cluster graph → viz, all client-side capable.*

## 4. Investigative journalism

- **ICIJ Offshore Leaks / Panama Papers (Pulitzer 2017)** — the defining graph-database journalism story: 2.6M leaked records modeled as officers-intermediaries-addresses graphs in Neo4j; ICIJ still publishes a browsable Neo4j browser guide and downloadable Neo4j data packages. https://neo4j.com/blog/cypher-and-gql/icij-neo4j-unravel-panama-papers/ | browser guide: https://github.com/ICIJ/offshoreleaks-data-packages/blob/main/documentation/icij-offshoreleaks.neo4j-browser-guide | case study PDF: https://go.neo4j.com/rs/710-RRC-335/images/Neo4j-case-study-ICIJ-EN-US.pdf — *Transferable: bundle the ICIJ public dataset as a single RelateDB database file + WAL/parquet checkpoint so anyone can run the actual Pulitzer queries locally or in-browser — a jaw-dropping demo with no server.*
- **ICIJ Neo4j sample-data guide** — step-by-step "find shortest path between two people" walkthrough on the leaks graph. https://guides.neo4j.com/sandbox/icij-panama-papers/examples.html — *Transferable: shortest-path storytelling on the same data.*
- **OCCRP Aleph** — open-source investigative data platform: entity/relationship extraction across leaked documents, follow-the-money graph exploration used by hundreds of journalists. https://aleph.occrp.org/ | https://github.com/alephdata/aleph | architecture: https://docs.aleph.occrp.org/developers/explanation/architecture/ — *Transferable: "Aleph-lite in the browser" — a bundle that ingests a doc set, extracts entities, and does follow-the-money queries client-side.*
- **GIJN: social network analysis for investigative journalism** — the training-materials layer around Gephi/Neo4j for newsrooms. https://gijn.org/stories/power-social-network-analysis-investigative-journalism/ — *Transferable: an "investigative graph kit" skill/tutorial.*

## 5. Fandom / Wikipedia / character networks

- **Network of Thrones (Math Horizons paper + site)** — the ASOIAF character network (Storm of Swords: 107 nodes/353 weighted edges) computed from book text; the classic "book → graph" teaching dataset. https://mathbeveridge.github.io/files/NetworkofThrones.pdf | https://networkofthrones.com/ | data: https://github.com/mathbeveridge/asoiaf — *Transferable: ship as a demo database + "who is the most central character?" Cypher queries.*
- **Six Degrees of Wikipedia (sdow)** — precomputed shortest paths across all ~6M English Wikipedia pages; fun path-finding at web scale. https://github.com/jwngr/sdow | https://www.sixdegreesofwikipedia.com/ — *Transferable: a smaller bundled Wikipedia graph + shortest-path Cypher = playful WASM demo ("degrees from Kevin Bacon to Kubernetes").*
- **The Wikipedia Republic of Literary Characters** — literary-character network built from Wikipedia, with an interactive viz. https://culturalanalytics.org/article/id/1301/ | https://clause-bielefeld.github.io/wikipedia-character-network/ — *Transferable: "literature as a graph" data story.*
- **Cornell INFO 2040 character-network blog** — student-built character networks as recurring class genre (Harry Potter etc.) — evidence this is how people *learn* graphs. https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/ — *Transferable: education lane — "build your own character network" notebook.*

## 6. Graph analytics on real software systems

- **GUAC (Graph for Understanding Artifact Composition)** — software-supply-chain knowledge graph: SBOMs + attestations + deps into one queryable graph for security posture questions. https://github.com/guacsec/guac/ — *Transferable: dependency/supply-chain graphs are a natural embedded use; a "cargo audit → graph → find vulnerable dependents" demo maps to RelateDB's own fs-to-graph/git-to-graph commands.*
- **Joern** — code property graph for static analysis (queries over ASTs, control/data flow in a graph DB). https://github.com/joernio/joern/ — *Transferable: code-as-graph; RelateDB's fs-to-graph lab is adjacent.*
- **FalkorDB DepGraph** — package dependency graphs in an in-memory graph DB for finding attack paths. https://github.com/FalkorDB/DepGraph — *Transferable: "attack path" queries = reachability Cypher.*
- **GH Archive + github_network** — the full GitHub event firehose archived hourly; early example of turning it into a social graph and mining collaboration. https://www.gharchive.org/ | https://github.com/rjurney/github_network/ — *Transferable: "one hour of GitHub events → embedded graph → top movers" CLI demo.*
- **mimecast/sbom-graph** — SBOM ingestion into a graph DB with queries for vulnerable paths. https://github.com/mimecast/sbom-graph — *Transferable: same lane, smaller.*
- **Neo4j graph examples org (movies, northwind, recommendations)** — the classic starter datasets every graph learner meets. https://github.com/neo4j-graph-examples/movies | https://github.com/neo4j-graph-examples/northwind | https://github.com/neo4j-graph-examples/recommendations — *Transferable: RelateDB equivalents of movies/northwind as first-load demo databases.*

## 7. Teaching / canonical graphs / network science

- **Barabási's Network Science book** — free, interactive, full textbook online; the standard onboarding to the field. https://networksciencebook.com/ — *Transferable: each chapter's datasets (karate club, co-authorship, internet AS graph) as ready-to-load RelateDB databases.*
- **Netzschleuder** — the network catalogue/repository: ~100s of curated graphs with metadata, browsable and API-fetchable. https://networks.skewed.de/ — *Transferable: an `relate lab netzschleuder <name>`-style loader of canonical datasets; also the source for the ideas list's "datasets" section.*
- **Zachary's karate club** — the most-cited small graph in history; built into NetworkX. https://en.wikipedia.org/wiki/Zachary%27s_karate_club | https://networkx.org/documentation/stable/auto_examples/graph/plot_karate_club.html — *Transferable: the "hello graph" dataset, loadable in one line.*
- **Les Misérables / Gephi sample datasets** — Knuth's Les Mis co-appearance + classic teaching graphs bundled with Gephi docs. https://docs.gephi.org/User_Manual/datasets/ — *Transferable: bundle the same canonical sets (Les Mis, karate, dolphins, florentine families) as first-run demo DBs.*
- **Mark Newman's network data page** — the original curated collection most teaching datasets trace back to. https://websites.umich.edu/~mejn/netdata/ — *Transferable: provenance-checked source for a bundled dataset pack.*
- **Interactive network-science course (chatox)** — open course site with interactive demos per concept. https://chatox.github.io/networks-science-course/ — *Transferable: WASM RelateDB could power "run the algorithm yourself" cells.*
- **WordNet visualizations** — WordNet as a browsable lexical graph (D3 force in browser; multiple open visualizers). https://github.com/rektdeckard/wordnet-web | https://www.visual-thesaurus.com/wordnet.php — *Transferable: WordNet is a perfect parquet-checkpoint-sized public graph; "explore the English language in your browser, no server" demo.*

## Cross-cutting conclusions

1. **Two demo lanes dominate:** (a) LLM/agent Graph RAG + entity resolution (Kuzu ecosystem), and (b) million-node in-browser visualization (Cosmograph/sigma.js). Both run serverless — exactly RelateDB's shape.
2. **The ICIJ/Panama Papers bundle is the single most compelling "one file, open it, query history" candidate** — real Pulitzer-winning data, downloadable today as a Neo4j pack that could ship as a RelateDB database file.
3. **Canonical small graphs (karate, Les Mis, GoT, WordNet) + Netzschleuder loader** make a cheap but beloved "hello graph" onboarding path.
4. **Code/supply-chain graphs (GUAC, Joern, DepGraph, GH Archive)** align perfectly with RelateDB's existing fs-to-graph / git-to-graph lab commands.
5. **"Humane" exploration (Mottin/Müller MetaExp)** argues the showcase UX should be relevance-driven subgraph views, not full-graph hairballs — same lesson as RelateDB's db.schema.visualization.
