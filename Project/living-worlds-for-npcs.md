---
type: Project
name: living-worlds-for-npcs
IN_CATEGORY:
  - "[[Category/Games & Interactive Fiction]]"
MENTIONS_ORG:
  - "[[Company/Kanka]]"
  - "[[Company/World Anvil]]"
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: complements
    reason: copies Graphiti's bi-temporal edge model for when a fact became known
    target: "[[Project/graph-native-agent-memory]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Graphiti]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Obsidian]]"
  - "[[Technology/RelateDB]]"
---

# Living Worlds for NPCs

> D&D campaign / MMO NPC state: who met whom, what they know, grudges
> and debts as temporal edges; the game master queries the world instead
> of remembering it.

## What

Every game master runs a failing mental database: which NPCs have met
the party, who knows they killed the guard captain, which baron owes
them a favor, which NPC's death they forgot to avenge. Campaign
trackers store prose; this project stores the world as temporal edges —
`(:NPC)-[:MET {session}]->(:PC)`, `(:NPC)-[:KNOWS {since}]->(:Fact)`,
`(:NPC)-[:OWES {why}]->(:PC)`, `(:NPC)-[:GRUDGE {severity}]->(:PC)` —
and turns GM prep into queries. "Who in Waterdeep knows the party's
faces?" is a one-liner; "what unresolved hooks exist?" is the
dangling-edge report between sessions.

The killer query class is knowledge asymmetry: which NPCs know
something the players don't know they know, and which NPCs each PC has
met but the *group* hasn't — the split-party intelligence map. Session
notes feed the graph after each session, so the world's memory
compounds like a real world's; MMOs want the same engine at spawn
scale (reputation edges, grudge decay, witness lists — millions of
rows).

## Why RelateDB

A campaign is one `.cl` file: the GM's whole world memory in a portable
artifact that passes to the next GM when the campaign does — the
handoff that is otherwise a Drive folder of documents. Temporal edges
are the point: *when* an NPC learned a fact decides whether they can
act on it, and native temporal types make "what did he know as of
session 12" a filter, not a forensic reconstruction. The WAL means
notes append incrementally — no rebuild — and the in-memory store
answers mid-session queries instantly while the party waits. Python
bindings ingest notes and transcripts, `serve --http` gives the VTT
integration an endpoint, and `--mcp stdio` makes the world queryable
by the AI assistant at the table — it reads the grudge graph instead
of guessing, the difference between a roleplay aid and a
hallucination machine.

## What it needs

- The NPC-state ontology (met/knows/owes/grudge/quest edges) with
  session timestamps and decay rules for grudges and favors
- Post-session ingest: notes or transcript → edge suggestions the GM
  confirms (never auto-written lore)
- GM prep query pack: dangling hooks, knowledge asymmetries, per-PC
  relationship reports
## Lineage & inspiration

- Kanka and World Anvil — the campaign trackers proving the need (and
  storing prose where queries should be): https://kanka.io |
  https://www.worldanvil.com/
- Graphiti's bi-temporal edge model — *when* a fact became known as a
  first-class question; the pattern to copy:
  https://github.com/getzep/graphiti (research/agent-native.md)
- Obsidian D&D campaign vaults — GMs already live in local files; this
  is that vault with a query language
- The JEV corpus's NPC-society builds — jev-lab's "Hundred" (100 town
  NPCs with relationships and memories, the oracle answering only "what
  next") and the player-model ledgers (opponents that study your habits
  and write counter-rules between fights) — the simulation-tick frontier
  of this same idea (`research/jev-longtail.md`)
