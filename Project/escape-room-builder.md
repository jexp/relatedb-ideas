---
type: Project
name: escape-room-builder
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
RELATED_IDEA:
  - kind: variant
    reason: the same lock-and-key progression DAG as an authored narrative
    target: "[[Project/choose-your-own-adventure-engine]]"
  - kind: complements
    reason: solvability and soft-lock checks are reachability proofs over a state DAG
    target: "[[Project/state-space-puzzle-solver]]"
  - kind: variant
    reason: dependency-gated progression graphs in another domain
    target: "[[Project/tech-trees]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Escape-Room Builder

> Locks, keys, puzzles as a dependency DAG; the design tool that proves
> the room is solvable.

## What

An escape room is a dependency graph wearing a costume: puzzles produce
keys/codes/information that unlock further puzzles, until the final door — and
designers sketch it as sticky notes. This project makes it a database:
`(:Puzzle {duration, difficulty})-[:YIELDS]-> (:Item)-[:UNLOCKS]->(:Puzzle)`,
with `:Item` typing keys, codes and knowledge. The tool then *proves* things
about the room: is every puzzle needed (orphaned puzzles are wasted budget); is
the room solvable (a topological path from entry to final door exists); are
there soft-locks — states where the team holds no usable item and no puzzle is
open, here a reachability query; and where is the critical path (the longest
dependency chain — the room's real minimum time).

The queries get sharper with room semantics: parallel tracks merge
when two keys open one lock; a red-herring puzzle unlocks nothing and
is *meant* to be skipped — typed, so the solvability proof doesn't route
through it. Playtests layer temporal evidence: teams' solve traces as paths
through the DAG, so "everyone stalls at the padlock for 14 minutes" is data,
not folklore. The same harness designs puzzle boxes, breakout EDU kits, and
boss-key dungeons.

## Why RelateDB

Solvability is a traversal claim, so the design tool that proves it
wants a traversal engine as its store — reachability, critical paths
and orphan detection are plain Cypher over the DAG, evaluated
instantly in memory on every edit, which turns room design into live
validation rather than test-night discovery. A room is one `.cl` file: portable
between designers, archivable per venue, with playtest evidence appending over
the WAL. The design view rides the WASM build — drag a puzzle, wire an unlock,
watch the solvability badge — and `mermaid()` emits the dependency chart for
the design doc. Python bindings ingest the venue's lock/key register, and a
night-mode dashboard over `serve --http` watches live teams move through the
room's graph — hint calls pinned to the puzzle they're stuck on.

## What it needs

- The room model: Puzzle/Item/Lock nodes, YIELDS/UNLOCKS edges,
  red-herring and optional tracks typed explicitly
- The proof pack: solvability, soft-lock states, orphaned puzzles,
  critical path and merge points — re-run on every edit
- Playtest telemetry: team traces as temporal paths, stall detection,
  puzzle-time distributions layered on the design DAG

## Lineage & inspiration

- Ron Gilbert's puzzle-dependency charts for Maniac Mansion — the
  famous sticky-note DAG this project makes first-class:
  https://grumpygamer.com/puzzle_charts
- The SCUMM adventure-game tradition — lock/key progression designed
  by hand since 1987, never queryable until now
- Zelda dungeon-design analyses (boss keys, small keys, region
  gating) — the same DAG discipline, documented by the level-design
community
