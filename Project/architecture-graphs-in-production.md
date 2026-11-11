---
type: Project
name: architecture-graphs-in-production
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Airbnb]]"
  - "[[Company/Amadeus]]"
  - "[[Company/Financial Times]]"
  - "[[Company/Lyft]]"
  - "[[Company/Uber]]"
MENTIONS_PERSON:
  - "[[Person/Rhys Evans]]"
  - "[[Person/Thomas Lawrence]]"
RELATED_IDEA:
  - kind: complements
    reason: the config-layer sibling this graph mounts
    target: "[[Project/configuration-misconvergence]]"
  - kind: complements
    reason: the same blast-radius instinct at LAN scale
    target: "[[Project/home-network-atlas]]"
USES_TECH:
  - "[[Technology/Amundsen]]"
  - "[[Technology/Cartography]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Kubernetes]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Terraform]]"
  - "[[Technology/WASM]]"
---

# Architecture Graphs in Production

> The case studies that proved the pattern: [Amadeus](https://www.youtube.com/watch?v=F1bWm_puNjQ),
> the [Financial Times' field guide](https://neo4j.com/videos/a-field-guide-to-the-financial-times-rhys-evans-financial-times/),
> [Lending Club's fabric of devops](https://neo4j.com/blog/cypher-and-gql/fabric-of-devops-using-neo4j-to-manage-site-infrastructure/),
> [Lyft's Amundsen and Cartography](https://eng.lyft.com/amundsen-lyfts-data-discovery-metadata-engine-62d27254fbb9),
> and the [data-discovery generation at Airbnb et al](https://medium.com/dataseries/how-linkedin-uber-lyft-airbnb-and-netflix-are-solving-data-management-and-discovery-for-machine-2361a8623aa8)
> — rebuilt embedded, per team, from their own infra.

## What

Infrastructure-as-graph is not a hypothesis; it has a decade of
production case studies. Amadeus proved it at airline scale —
infrastructure and dependencies as one graph, blast radius answered
before a deployment ships. The Financial Times field guide put
services, hosts, DNS, and deploy pipelines in one graph; Lending
Club's "fabric of devops" did the same for site infrastructure.
Lyft built Amundsen and adopted Cartography; LinkedIn, Uber, Airbnb,
and Netflix each followed with metadata-graph platforms.

Verified specifics: Amadeus (Thomas Lawrence, GraphConnect NYC 2017)
demoed YAC — "Your Architecture Cartography" — a graph of business
services, applications, technologies, and integration points;
LendingClub's Mercator synced 400+ microservices into one graph;
Airbnb's "Democratizing Data" (GraphConnect Europe 2017) put the
metadata graph at the data portal's core; Uber runs a Config Knowledge
Graph today.

The common thread: those teams needed *servers*, clusters, and platform
teams to get their graphs. The pitch here is the same graphs, rebuilt
embedded, per team: a `.cl` file generated from the team's own infra —
Terraform state, k8s API, DNS zone, CI config — queryable in seconds,
no platform investment. A team of 10 deserves the same "what breaks if
this dies?" answers Amadeus had — from a file they can commit.

## Why RelateDB

The sources are the team's own; the questions are multi-hop reachability
over one environment — the in-memory embedded shape. Terraform, k8s, DNS,
and CI exports are YAML or JSON, loaded via the Python bindings — CSV
loaders and `relate-arrow` for the exportable bits. One `.cl` file
per environment, regenerated nightly; the WAL makes each regeneration
an append, so the graph *accumulates* history — what changed between
Friday's and Monday's blast radius is itself a query. In-memory
multi-hop ("which services transitively mount this ConfigMap?") runs
at build speed, so it can gate a deploy. `relate serve` shares it
over HTTP/MCP; the WASM build renders the service map for on-call.

## What it needs

- Extractors: Terraform state → resources and dependencies; k8s API →
  workloads, ConfigMaps/Secrets, ingress; DNS, service registry, CI
  topology — one connector per source, start with one cloud
- The schema: `(:Service)`, `(:Deployment)`, `(:ConfigMap)`, `(:Host)`, `(:Datastore)`
  with `:DEPENDS_ON`/`:MOUNTS`/`:RESOLVES_TO`, environment-tagged so prod/staging stack cleanly
- The query pack: blast radius, single points of failure, config
  misuse, ownership — which team's pager does this wake?
- Nightly regeneration as versioned WAL history — drift as a diff, not a surprise

## Lineage & inspiration

- [Amadeus](https://www.youtube.com/watch?v=F1bWm_puNjQ) — the production story, at global scale
- [FT field guide](https://neo4j.com/videos/a-field-guide-to-the-financial-times-rhys-evans-financial-times/) (Rhys Evans);
  [Lending Club's fabric of devops](https://neo4j.com/blog/cypher-and-gql/fabric-of-devops-using-neo4j-to-manage-site-infrastructure/)
- [Lyft's Amundsen](https://eng.lyft.com/amundsen-lyfts-data-discovery-metadata-engine-62d27254fbb9) and Cartography;
  [the data-discovery generation](https://medium.com/dataseries/how-linkedin-uber-lyft-airbnb-and-netflix-are-solving-data-management-and-discovery-for-machine-2361a8623aa8) — LinkedIn, Uber, Lyft, Airbnb, Netflix
- [Airbnb: Democratizing Data](https://medium.com/airbnb-engineering/democratizing-data-at-airbnb-852d76c51770) (Williams & Bodley, GraphConnect Europe 2017);
  [Uber's Config Knowledge Graph](https://neo4j.com/videos/graphsummit-nyc-25-ubers-config-knowledge-graph-genai-with-graphrag-and-mcp/) — the pattern's modern generation
- [Home Network Atlas](home-network-atlas.md) — the same blast-radius instinct at LAN scale;
  [Configuration Misconvergence](configuration-misconvergence.md) — the config-layer sibling this graph mounts
