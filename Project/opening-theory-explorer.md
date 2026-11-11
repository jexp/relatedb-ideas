---
type: Project
name: opening-theory-explorer
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Opening-Theory Explorer

> Your chess/Go games as a move-DAG.

## What

Your chess history is a tree you've never seen: every game you've
played branches from shared positions, your Sicilian games all descend
from one node after `1.e4 c5`, and your results annotate the branches.
This project stores it as that tree: positions as nodes (FEN-encoded,
MERGE-keyed), moves as edges carrying your outcomes (won/lost/drew,
when, as what color), then overlays master theory — ECO
classifications, the lichess opening book's aggregated stats — so the
same DAG holds "what the theory says" and "what actually happens when
*I* play it," side by side on every edge.

The queries are the study product: my worst-scoring branch of the
Sicilian by depth (the line where my score craters is *this* 8th move,
not the 5th); novelties I've played (the edge where my game tree
departs every recorded continuation); branches where opponents
consistently outperform the book (they know my repertoire); and the
gaps — strong master lines adjacent to my repertoire that I've never
once played, ranked by how close they sit to my existing tree. Go
works the same way with joseki dictionaries as the overlay; the DAG is
the same, the theory source changes.

## Why RelateDB

The natural import is lichess's open database (their whole game dump
and opening-explorer aggregates) — CSV/Parquet via `relate-arrow`,
exactly the import path built for this, and MERGE-keyed position nodes
mean a million games collapse into one shared DAG where each edge
accumulates its own stats: no dedupe pass, the structure emerges from
MERGE. Your games plus your study corpus sits in memory at query
speed, and the store is one `.cl` file you carry between machines and
study tools — your repertoire as an artifact, not an account.
Temporal types on the edges ("my score in this line *this year*" vs.
three years ago — repertoire drift as a time-window) are native; the
WASM build makes the explorer a browser tab (position → branch stats →
sub-branches as clickable traversals, the lichess-explorer UX on
*your* data); and Python bindings ingest PGN files from any club or
site.

## What it needs

- PGN/game-record ingest via Python bindings; position MERGE on
  canonical FEN; move edges with outcome annotations
- Theory overlay: ECO index and lichess opening-book stats merged into
  the same DAG; joseki dictionaries for the Go variant
- The study query pack: worst-branch-by-depth, novelty detection,
  opponent-overperformance, unplayed strong-adjacent lines
## Lineage & inspiration

- lichess.org's open database and opening explorer — the free game
  dump and the UX this project rebuilds on your own subtree:
  https://lichess.org/api
- The ECO classification (Encyclopedia of Chess Openings) — the theory
  taxonomy: https://en.wikipedia.org/wiki/List_of_chess_openings
- Joseki dictionaries for Go — the branch-canon this explorer
  overlays in its Go variant
