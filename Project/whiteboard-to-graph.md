---
type: Project
name: whiteboard-to-graph
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Excalidraw]]"
  - "[[Company/Zackriya Solutions]]"
  - "[[Company/tldraw]]"
RELATED_IDEA:
  - kind: complements
    reason: correction loop for the extracted graph
    target: "[[Project/direct-manipulation-graph-editor]]"
  - kind: complements
    reason: where the extracted graph goes next
    target: "[[Project/the-intentional-graph-workbench]]"
USES_TECH:
  - "[[Technology/Excalidraw]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/diagram2graph]]"
  - "[[Technology/tldraw]]"
  - "[[Technology/transformers.js]]"
  - "[[Technology/web-llm]]"
---

# Whiteboard to Graph

> Photograph a whiteboard, a slide diagram, or a napkin sketch; a vision model
> extracts nodes, edges, and labels into RelateDB — the drawing becomes
> queryable, and the diff from the last photo becomes a change log.

## What

Everyone already authors graphs — on whiteboards, in slide decks, on napkins.
The complexity was never the graph; it was the *getting it in*. This project
closes that gap: photograph the whiteboard after the architecture discussion;
a vision model (a local one via the WASM/web-llm stack, or a hosted one —
your choice, your privacy) extracts the boxes, arrows, and labels into
typed nodes and relationships in a RelateDB store. The sketch that dies
when the whiteboard gets wiped becomes the seed of the living graph.

The deeper loop: repeat photos of the *same* whiteboard across a week of
discussions become a time series — the diff between extractions (new nodes,
removed edges, relabeled things) is the meeting's actual outcome, captured
as WAL entries. "What did we decide on Tuesday?" becomes a query.

The research is arriving fast enough to build on. Zackriya's diagram2graph
fine-tunes a vision-language model to extract typed knowledge graphs — nodes,
edges, labels — from flowcharts and architecture diagrams; "From Sketches to
Graphs" (Design Society, 2023) detects and contextualizes principle sketches
from early product development; and topology-extraction work now measures
exactly the failure mode this pipeline fears — arrow endpoints and structure,
not labels. On the consumer side, tldraw's *make real* and Excalidraw's
wireframe-to-code line proved that drawing → structured output is a mass
reflex, not a niche: the extraction step is a solved-enough commodity, the
queryable store behind it is the missing half.

## Why RelateDB

The extraction lands in a single `.cl` file that starts its life on the
laptop of the person who took the photo — no server, no schema ceremony,
the sketch's shapes (often untyped at first) become nodes that gain labels
and properties as the model organizes. The WAL makes the photo-history a
replayable change log; `relate serve --http` turns the extracted graph
into a shareable link before the meeting's coffee is cold; the hybrid
search finds "that box about payment retry" by meaning rather than by
whatever the model guessed as its label.

## What it needs

- A vision-extraction prompt pipeline (VLM → typed JSON graph → `CREATE`
  statements), local-first via web-llm/transformers.js or the browser of
  a hosted model — diagram2graph is the fine-tuned precedent; generic
  VLM prompting is the commodity path
- Image-diff alignment (matching nodes across photos — entity resolution
  over extracted labels and positions); the diagram-topology benchmark
  results are the checklist for what extraction must get right first
  (arrow endpoints, then labels)
- The edit loop: the projected extraction opens in the direct-manipulation
  editor (see [Direct Manipulation Graph Editor](direct-manipulation-graph-editor.md))
  for correction before committing

## Lineage & inspiration

- Every whiteboard ever photographed — the unmet demand is the point
- [diagram2graph](https://github.com/Zackriya-Solutions/diagram2graph) — the fine-tuned VLM that extracts knowledge graphs from diagrams; the extraction step's proof it works
- "From Sketches to Graphs" (Design Society, 2023) — deep-learning detection and contextualisation of principle sketches: https://doi.org/10.1017/pds.2023.198
- [tldraw make real](https://github.com/tldraw/make-real) — drawing to working code at consumer scale ([the story so far](https://tldraw.dev/blog/make-real-the-story-so-far)); [Excalidraw's AI / wireframe-to-code](https://plus.excalidraw.com/ai) line — the diagram-as-code counter-movement's inverse, proven
- The diagram-as-code counter-movement (Mermaid, Excalidraw → code) — this is its inverse and complement: code from diagrams
- [The Intentional Graph Workbench](the-intentional-graph-workbench.md) — where the extracted graph goes next
