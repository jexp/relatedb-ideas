---
type: Research
name: embedded-ecosystems
INFORMS:
  - "[[Project/clone-fork-pull-push]]"
  - "[[Project/edge-workers-graphs]]"
  - "[[Project/graph-database-in-a-lambda]]"
  - "[[Project/on-device-agent-graph-store]]"
  - "[[Project/read-replica-in-your-pocket]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Cloudflare]]"
  - "[[Company/Ink & Switch]]"
  - "[[Company/Kuzu]]"
  - "[[Company/Supabase]]"
  - "[[Company/Turso]]"
MENTIONS_PERSON:
  - "[[Person/Ben Johnson]]"
  - "[[Person/Simon Willison]]"
RELATED_IDEA:
  - kind: complements
    reason: embedded engine inside edge runtime functions is the Turso and Cloudflare pattern surveyed here
    target: "[[Project/edge-workers-graphs]]"
  - kind: complements
    reason: local replica synced from an origin is the Turso embedded-replica architecture
    target: "[[Project/graph-database-in-a-lambda]]"
  - kind: complements
    reason: embed-one-file-per-agent story mirrors sqlite-vec and embedded replicas
    target: "[[Project/on-device-agent-graph-store]]"
  - kind: complements
    reason: sync and replication story borrowed from the embedded database ecosystems
    target: "[[Project/the-pouchdb-move]]"
USES_TECH:
  - "[[Technology/DuckDB]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/MCP]]"
  - "[[Technology/PGlite]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/Turso]]"
  - "[[Technology/WASM]]"
---

# Research findings: embedded & agent-native database ecosystems

*Collected 2026-10-22 as inspiration research for the relate-ideas list.
Profile used as the lens: RelateDB is an embedded in-memory property-graph engine,
single binary, fsync'd WAL + Parquet checkpoints, openCypher TCK dialect, WASM/browser
build, MCP server, Bolt/HTTP APIs, C ABI wrapped by Python/JS/Java/Go clients, runs
on edge devices.*

## 1. SQLite ecosystem (awesome-sqlite)

Source: https://github.com/lichuang/awesome-sqlite (categories: forks, backup/replicate, distribute, extensions, GUI, encryption, wrappers, internals)

- **litefs** (superfly) — https://github.com/superfly/litefs — FUSE-based filesystem that replicates SQLite databases across a cluster of machines (powering Fly.io's global apps). *Why:* shows the pattern "embedded DB + log shipping = planet-scale without a server"; RelateDB's WAL is already the exact artifact a litefs-style replicator could ship — an embedded-replicas story is RelateDB's most direct Turso-analog play.
- **rqlite** — https://github.com/rqlite/rqlite — "lightweight, user-friendly distributed relational database built on SQLite": Raft layer over an embedded DB, single ~30 MB binary. *Why:* proves a distributed database can be a thin consensus shell over an embedded engine; a `relate-cluster` could be Raft over WAL segments.
- **sqlite-vec** (asg017) — https://github.com/asg017/sqlite-vec — vector search as a tiny extension that "runs anywhere" (OSes, browsers, mobile, Python). *Why:* the single most successful embedded-extension story; RelateDB already has vector search + hybrid search (CIP-278) — packaging it as a zero-config embeddable feature is the lesson, plus the "runs anywhere" portability discipline.
- **Datasette** (simonw) — https://github.com/simonw/datasette — instant read-only JSON/HTML publishing and exploration tool for any SQLite file; spawned a whole ecosystem (sqlite-utils, plugins). *Why:* the canonical "explore + publish a DB file over HTTP" tool — RelateDB already has an HTTP API; a `relate publish/datasette` analog (read-only graph explorer over Bolt/HTTP) is a proven community-builder.
- **cr-sqlite** (vlcn.io) — https://github.com/vlcn-io/cr-sqlite — convergent, replicated SQLite: CRDT tables enabling multi-writer, offline-first sync. *Why:* CRDT-over-WAL is a local-first graph future; RelateDB's in-memory model + WAL is a natural base for the same convergent graph story.
- **litestream** (benbjohnson) — https://github.com/benbjohnson/litestream — continuous streaming backup of SQLite to S3 by tailing the WAL. *Why:* direct template for "WAL → object storage" durability; RelateDB's WAL+Parquet checkpoints could add a litestream-style async S3 replication mode.
- **sqlsync** (orbitinghail) — https://github.com/orbitinghail/sqlsync — collaborative offline-first wrapper syncing app state across users/devices/edge via SQLite CRDTs. *Why:* collaborative multi-user graphs on an embedded engine — a differentiator no graph DB has.
- **DB Browser for SQLite / sqlitebrowser** — https://github.com/sqlitebrowser/sqlitebrowser — the de-facto desktop GUI every SQLite user knows. *Why:* every thriving embedded DB has a first-class free GUI; RelateDB needs its "DB Browser" (graph viz included — even better: `db.schema.visualization` exists).
- **sqlite-web / sqlite-utils** (coleifer / simonw) — https://github.com/coleifer/sqlite-web, https://github.com/simonw/sqlite-utils — instant web browser and CLI/Python manipulation toolkit for SQLite files. *Why:* the "just point it at a file" utility layer; RelateDB's `relate info/pull` is the seed of the same toolkit family.
- **MCP servers for SQLite** — e.g. https://github.com/sqliteai/sqlite-mcp, https://github.com/rusq/mcp-sqlite — a whole wave of MCP wrappers putting SQLite into agents' hands (Claude, Cursor). *Why:* validates RelateDB shipping a first-class MCP surface; an agent-native SQLite is largely just SQLite + MCP — RelateDB can lead here with graph-native MCP tools (schema visualization, path queries as tools).
- Also notable: **Cloudflare D1 / SQLite-in-Durable-Objects** (https://blog.cloudflare.com/sqlite-in-durable-objects/) — SQLite as the storage engine *inside* edge runtimes; the model for RelateDB on edge devices.

## 2. DuckDB ecosystem (awesome-duckdb + community showcase)

Sources: https://github.com/davidgasquez/awesome-duckdb, https://duckdb.org/2025/06/27/discovering-w-github (DuckDB team mines use cases from GitHub), https://duckdb.org/science/

- **duckdb-wasm / Online DuckDB Shell** — https://shell.duckdb.org/ — full analytical SQL in the browser; the shell itself became the #1 demo/teaching tool. *Why:* RelateDB already has a WASM build — a zero-install in-browser Cypher shell + playground is the highest-leverage marketing artifact this ecosystem knows.
- **Evidence** — https://evidence.dev — reports/dashboards authored in SQL + markdown, compiled to static sites, can run fully client-side on DuckDB-WASM. *Why:* "queries-as-prose" publishing; RelateDB + a cookbook/docs site could ship graph reports as tested markdown (RelateDB's cookbook format is already 80% of this).
- **Huey** (rpbouman) — https://github.com/rpbouman/huey — blazing-fast in-browser pivot tables over Parquet/CSV via DuckDB-WASM. *Why:* pattern for pure client-side graph exploration on RelateDB-WASM (drag a .relate file onto a page).
- **Harlequin** — https://harlequin.sh — polished terminal TUI SQL IDE for DuckDB (dbcli's DuckDB-native IDE). *Why:* a TUI over the `relate` CLI (table/gram output already exists) would serve the terminal-native agent/operator crowd.
- **marimo / jupysql / magic-duckdb** — https://marimo.io, https://pypi.org/project/jupysql/ — reactive notebooks and cell magics where SQL runs inline against an embedded engine. *Why:* RelateDB in notebooks = Cypher cells in Jupyter/marimo; the Python DB-API binding is the hook.
- **Apple Embedding Atlas** — https://apple.github.io/embeding-atlas/ — interactive visualization of large embedding spaces, DuckDB underneath. *Why:* RelateDB has vector search; a "graph + embedding atlas" viz (nodes, relationships, vectors in one canvas) is a project nobody ships.
- **Spice.ai** — https://github.com/spiceai/spiceai — unified runtime that materializes data + accelerators into an embedded DuckDB for local AI/API access (includes MCP!). *Why:* the template for "RelateDB as the local knowledge/materialized layer an agent queries next to" — RelateDB + MCP + Arrow already matches this shape.
- **Totsum Data Explorer** — https://www.totsum.app — desktop app turning plain-language questions into DuckDB SQL via an on-device model, fully offline. *Why:* local natural-language → Cypher generation over an embedded graph is a killer demo for RelateDB + small on-device models.
- **DuckDB in Science / Splink / smallpond** — https://duckdb.org/science/, https://github.com/moj-analytical-services/splink, https://github.com/deepseek-ai/smallpond — a curated collection of scientific papers built on DuckDB; record linkage at scale (Splink); DeepSeek's distributed compute framework on DuckDB. *Why:* science adoption gave DuckDB its credibility moat; entity-resolution/record-linkage is *natively graph-shaped* — RelateDB could own that niche the way DuckDB owns bioinformatics queries.
- **community-extensions repo** — https://github.com/duckdb/community-extensions — central registry where anyone ships DuckDB extensions with CI. *Why:* extension distribution infrastructure (incl. `duckpgq` SQL/PGQ property-graph extension!) — RelateDB's C ABI is the same seam; an extension registry + `relate install` is the long-term play. Also fun: **duckdb-acp** (https://github.com/sidequery/duckdb-acp) embeds AI agents *inside* DuckDB, and **connections.duckdb** solves the NYT puzzle in SQL.

## 3. Turso / libSQL ecosystem (embedded replicas, edge)

Sources: https://github.com/tursodatabase/awesome-turso, https://docs.turso.tech/features/embedded-replicas/introduction

- **Embedded Replicas** — https://docs.turso.tech/features/embedded-replicas/introduction — the signature Turso feature: a full local SQLite replica inside your app/serverless function, synced from the edge origin, giving microsecond reads and offline capability. *Why:* THE transferable architecture — "embedded graph replicas": RelateDB embedded in the app pulling Parquet checkpoint + WAL deltas from a central origin gives local-speed Cypher with cloud durability. Turso's own writeups show microsecond latency on AWS Lambda (https://blog.turso.tech/get-microsecond-read-latency-on-aws-lambda-with-local-databases-479db00a).
- **Turso Platform / libSQL fork** — https://github.com/tursodatabase/libsql — SQLite fork adding server mode, replication, and native HTTP/SQID endpoints — "SQLite, everywhere." *Why:* the fork-not-rewrite strategy that turned an embedded DB into a platform; RelateDB's single-writer + HTTP/Bolt surfaces map onto the same three modes (embed, edge, server).
- **libSQL Studio** — https://github.com/invisal/libsql-studio — slick browser-based client for libSQL/Turso (works with local files and remote DBs). *Why:* a browser studio that opens a local RelateDB store (WASM build) or a remote Bolt/HTTP endpoint = RelateDB's "Studio."
- **Flipt** — https://github.com/flipt-io/flipt — GitOps feature-flag platform using embedded replicas for zero-latency flag reads at the edge (they wrote about edge experiments: https://blog.flipt.io/experimenting-on-the-edge). *Why:* a real flagship app whose whole architecture = embedded DB synced to origin; a RelateDB analog is "graph-shaped config/feature state replicated to every pod."
- **val.town** — https://www.val.town/ — social platform for writing and deploying TypeScript snippets, running on Turso. *Why:* programmable-runtime + embedded DB pairing; RelateDB + user scripts is the graph version (agent sandboxes).
- **Undb** — https://undb.io — no-code database platform / BaaS built entirely on embedded SQLite; runs anywhere SQLite runs. *Why:* an entire SaaS product on an embedded engine with no server DB — RelateDB as the backend of a local-first no-code graph app builder.
- **OpenStatus** — https://www.openstatus.dev — monitoring product that migrated off PlanetScale to Turso for cost/simplicity. *Why:* the "escape from server databases" case study genre RelateDB can court.
- **Cloudflare Workers + Turso patterns** — https://blog.turso.tech/create-a-distributed-api-for-your-e-commerce-store-using-cloudflare-and-turso-fa449c932240 and Fermyon Spin with Rust (https://blog.turso.tech/fermyon-spin-with-rust-setup-guide-223813d3) — e-commerce and serverless apps with the DB embedded in the edge function. *Why:* RelateDB on edge devices is exactly this deployment shape; these are the reference apps to imitate.
- **expo-opsqlite-libsql-turso** — https://github.com/expo-starter/expo-opsqlite-libsql-turso — mobile (Expo/React Native) starter embedding libSQL with sync on device. *Why:* RelateDB's C ABI → mobile wrappers; graph-in-your-pocket apps (offline knowledge graphs).

## 4. PGlite (electric-sql/pglite) — in-browser Postgres

Sources: https://pglite.dev/, https://github.com/electric-sql/pglite, https://supabase.com/blog/in-browser-semantic-search-pglite, https://electric-sql/electric examples

- **PGlite itself** — https://github.com/electric-sql/pglite — full Postgres compiled to WASM, under 3 MB gzipped, persisted to IndexedDB (`idb://`), with live queries and dynamic extension loading (pgvector, PostGIS) — "Embeddable Postgres." *Why:* PGlite's entire rise (acquired-into-Electric, used by Supabase, database.build) is the strongest proof that "the real thing, embedded in the browser" beats bespoke browser stores; RelateDB-WASM is positioned identically for graphs.
- **Linearlite** — https://github.com/electric-sql/electric/tree/main/examples/linearlite — flagship example: a local-first Linear clone syncing 100k issues (~150 MB) into browser PGlite, with live queries, kanban drag-and-drop via fractional indexing, and tsvector full-text search — all client-side. *Why:* the model showcase for "real app, real scale, fully local"; a graph-native version (knowledge/work management with relationships as first-class Cypher joins) is the RelateDB demo to build.
- **Supabase in-browser semantic search** — https://supabase.com/blog/in-browser-semantic-search-pglite — PGlite + pgvector + Transformers.js embeddings = fully client-side semantic search over IndexedDB, WebGPU when available. *Why:* RelateDB has vector + hybrid search and a WASM build — an in-browser "graph + semantic search of your local data" demo (zero server, zero cost) is a headline project.
- **PGlite + Electric sync plugin** — https://electric-sql.com/ — sync engine streaming Postgres "shapes" into the embedded PGlite instance (live query reactivity, merge-on-write patterns). *Why:* the companion lesson: an embedded engine gets 10x more valuable with one canonical sync story — a "graph shapes" sync over RelateDB WAL/Parquet.
- **database.build** (referenced by Supabase/PGlite ecosystem) — natural-language schema + data generation with instant in-browser database preview. *Why:* "type a description, get a seeded database in your browser" — RelateDB + MCP + a seed generator would be the agent-native version.
- **PGlite REPL / playground** — https://pglite.dev/ — an interactive REPL right on the homepage; the site itself runs a Postgres instance in your browser. *Why:* trivially cheap, extremely sticky — a RelateDB homepage REPL (openCypher in the browser) is a day's work on the existing WASM build.
- **SvGrid Northwind demo** — https://svgrid.com/demos/338-pglite-northwind/ — classic dataset explored in a data grid entirely in-browser. *Why:* shipping canonical demo graphs (Northwind-as-graph, LDBC snippets) playable in the browser lowers the "first five minutes" to zero.

## 5. clickhouse-local — the single-binary embedded analytics swiss-army knife

Sources: https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local, https://clickhouse.com/blog/apache-parquet-clickhouse-local-querying-writing, https://clickhouse.com/blog/chdb-embedded-clickhouse-rocket-engine-on-a-bicycle

- **clickhouse-local** — https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local — the entire ClickHouse in one binary, running SQL directly against local and remote files: `./clickhouse local -q "SELECT * FROM 'reviews.tsv'"`, globs, `DESCRIBE file(...)`, and remote URLs (`s3://`, `https://`) as table engines. *Why:* the masterclass in "the binary IS the product": zero setup, one download, instant value. RelateDB is already this shape — lean into `relate`-as-a-tool: query Parquet/LDBC CSVs, point at S3 exports, convert formats, no `serve` required.
- **Parquet deep-dives with clickhouse-local** — https://clickhouse.com/blog/apache-parquet-clickhouse-local-querying-writing — using the local binary to inspect, convert, and aggregate Parquet datasets (and pipe JSON→CSV, etc.). *Why:* RelateDB's durable form is Parquet — a story where relate reads/writes the industry-standard interchange format natively is both practical and great positioning.
- **S3/object-storage analytics without a server** — e.g. https://oneuptime.com/blog/post/2026-03-31-clickhouse-local-query-s3-files/view — ad-hoc SQL over S3-hosted files, no cluster. *Why:* "point your embedded binary at an object store" is the exact edge/analytics workflow RelateDB on edge devices could own for graphs.
- **chDB** — https://clickhouse.com/blog/chdb-embedded-clickhouse-rocket-engine-on-a-bicycle — ClickHouse embedded *as a library* (Python/Node/Rust/Go bindings) — "a rocket engine on a bicycle." *Why:* chDB is the embeddable-library chapter of the same story; RelateDB's C ABI + Python wheel is already there — the lesson is the narrative and the obsession with library-mode ergonomics.
- **Shell-pipeline usage** — piping `ps aux` output into SQL, format auto-detection, `--structure`, Pretty output in the terminal (from the docs page). *Why:* "unix-tool that happens to speak SQL" is a beloved identity; a `relate` that happily sits in shell pipelines (it already has table/CSV/JSON/JSONL formatters) earns the same affection.
- **Deployment-modes framing** — https://clickhouse.com/docs/get-started/about/deployment-modes — ClickHouse explicitly markets local/serverless/cloud as *one* product in multiple modes. *Why:* RelateDB should tell one story across embed / WASM / `serve` / MCP rather than separate pitches — the deployment-modes page is the template.

## 6. General embedded / local-first / agent-native communities

Sources: https://github.com/alexanderop/awesome-local-first, https://github.com/sdkks/awesome-localdb, https://www.inkandswitch.com/local-first/, https://github.com/getzep/graphiti, https://duckdb.org/science/

- **Ink & Switch "Local-First Software" essay** — https://www.inkandswitch.com/local-first/ — the founding manifesto: data ownership, offline capability, long-lived data outliving apps (seven ideals). *Why:* RelateDB's WAL+Parquet-on-your-filesystem story is local-first ideology made concrete for graphs — read and cite this to place the project in a movement with its own conferences (https://localfirstconf.com).
- **Ink & Switch "Upwelling" and "Patchwork"** — https://www.inkandswitch.com/upwelling/, https://www.inkandswitch.com/patchwork/notebook/ — CRDT collaboration with *branching and history layers* for non-code apps. *Why:* branching a graph database (aergoio/litetree does branches for SQLite — https://github.com/aergoio/litetree) is an unclaimed killer feature: `relate branch` for experimentation, agent sandboxes, what-if analytics.
- **LiveStore** — https://livestore.dev — event-sourced app framework on in-memory SQLite, treating the event log as the app state source of truth. *Why:* RelateDB is in-memory + WAL — an event-sourced app framework on top is nearly free and very current.
- **Zero (Rocicorp) / PowerSync / Triplit** — https://zero.rocicorp.dev, https://www.powersync.com, https://triplit.dev — the sync-engine generation: reactive client stores with server sync. *Why:* whichever engine gives graphs a first-class sync story first wins the local-first graph niche; these are the UX bar to meet.
- **Kuzu** — https://github.com/kuzudb/kuzu (also in awesome-localdb's only two graph entries, with CozoDB) — embedded, columnar property-graph DB, "SQLite for graphs," Cypher-based, used in production and even as a Graphiti backend. *Why:* THE closest analog and the proof the niche exists; RelateDB's differentiators over it: in-memory speed, full openCypher TCK compliance, WASM/browser, Parquet durability, MCP/Bolt/HTTP, C ABI multi-language clients — a comparison page against Kuzu/CozoDB is itself a needed artifact.
- **Graphiti (getzep)** — https://github.com/getzep/graphiti — framework for real-time *temporal knowledge graphs* for AI agents: entities, time-windowed facts, episode provenance, hybrid (semantic + BM25 + traversal) retrieval; backends Neo4j/FalkorDB/Neptune; powers Zep's agent memory; ships MCP + REST servers. *Why:* the clearest signal of what agents want from a graph DB — temporal validity, provenance, hybrid retrieval over relationships. RelateDB could be the self-hostable, embedded backend Graphiti-style tools are missing (they even tried Kuzu then deprecated it).
- **Agent-memory landscape (Zep, Letta/MemGPT, mem0, cognee)** — https://github.com/mem0ai/mem0, https://github.com/letta-ai/letta, https://www.cognee.ai — memory vendors converge on graphs + vectors as agent substrate; mem0 has a PR adding Kuzu as a graph-memory backend (https://github.com/mem0ai/mem0/pull/2934). *Why:* "agent-native graph memory" is the market narrative of 2026; RelateDB + MCP + Cypher + vector search is a credible open, local, private alternative to every hosted memory vendor.
- **AgentDB / MCP-server-everything wave** — https://github.com/hvrcharon1/agentdb and the SQLite MCP-server list above — early "databases rebuilt around agent access patterns" experiments. *Why:* the category is being defined right now; an embedded graph DB with MCP-first ergonomics (schema introspection tools, visualization tools, read-only safety modes — RelateDB already has agent-safety references in its skill) can define the "agent-native" reference architecture instead of following it.
- **Obsidian/Logseq/Anytype + SQLite-in-Notion** — https://obsidian.md, https://logseq.com, case studies in awesome-local-first — local files/DBs as the substrate for end-user knowledge tools. *Why:* personal knowledge graphs are the consumer face of property graphs; RelateDB as the embedded engine under an Obsidian-like tool (graph queries over your notes, fully offline) is a flagship-app opportunity no other engine can serve as well.

## Cross-cutting patterns worth stealing

1. **One binary, multiple deployment modes, one story** (clickhouse-local, Turso, libSQL): embed / WASM / serve / MCP as modes of the same product.
2. **Embedded replicas + WAL shipping = edge platform** (Turso, litefs, litestream): RelateDB's WAL+Parquet is the right substrate; an async S3/origin replication mode turns an embedded engine into an edge database.
3. **The browser demo is the funnel** (duckdb-wasm shell, PGlite homepage REPL, Huey): a homepage in-browser Cypher REPL + playground with seeded demo graphs.
4. **Extension/community registry** (sqlite-vec, sqlean, duckdb community-extensions): the C ABI is the seam; `relate` extension distribution builds an ecosystem flywheel.
5. **Agents are the new application tier** (Graphiti, MCP-SQLite wave, spice.ai, duckdb-acp): MCP-first ergonomics, temporal fact tracking, hybrid retrieval, agent-safety read modes — RelateDB already has most pieces; the missing narratives are temporal validity/provenance and a flagship agent-memory showcase.
6. **Flagship example apps beat feature lists** (Linearlite, Flipt, Undb): one real app at real scale (100k rows, offline, local-first) per surface — browser, edge device, agent.
7. **A GUI/Studio is table stakes** (DB Browser, libSQL Studio, Harlequin, Datasette): browser studio + TUI + read-only publishing tool for `.relate` files.
8. **Own a scientific/niche workload** (DuckDB-in-science, Splink): entity resolution / record linkage / provenance graphs are natively Cypher-shaped and underserved.
