---
type: Project
name: software-design-x-rays
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/CodeScene]]"
  - "[[Company/jQAssistant]]"
MENTIONS_PERSON:
  - "[[Person/Adam Tornhill]]"
RELATED_IDEA:
  - kind: complements
    reason: cited as the renderer that consumes the same data
    target: "[[Project/code-cities]]"
  - kind: complements
    reason: static structure graph complements the behavioral churn graph
    target: "[[Project/code-graph]]"
  - kind: variant
    reason: same churn vocabulary applied to public GitHub history
    target: "[[Project/software-analytics-sandbox]]"
USES_TECH:
  - "[[Technology/CSV]]"
  - "[[Technology/CodeScene]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Git]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/jQAssistant]]"
---

# Software Design X-Rays

> Adam Tornhill's method on a WAL-backed temporal graph: churn (from git history) × complexity per file; hotspots are one query, the trend line is a time-window replay. CodeScene's behavioral analytics — summed per module — without the SaaS.

## What

Adam Tornhill's behavioral-code-analytics method: the risk in a codebase isn't
where the code is complex — it's where complexity *coincides with churn*. Files
that change often and are hard to change are the hotspots where defects
cluster. His approach (built into CodeScene as a SaaS) computes churn×
complexity per file and per author, then layers behavioral signals: temporal
coupling (files that change together), knowledge loss (authors who vanished
from a file), and developer fragmentation (a file touched by everyone).

This project runs the whole method on a local graph: `git-to-graph` gives the
commit/file/author history; a complexity metric per file completes the hotspot
matrix. Then every analysis is one Cypher query: hotspots are `ORDER BY churn
* complexity DESC`; temporal coupling is co-churn correlation between files;
knowledge decay is author coverage per file over a trailing window. Summed per
module or directory — the hierarchy is already the graph.

And the trend line: WAL-backed time-window replay re-runs the analysis as of
any past date — watch a hotspot *emerge* over the quarters.

## Why RelateDB

`relate lab git-to-graph` already ingests the git history — commits, files,
authors, changesets — with `--since`, `--max-commits` controls; the churn half of
the matrix is a built-in lab command, not a new pipeline. The WAL is the honest
trend machine: analysis runs are themselves recorded, and time-window replay is
native (an Event-Stream-to-Temporal-Graph shape). In-memory Cypher turns the
churn×complexity matrix, temporal-coupling pairs, and author-coverage queries
into interactive explorations of arbitrarily large histories instead of batch
jobs. Results export as CSV/JSON for charts. The single binary + `.cl` file means a
team's X-ray is a committed artifact — per-team baselines in git, no SaaS
subscription, no uploading your code to someone's metrics platform.

## What it needs

- Complexity scoring per file (language-aware; per-file cyclomatic or Tornhill-
  style weighted lines) as a post-pass over the graph
- The query pack: hotspot ranking, temporal coupling, knowledge
  loss/fragmentation, hotspot-per-module rollups — curated Cypher with
  documented intent
- Time-window replay tooling over the stored analysis history
- A dashboard front end: hotspot treemaps and trend lines from CSV/JSON output
  (or the Code Cities renderer — same data)
- Metric honesty: complexity metrics are proxies; document the limits

## Lineage & inspiration

Adam Tornhill's **Software Design X-Rays** and *Your Code as a Crime Scene*
(https://adamtornhill.com) — the method and the metaphor; CodeScene
(https://codescene.com) is the SaaS whose analytics this reproduces locally
("summed per module, without the SaaS"). From
[research/graph-world.md](../research/graph-world.md) §6: the
[GH Archive](https://www.gharchive.org) analytics lane proves behavioral
signals over event history are a graph problem, and jQAssistant
(https://jqassistant.org, the user's OG code-graph project) first showed that
repo-scanned graphs make maintainability queryable.
