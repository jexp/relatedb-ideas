---
type: Project
name: software-analytics-sandbox
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
MENTIONS_ORG:
  - "[[Company/ClickHouse]]"
  - "[[Company/GitHub]]"
RELATED_IDEA:
  - kind: variant
    reason: explicitly shares the churn vocabulary, applied to public history
    target: "[[Project/software-design-x-rays]]"
  - kind: complements
    reason: supplies the dependency-edge half of the supply-chain questions
    target: "[[Project/transitive-dependency-networks]]"
USES_TECH:
  - "[[Technology/Arrow]]"
  - "[[Technology/ClickHouse]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/GH Archive]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Software Analytics Sandbox

> GitHub Archive (GH Events) subsets as graphs; bus-factor, orphaned modules, coordination bottlenecks — reproducible, in one file.

## What

GH Archive records the entire GitHub firehose — every push, PR, issue, comment,
star — hourly, as JSON. People mine it in ClickHouse when they have a warehouse;
this project makes a *wedge* of it a personal research instrument: pull a subset
(a topic's repos, an org, a language's top projects, one interesting month),
model it as a graph — `(:Actor)-[:OPENED]->(:PullRequest)-[:TOUCHED]->(:Repo)`,
`(:Actor)-[:COMMENTED_ON]->(:Issue)`, `(:Repo)-[:DEPENDS_ON]->(:Repo)` — and
compute the empirical-software-engineering hits with plain Cypher.

Bus factor (how few actors touch the critical files), orphaned modules (code
whose every author has vanished), coordination bottlenecks (PRs waiting on
one reviewer), architectural hotspots via co-change — each is a query, not a
pipeline. Because the wedge is a single `.cl` file, an analysis is *reproducible
by construction*: the blog post or team review ships the file, and anyone
re-runs the queries against exactly the same graph. The dataset
becomes an artifact you can attach — a software-engineering course can hand
out one `.cl` file per study and let students *interrogate* the differences.

## Why RelateDB

GitHub events are JSON with actor/repo/event structure — a direct loader, and
the `pull` command's shape (query a source, `CREATE` into a database) plus
JSONL ingestion covers the mechanical half. The wedge stays modest (a topic or
an org, not 4B events/month), and in-memory Cypher at scan speed makes the
interactive part — slice, re-query, pivot the cohort — instant, which is the
difference between exploring and merely reporting. Reproducibility is the
core claim, and the single `.cl` file delivers it: data + the queries' dialect
floor travel together, openable by anyone via the CLI, in a browser tab (WASM),
or through the Python bindings for the notebook crowd. Arrow conversion
(`relate-arrow`) makes the Parquet-adjacent half of the ecosystem
interoperable, and CSV/JSON output feeds the charts.

## What it needs

- GH Archive downloader: hour-slices filtered by repo/topic into JSONL → the
  graph model (the filter discipline is what keeps a wedge a wedge)
- Event vocabulary mapping (PushEvent → FileChanged edges with co-change
  pairs; PullRequestEvent → the review graph)
- The analysis query pack: bus factor, orphan detection, review bottleneck,
  co-change coupling, activity decay — documented Cypher, each citing the ESE
  metric it implements
- Dependency edges from lockfiles/manifests for the supply-chain questions
- A study format: one .cl file + a markdown of the queries and findings

## Lineage & inspiration

[GH Archive](https://www.gharchive.org) and the
[ClickHouse github-explorer](https://ghe.clickhouse.tech/) — the whole firehose
as a queryable dataset, stored in columns though it's a natural graph;
[rjurney/github_network](https://github.com/rjurney/github_network/) — the early
example of turning it into a social graph and mining collaboration. From
[research/graph-world.md](../research/graph-world.md) §6:
[GUAC](https://github.com/guacsec/guac/) (software-supply-chain knowledge
graph — the dependency half of the model), and this project shares its churn
vocabulary with **Software Design X-Rays** (Tornhill's behavioral analytics —
https://adamtornhill.com) — applied to public history instead of your repo.
