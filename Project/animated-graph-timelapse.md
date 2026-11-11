---
type: Project
name: animated-graph-timelapse
IN_CATEGORY:
  - "[[Category/Visualization & Rendering]]"
MENTIONS_ORG:
  - "[[Company/GDELT]]"
  - "[[Company/GitHub]]"
MENTIONS_PERSON:
  - "[[Person/Andrei Kashcha]]"
RELATED_IDEA:
  - kind: complements
    reason: diff-mode frames share machinery with the Diff View idea
    target: "[[Project/diff-view-for-graphs]]"
USES_TECH:
  - "[[Technology/Cosmograph]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/GDELT]]"
  - "[[Technology/GH Archive]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Animated Graph Timelapse

> A temporal graph played over time; the rise and fall of a community, a market,
> or a pandemic, one WAL frame at a time.

## What

A play button on top of a graph. The store holds a temporal graph — every node
and edge carries validity timestamps, or the store's history itself is the
timeline — and the viewer animates through time: scrub a slider and the canvas
shows the graph *as of* that moment, nodes and edges fading in and out as they
appear and disappear. Watch a community condense out of noise, an industry's
M&A network consolidate, a rumor's retweet cascade spread outward from patient
zero.

Two distinct modes fall out of one viewer. Snapshot mode renders the graph
as-of-t for any t: a temporal query drives the frame, so scrubbing is literally
`MATCH` with a time predicate re-executed per frame — and the intermediate
states are queryable, not just watchable ("what did the network look like the
week before the collapse?"). Diff mode animates the *changes*: each frame is the
change-set between two ticks, edges pulsing as they form, so the eye follows
events rather than states.

The storytelling output is as important as the exploration UX: export a run as
a recorded animation (video or an animated Mermaid/sequence), and a temporal
analysis becomes a narrated artifact for a class, a newsroom, or a postmortem.

## Why RelateDB

In-memory Cypher at scrub speed is the core enabler: re-running an as-of query
per animation frame is only viable when the query costs milliseconds, and
RelateDB's whole design is fast queries over resident data with zero round
trips. The WAL is a native timeline: an event-sourced or WAL-backed store makes
"replay any window and query it as it was" a materialization step, so the
temporal substrate may already exist depending on ingest shape. The formatters
and adapters (table for the "what changed this tick" pane, the viz adapters for
the canvas) mean the viewer is glue over existing output modes. And the WASM
build makes the timelapse a shareable artifact: a `.cl` file plus a scrubber in
a tab — a data story someone emails, not a dashboard someone logs into.

## What it needs

- Temporal modeling conventions: validity properties on nodes/edges, or
  WAL-window replay for event-shaped sources
- A scrub/play controller with frame-budget queries (as-of `MATCH` per tick)
- Diff-mode frames from consecutive change-sets (shares machinery with the
  Diff View idea)
- Layout stability across frames (incremental layout, so structure doesn't
  jump between ticks)
- Export: recorded video/animation for slides and social
- Example datasets with real dynamics: GDELT story clusters, citation growth,
  an epidemic simulation, one hour of GitHub events

## Lineage & inspiration

- [GDELT story-cluster visualization](https://blog.gdeltproject.org/using-the-gsg-document-embeddings-to-visualize-story-clusters-using-gephi/)
  — news dynamics as evolving networks; the flagship story to animate
- [GH Archive](https://www.gharchive.org/) — timestamped event firehose
- [Cosmograph](https://cosmograph.app/) — the canvas performance bar for
  animating large frames in a tab
- [Gource](https://github.com/acaudwell/Gource) — the beloved software-activity
  animation (commits streaming into a repository tree over time): the
  software-history genre this viewer serves with a real query engine behind
  the scrubber — `git-to-graph` makes every Gource frame a Cypher result
- [react-force-graph (vasturiano)](https://github.com/vasturiano/react-force-graph)
  — live-updating force layouts (the in-motion renderer end of the spectrum);
  Andrei Kashcha's [anvaka](https://anvaka.org/) experiments —
  [VivaGraphJS](https://github.com/anvaka/VivaGraphJS), the
  [ngraph](https://github.com/anvaka/ngraph) ecosystem,
  [city-roads](https://github.com/anvaka/city-roads) — the interactive-dynamics
  reference work for how graphs should move
