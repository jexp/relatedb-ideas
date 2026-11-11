---
type: Project
name: the-driver-that-isnt
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/DuckDB Labs]]"
  - "[[Company/Electric SQL]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: both expose the engine through an API ecosystem already expects
    target: "[[Project/graphql-straight-from-the-engine]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DuckDB]]"
  - "[[Technology/GraphRAG]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/PGlite]]"
  - "[[Technology/RelateDB]]"
---

# The Driver That Isn't

> A Neo4j-driver-shaped client library backed by the embedded engine
> (`GraphDatabase.driver("relate:...")`): GraphRAG packages, GraphQL
> libraries, and every tool already written against the Neo4j driver run on an
> embedded, zero-server RelateDB by swapping one URL (the DuckDB-driver
> pattern; the pglite precedent of "the real protocol, embedded").

## What

The graph-tooling world already standardized on one client: the Neo4j driver.
GraphRAG frameworks, GraphQL-to-Neo4j layers, LangChain graph stores, test
suites, notebooks — thousands of integrations are written against
`GraphDatabase.driver(...)` and plain Cypher, and every one assumes a server at
the other end. This project ships a driver that isn't: the same API shape, the
same `Session`/`Result` surfaces — backed by the embedded RelateDB engine
instead of a socket.

The user-facing change is one URL: `GraphDatabase.driver("relate://./my.cl")`
instead of `"neo4j://..."`. Nothing else in the application moves. The driver
opens the local store (a file, a directory, or `:memory:`), executes queries
in-process, and returns real driver types — records, nodes, relationships,
paths — so libraries that destructure results keep working untouched.

Both precedents hold up under inspection. DuckDB's Python client is one pip
package — `duckdb.connect("file.db")` (or in-memory) and queries run
in-process, no server, no service — which is exactly why `import duckdb`
appears unmodified inside hundreds of downstream libraries. And the Neo4j
driver surface is a stable, documented contract, not a vibe:
`GraphDatabase.driver(url, auth)`, then `driver.execute_query(...)` or a
`Session`, results as `Record` objects that behave like read-only mappings of
name to value. A facade that reproduces `driver`/`Session`/`Record` plus the
URL scheme is compatible at the call-site level — which is the level
ecosystem libraries actually code against.

## Why RelateDB

The dialect is the prerequisite: RelateDB passes the openCypher TCK floor,
so driver-written Cypher actually runs rather than mostly-runs. The engine is
embeddable in every language the Neo4j drivers ship in — the C ABI under the
Python, JS, Java and Go clients means each language's "driver" is a thin
facade over the same in-process engine, and the WASM build covers the browser
(like PGlite). Result metadata, parameter semantics and error shapes stay
aligned with the driver's expectations (Bolt is a transport, so the embedded
path can mirror its wire types faithfully), and the store is one portable
`.cl` file — tests run against committed graph fixtures, not a containerized
server in CI.

## What it needs

- Driver facades per language, starting with Python and JS/TS: the Neo4j
  driver's object model over the C-ABI client; `relate:` URL scheme and
  path/`:memory:` targets
- Record/result type fidelity: nodes, relationships, paths, temporal and
  spatial types shaped the way driver consumers destructure them
- A compatibility test suite: the well-known GraphRAG / GraphQL / LangChain
  integrations running unmodified against the embedded driver, pinned in CI
  as the runnable examples
- The driver-shaped client investigation is tracked in the RelateDB backlog

## Lineage & inspiration

- [PGlite](https://pglite.dev/) — "the real protocol, embedded": full Postgres
  in the browser instead of a lookalike; the precedent for embedding the real
  thing under the expected API
- The [duckdb-driver pattern](https://duckdb.org/) — ecosystem adoption via a
  drop-in connection API; the [Python client
  docs](https://duckdb.org/docs/2.0/clients/python/overview.html) show the
  one-package in-process shape being copied; users never compared engines,
  they compared imports
- [Neo4j drivers](https://neo4j.com/docs/establishing-connections/) and the
  [Python driver API reference](https://neo4j.com/docs/api/python-driver/current/api.html)
  — the API surface being mirrored (`GraphDatabase.driver`, `Session`,
  `Record`); Bolt as the semantics reference, embedded as the
  transport; [research/embedded-ecosystems.md](../research/embedded-ecosystems.md)
  §4 and the cross-cutting patterns — the findings this project applies
