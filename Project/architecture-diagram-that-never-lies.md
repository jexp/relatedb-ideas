---
type: Project
name: architecture-diagram-that-never-lies
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
RELATED_IDEA:
  - kind: complements
    reason: drift diffing after a PR pairs with the graph diff view
    target: "[[Project/diff-view-for-graphs]]"
  - kind: inspired-by
    reason: explicitly echoes the diagram-as-a-view pattern
    target: "[[Project/static-sites-from-dynamic-graphs]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/Kubernetes]]"
  - "[[Technology/Mermaid]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Terraform]]"
  - "[[Technology/WASM]]"
---

# Architecture Diagram That Never Lies

> Services, tables, topics and jobs from real configs (k8s manifests, terraform, docker-compose) into one graph; the diagram is a *view*, the graph is the truth.

## What

Every org's architecture diagrams are fiction drawn months ago; the truth is in
the configs, scattered across repos. This project ingests the *real* declarative
sources — k8s manifests (Deployments, Services, Ingresses, ConfigMaps, env
vars), terraform (resources and their references), docker-compose, schema
migrations, topic/queue definitions — and resolves them into one graph:
`(:Service)-[:READS]->(:Table)`, `(:Service)-[:PUBLISHES_TO]->(:Topic)`,
`(:Ingress)-[:ROUTES_TO]->(:Service)`, `(:Job)-[:CRON_DEPENDS_ON]->(:Service)`.

Then the questions that architecture reviews argue about are lookups: "which two
services both write this table?" (your hidden coupling), "what breaks if we
delete this topic?", "show every consumer of the old payment API," "which
services depend on this Terraform module change?" The diagram becomes a *view* —
regenerated from the graph per query, per team, per time — while the graph stays
the single source of truth, rebuilt from the same configs CI already reads.

The killer moment: the PowerPoint and the cluster disagree, and the graph tells
you which one is lying.

## Why RelateDB

Config files are tree-shaped with references — a loader per format is honest
but bounded work, and `lab fs-to-graph` already sweeps a directory of files into
a graph as the foundation. `db.schema.visualization` — freshly upgraded with an
options map — renders the *current* structural model of the store; a
Mermaid-as-query-result renderer turns any subgraph traversal into a living
diagram for docs and RFCs. Single binary means it runs in CI, in a Docker
image, in a git hook: regenerate-and-diff on every PR (diagram drift as a
failing check, finally). The single `.cl` file is the shareable architecture
snapshot — email it, commit it, open it in a browser tab (WASM) and explore
the real system interactively. In-memory Cypher keeps the "who reads this
table" query instant, unlike the Confluence page, which is unavailable.

## What it needs

- Parsers per source: k8s manifests (incl. env-var service references — the
  sneaky edges), terraform graph output, compose files, SQL migrations (table
  DDL + query provenance from code), queue/topic definitions
- Cross-repo aggregation: a folder of repos or a git org checkout → one store
- Diff mode: rebuild after a PR, graph-diff added/removed edges (pairs with the
  Diff View for Graphs visualization idea)
- Boundary honesty: static config won't see runtime HTTP calls — either ingest
  traces later or label those edges "declared-only"

## Lineage & inspiration

From [research/graph-world.md](../research/graph-world.md) §6:
[GUAC](https://github.com/guacsec/guac/) — the same move done for the supply
chain: ingest many declarative sources into one graph, ask posture questions —
here the artifacts are your services instead of your SBOMs; and
[jQAssistant](https://jqassistant.org) (the code-graph OG — config-as-graph is
the same discipline applied to infrastructure). The diagram-as-a-view idea
echoes the **Static Sites from Dynamic Graphs** pattern (the graph is the CMS;
the pages are views).
