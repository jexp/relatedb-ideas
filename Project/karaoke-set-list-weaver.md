---
type: Project
name: karaoke-set-list-weaver
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/Mixed In Key]]"
  - "[[Company/Spotify]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/Camelot Wheel]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Spotify Web API]]"
  - "[[Technology/WASM]]"
---

# Karaoke Set-List Weaver

> Songs, keys, tempos, energy as a weighted graph.

## What

A good set list is a path, and nobody plans it as one. Songs carry
weighted compatibility edges — key compatibility (the harmonic-mixing
lesson DJs formalized as the Camelot wheel), tempo delta, energy ramp
(ballad → anthem → cooldown), and singer fit (whose range, whose
crowd-favorite). The weaver stores all of it: `(:Song {bpm, key,
energy, range})` and `(:Singer)-[:SINGS {confidence}]->(:Song)`, with
transition edges scored on the musical dimensions, plus the social
layer — who's at tonight's session, what they've sung, who duets.

The weaver then runs the night as a path query: given the crowd (their
singers, their confidence levels, the requests that must be honored),
weave a sequence — warm up the shy singer on a low-stakes singalong,
ramp energy, land the closer on the confident belter — each transition
justified (key-compatible, +10 BPM, energy 4→6, and the next singer
warmed up). Mid-session it re-plans live: someone left, a request
arrived, the energy died at the rap verse — re-weave the remaining
path under new constraints. Afterward the history graph compounds:
which transitions worked, which songs the room sang hardest on —
every session makes the next weaver smarter.

## Why RelateDB

Re-planning the night is a constrained path query over a small
in-memory graph — sub-second on a phone, which is where karaoke
happens: the WASM build (or a C-ABI mobile wrapper) runs the whole
thing offline in the booth, no bar wifi required, and the night's
store is one `.cl` file carried in a pocket. Temporal types make the
session log native: sung-at timestamps, room-energy ratings per song
("how did it land at 11pm vs. 1am"), the after-report as one query.
Python bindings ingest catalogs (the karaoke app's song book, Spotify
audio-feature dumps for BPM/energy/key), MERGE keeps the session
history incremental across nights, and the weighted-path machinery is
plain Cypher arithmetic on edge properties — no bespoke planner, just
traversals with scores the weaver composes.

## What it needs

- Song ingest: karaoke catalog exports + audio features (bpm, key,
  energy) via Python bindings; `relate-arrow` for bulk imports
- The scoring model: transition weights from key/tempo/energy, plus
  singer-confidence and duet edges
- The weaver: constrained path planning (requests honored, energy
  arc, singer warm-up ordering) with live re-planning mid-session
- Session log: sung/landed temporal edges, the after-report ("best
  transitions of the night") compounding across sessions
## Lineage & inspiration

- The Camelot wheel / harmonic mixing — DJs' key-compatibility system,
  the backbone of the transition scoring:
  https://mixedinkey.com/harmonic-mixing-guide/
- Spotify's audio-features API — tempo/energy/key at scale, the bulk
  ingest source
- DJ set-planning as an arc — the warm-up-to-peak-to-close craft this
  weaver borrows for singers
