---
type: Project
name: phone-app-shell
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Apple]]"
  - "[[Company/Google]]"
RELATED_IDEA:
  - kind: complements
    reason: another flagship app that needs offline mobile graph storage
    target: "[[Project/disaster-response-router]]"
  - kind: complements
    reason: selection language behind the share-sheet subgraph export
    target: "[[Project/graph-clipboard]]"
  - kind: complements
    reason: one of the flagship apps the shell would host
    target: "[[Project/local-route-brain]]"
  - kind: complements
    reason: agent-data version of the same phone-hosted graph file
    target: "[[Project/on-device-agent-graph-store]]"
USES_TECH:
  - "[[Technology/C ABI]]"
  - "[[Technology/Kotlin]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/Swift]]"
  - "[[Technology/iCloud]]"
---

# The Phone App Shell

> A native app whose database *is* a `.cl` file: Swift/Kotlin over the C ABI,
> open it from Files/iCloud, share a subgraph out through the share sheet, a
> stored query as a lock-screen widget — the graph file as a first-class
> mobile citizen.

## What

On phones, SQLite won because it ships *inside the app*: every iOS/Android
device carries hundreds of app databases, and the platform treats them as
just files (open, share, back up). Graphs never got that deal — every
graph-mobile story is a server talking to a thin client.

This project is the native-app form factor: a small app shell (Swift on
iOS, Kotlin on Android, both wrapping the C ABI) whose entire persistence
is a `.cl` file — opened from the system Files app, stored in iCloud/Drive
and synced like any document, exported through the OS share sheet. The
platform integrations are the idea:

- **Open with**: `.cl` registers as a document type; tapping one in Files
  opens the app on it
- **Share sheet out**: select a subgraph (the Graph Clipboard's selection
  language) and share it to another person's device — a graph handoff with
  no cloud in between
- **The widget**: a stored query as a home-screen/lock-screen widget —
  "next trail head," "today's meal-plan constraints," "this week's
  co-author count" — the query that matters at a glance
- **Shortcuts/actions**: the app's queries registered as OS automation
  actions, so the graph participates in the platform's scripting layer

The flagship apps write themselves out of this repo: a personal CRM
(Friendship Archipelago), a genealogy viewer, a travel router, a decision
journal — each one `.cl` under a native shell.

## Why RelateDB

The C ABI is the mobile contract (JS/Java/Go wrap it; Swift/ObjC and
Kotlin/JNI do the same) and in-memory-at-restart is actually the right
shape for a phone app (small personal graphs, instant open, no server).
The `.cl` file makes the app's data *the user's data*: visible in Files,
restorable from backups, transferable between apps — the platform-promise
SQLite gets and every server-backed graph app forfeits. And the WAL means
the app that edits is durable without any save button.

## What it needs

- The two shells (Swift, Kotlin) with the C ABI binding and a small demo
  app each
- Document-type registration and the Files-app integration per platform
- Share-sheet subgraph export (selection → `.cl` snippet or QR)
- The widget bridge: stored queries (local-callables) polled or pushed to
  the widget timeline
- The flagship: one app end-to-end that proves the pattern

## Lineage & inspiration

- The SQLite-on-mobile deployment story (every phone carries hundreds of
  app databases — `research/sqlite-everywhere.md`) — the deal this project
  extends to graphs
- [On-Device Agent Graph Store](on-device-agent-graph-store.md) — the
  agent-data version of the phone home; this is the *human-app* version
- [Graph Clipboard](graph-clipboard.md) — the share-sheet edge of this
  idea, plus [Local Route Brain](local-route-brain.md) and
  [Disaster Response Router](disaster-response-router.md) — the flagship
  apps that want this shell
- Apple/Google's document-and-files conventions — the platform contract
  the `.cl` type registers into
