---
type: Project
name: graphql-straight-from-the-engine
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: the same drop-into-an-existing-ecosystem argument, applied to GraphQL clients
    target: "[[Project/the-driver-that-isnt]]"
USES_TECH:
  - "[[Technology/Apollo]]"
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/GraphQL]]"
  - "[[Technology/GraphiQL]]"
  - "[[Technology/Neo4j GraphQL Library]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/neo4j-graphql]]"
---

# GraphQL, Straight from the Engine

> The graph schema *is* the GraphQL schema: labels become types, relationship
> types become fields, one GraphQL query compiles to one Cypher traversal —
> served in-process, zero mapping config. The direct 2016 shape, before the
> successors moved the idea out of the database and wrapped it in a framework.

## What

The [neo4j-graphql plugin](https://github.com/neo4j-graphql/neo4j-graphql)
(2016) ran GraphQL *inside* the database, and its mapping was almost the
identity function: node labels → object types, relationship types → typed
fields, properties → scalar fields, and a GraphQL query compiled to exactly
one Cypher statement. No mapping DSL, no annotations, no build step — the
schema you already had was the API you already had
([GraphQL meets graph database](https://neo4j.com/blog/graphql/graphql-neo4j-graph-database-integration/)).

The successors went the framework route: the
[Neo4j GraphQL Library](https://github.com/neo4j/graphql) is a
directive-driven code-generation layer (`@node`, `@relationship`, `@cypher`)
that runs as its own server process with its own configuration and
abstractions. More powerful — federation, subscriptions, auth directives —
but the directness is gone: what was "the API is the schema" became "the
schema is a build step."

This project is the direct shape, revived on an engine built for it:

- **Catalog → SDL**: the labels, relationship types, and property keys the
  engine already tracks emit the type definitions — introspection is a
  query, not a config file; schema changes re-emit live
- **Selections → traversals**: field selections map to returned properties
  and one-hop patterns; nested selections compose into the multi-hop
  pattern. The N+1 problem — the defining cost of GraphQL over relational
  backends, fought with dataloaders and batching — *dissolves*, because the
  whole query is one compiled traversal over the graph
- **Arguments → WHERE/ORDER BY/pagination**; **mutations → typed
  create/update/delete** operations
- Served by the same process as Bolt/HTTP/MCP (`relate serve` stacking
  one more protocol on the accept loop); resolvers are in-process, so
  GraphQL latency *is* engine latency — no server hop, no translation layer
  in between

## Why RelateDB

Everything the 2016 plugin needed is already first-class here: the catalog
models the schema as data, the engine resolves patterns natively, and the
serve stack already runs multiple protocol surfaces in one process — GraphQL
is one more tenant of the same accept loop. The embedded shape removes the
successor's biggest cost (the separate server process) while keeping its
ecosystem win: every GraphQL client, tool, and frontend framework (Apollo,
urql, GraphiQL) works unmodified by pointing at the endpoint — the
[Driver That Isn't](the-driver-that-isnt.md) argument for the GraphQL world.
And the WASM build makes the endpoint run in a tab: a local-first app whose
frontend speaks GraphQL to its own embedded graph. Honest scope: this is the
direct mapping, not the framework — federation, subscriptions, and auth
directives are explicitly out (they are what convoluted the original).

## What it needs

- The SDL emitter: labels/types/properties → type definitions with
  pluralized relationship fields and pagination
- The resolver: GraphQL document AST → type-directed Cypher compilation
  (argument handling, sort/filter mapping), one statement per root field
- The mutation set: create/update/delete/merge shapes with argument
  validation from the schema
- Live re-emit on schema change (the catalog diff is the trigger)
- A flagship demo: the movie graph served over GraphQL in a GraphiQL tab
  (WASM) and from the CLI

## Lineage & inspiration

- [neo4j-graphql](https://github.com/neo4j-graphql/neo4j-graphql) — the
  2016 plugin: GraphQL inside the database, the identity-ish mapping this
  project revives; the writeup is
  [GraphQL meets graph database](https://neo4j.com/blog/graphql/graphql-neo4j-graph-database-integration/)
- [The Neo4j GraphQL Library](https://github.com/neo4j/graphql) — the
  successor and the contrast: directive-driven generation, framework
  features, a separate server — the power this project consciously trades
  away for directness
- [The Driver That Isn't](the-driver-that-isnt.md) — the same
  drop-into-the-ecosystem argument, applied to GraphQL clients
- `relate serve` (ADR-0232/ADR-0248) — the protocol-stacking
  architecture the endpoint joins
