---
type: Research
name: sqlite-everywhere
INFORMS:
  - "[[Project/family-tree-but-with-the-awkward-parts]]"
  - "[[Project/friendship-archipelago]]"
  - "[[Project/on-device-agent-graph-store]]"
  - "[[Project/transitive-dependency-networks]]"
  - "[[Project/user-journey-recorder]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Mozilla]]"
  - "[[Company/Tencent]]"
  - "[[Company/Turso]]"
MENTIONS_PERSON:
  - "[[Person/Richard Hipp]]"
RELATED_IDEA:
  - kind: same-data
    reason: Gramps stores family trees in SQLite as blobs that want to be a property graph
    target: "[[Project/family-tree-but-with-the-awkward-parts]]"
  - kind: same-data
    reason: messenger stores are the strongest graph-native class found in the audit
    target: "[[Project/friendship-archipelago]]"
  - kind: same-data
    reason: lockfile dependency graphs exist precisely because no embeddable graph engine did
    target: "[[Project/transitive-dependency-networks]]"
  - kind: complements
    reason: browser history analysis is the forensic layer this audit separates from recording
    target: "[[Project/user-journey-recorder]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/Turso]]"
  - "[[Technology/WASM]]"
  - "[[Technology/osquery]]"
---

# Research findings: SQLite runs the world — how much of it is secretly graph-shaped?

*Collected 2026-10-23 as inspiration research for the relate-ideas list.
Question asked: SQLite ships in trillions of instances across billions of devices,
in every app class from set-top boxes to CRMs. Which of those app/use-case classes
would genuinely benefit from an actual graph database — and where is SQLite already
the right tool that should be left alone? Profile used as the lens: RelateDB is
an embedded in-memory property-graph engine, single binary, fsync'd WAL + Parquet
checkpoints, openCypher TCK dialect, WASM/browser build, MCP server, Bolt/HTTP APIs,
C ABI wrapped by Python/JS/Java/Go clients — "the SQLite of graph databases."*

The honest headline, up front: most of the SQLite footprint is not graph-shaped and
should never convert. The audit below finds **5 genuinely graph-native classes,
3 graph-adjacent classes, and a long unapologetic "leave it alone" list**. The
"leave it alone" section is the load-bearing one — without it the rest is a pitch,
not an audit.

## 1. The evidence base: SQLite at trillion scale

- **sqlite.org's own scale claims** — https://www.sqlite.org/mostdeployed.html —
  "there are more than 4.0 billion (4.0e9) smartphones in active use, each holding
  hundreds of SQLite database files, it seems likely that there are over one
  trillion (1e12) SQLite databases in active use"; "SQLite is probably one of the top
  five most deployed software modules of any description"; "our best guess is that
  SQLite is the second mostly widely deployed software library, after libz."
  **Caveat, stated by SQLite itself:** the page is a chain of hedged estimates
  (*likely → probably → best guess → might*) and concedes "Precise numbers are
  difficult to obtain and so exact rankings are impossible." SQLite publishes **no
  download counts** anywhere on sqlite.org (checked mostdeployed.html and
  about.html) — the trillion figure is inference from device counts, not telemetry.
- **The VLDB 2022 paper** — Gaffney, Prammer et al., "SQLite: Past, Present, and
  Future," https://www.vldb.org/pvldb/vol15/p3535-gaffney.pdf (PVLDB vol. 15) —
  the peer-reviewed version of the scale story: "the most widely deployed database
  engine in existence," "found in every iOS and Android device, which currently
  number in the billions," "There are likely over one trillion SQLite databases in
  active use." Equally important for us: its workload character — SQLite is
  "primarily designed for fast online transaction processing (OLTP)," row-oriented,
  B-tree storage, "embedded in major web browsers, personal computers, smart
  televisions, automotive media systems, and the PHP and Python programming
  languages." People run analytical queries on it anyway (the paper's contribution
  was making SQLite "up to 4.2X faster on SSB"), but the shape it is *deployed* in
  is short local transactions, not big joins.
- **The app-file-format essay** — https://www.sqlite.org/appfileformat.html —
  SQLite's own case for being the *fourth category* of application file format
  (after custom binary blobs, pile-of-files, and wrapped pile-of-files): single
  portable file, atomic transactions, incremental updates, schema-as-documentation.
  This essay is the exact template for RelateDB's `.cl` file story — "a
  high-level, stable, reliable, cross-platform, widely-deployed, extensible,
  performant, accessible, concurrent file format." *Why:* RelateDB should write
  (or already write) the same essay with a graph schema instead of tables; the
  quoted Torvalds line ("Good programmers worry about data structures and their
  relationships") is even graph-shaped already.
- **Well-known users** — https://www.sqlite.org/famous.html — Microsoft ("core
  component of Windows 10"), Google (Android, Chrome), Apple (iOS, macOS,
  iTunes — "even on non-Apple hardware"), Mozilla ("SQLite is the primary
  meta-data storage format for the Firefox Web Browser … and the Thunderbird
  Email Reader"), Dropbox client, Adobe Photoshop Lightroom (as its application
  file format), Bosch ("multimedia systems install on GM, Nissan, and Suzuki
  automobiles"), Airbus ("flight software for the A350 XWB"), PHP and Python
  distributions, RPM, Library of Congress (recommended preservation format).
  https://www.sqlite.org/mostdeployed.html adds "most television sets and set-top
  cable boxes" and "most automotive multimedia systems." *Why:* these are the
  deployment classes the audit below walks through one by one.
- **Richard Hipp, first person** — CoRecursive episode 066,
  https://corecursive.com/066-sqlite-with-richard-hipp/ — "the most used database
  in the world … by some counts, it's the most widely deployed software module of
  any type," "It's in your web browser, it's in your phone, it's probably in your
  car, it's definitely in commercial planes," and the key line for the messenger
  class: "It's where your iMessages and WhatsApp messages are stored." Also the
  origin story that explains the reliability obsession (a warship, "smoke and
  blood and chaos," DO-178B branch-coverage testing).
- **WeChat / WCDB — SQLite at messenger scale, with scars** —
  https://github.com/Tencent/wcdb — Tencent's cross-platform database framework
  built on SQLite + SQLCipher, "used in the WeChat application," with a "repair kit
  for database corruption recovery," connection pooling, migration tooling, and
  Zstd field compression. The team's writeups (in Chinese) live on Tencent Cloud's
  developer community, e.g. https://cloud.tencent.com/developer/article/1005623
  ("WeChat client SQLite database repair practice") with an English summary at
  https://www.besthub.dev/articles/how-wechat-solved-sqlite-corruption-inside-wcdb-s-multi-layer-recovery-strategies-1524a9a760d0 .
  A related repair writeup (https://engineered.at/articles/repairing-database-on-the-fly-for-millions-of-users)
  describes the pattern for "a messaging app" on "billions of devices" without
  naming WeChat — treat that attribution as unconfirmed. **Caveat:** neither the
  WCDB repo nor these pages state WeChat's user count; don't repeat a number here
  that no source on this page pins down.
- **SQLite in the browser** — phiresky's sql.js-httpvfs,
  https://phiresky.github.io/blog/2021/hosting-sqlite-databases-on-github-pages/ +
  https://github.com/phiresky/sql.js-httpvfs — read-only SQLite over HTTP Range
  requests against a static host; demo serves a 670 MiB / 8-million-row World Bank
  database where a typical query fetches 130–270 KiB. The official
  @sqlite.org/sqlite-wasm build (the first WASM port "officially associated with
  the SQLite project") with OPFS persistence:
  https://developer.chrome.com/blog/sqlite-wasm-in-the-browser-backed-by-the-origin-private-file-system .
  Extension ecosystem: sqlean, https://github.com/nalgeon/sqlean . *Why:* this is
  the lane RelateDB's WASM build occupies for graphs; read-only static hosting of
  a `.cl` file is the direct analog of phiresky's trick.
- **Turso** — https://turso.tech/ — "Built on SQLite. Lightweight enough to
  multiply, fast enough to run anywhere," a "ground-up rewrite of SQLite" and
  "drop-in replacement," marketed as "a database for every user, agent, and
  tenant." *Why:* the commercial proof that the SQLite deployment model (embed,
  one file per thing, no server) is a platform, not a limitation — the positioning
  RelateDB inherits for graphs.

## 2. The audit — app classes, classified honestly

The classification bar, borrowed from SQLite itself: a class converts to a graph
engine only if its *core data is relationships* and its *hot queries are
multi-hop / traversal / pattern-shaped*. If the hot queries are single-entity CRUD
or sequential scans, SQLite is the right tool and stays.

### (a) Graph-native — the data is relationships and the queries are traversals

1. **Messenger stores (the strongest one).** The real apps: WhatsApp (Android
   `msgstore.db`, SQLite — schema documented by
   https://github.com/andreas-mausch/whatsapp-viewer and
   https://belkasoft.com/android-whatsapp-forensics-analysis), Telegram (TDLib's
   persistence layer is SQLite — https://github.com/tdlib/td), iMessage (Hipp's own
   testimony, above), WeChat (WCDB, above). The graph is already there: reply
   threads, quoted-message chains, group membership, forwarding provenance,
   contact graphs, message→sender→device lineage. What SQL does today is
   denormalized per-chat tables plus recursive CTEs for anything thread-shaped —
   the same joins a graph engine makes one `MATCH` path. What it would need from
   RelateDB: mobile-embeddable C ABI, incremental checkpointing, and — the hard
   lesson from WCDB — a corruption-repair and backup story at production quality,
   because a messenger's local store is the *least* deletable data a user has.
2. **Genealogy.** The real app: Gramps,
   https://gramps-project.org/wiki/index.php/Database_Backends — "Beginning with
   the Gramps 5.1 version, SQLite is the default database engine." The telling
   detail: Gramps uses SQLite "as a data store" holding serialized pickled blobs —
   it doesn't even use the relational layer, because family trees (people,
   marriages, events, places, citations, with the awkward parts: remarriages,
   half-siblings, adoption) resist table joins and get traversed in application
   code. A property graph is the honest schema for this data; ancestor lines,
   cousin distance, and "how am I related to" are path queries. Covered in the
   list already (see §3), so evidence, not a new idea.
3. **Endpoint security and audit lineage.** The real app: osquery —
   https://osquery.readthedocs.io/en/latest/introduction/sql/ ("The osquery SQL
   language is a superset of SQLite's"; "think of your operating system as a
   series of tabular concepts"), https://github.com/osquery/osquery, and Kolide's
   internals piece https://www.kolide.com/blog/osquery-under-the-hood . Incident
   responders' hottest question is a traversal: process→parent→grandparent
   chains, socket→process→binary→hash, autorun→file→signature. In SQL that is
   self-joins and recursion over pid/ppid columns; in a property graph it is a
   native path. **Caveat:** the entitlement end of this class (Windows ACL
   inheritance chains, nested group expansion, Android permission delegation) is
   the same graph shape but has no flagship *SQLite* app to anchor to — the data
   lives in proprietary OS stores; flag that honestly rather than force an anchor.
4. **Versioned DAGs and dependency graphs.** The real app for the DAG shape:
   Fossil, SQLite's own version control system, which stores its check-in DAG in
   an SQLite file and uses transactions to verify "no history is lost before each
   commit" (https://www.sqlite.org/appfileformat.html). The honest adjacent note:
   package managers (npm, cargo, pip) keep their transitive dependency graphs in
   lockfiles and JSON *precisely because no embeddable graph engine existed* —
   resolution, SBOM↔CVE blast radius, and license propagation are multi-hop
   traversals over data that already has the shape. Covered in the list (Transitive
   Dependency Networks, Dependency Radar), so evidence, not a new idea.
5. **Entity resolution / contact dedup.** The shape is pure graph (records,
   candidate-match edges, survivorship, connected components of "same person"),
   and the demand is proven at scale by Splink (https://github.com/moj-analytical-services/splink,
   record linkage over an embedded columnar engine). **Caveat:** the SQLite-side
   anchor is thin — the flagship implementations run on DuckDB/Postgres, not
   SQLite; classify it graph-native on data shape, but flag that SQLite itself
   never won this class, which is exactly the opening.

### (b) Graph-adjacent — relational today, a graph projection helps *some* queries

1. **Media libraries.** The real app: Kodi — "Kodi uses SQLite, an open source
   light-weight SQL database-engine" holding "all the library, add-on, EPG,
   textures and PVR related data" (https://kodi.wiki/view/Databases — MyVideos,
   MyMusic, and six more). Mostly single-entity CRUD ("where is this file, have I
   watched it") — leave it — but the browsable queries ("other films by this
   director's frequent collaborators in genres I finish") are actor→film→genre
   traversals. A graph *projection* for discovery, not an engine swap.
2. **Browser history and bookmarks.** The real app: Firefox's `places.sqlite`
   (https://firefox-source-docs.mozilla.org/browser/places/architecture-overview.html),
   plus the forensic ecosystem that archaeologically mines it
   (https://psmths.gitbook.io/windows-forensics/artifacts-by-activity/browser-activity/history/firefox-places-sqlite,
   Belkasoft et al.). The schema is already visit→url→referrer links, and forensic
   questions (session reconstruction, download provenance, cross-site tracking)
   are path questions over that link structure. For the *user-facing* features
   SQLite stays right; for the *analysis* layer a graph helps.
3. **CRM-in-an-app.** A real, verifiable example of the genre: a small SaaS sales
   pipeline on SQLite (https://dev.to/hassan_4e2f0901edda/sqlite-as-a-crm-why-we-chose-the-simplest-database-for-our-sales-pipeline-gjj).
   Mostly flat joins (activity→contact→company); the graph win is narrow —
   referral chains and relationship history. This is the borderline class: it
   converts only when the *feature* (who introduced whom) becomes the product.

### (c) SQLite is right — leave it alone

This is the credibility section, and SQLite's own decision document
(https://www.sqlite.org/whentouse.html) does the classifying: "SQLite does not
compete with client/server databases. **SQLite competes with fopen()**." The
classes below are fopen()-shaped and a graph engine is a cost, not a win:

- **Settings and configuration stores** — write-once, read-at-startup, no
  relationships. Every one of the billions of phone/browser installs from §1.
- **Caches** — SQLite's own listed use case ("Cache for enterprise data":
  content snapshots from an origin RDBMS for latency and offline operation).
- **Single-entity CRUD** — to-do lists, form drafts, save-game state, the long
  tail of "millions of applications" from famous.html. One table, no traversal.
- **Sequential event logs and telemetry buffers** — append-only, read in order or
  aggregated; a log is a list, not a graph, until someone asks a path question
  over it (and at that point the *analysis* is §2a/2b, not the store).
- **Queues** — FIFO with transactions; this is what SQLite's OLTP core is for.
- **Key-value with SQL sugar** — SQLite explicitly: "A key/value database is
  better than no database at all."
- **File containers / archives** — the SQLite Archive-as-ZIP-substitute role
  (https://www.sqlite.org/appfileformat.html, https://www.sqlite.org/whentouse.html).
  A container of files has an *implied* graph at most; shipping `.cl` as "a better
  ZIP" would be re-pitching §(c) as a feature.
- **The bulk of IoT/device-local capture** — sensor append, thermostat state,
  the "cellphones, set-top boxes, televisions, watches, kitchen appliances" list
  from whentouse.html. The device is a *host* for a graph (see the agent-store
  ideas already in the list), but the sensor log itself is not graph-shaped.

The one-line bar any conversion claim must survive, borrowed from whentouse's
own checklist inverted: if it is device-local, single-writer, and the queries are
single-hop — **keep SQLite**. Only when the query needs the *second* hop and the
data was relationships all along does RelateDB earn the slot.

## 3. Conclusions — what converts, what the list already covers, what's new

**What converts:** exactly the §2a five — messenger stores, genealogy, endpoint
security/audit lineage, versioned/dependency DAGs, entity resolution — plus graph
*projections* (not engine swaps) inside the §2b three.

**What the repo already covers** (checked against the README's ~166 ideas across
19 sections): messenger/contacts ("Friendship Archipelago", "Your Follow Graph",
the whole "Your Digital Life as a Graph" section), genealogy ("Family Tree, But
With the Awkward Parts", "Franchise Genealogy", "History as Graph", "Music
Genealogy"), dependency DAGs ("Transitive Dependency Networks", "Dependency
Radar", "Software & Code Intelligence" generally), entity resolution ("Entity
Resolution (MDM)" in the Use-Case Gallery; dedup with reviewable matches in
Authoring & Projection), media recommendations ("The Movie Graph, All Grown Up",
"Reading-List Recommender That Shows Its Work"), browser self-tracking
("User-Journey Recorder", "In-Browser Knowledge Extraction"), and on-device
storage generally ("On-Device Agent Graph Store"). Coverage of the convertible
classes is strong — the gaps are flavor gaps, not class gaps.

**Genuinely-new candidates** (report only — the parent session decides; 0–5
asked, four offered):

1. **"osquery, but graph" — endpoint state as traversals.** A single-binary
   RelateDB on the endpoint (or on a triage disk image) ingesting process
   trees, sockets, autoruns, and file signatures, where the incident-response
   questions ("give me the full ancestry of everything that touched this file")
   are native path queries instead of osquery's recursive self-joins. The
   Cybersecurity section has attack-path simulation and log replay, but not the
   *live OS-state-as-graph* angle with osquery as the named lineage.
2. **Permission / entitlement graph auditor.** Windows ACL inheritance chains,
   nested-group expansion, sudoers/role delegation — all transitive-closure
   problems painfully done with iterative scripts today. Honest caveat from §2a:
   no flagship SQLite app anchors this; it converts on data shape, anchored to
   the enterprise-IT pain instead. Adjacent to "Configuration Misconvergence" and
   "Crew Org Chart" but neither covers OS/file entitlement chains.
3. **"Graph WCDB" — the messenger-store role, developer-facing.** Not another
   consumer analysis of your chats (Friendship Archipelago covers that), but the
   developer product: an embeddable graph store for messaging apps with the
   WCDB-grade ops (corruption repair, incremental backup, encryption) that made
   SQLite survive at WeChat scale. This is the §2a #1 finding turned into an
   idea entry; nothing in the list currently owns the "be the local store of a
   chat app" position.
4. **Browser-history forensics workbench.** places.sqlite / Chrome History →
   `.cl` graph for investigators (session reconstruction, referrer and download
   chains, artifact lineage), distinct from "User-Journey Recorder" (which
   records *your own* browsing). Anchored by the existing forensic tooling around
   SQLite browser artifacts; the graph engine is the missing analysis layer.

**What does not convert, full stop:** everything in §2c — and RelateDB should
say so out loud. "The SQLite of graph databases" wins trust by conceding most of
SQLite's trillion-instance kingdom is fopen-with-indexes, then being unreasonably
good at the part that is actually relationships.

## Sources

- https://www.sqlite.org/mostdeployed.html
- https://www.sqlite.org/famous.html
- https://www.sqlite.org/about.html
- https://www.sqlite.org/appfileformat.html
- https://www.sqlite.org/whentouse.html
- https://www.vldb.org/pvldb/vol15/p3535-gaffney.pdf
- https://corecursive.com/066-sqlite-with-richard-hipp/
- https://github.com/Tencent/wcdb
- https://cloud.tencent.com/developer/article/1005623
- https://www.besthub.dev/articles/how-wechat-solved-sqlite-corruption-inside-wcdb-s-multi-layer-recovery-strategies-1524a9a760d0
- https://engineered.at/articles/repairing-database-on-the-fly-for-millions-of-users
- https://phiresky.github.io/blog/2021/hosting-sqlite-databases-on-github-pages/
- https://github.com/phiresky/sql.js-httpvfs
- https://developer.chrome.com/blog/sqlite-wasm-in-the-browser-backed-by-the-origin-private-file-system
- https://github.com/nalgeon/sqlean
- https://turso.tech/
- https://github.com/tdlib/td
- https://github.com/andreas-mausch/whatsapp-viewer
- https://belkasoft.com/android-whatsapp-forensics-analysis
- https://gramps-project.org/wiki/index.php/Database_Backends
- https://osquery.readthedocs.io/en/latest/introduction/sql/
- https://github.com/osquery/osquery
- https://www.kolide.com/blog/osquery-under-the-hood
- https://github.com/moj-analytical-services/splink
- https://kodi.wiki/view/Databases
- https://firefox-source-docs.mozilla.org/browser/places/architecture-overview.html
- https://psmths.gitbook.io/windows-forensics/artifacts-by-activity/browser-activity/history/firefox-places-sqlite
- https://dev.to/hassan_4e2f0901edda/sqlite-as-a-crm-why-we-chose-the-simplest-database-for-our-sales-pipeline-gjj
