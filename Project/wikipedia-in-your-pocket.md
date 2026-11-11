---
type: Project
name: wikipedia-in-your-pocket
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Kiwix]]"
  - "[[Company/Turso]]"
  - "[[Company/Wikimedia Foundation]]"
RELATED_IDEA:
  - kind: complements
    reason: same zero-install low-hardware constraint
    target: "[[Project/the-low-resource-kit]]"
  - kind: complements
    reason: offline archive plus query engine for wikis
    target: "[[Project/wiki-as-a-file]]"
  - kind: same-data
    reason: same Wikipedia link subgraph shipped offline
    target: "[[Project/wikipedia-wedge]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Kiwix]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/Turso]]"
  - "[[Technology/ZIM]]"
  - "[[Technology/libsql]]"
---

# Wikipedia in Your Pocket

> Offline (sub)graph keeps for mobile: download your article neighborhood
> before a flight, query it on the plane; the C ABI → mobile wrappers make
> the phone a first-class graph host.

## What

Kiwix proved people want offline Wikipedia on their phones; this project
adds the part Kiwix can't give: a query engine. Before a trip, you pick a
topic neighborhood — or let an app build one from your reading history —
and synchronize a Wikipedia subgraph to the phone: articles as nodes, links
as relationships, summaries and key infobox fields as properties. On the
plane, you browse by following edges (a native "graph reader" UI), and you
can also *ask*: "which of the articles I saved mention thermodynamics?",
"give me a reading path from quantum mechanics to philosophy of mind" —
all offline.

The keeps are personal: annotations, highlights, and "read" markers are
written into the same store, so your reading history becomes a temporal
graph over the encyclopedia graph. Two months later, "what was that concept
next to the Bayes-theorem article I read in October?" is a one-hop query,
not a search through your memory.

The packaging precedent is verified at scale: Kiwix's ZIM archives are the
offline-Wikipedia standard — one compressed, indexed file per edition,
opened by native Android/iOS readers, a local server, or a PWA that caches
gigabytes in browser storage — and the ZIM pack is exactly the read-only
form this project gives a query engine. SQLite shipping inside every
phone app, plus the newer embedded-and-sync lineage (libsql/Turso in the
Expo starter below), proves a C-ABI database riding an app binary is a
shipping pattern, not an experiment.

Sync is just file shipping: the store is a directory (WAL + Parquet
checkpoint), so "download a keep" is fetch-the-file, and sharing a keep
with a classmate is sending the file.

## Why RelateDB

This is the C ABI story: RelateDB is wrapped by JS/Java/Go and mobile
bindings through one product C ABI, so the same engine that runs in a
terminal runs inside an iOS/Android app with no server process,
embedded and in-memory-fast on device hardware. The single-file store makes
keeps portable artifacts — download once, query forever, sync by copying.
Full openCypher (TCK 3892/3892) means the queries you use to explore the
keep are the same ones you'd write against any Cypher database. And the
WAL gives durable annotations and reading history inside the same store —
no side database for the user's own data.

## What it needs

- Mobile bindings over the C ABI (an iOS/Android framework per platform)
  plus a keep format that is just the store directory zipped
- A Wikipedia wedge builder (dump/API → subgraph) with a size budget for
  phones — summaries, not full wikitext, by default
- A reader UI: node = article, edge tap = navigate, plus a query box for
  the curious
- Sync plumbing: prebuilt keeps from a static site, or a "build my keep
  from these articles" tool on the desktop

## Lineage & inspiration

- [Kiwix](https://www.kiwix.org) — offline Wikipedia at scale; the proof of
  demand and the packaging model to layer a query engine on
- [Six Degrees of Wikipedia (sdow)](https://github.com/jwngr/sdow) —
  shortest-path play over the real article graph, now offline in your pocket
- [Kiwix for Android](https://github.com/kiwix/kiwix-android) and the
  [Kiwix PWA case study](https://web.dev/case-studies/kiwix) — offline
  Wikipedia as shippable files: native readers, and a web app caching
  gigabytes client-side
- [Wikimedia dumps](https://dumps.wikimedia.org/) — raw material for keep
  builders
- Turso's [expo starter](https://github.com/expo-starter/expo-opsqlite-libsql-turso) — the mobile embedded-DB-with-sync pattern, transposed to a graph
