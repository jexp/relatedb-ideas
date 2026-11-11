---
type: Project
name: smart-home-state-graph
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/Zep]]"
RELATED_IDEA:
  - kind: variant
    reason: same append-only event stream into a temporal property graph
    target: "[[Project/event-stream-to-temporal-graph]]"
  - kind: inspired-by
    reason: borrows graphiti's bi-temporal event/entity model
    target: "[[Project/graph-native-agent-memory]]"
  - kind: complements
    reason: both graph the state of a household's infrastructure
    target: "[[Project/home-network-atlas]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Home Assistant]]"
  - "[[Technology/MQTT]]"
  - "[[Technology/Python]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SQLite]]"
  - "[[Technology/WAL]]"
---

# Smart-Home State Graph

> HomeAssistant/MQTT events into a temporal property graph; "who turned the lights on at 3am and what triggered it" is a path query.

## What

Smart-home history is a firehose of events that dashboards flatten into
per-device charts. But the interesting questions are causal and relational: the
light came on at 3am *because* the motion sensor fired *because* the cat moved —
or because someone's phone joined the WiFi. A temporal property graph keeps all
of it: `(:Event)-[:TRIGGERED]->(:Event)`, `(:Device)-[:EMITTED]->(:Event)`,
`(:Person)-[:PRESENCE]->(:Zone)`, every event stamped with RelateDB's native
temporal types.

Then "who turned the lights on at 3am and what triggered it" is literally a path
query: match the light event, walk `TRIGGERED` edges backwards, land on the
automation, the sensor, and — via presence edges — whether anyone was home.
Automations become first-class nodes, so "which automations reference the sensor
I'm about to replace?" is reachability over your own home's logic.

The killer view is replay: WAL-backed means the store *is* the append-only event
log, so scrubbing a time window and re-querying it as it was is native — not a
rebuilt feature. "Show me the house between 02:58 and 03:10."

The ingest contract is documented, not guessed. Home Assistant's state model
is exact: every entity has a state object — `entity_id`, `state`, `attributes`,
`last_changed`, `last_updated` — and every state change propagates as a
`state_changed` event on the event bus; the recorder component persists those
states to SQLite as the official history. That maps one-to-one onto the graph
model: state objects → Event nodes, the `last_changed`/`last_updated` pair →
the bi-temporal properties, `state_changed` events → the WAL batches, and the
recorder's schema is both the backfill source and the checklist for what the
graph must keep.

## Why RelateDB

The event-ingest shape fits perfectly: MQTT/HomeAssistant events are an append-
only stream, and RelateDB's WAL is exactly an append-only durable log — each
event batch is a transaction, each checkpoint a snapshot to rewind to for the
time-window replay. Native temporal types make the time comparisons (`event.time
> datetime('03:00')`, durations, overlapping intervals) first-class instead of
string arithmetic. In-memory Cypher at scan speed keeps dashboard queries
interactive even against years of events. It runs where the data is: a
Raspberry Pi under the stairs with the single binary, `serve --http` feeding a
home dashboard, or fully embedded in a HomeAssistant add-on via the Python
bindings over the C ABI. `:memory:` mode gives automations a scratch graph for
"what would this rule have matched yesterday?" dry runs.

## What it needs

- A HomeAssistant integration / MQTT bridge mapping entities, states, and
  automation executions to the graph model (entity registry → Device nodes;
  state changes → Events; automation traces → TRIGGERED edges)
- Backfill from HomeAssistant's recorder database for the pre-existing history
- The replay front end: timeline scrub + neighborhood view around any event
- Pruning policy — event graphs grow; compaction (roll old events into hourly
  summaries) needs to be deliberate, WAL-aware

## Lineage & inspiration

From [research/graph-world.md](../research/graph-world.md): the event-stream-to-
temporal-graph pattern sits beside
[GH Archive analytics](https://www.gharchive.org) — firehoses that are natural
graphs once you stop flattening them into tables. From
[research/agent-native.md](../research/agent-native.md): [zep](https://arxiv.org/html/2501.13956)
and [graphiti](https://github.com/getzep/graphiti) established the bi-temporal
event/entity model ("when was it true vs when did we learn it") this project
borrows for state history; and the LangGraph forum's
["transaction log for agent systems"](https://forum.langchain.com/t/what-is-the-equivalent-of-a-transaction-log-for-agent-systems/3986)
ask is the same ask — a WAL-shaped memory for stateful systems.
The Home Assistant contract itself is verified at
[State and state object](https://developers.home-assistant.io/docs/dev_101_states/),
the [recorder integration](https://www.home-assistant.io/integrations/recorder/),
and its [persistent schema](https://github.com/home-assistant/core/blob/dev/homeassistant/components/recorder/db_schema.py)
— the closest production graph-shaped home-automation store, and the model
this project extends with explicit causal edges.
