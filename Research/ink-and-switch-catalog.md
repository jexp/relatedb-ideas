---
type: Research
name: ink-and-switch-catalog
INFORMS:
  - "[[Project/cambria-for-graphs]]"
  - "[[Project/clone-fork-pull-push]]"
  - "[[Project/diff-view-for-graphs]]"
  - "[[Project/keyhive-share-menu]]"
  - "[[Project/obsidian-vfs-native]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Ink & Switch]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: Cambria lenses become a stored lens graph over schema versions
    target: "[[Project/cambria-for-graphs]]"
  - kind: complements
    reason: branching and history layer over the WAL
    target: "[[Project/clone-fork-pull-push]]"
  - kind: complements
    reason: version history and structural diffs over graph changes
    target: "[[Project/diff-view-for-graphs]]"
  - kind: inspired-by
    reason: capability based sharing mapped onto graph authorization
    target: "[[Project/keyhive-share-menu]]"
USES_TECH:
  - "[[Technology/Cambria]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Keyhive]]"
  - "[[Technology/WASM]]"
---

# Ink & Switch Catalog

*Collected 2026-10-23 as inspiration research for the relate-ideas list.
Lens: RelateDB is an embedded in-memory property graph, Cypher, single binary,
WASM in the browser, one portable `.cl` store with WAL + checkpoint durability,
built-in MCP + Bolt/HTTP. Ink & Switch is the independent research lab behind
local-first software, Automerge, and a decade of "tools for thought" research
(https://www.inkandswitch.com/).*

Already-covered overlap in this repo (excluded from the project ideas below):
offline-first sync to a central origin (the-pouchdb-move, clone-fork-pull-push),
CRDT-ish node/edge merging (team-wiki-from-a-shared-file, diff-view-for-graphs),
agent memory graphs (graph-native-agent-memory, agent-trace-warehouse), personal
knowledge graphs (cy-your-personal-knowledge-graph, decision-journal).

## The works

Essays (index: https://www.inkandswitch.com/essay/ — 17 entries, reverse
chronological; titles/taglines verified against that page):

- **Local-first software: You own your data, in spite of the cloud** (2019) — https://www.inkandswitch.com/essay/local-first/ — the founding essay: seven ideals (no spinners, multi-device, offline, seamless collaboration, the Long Now, privacy by default, ultimate ownership); CRDTs as the enabling tech, cloud demoted to a secondary "cloud peer."
- **Slow software: Observations on latency** (2018) — https://www.inkandswitch.com/slow-software/ — users judge software by latency, not throughput; fast software is achievable and most software chooses not to be.
- **End-user programming: Empowered computing** (2019) — https://www.inkandswitch.com/end-user-programming/ — the forty-year vision of users as programmers, and why it keeps not happening.
- **Muse: Designing a studio for ideas** (2019) — https://www.inkandswitch.com/muse/ — a fast, fluid freeform-canvas thinking tool modeled on physical workspaces (now shipping as Allume, https://allume.com).
- **Capstone: A tablet for thinking** (2018) — https://www.inkandswitch.com/capstone/ — cards and inking on a freeform canvas for the two-step creative process.
- **Pixelpusher: Real-time peer-to-peer collaboration with React** (2018) — https://www.inkandswitch.com/pixelpusher/ — early exploration of CRDTs (then "causal trees") enriching a creative drawing app.
- **PushPin: Towards production-quality peer-to-peer collaboration** (2020) — https://www.inkandswitch.com/pushpin/ — taking P2P beyond research prototypes toward commercial-grade collaboration; media canvas + extensible tools.
- **Cambria: Translate your data with lenses** (2020) — https://www.inkandswitch.com/cambria/ — bidirectional lenses as an isolated layer translating data between schemas on demand; lenses form a graph and Cambria routes through it (code: https://github.com/inkandswitch/cambria).
- **Backchannel: A relationship-based digital identity system** (2021) — https://www.inkandswitch.com/backchannel/ — a design experiment: identity grounded in who vouches for you (relationships), not attributes you claim about yourself.
- **Peritext: A CRDT for rich-text collaboration** (2021) — https://www.inkandswitch.com/peritext/ — plain-text CRDTs (RGA/Logoot) mangle rich text (bold spans, comments); Peritext models formatting as a range map over characters (code: https://github.com/inkandswitch/peritext).
- **Crosscut: Drawing dynamic models** (2022) — https://www.inkandswitch.com/crosscut/ — uniting the directness of pen & paper with the dynamism of software; drawings with behavior.
- **Potluck: Dynamic documents as personal software** (2022) — https://www.inkandswitch.com/potluck/ — gradually enriching plaintext documents into interactive applications, formality on demand.
- **Inkbase: Programmable ink** (2022) — https://www.inkandswitch.com/inkbase/ — hand-drawn sketches programmable like spreadsheets; the "programmable ink" research line's flagship.
- **Untangle: Solving problems with fuzzy constraints** (2023) — https://www.inkandswitch.com/untangle/ — pen-based sketching of constraint problems with spatial-query rules, and browsing "good enough" candidate solutions rather than formally optimal ones.
- **Upwelling: Combining real-time collaboration with version control for writers** (2023) — https://www.inkandswitch.com/upwelling/ — writers get creative privacy (local edits not instantly broadcast) with accountability (deliberate publishing of change sets).
- **Embark: Dynamic documents for making plans** (2023) — https://www.inkandswitch.com/embark/ — live data and computation gradually enriching informal travel plans.
- **Malleable software: Restoring user agency in a world of locked-down apps** (2025) — https://www.inkandswitch.com/essay/malleable-software/ — the agenda piece: a "gentle slope" from user to creator, tools (composable, shared-data) instead of apps, communal creation; LLM coding as accelerant but not substitute.

Research projects and lab notebooks (index:
https://www.inkandswitch.com/project/ — 39 numbered projects; pages exist for
the ones linked below):

- **Automerge** — https://automerge.org — the lab's production CRDT library (JSON documents, full history, branching/merging) that grew out of Pixelpusher/PushPin; everything else rides on it.
- **Patchwork** — https://www.inkandswitch.com/patchwork/ (notebook: https://www.inkandswitch.com/patchwork/notebook/2024-version-control/) — "version control for everything": dynamic history, edit groups, simple branching/merging, AI bots as branch collaborators, version history as chat, universal comments via pointers, beyond prose to diagrams and spreadsheets.
- **Keyhive** — https://www.inkandswitch.com/keyhive/ — capabilities-based access control for local-first software: signed, non-extractable local keys; per-document capability checks; ops sync over the same stack; a share-menu UI mapped onto issuing/revoking capabilities (per https://www.inkandswitch.com/newsletter/dispatch-014/).
- **Cambria** — https://www.inkandswitch.com/cambria/ — the lens library above, as a project.
- **Backstitch** — https://www.inkandswitch.com/backstitch/ — real-time version control inside the Godot game engine; diff visualizations and structural changes for scene files (lab note: https://www.inkandswitch.com/backstitch/notebook/01/).
- **Livelymerge** — https://www.inkandswitch.com/livelymerge/notebook/ — a collaborative programming kernel with shared object memory; a Morphic/Lively-style world where live objects merge (notebook entries lm-01…lm-07).
- **Ambsheets** — https://www.inkandswitch.com/ambsheets/ (LIVE 2025 paper: https://www.inkandswitch.com/ambsheets/live25/) — spreadsheets for exploring scenarios, from the dynamic-documents line.
- **Subduction** — per https://www.inkandswitch.com/newsletter/dispatch-014/ — a sync approach that streams only the minimal state needed to reconcile peers instead of materializing whole documents.
- **GAIOS** — per https://www.inkandswitch.com/newsletter/dispatch-014/ — the lab's ARIA Safeguarded AI contribution: a malleable, collaborative platform derived from Patchwork for uniting modelling/simulation tools, with interoperability and version control handled by Automerge.
- **Allume (formerly Muse)** — https://allume.com — the lab's production spinout: a visual workspace for notes, sketches, and PDFs.
- Earlier projects (LiveBook, TextNotes, DraftKraft, Trellis, Badge, PixelPusher, Dossier, Rectoverse, KSP, Farm, Ink Explorations, Automerge-RS, Inkling, Trail Runner, Habitat, Heart Transplant, Sketchpad, Venice, PlayBook, Jacquard) are listed at https://www.inkandswitch.com/project/ — most without dedicated pages yet.

Research-area hubs: local-first software
(https://www.inkandswitch.com/local-first-software), malleable software
(https://www.inkandswitch.com/malleable-software), programmable ink
(https://www.inkandswitch.com/ink), universal version control
(https://www.inkandswitch.com/universal-version-control). Newsletter (the
Dispatch): https://www.inkandswitch.com/newsletter/ — dispatch-014
(https://www.inkandswitch.com/newsletter/dispatch-014/) covers GAIOS,
Keyhive, Subduction, Ambsheets, Backstitch; dispatch-016
(https://www.inkandswitch.com/newsletter/dispatch-016/) is the ten-year
"Tenfold" retrospective.

## RelateDB-shaped project ideas

Five ideas that go beyond what this repo already lists. (Considered and
excluded as already-covered: local-first sync, CRDT merging, agent memory,
personal knowledge graphs, diff view / blame over the WAL — the PouchDB move,
team wiki, clone/fork/pull/push, diff-view-for-graphs already claim that
ground.)

**1. Cambria for graphs — the lens graph (schema evolution as a stored
graph).** Cambria's core move is that schema versions are not a linear
migration ladder but a *graph of bidirectional lenses*, with data routed
through the shortest path, so multiple schema versions can interoperate at
once with no central authority. RelateDB is unusually well-shaped for this:
the lens registry is itself a property graph — `(:SchemaVersion)` nodes,
`(:Lens {direction: bidirectional})` edges — and each lens body is a pair of
Cypher transformation queries. The engine capability this leans on is the
single portable `.cl` store as the Long Now artifact: an old checkpoint is
never "unreadable," it's a node in the version graph, and `relate open
old.cl --lens-path v3` materializes it through the lens chain into today's
shape. Schema evolution becomes queryable ("which fields have been renamed
three times," "which lens paths are losing data"), agents can author lens
candidates over MCP, and the WAL gives every transformation an auditable
replay log. Where the repo's graph-lens-over-any-database idea is a lens
*across databases* (read Cypher over tables), this is Cambria's lens *across
time* — the two compose.

**2. Patchwork's dynamic history, on the WAL — history as chat, milestones,
edit groups, universal pointers.** Patchwork's most transferable findings are
UX-shaped, not CRDT-shaped: auto-saved history that you flexibly query, named
milestones over a continuous change stream, "edit groups" bundling granular
writes into human-meaningful units, history rendered as a chat-like timeline,
AI summaries of change sets, and "universal comments" via pointers that anchor
in any view. RelateDB already has the substrate — the fsync'd WAL *is* the
continuous change stream, and checkpoints *are* milestones. The project: a
history layer above the WAL where every entry is a graph node (`:ChangeGroup`
of `:Write` ops, `:Milestone`, `:Summary`), so "what have we been doing?" is a
Cypher query and an agent-written summary lands as a `(:Summary)-[:SUMMARIZES]->(:ChangeGroup)`
edge. The Patchwork notebook's "version history as chat" is literally this
data model. Universal pointers translate to annotation nodes anchored to
subgraph *selections* (a Cypher pattern as the anchor), which makes
"commenting on any graph view" one mechanism instead of per-tool UIs. Leans
on: WAL as history, checkpoint-as-milestone, MCP/agents for summarization,
hybrid search over change-set text ("what changed about the Munich leg of the
trip?").

**3. Keyhive's share menu — the capability graph for local-first access
control.** Keyhive reframes sharing as capabilities signed by local keys,
issued and revoked per document, synced over the same stack as the data. For
RelateDB the natural shape is *authorization as a graph*: `(:User/:Key)`
nodes, `(:Capability {scope, expires})` edges to `(:Store)`, `(:Label)`, or an
arbitrary subgraph pattern ("can read anything `(:Project {name:'Aurora'})`-reachable").
The two payoffs: (a) `relate serve --http/--mcp/--bolt` gets
per-request capability checks that are ordinary Cypher, extending the existing
auth work (relate-auth) from "one token for the server" to "scoped
subgraph grants" — exactly what you want before pointing an agent at your
personal graph over MCP; (b) sharing a graph becomes portable — "here's the
`.cl` file plus a capability grant for Bob's key" — with revocation enforced
at open time, and the grant list itself living in the store so it syncs with
the file. Leans on: single-file portability, MCP/Bolt/HTTP surfaces, Cypher
as the policy query language, WAL to log every grant/revoke.

**4. Backchannel — relationship-based identity, a vouching graph you can
carry.** Backchannel's insight is that self-claimed identity attributes are
cheap to fake; *relationships* — who introduces you, who vouches for you —
are the honest signal, and introductions are events between two people, not
rows in a directory. This maps to a portable Web-of-Trust: `(:Person/:Key)`
nodes, `[:INTRODUCED_TO {when, context}]` and `[:VOUCHES_FOR {strength,
scope}]` edges, every introduction carrying a signature from both endpoints.
The RelateDB angle is the file: your identity "wallet" is one `.cl` file
you own and carry (phone via the C ABI, browser via WASM), not an account on
someone's server — the local-first ownership ideal applied to identity
itself. Trust questions become traversals: "is there any unbroken vouching
path from my key to this stranger's," scoped by relationship type, decayed by
edge age. And a handshake between two RelateDB holders is a WAL exchange —
each side merges the introductions it witnessed. This is distinct from the
repo's social-graph ideas (your-follow-graph, friendship-archipelago) in that
the graph *is the credential machinery*, not the social map being displayed.

**5. Embark/Potluck — dynamic documents for plans: an outline that grows a
graph underneath.** The dynamic-documents line (Potluck, Embark, Ambsheets)
has one shared move worth stealing: start from informal text and *gradually*
enrich it with structure and computation — formality on demand, never an
up-front schema. A plan (trip, project, move house) begins as an outline in
one pane; whenever an item crystallizes, it becomes a node — a place with
coordinates, a day with dates, a budget with numbers — and the document's
prose, the graph, and computed views stay linked ("what's still unscheduled,"
"which days are overloaded," "cheapest order to visit these cities"). Leans
on: WASM (the whole thing is a browser tab with the engine embedded), hybrid
search (find the paragraph that mentions Munich and link it to the `(:City)`
node), Cypher as the spreadsheet-formula layer over the plan, and the
`.cl` file as the plan's durable form — a plan you can hand to an agent over
MCP in ten years, because the document and the data were never two things.

(Honorable mention, if a sixth is wanted: Upwelling's *creative privacy* — a
private local branch over a shared store where edits accumulate invisibly
until deliberately published as a change set, i.e. junior-agent works on a
fork, the human reviews the WAL segment before it merges into the shared
graph. It is adjacent to clone/fork/pull/push but the asymmetry — one
reflecting author, one reviewing publisher — is not in that idea.)

## Local-first Conf leads

Ink & Switch co-organizes Local-first Conf (https://www.localfirstconf.com/).
Talk topics that map to embedded-graph applications, verified from the
published schedules (2025: https://app-2025.localfirstconf.com/schedule;
2026: https://app-2026.localfirstconf.com/schedule/day-1 and
/schedule/day-2):

- **"Agents on the canvas"** — Steve Ruiz (tldraw), LFC 2026 — agents operating on an infinite canvas; a canvas event/object log is a graph, and "the agent's model of the board" is a RelateDB store in the tab. Extends this repo's whiteboard-to-graph idea into the agent era.
- **"Plaintext-first apps in the age of agents"** — Tristan Edwards, LFC 2026 — plaintext/markdown vaults as agent substrate; the graph-shaped version is obsidian-vfs-native plus agents writing derived nodes over MCP.
- **"Local-first from the factory floor"** — Jeremy Theocharis (FreeCAD/Katana MRP), LFC 2026 — manufacturing data (BOMs, routings, work orders) is a classic property graph; an offline shop-floor RelateDB with sync is "your digital life as a graph" for small manufacturers, and nobody has written that project idea yet.
- **"Local-first Matrix"** — Kegan Dougal, LFC 2026 — decentralized chat; chat history/threads/reactions are graph-shaped, and a local embedded graph as the client-side store for a Matrix-like P2P protocol is a genuinely open niche.
- **"Local digital objects using zero-knowledge cryptography"** — Rob Knight, LFC 2026 — composes with the Backchannel capability/vouching idea above (grants with ZK proofs over a portable graph).
- **"Frontier LLM results, on device"** — RL Nabors, LFC 2026 — on-device RAG; hybrid search in a WASM RelateDB is exactly the retrieval substrate for this.
- **"Beyond Git: Real-Time Version Control for Godot"** — Lilith Duncan (Ink & Switch's Backstitch), LFC 2026 — scene/resource files as CRDTs; the graph-native version is diff-view-for-graphs applied to non-text assets.
- **"Tool engines"** — Pete Hayman, and **"The Harness Is the App"** — Sunil Pai (author of "ai agents are local first clients," https://sunilpai.dev/posts/local-first-ai-agents/), LFC 2026 — both are the malleable-software argument applied to agents; RelateDB as the shared data layer between user tools and agent tools.
- **"Towards a Local-First Desktop"** — Tobias Bernard / Andreas Dzialocha, LFC 2026 — desktop shell where apps share a data substrate; a graph engine embedded in the shell is the far edge of this.
- **"Stable Schemas, Mutable Software"** — Seph Gentle, LFC 2026 — the Cambria idea's cousin; schema stability across mutable implementations is what the lens-graph project answers for graphs.
- 2025 standouts for the same lens: **"Partial sync is a red herring"**, **"Global schemas"** (schema evolution at sync scale — the Cambria angle again), **"Postgres and local-first"**, **"Streaming a collaborative filesystem"** (a *filesystem* whose sync substrate is an embedded graph: files as nodes, hard links as edges), **"Every app secretly wants to be local-first"**, **"Local-first and social software"** (shared social graphs without a server — the friendship-archipelago idea with teeth), and **"Home-cooked software and barefoot programmers"** (the malleable-software audience: RelateDB as the database of home-cooked apps).
