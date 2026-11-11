---
type: Project
name: the-nothing-to-watch-chooser
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/GroupLens]]"
  - "[[Company/JustWatch]]"
RELATED_IDEA:
  - kind: complements
    reason: shared store and import lineage for the couch-side consumer
    target: "[[Project/the-movie-graph-all-grown-up]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/IMDB]]"
  - "[[Technology/MCP]]"
  - "[[Technology/MovieLens]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/TMDB]]"
  - "[[Technology/WASM]]"
---

# The Nothing-To-Watch Chooser

> Moods, actors, themes, runtimes; "40 minutes and tired" as a weighted
> query.

## What

The streaming paradox: infinite catalogs, endless scroll, and the evening ends in
the preview carousel. The chooser replaces scroll with query: your watch history and
wishlist as a graph — `(:Title {runtime, type})-[:WITH_THEME]->(:Theme)`,
`[:FEATURING]->(:Actor)`, `[:FROM]->(:Franchise)` — plus a personal mood layer
(`(:Mood)` edges built by tagging things you loved) and the evening's constraints as
parameters: "40 minutes and tired" is `runtime <= 40, mood = comfort, type =
episodic, not re-watched-this-month`, one weighted query returning candidates *with
reasons* (episodic, 22 minutes, comfort-adjacent to what you rated 9, first episode
of a completed series so it can't cliffhang you).

The reasons are the product: every pick returns its evidence path, so
unlike every streaming UI the chooser is auditable — you can see it chose the baking
show because of the comfort edge you gave *Great British Bake Off* in November, and
prune the edge if it lied. Around the nightly query: the "two hops from your
favorite but never tried" discovery lane; and the group query — two tired people,
both profiles, the intersection that respects both histories.

## Why RelateDB

This is the Movie Graph, All Grown Up's couch-side consumer: the same
store (TMDB/IMDB import via `relate-arrow`, the classic movies
lineage) pointed at one person on one evening, running where the decision happens —
in a browser tab over WASM on the couch device, offline-capable, zero install,
because the nothing-to-watch moment is exactly when nobody will tolerate a setup
ritual. The personal layer (moods, ratings, watch history) is one `.cl` file — watch
data is intimate and belongs on your disk, not in a recommendation system's training
corpus. Hybrid search (`COMBINE`) handles the vibe side ("something like *Chef's
Table* but about carpentry") while the constraints stay exact Cypher. Temporal types
make "re-watched this month" native; the WAL takes the ten-second post-watch ritual
(rated, finished, abandoned at minute 30 — abandonment edges are gold); and MCP lets
the agent that knows your evening ask the real graph.

## What it needs

-

The store: TMDB/IMDB import (the Movie Graph project's pipeline) plus the
personal mood/rating/history layer as edges
- The evening query: constraint + weight model ("40 minutes and
tired") whose every answer returns its evidence path
- The mood layer: personal tagging UX that builds edges fast (one
word per watch), with edge pruning when a pick explains badly

## Lineage & inspiration

- The Movie Graph, All Grown Up (this collection) — the shared store
  and import lineage: the neo4j-graph-examples movies dataset
(research/graph-world.md), TMDB, MovieLens for the collaborative
cold start
- JustWatch / the streaming-decision-fatigue era — the mainstream
proof that catalog search is solved and *evening choice* is not
- GroupLens/MovieLens preference research — the ratings-corpus science
behind the weighted scoring, embedded and personal here
