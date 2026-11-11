---
type: Project
name: the-fact-check-engine
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Diffbot]]"
  - "[[Company/GDELT]]"
  - "[[Company/ICIJ]]"
RELATED_IDEA:
  - kind: complements
    reason: provenance chains for claims built from recorded judgments
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GDELT]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
---

# The Fact-Check Engine

> Import Diffbot/GDELT slices as the evidence graph; paste an article,
> extract its claims, and query each against the source graph: which
> entities co-occur in reporting, which claimed relationships have no
> documented edge anywhere — fact-checking as missing-edge detection
> with full provenance (which sources say what, and how they're
> connected).

## What

The product is a laptop, an article, and a verdict with receipts. The evidence
layer is an evidence graph imported from public news-scale datasets — Diffbot's
Knowledge Graph slices and GDELT's event/co-occurrence data — plus the beats
you follow: `(:Article)-[:MENTIONS]->(:Entity)`, `(:Source)-[:PUBLISHED]->`,
`(:Entity)-[:CO_OCCURS {in}]->(:Entity)`, every edge carrying provenance
(article, date, outlet). Then you paste today's article: an extraction step
(local LLM or rules) turns its sentences into typed claims, each a candidate
edge over the same node vocabulary.

The check is the twist: each claim is queried against the evidence
graph, not matched against a text index. *Supported* claims land on
documented edges with provenance (and one-hop source-graph checks on who says
so). *Novel* claims have no documented edge anywhere — the missing-edge result
that separates "new reporting" from "invented relationship" and *names the
exact edge that is missing*. Between them: entities co-occurring with a
different relation (possible conflation), and claims supported only by
connected sources (the echo check). The verdict page cites its evidence as
paths.

The sources are documented and structured, and the claim side has shipped
predecessors. GDELT publishes daily event and mentions tables as CSV with a
versioned V2.0 codebook (CAMEO-coded actors and events, co-occurrence via the
mentions table) — columnar is literally its native form; Diffbot's KG is
queried through DQL. ClaimBuster (UTA) is the end-to-end claim spotter —
VLDB 2017, check-worthy claim detection from live transcripts — and Duke
Reporters' Lab built Tech & Check and Squash on ClaimReview and now publishes
the Fact-Check Insights dataset: the verified-claim corpus a verdict pack
can calibrate against.

## Why RelateDB

"Which claimed relationships have no documented edge anywhere" is
literally a query — missing-edge detection needs traversal, not
search, against a graph that fits the analyst's machine: Diffbot/
GDELT slices arrive as Parquet via `relate-arrow` (the import
path built for exactly this columnar-in, graph-out job), and the
store is a single `.cl` file per case — an investigation in one attachment a
newsroom shares, or a browser tab over WASM. Hybrid search (`COMBINE`) drives
the article-to-graph entity linking; the verdicts stay Cypher. Temporal types
keep reporting dates first-class. Python bindings run the ingest and extraction
pipeline, `serve --mcp stdio` turns the graph into a tool agents query instead
of hallucinating sources, and the WAL keeps the case file growing.

## What it needs

- Importers: Diffbot KG slices and GDELT event/co-occurrence tables via
  `relate-arrow`, provenance edges mandatory on every write
- The claim extractor: article → typed candidate edges over the
  graph's entity vocabulary (local model, reviewable output) —
  ClaimBuster's check-worthy-claim model as the extraction precedent
- The verdict query pack: documented / missing-edge / conflated /
  echo-supported, each returning provenance paths
- Calibration against Fact-Check Insights: the verified-claim corpus
  as the verdict pack's test set

## Lineage & inspiration

- Diffbot Knowledge Graph — the web-scale entity/relation source seeding the evidence layer, queried through DQL: https://www.diffbot.com/products/knowledge-graph/ | https://www.diffbot.com/docs/dql/
- GDELT — global news events and co-occurrence at scale, the second parent dataset (research/graph-world.md): https://www.gdeltproject.org/ | data access and the V2.0 event codebook: https://gdeltproject.org/data.html | http://data.gdeltproject.org/documentation/GDELT-Event_Codebook-V2.0.pdf
- ClaimBuster (UTA IDIR) — the end-to-end automated fact-checking system, VLDB 2017, and the live claim spotter: https://claimbuster.org/ | https://vldb.org/pvldb/vol10/p1945-li.pdf | https://github.com/utaresearch/claimbuster-spotter
- Duke Reporters' Lab — Tech & Check, the Squash lessons, and the Fact-Check Insights dataset: https://reporterslab.org/tech-and-check/ | https://reporterslab.org/2021/06/28/the-lessons-of-squash-our-groundbreaking-automated-fact-checking-platform/ | https://factcheckinsights.org/guide
- ClaimReview + Google Fact Check Tools — the structured-claim interop format to emit/consume: https://claimreview.gdeltproject.org/
- Project Domino (Leo Meyerovich, Graphistry + the Data Ride-Alongs) — citizen data science against the COVID "infodemic": claim sources, social-media echo networks, and authority endpoints as one analyzed graph, from the DefCon AI Village keynote onward: https://www.graphistry.com/blog/defcon-aiv-keynote-citizen-science-against-covid-misinformation | code: https://github.com/theDataRideAlongs/ProjectDomino | writeup: https://diginomica.com/could-data-science-help-us-fight-back-against-covid-infodemic
- The ICIJ Offshore Leaks precedent — graph databases as journalism's instrument (research/graph-world.md), pointed at claims instead of shell companies
