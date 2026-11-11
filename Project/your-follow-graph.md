---
type: Project
name: your-follow-graph
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
RELATED_IDEA:
  - kind: complements
    reason: another browser plugin building a private local graph
    target: "[[Project/user-journey-recorder]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/NetworkX]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Your Follow Graph

> A browser plugin exports your (and friends', opt-in) follower/following graphs; explore 1st/2nd-degree neighborhoods, find bridges between communities — all locally.

## What

Your social platform knows your social graph better than you do — and shows you
deliberately tiny slices of it. This project takes it back. A browser plugin
scrapes or exports your follower/following list (and, with explicit opt-in, your
friends' lists too), builds the union as a property graph, and hands you the whole
neighborhood: `(:Account)-[:FOLLOWS]->(:Account)` with bio, follower count and
last-interaction properties.

The fun starts at 2nd degree. "Who do three different communities of mine all
follow that I don't yet?" — bridges between your worlds, one query. "Who unfollowed
me this month?" — a diff against last week's export, visualized. Ego networks,
community detection, mutual-follow clusters — the classic social-network-analysis
moves, run on *your* graph, in your browser.

The opt-in federated bit is the social twist: friends export their graphs, you
each share only the `.cl` files (the store is one file), and RelateDB unions
them — a collectively-owned map of a friend group that no platform hosts.

## Why RelateDB

Sensitive social data should never leave the device, and RelateDB's WASM build
makes that literal: the whole engine runs in the browser tab the plugin opened,
in-memory, with the export loaded straight in. No server, no account, no upload.
The single `.cl` file is the sharing primitive between opt-in friends — one
attachment, `MERGE`d into the union store. First- and second-degree neighborhood
queries are exactly what in-memory Cypher at scan speed is for; there is no
round-trip to a platform API. For friends who prefer the terminal, the same file
opens with the CLI (`relate --database friends.cl`) and the queries run
identically. Checkpoints keep snapshots, so "who unfollowed whom" is a diff
between two Parquet checkpoints rather than a scrape history.

## What it needs

- The browser plugin: export flow per platform (scraped pages, takeout archives,
  official APIs where they exist), rate-limit-aware, incremental
- Graph hygiene: dedupe accounts across platforms, store as-of dates on FOLLOWS
  edges so the graph is temporal, not just a snapshot
- A WASM front end: ego-network view, community coloring, bridge highlighting —
  the MetaExp lesson: show relevant subgraphs, never the hairball
- An opt-in sharing protocol between friends (`.cl` file exchange + a merge recipe)
- Honest legal notes per platform (scraping ToS varies; this is personal-use,
  opt-in data)

## Lineage & inspiration

From [research/graph-world.md](../research/graph-world.md): the
[NetworkX gallery](https://networkx.org/documentation/stable/auto_examples/index.html)
(ego graphs, centrality, communities — the computation catalog to port to Cypher),
[Gephi](https://bellingcat.gitbook.io/toolkit/more/all-tools/gephi) (the
import → detect communities → curate workflow this replaces, client-side), and
[Mottin/Müller's MetaExp](https://mott.in/publications/publications/metaexp/)
(relevance-driven exploration instead of full-graph dumps). From
[research/agent-native.md](../research/agent-native.md): the local-first stack
argument — [sql.js + sqlite-vec](https://sql.js.org) proved browser-tab databases
are a category; RelateDB-WASM is the graph-native version.
