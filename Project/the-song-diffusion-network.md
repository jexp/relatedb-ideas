---
type: Project
name: the-song-diffusion-network
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
RELATED_IDEA:
  - kind: complements
    reason: one frame per year timelapse view of the diffusion
    target: "[[Project/animated-graph-timelapse]]"
  - kind: inspired-by
    reason: temporal transmission machinery reused over animal populations
    target: "[[Project/the-emergent-interaction-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
---

# The Song Diffusion Network

> Humpback whale song spreading across ocean populations, bird dialect
> boundaries, chimpanzee tool traditions — culture in animals as a
> temporal transmission graph over populations, not people.

## What

Cultural transmission in animals is a graph story nobody has graphed
properly. The flagship: humpback whale song. Male populations sing, the
song evolves within a population, and — Garland et al. showed — whole
song revolutions propagate across the South Pacific from east to west,
population to population, on migration corridors, over years. The data
exists (song recordings classified into theme/unit sequences per
population per year); the analysis is PCA-and-diagrams in papers; the
model — who heard whom, when, on which route — is a temporal graph nobody
has stood up.

This project is that graph: `(:Population)`, `(:Year)`, `(:SongTheme)`
with `(:Recorded {population, year, sequence})`, similarity edges
between theme variants (the acoustic-distance clusters), inferred
transmission edges (population A's year-n song ≈ population B's year-n+1
song, on a migratory route), and the question set as queries:

- "trace the 2011 eastern-Australian song revolution through the chain
  to French Polynesia" — a temporal path query over similarity edges
- "which pairs of populations share a migratory corridor but never
  share a song" — the missing-edge question (the transmission gap
  evidence must explain)
- complexity tracking: song complexity per population over years as a
  property series (the cumulative-culture literature's measure), and
  complexity *direction* along transmission edges

The same skeleton serves the other animal-culture datasets: bird dialect
maps (white-crowned sparrow dialect boundaries), chimpanzee termite-fish
traditions, whale-sight-call dialects. The field publishes static
figures; the field's questions are traversal + temporal queries.

## Why RelateDB

The corpus (population-year-theme tables + similarity matrices) is small
and fully public — a `.cl` file with the query pack is the citable
supplementary artifact a paper can ship, and the teaching artifact a
behavioral-ecology course can open in a tab. The questions are exactly
temporal path queries; the missing-edge form is the engine's home turf;
and the timelapse view (the song network evolving over the decade, one
year per frame) is the Animated Graph Timelapse pattern on genuinely
beautiful data.

## What it needs

- The corpus loader: the published population-year theme classifications
  (starting with the South Pacific humpback datasets the Garland papers
  summarize) and their similarity/cluster data
- The query pack: transmission-path tracing, corridor-but-no-song
  missing-edge queries, complexity series and their directions
- The migration-corridor overlay: population pairs with shared routes
  (the geography layer the inference needs)
- The timelapse view: one decade, one frame per year

## Lineage & inspiration

- [Dynamic horizontal cultural transmission of humpback whale song at
  the ocean basin scale (Garland et al., Current Biology 2011)](https://www.cell.com/current-biology/fulltext/S0960-9822(11)00291-0)
  — the founding diffusion result
- [Migratory convergence facilitates cultural transmission](https://doi.org/10.1098/rsos.190337)
  and the [global cultural evolutionary model](https://pmc.ncbi.nlm.nih.gov/articles/PMC8419575/)
  — the mechanism and the model this project makes queryable
- [Cultural revolutions reduce complexity in the songs of humpback
  whales](https://royalsocietypublishing.org/doi/10.1098/rspb.2018.2088)
  — the complexity-tracking lineage
- [The Emergent Interaction Graph](the-emergent-interaction-graph.md) —
  the temporal-transmission machinery; [Animated Graph
  Timelapse](animated-graph-timelapse.md) — the view
