---
type: Project
name: developer-social-networks
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
MENTIONS_ORG:
  - "[[Company/GitHub]]"
  - "[[Company/Meetup]]"
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: supplies the PageRank and clustering queries the guides call for
    target: "[[Project/gds-round-trip]]"
  - kind: complements
    reason: the same tutorial corpus format turned into teaching material
    target: "[[Project/graph-school]]"
  - kind: variant
    reason: the personal-subgraph instance of the same open social-network family
    target: "[[Project/your-follow-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GitHub]]"
  - "[[Technology/GraphQL]]"
  - "[[Technology/Meetup]]"
  - "[[Technology/Stack Overflow]]"
  - "[[Technology/Twitch]]"
---

# Developer Social Networks

> Developer social networks have open APIs and free data access — and they
> matter to a developer audience. Load your personal network or your
> subgraph of interest, then query, visualize, and analyze it. One dataset
> family, one `.cl`-file shape each.

## What

The concept: social networks are the best way to *explain* graphs, and
developer social networks are the ones with genuinely open data — Twitter
(followers, follows, tweets, tags, URLs — pull your own via auth), Stack
Overflow (questions, answers, tags, users — via the API or filtered dumps),
GitHub (orgs, repos, languages, topics, issues, collaboration via the
GraphQL API or GH Archive slices), Meetup (geography, topics, RSVP
streams), Slack/Discord (community archives), Twitch (a prepared
10M-node/17M-relationship streamer graph exists — streamers, teams,
games, moderators, chatters), Reddit (subreddit hyperlink networks,
meme graphs), YouTube (API-driven video/comment graphs).

Each dataset ships the same shape: a dump file of pre-selected interesting
data, a model image, an example query with parameters and expected result,
and a browser guide with incremental-complexity queries — intro Cypher,
top-n, recommendations and collaborative filtering, clustering, PageRank,
similarities. The full dataset catalog with importer code, prior articles,
and per-network analytics ideas is in
[`research/developer-social-networks.md`](../research/developer-social-networks.md).

## Why RelateDB

This is the tutorial corpus that taught a generation of graph developers —
and RelateDB makes it *personal again*: your own follower graph, your own
Stack Overflow questions, your own org's GitHub activity — loaded in
seconds, queryable without a sandbox, shareable as one `.cl` file that
reopens on any laptop or in a browser tab (WASM). The engine's
recommendations-friendly shape (in-memory multi-hop at interactive speed)
makes the collaborative-filtering and PageRank queries feel live; hybrid
search adds the semantic layer the original guides never had ("questions
like mine" by meaning, not just tags).

## What it needs

- Per-network loaders (Python bindings; the community-graph importer code
  base is the lineage) producing `.cl` dumps
- The browser guide format (the cookbook recipe precedent: data + model +
  queries in one citable file)
- A personal-data pull path (OAuth where the API requires it — your own
  subgraph of interest)
- The GDS bridge for the PageRank/clustering queries ([GDS
  Round-Trip](gds-round-trip.md))

## Lineage & inspiration

- [`research/developer-social-networks.md`](../research/developer-social-networks.md)
  — the full catalog: 13 networks, importer code, guides, data models, and
  the prior-article corpus
- The neo4j-graph-examples repos (twitter-v2, github) — the shipped
  dataset template this family follows
- The [Analyzing Meetup Data with Neo4j](https://guides.neo4j.com/meetup)
  training guide — the groups/topics/members/events model that taught a
  generation of graph classes, in a guide whose own pages link to hidden
  follow-on pages (a graph guide that is itself a small graph). Its import
  is dead as written — Meetup killed the REST API on January 31, 2022 and
  pushed everything to a GraphQL successor — which is exactly the
  community-archive argument this family carries: platforms change or kill
  their APIs; the archived `.cl` outlives them
- The community-graph importer CLI (the loader code base)
