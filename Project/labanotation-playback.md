---
type: Project
name: labanotation-playback
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
RELATED_IDEA:
  - kind: complements
    reason: the playback pattern the score timeline reuses
    target: "[[Project/animated-graph-timelapse]]"
  - kind: complements
    reason: the heritage-preservation sibling in the humanities pack
    target: "[[Project/the-hnr-humanities-pack]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Labanotation Playback

> Dance scores as structured graphs: Labanotation's movement columns —
> body part, direction, duration — as temporal nodes, and the repertoire
> ("every lift sequence longer than two counts in the company's
> history") as a query.

## What

Labanotation is the century-old system for scoring movement on paper
(and now in software): a vertical time axis with columns per body part,
symbols encoding direction and duration. A score is a rigorous
structured document — and structurally, a temporal graph: movement
events with body-part scoping, time-spans, and the hierarchy of
sections, phrases, and repetitions that any choreography builds. The
notated repertoire of a company — hundreds of scores, decades deep — is
a graph nobody can currently query: "show me every use of this floor
pattern" means a human reading scores.

The recent research direction validates the shape: LabanFormer and its
kin use *graph attention networks and transformers* on Labanotation
(and mocap → Labanotation generation is an active ML task for folk-dance
preservation). The ML world treats the score as graph data; the dance
world still has no graph tool.

This project is the repertoire engine: `(:Movement {direction, level,
duration})` scoped by `(:BodyPart)`, `(:TimeSpan)` nodes with the score's
hierarchy (section → phrase → movement), `(:Production)`, `(:Choreographer)`,
`(:Dancer)` cast layers. The queries: motif search ("the arm-spiral
phrase — where else does it appear in the repertoire"), sequencing
("every lift followed by a fall of more than two counts"), casting and
rights ("which dances still performed include the original cast's
roles"), and the preservation angle — folk-dance corpora (the
mocap→score pipelines produce structured data that needs exactly this
home).

Playback: the score as a queryable timeline — scrub, and the movement
graph animates in step (the Timelapse pattern in leotard form).

## Why RelateDB

The repertoire scale (hundreds of scores, thousands of phrases) is a
file, not a fleet; temporal types are the score's native axis; the
hierarchical containment queries are traversals; and the WASM tab makes
a score browsable beside a video — the notation/graph alignment view
that preserves dance heritage. A company's whole repertoire as one `.cl`
file is the archival artifact dance archives have needed since
Labanotation was invented.

## What it needs

- The Labanotation loader: LabanXML/LABAN-movement formats (the notation
  software's export formats) → the temporal movement graph
- The motif query pack: phrase search, sequencing, casting queries
- The alignment view: score timeline beside video playback
- A pilot corpus: one company's preservation archive or a folk-dance
  collection, published as a `.cl` file

## Lineage & inspiration

- [LabanFormer: graph attention networks for Labanotation](https://www.sciencedirect.com/science/article/abs/pii/S0925231223003120)
  — the ML world already treating the score as a graph
- [Labanotation generation from motion capture for folk-dance
  protection](https://doi.org/10.1109/access.2020.3014157) — the
  preservation pipeline whose output needs a home
- The Labanotation tradition (Laban's system, the Dance Notation Bureau)
  — the century of structured movement documentation
- [Animated Graph Timelapse](animated-graph-timelapse.md) — the
  playback pattern; [The HNR Humanities Pack](the-hnr-humanities-pack.md)
  — the heritage-craft sibling
