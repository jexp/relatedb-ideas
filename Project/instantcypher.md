---
type: Project
name: instantcypher
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
  - "[[Company/TypeSafe AI]]"
RELATED_IDEA:
  - kind: complements
    reason: the CLI-pipe cousin of the oracle post-processing stage
    target: "[[Project/shell-native-cypher]]"
  - kind: complements
    reason: the natural next step after comparing both query languages
    target: "[[Project/sql-vs-cypher-live]]"
  - kind: complements
    reason: the materialized form of the same oracle decisions
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JEV]]"
  - "[[Technology/MCP]]"
  - "[[Technology/PostgreSQL]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
---

# InstantCypher

> Natural-language questions compiled to deterministic, inspectable
> Cypher: a decision oracle (TypeSafe's Jev, the System One model — typed
> questions in, calibrated probabilities out, no free-text generation)
> choosing against the *real schema* as its option set. The pattern family
> the SQL world built three times over, in its confirmed empty lane: the
> graph one.

## What

"Ask your database in plain language" is mostly done by LLMs *generating*
queries — free text out, no guarantees, hallucinated columns included.
The decision-oracle family does it differently: send the state (schema +
question) as typed input, get typed answers — Choice among named options,
Score on described levels, a calibrated probability on a statement. The
SQL world already built this three times: IntentSQL (Jev decisions →
typed plan → deterministic SQL over SQLite), JevQL (PostgreSQL, judgment
cache, guarded writes), and [pg-jev](https://github.com/realZachi/pg-jev)
(1,209★ — `jev()` as a *plain-language SQL predicate*, "no index, no
embeddings"), with jev4pg extending to 41 query operators and an evidence
cache. **Nobody has done it for Cypher or any graph query language** —
searched and confirmed empty.

InstantCypher is the graph version, with the graph-specific twist the
SQL versions can't have: **the schema is the option set**. The oracle
chooses between real labels, real relationship types, real property keys
(the catalog as its menu), so the compiled query is grounded by
construction — "questions the model can only answer with the store's own
vocabulary." The pipeline: catalog → options; question → typed decisions
(plan shape, label choices, property predicates); decisions → a
deterministic Cypher template instantiation; template → execution, with
the generated query always shown and the decision trail attached.

**The engine-boundary question, answered up front** (the pg-jev design
question): the oracle is *not* a built-in function. The engine stays
hermetic — no network in the query path, queries remain pure functions of
the store (the TCK floor depends on it), and a tab-running WASM engine
can't hold API keys. The three legitimate shapes, in order: (1)
**post-processing** — the surface layer (CLI, embedding app, MCP host)
runs the query, then scores rows through the oracle as an inspectable
pipeline stage; (2) **materialization** — judgments written as data (see
[The Judgment Ledger](the-judgment-ledger.md)) so subsequent queries
traverse frozen decisions; (3) eventually, **host-registered callables** —
the SQLite `create_function` precedent, an embedder-provided procedure
the engine calls blind, consistent with the local-callables architecture.

Honest calibration, carried from the corpus benchmarks: routing accuracy
for model-in-the-loop selection is *negative* in published evals — the
pitch is **inspectability and determinism** (a compiled query you can read
and fix), not accuracy over the alternative.

## Why RelateDB

The catalog is already data (labels, relationship types, property keys
as queryable store content) — the option set for the oracle is one query
away. Deterministic Cypher from a decision trail means every generated
query is auditable, cacheable, and cheap — the judgment cache turns
repeat questions into template lookups. The embedded shape puts the whole
loop (schema → decide → compile → run → explain) in one process with no
server, and the WASM tab makes "ask this dataset in your words" a
shareable page: the gallery datasets with a plain-language box over them.

## What it needs

- The decision pipeline: catalog → typed options; question → decisions
  (the System One API); decisions → deterministic Cypher templates — with
  the graph-schema twist (pattern shapes, direction, var-length) that
  SQL's versions never had
- The template library: the bounded, parameterized Cypher skeletons the
  decisions fill (guarded reads first; writes only behind explicit
  confirmation)
- The judgment cache and the shown-query contract (never hidden)
- The eval: compiled-query correctness on a question corpus over the
  gallery datasets — published honestly

## Lineage & inspiration

- The SQL family: IntentSQL (SQLite), JevQL (PostgreSQL), and
  [pg-jev](https://github.com/realZachi/pg-jev) with
  [jev4pg](https://github.com/hadadrfg/jev4pg) — decisions as composable
  query operators, the reference implementation (`research/jev-head.md`)
- TypeSafe's System One (Jev) — the decision oracle; the corpus context
  in `research/jev-ecosystems.md`, the long tail in
  `research/jev-longtail.md`
- [SQL vs. Cypher, Live](sql-vs-cypher-live.md) — the next step after
  reading both languages: asking in neither
- [The Judgment Ledger](the-judgment-ledger.md) — the materialization
  form of the same decisions; [InstantCypher's post-processing stage] is
  the CLI-pipe cousin of [Shell-Native Cypher](shell-native-cypher.md)
