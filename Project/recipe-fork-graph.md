---
type: Project
name: recipe-fork-graph
IN_CATEGORY:
  - "[[Category/Domain Modeling]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Luanne Misquitta]]"
  - "[[Person/Mark Needham]]"
  - "[[Person/Rik van Bruggen]]"
  - "[[Person/Yong-Yeol Ahn]]"
RELATED_IDEA:
  - kind: complements
    reason: shares the dietary and substitution edge model from the diner's side
    target: "[[Project/menu-allergen-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Recipe Fork Graph

> Dishes as nodes, substitutions as edges; the kitchen's git history.
> With the flavor layer: ingredients ↔ flavor compounds ↔ taste profiles
> (Ahn et al's flavor network science) — "what pairs with this?" and
> "novel pairings two hops from anything I cook" as graph queries.
> Lineage: the Neo4j community's recipe/food/taste classics (Luanne
> Misquitta, Rik van Bruggen, Mark Needham) — the same genre, embedded.

## What

Recipes fork like code: a base dish, a substitution, a regional variant, a
deconstruction. This project stores that history the way git stores software's:
`(:Dish)-[:FORKED_FROM {change}]->(:Dish)`, substitution edges typed by intent
(allergy swap, availability, taste). "What can I make with what's in the fridge"
becomes a closure problem; "how does my bolognese relate to the cookbook's" is a
two-edge path with the change named on the edge.

The flavor layer makes it sing: ingredients carry their flavor compounds, compounds
their taste profiles — Ahn, Ahnert, Bagrow and Lehmann's flavor-network science
(shared aroma compounds predict successful pairings) as a bipartite graph under the
recipes. Then the README's queries are literal: "what pairs with this" is one hop
through compounds; "novel pairings two hops from anything I cook" is the discovery
query — combinations flavor science supports but your cooking history has never
touched, ranked by graph distance.

## Why RelateDB

The whole flavor graph (thousands of ingredients, millions of compound
edges) sits in memory, so "novel pairings" runs in a second on a phone — and the
phone is where cooking happens: the WASM build puts the graph in a browser tab over
the kitchen counter, offline, no "smart kitchen" subscription. The personal cookbook
is one `.cl` file: synced via git, shared as an attachment, backed up as Parquet.
The Neo4j community heritage made this genre a server ritual (a database instance
per cookbook); embedded, it's just a file your recipes live in — the Luanne/Rik/Mark
classics reborn as weeknight tools. Temporal types carry seasonality; hybrid search
finds "that soup we made in March" from prose notes; and MCP lets the agent
meal-plan from the actual pantry graph with the actual allergy edges.

## What it needs

- The recipe/fork model with change-named edges
(the git discipline: every fork says what it changed) - The flavor layer: Ahn
et al's ingredient ↔ compound ↔ taste data as bipartite graph, loadable via
`relate-arrow`
- The discovery pack: pairing queries, novelty-by-graph-distance
ranking, seasonal/pantry constraint composition

## Lineage & inspiration

- Ahn, Ahnert, Bagrow & Lehmann, "Flavor network and the principles of
  food pairing" (*Scientific Reports*, 2011) — the flavor-network
science this project operationalizes:
  https://www.nature.com/articles/srep00196
- The Neo4j community's recipe classics — Luanne Misquitta's recipe
  traversals, Rik van Bruggen's food graphs, Mark Needham's graph
recipes (the *Neo4j in Practice* genre this inherits, embedded
this time): https://neo4j.com/graphgists/ - The Menu Allergen Graph (this
collection) — the dietary-edge model this recipe graph shares
