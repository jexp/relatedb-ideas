---
type: Project
name: chat-native-queries
IN_CATEGORY:
  - "[[Category/Tooling & Developer UX]]"
MENTIONS_ORG:
  - "[[Company/Discord]]"
  - "[[Company/Slack]]"
  - "[[Company/Telegram]]"
RELATED_IDEA:
  - kind: complements
    reason: named as the shareable-result artifact the bot attaches
    target: "[[Project/graphclips-heroku-dataclips-reborn]]"
  - kind: complements
    reason: named as the prose-to-Cypher bridge behind the ask-in-prose mode
    target: "[[Project/instantcypher]]"
  - kind: complements
    reason: named as the shared store the bot fronts
    target: "[[Project/team-wiki-from-a-shared-file]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Discord]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/Slack]]"
  - "[[Technology/Telegram]]"
  - "[[Technology/WASM]]"
---

# Chat-Native Queries

> The team's chat window as the query interface: a Slack/Discord/Telegram
> bot over the shared `.cl` — slash commands run stored queries, results
> render in-channel, and the channel's own history is the access log.

## What

Every team already lives in a chat tool, and every shared graph file
(community archive, team wiki, incident graph, club's board-game night
matchmaker) has the same last-mile problem: the people who'd query it
don't have a terminal, don't open a browser tab deliberately — they're
already somewhere else.

This project is the messenger form factor: a small bot process that owns a
RelateDB connection (locally-embedded or Bolt to a `serve` instance) and
exposes the graph where the team already is:

- **Slash commands run stored queries** — `/graph top-customers` maps to
  a named, parameterized query (the local-callables stored-query pack),
  rendered as an in-channel card or table; the command surface *is* the
  query pack's public API
- **Ask in prose, get the query's answer** — the InstantCypher pattern
  behind the bot: natural language → deterministic Cypher against the
  real schema, with the generated query shown, never hidden
- **In-channel rendering** — results as attachments, images (the mermaid
  result mode), or shareable clips (the GraphClips form): answers that are
  themselves artifacts
- **The channel as the audit log** — who asked what, when, and what the
  graph said; the WAL of the *interface*, greppable in the chat archive

The honest boundary: chat is the *lightweight read* surface — data entry
and heavy analysis still want the real surfaces; the bot's value is
answers-in-context during conversation, where the question was actually
born.

## Why RelateDB

The bot process embeds the engine (no database server to babysit — one
process, one WASM-or-native build, the token and file permissions already
handled by the chat platform). Stored queries via local-callables give the
slash-command table for free, with parameters and stable output shapes;
the formatter family renders for chat; and the `.cl` durability means the
bot's store is the team's shared artifact (the wiki-as-file and
community-archive ideas) — the chat surface is just one more tenant of the
serve stack, like Bolt/HTTP/MCP.

## What it needs

- The bot shell (one process, Slack/Discord/Telegram adapters over their
  bot APIs) with the command → stored-query mapping
- The rendering pack: tables/cards, the mermaid diagram mode, GraphClips
  export links
- The prose-bridge for questions (the deterministic question-compiler
  family — the InstantCypher candidate in `research/jev-ecosystems.md`)
  — with the query always shown
- The audit export: channel history → the question/answer log as a query

## Lineage & inspiration

- The Slack/Discord/Telegram bot platforms — the messenger surfaces this
  adapter family targets; the wiki-as-file store it fronts ([Team Wiki
  from a Shared File](team-wiki-from-a-shared-file.md)) and the
  community-archive pattern (`research/bending-spoons-portfolio.md`)
- The deterministic question-compiler family (the InstantCypher candidate,
  `research/jev-ecosystems.md`) — the prose-bridge this bot would use
- [GraphClips (Heroku Dataclips, Reborn)](graphclips-heroku-dataclips-reborn.md)
  — the shareable-result artifact the bot attaches
- The serve stack (Bolt/HTTP/MCP) — the pattern the chat adapter joins as
  one more tenant
