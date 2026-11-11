---
type: Project
name: connectome-explorer
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/Gephi]]"
  - "[[Company/Janelia Research Campus]]"
  - "[[Company/OpenWorm]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
  - "[[Person/Mark Newman]]"
USES_TECH:
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Cytoscape]]"
  - "[[Technology/Gephi]]"
  - "[[Technology/JSON]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Connectome Explorer

> small-animal connectomes (C. Elegans to fly) as graphs; circuit-tracing queries
> for students, neuro classes, and papers.

## What

The complete wiring diagrams of small nervous systems — C. Elegans (302 neurons,
~7k synapses), the larval and adult fly brain (Janelia's hemibrain / FlyWire, ~140k
neurons), and soon fish and mouse wedges — are public, versioned, and graph-shaped
at the source. Yet most neuroscientists explore them through bespoke portals,
because the data is too big for a spreadsheet and too specialized for a generic
graph service.

This project loads a connectome into RelateDB as typed neurons
(`Neuron {id, class: sensory/inter/motor, neurotransmitter}`), directed synapse
edges with weight (synapse count), and muscle/organ targets for the motor side.
Then circuit-tracing becomes Cypher: "every sensory neuron within 3 synapses of a
body-wall muscle", "all paths from this mechanosensor to the locomotion circuit",
"which interneurons receive both dopaminergic and GABAergic input" — each a single
query a student can read and modify. Cross-species comparison loads two connectomes
side by side in one store and asks which motifs survive.

The sources are verified and versioned. The C. elegans wiring exists as published
adjacency matrices per study — White et al. 1986, Varshney et al. 2011, Cook et al.
2019 — on WormWiring, and OpenWorm's Connectome Toolbox bundles those same datasets
as a curated, versioned archive (the model for a `.cl` handout with provenance). On
the fly side, Janelia's hemibrain is served through neuPrint (server plus a Python
client whose query examples read exactly like the Cypher this project wants), and
FlyWire publishes whole-brain connectivity exports on Zenodo and via its Codex
download API. The analysis genre exists too — Cytoscape and the fly-connectome
tool pages (natverse, flyconnecto.me) are what researchers use today; all are
portal- or notebook-shaped, none query-first.

## Why RelateDB

Connectomes are the perfect embedded workload: the whole C. Elegans wiring diagram
is smaller than a typical karate-club exercise scaled up — microseconds per
traversal, entirely in memory, zero infrastructure for a neuro course of 200
students. The `.cl` file is the lab handout: download it, open it, query it. The
WASM build makes an interactive explorer where students click a neuron and see the
Cypher that fetched its partners — the query *is* the teaching material. A single
`relate serve --mcp stdio` lets an agent answer "compare this with the
published locomotion circuit" against the real graph instead of from memory, and
WAL+Parquet checkpoints mean a course's curated annotations (this-neuron-is-suspect,
renamed-class corrections) survive re-loads as versioned layers.

## What it needs

- Loaders: WormAtlas/WormBase C. Elegans adjacency matrices; Janelia hemibrain /
  FlyWire neuron-connectivity exports (CSV/JSON)
- Ablation-friendly model: neurotransmitter as edge property so typed-path queries
  (e.g. only inhibitory hops) stay one pattern
- Front-end: neuron browser over WASM (click → partners → expand), ideally with the
  generated Cypher shown beside the result
- Optional: cross-species node keys (a `SAME_AS` edge layer) and centrality
  overlays for "hub neuron" exercises

## Lineage & inspiration

- WormWiring — the published C. elegans adjacency matrices per study version:
  https://www.wormwiring.org/pages/adjacency.html | OpenWorm's C. Elegans
  Connectome Toolbox (White/Varshney/Cook datasets, archived):
  https://openworm.org/ConnectomeToolbox/
- neuPrint and its Python client (the Janelia hemibrain server, and the closest
  existing 'query a connectome' UX): https://github.com/connectome-neuprint/neuprint
  and https://connectome-neuprint.github.io/neuprint-python/docs/
- FlyWire whole-brain connectivity data (Zenodo export, the bulk-download
  precedent): https://zenodo.org/records/10676866
- C. Elegans is a canonical teaching graph — bundled in Gephi's sample datasets
  alongside karate and Les Mis: https://docs.gephi.org/User_Manual/datasets/
- Mark Newman's network data page (the small-graphs-with-real-science tradition):
  https://websites.umich.edu/~mejn/netdata/
- Netzschleuder catalogue (neural and biological networks, browsable):
  https://networks.skewed.de/
- Barabási's *Network Science* chapters where connectomes are the case study:
  https://networksciencebook.com/
