---
type: Project
name: the-cl-file-viewer
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the share-the-result end the viewer's export feeds
    target: "[[Project/graphclips-heroku-dataclips-reborn]]"
  - kind: complements
    reason: both depend on the file format being directly openable
    target: "[[Project/single-file-graph-stories]]"
  - kind: complements
    reason: cited as the dataset content this viewer makes openable
    target: "[[Project/use-case-gallery]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/DB Browser for SQLite]]"
  - "[[Technology/Datasette]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/WASM]]"
---

# The `.cl` File Viewer

> Double-click a `.cl` file, browse and query it in a GUI — the DB Browser for
> SQLite analog for graph files. The form factor that makes a file format
> usable by mortals.

## What

SQLite conquered the world twice: once as an engine, and once through its
*viewer* ecosystem — DB Browser for SQLite, Datasette, the inspector built
into every platform's dev tools — so that "look inside the file" is a
ten-second task for someone who has never read a line of SQL. The second
conquest matters as much as the first: a file format nobody can open is a
file format only engineers use.

This project is the viewer layer for `.cl`: a desktop (and tab) app that
opens a graph file read-only by default and gives the standard inspection
loop — schema view (the catalog, rendered as the `db.schema.visualization`
graph), table-ish property browsing per label, full-text across node
properties, a query box for the curious, result export. It is deliberately
not an IDE, not an ETL tool, not a dashboard builder: the scope is DB
Browser for SQLite's scope — *look inside the file, run a question, save the
answer* — plus the one thing a graph has and tables don't: a canvas view of
any result set (the viz-adapter pattern, one pane, optional).

The two modes: a standalone app (OS file association: `.cl` opens here) and
a WASM tab (drag a file onto a page — the Datasette model, zero install).

## Why RelateDB

The engine's surfaces make the viewer thin: the schema is one procedure
call (`db.schema.visualization`), results stream as table/CSV/JSON, and the
WASM build means the tab version is the same binary as the desktop version.
The read-only story is native (open the checkpoint without mounting the
WAL). And the viewer is the *on-ramp artifact* every other idea in this
repo assumes: a person receives a `.cl` (a gallery dataset, an escape-hatch
export, a handoff object) — this is what opens it.

## What it needs

- The shell: file open, store info (node/relationship counts, label
  distribution), schema canvas, property browser per label
- The query box with result tables and the csv/json export buttons
- Read-only-by-default with an explicit "take a copy and edit" path
- The OS integration: file association, quick-look/thumbnail plugin where
  the platforms allow it
- The tab variant: drag-and-drop page on static hosting

## Lineage & inspiration

- [DB Browser for SQLite](https://sqlitebrowser.org/) — the canonical "open
  the file, look inside" app; the scope this project copies
- [Datasette](https://datasette.io/) — instant read-only publishing of a
  database file; the tab-mode model (see
  `research/embedded-ecosystems.md`)
- [GraphClips (Heroku Dataclips, Reborn)](graphclips-heroku-dataclips-reborn.md)
  — the share-the-result end this viewer's export feeds
- The [.cl dataset gallery](use-case-gallery.md) — the content whose
  openability this viewer guarantees
