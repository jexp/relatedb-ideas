---
type: Project
name: atproto-firehose-graph
IN_CATEGORY:
  - "[[Category/Social & Community Networks]]"
MENTIONS_ORG:
  - "[[Company/Bluesky Social]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: the dataset-family tradition this entry explicitly extends
    target: "[[Project/developer-social-networks]]"
  - kind: complements
    reason: cited as the ingestion pattern this firehose follows
    target: "[[Project/the-emergent-interaction-graph]]"
  - kind: complements
    reason: cited as the personal-slice framing
    target: "[[Project/your-follow-graph]]"
USES_TECH:
  - "[[Technology/ATProto]]"
  - "[[Technology/Bluesky]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Jetstream]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Pulsar]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# The AT Protocol Firehose Graph

> Bluesky/ATProto as the open social network we can finally watch being
> born: a temporal interaction graph with typed overlays (follow, mention,
> reply, repost, hashtag) from the Jetstream firehose — plus the protocol's
> own infrastructure as a graph: DIDs, PDSes, relays, AppViews, and across
> the bridge, the fediverse's instance mesh.

## What

Two graphs live in the AT Protocol stack, and both are unprecedentedly
open:

**The social layer.** Jetstream (Bluesky's websocket firehose — the
>99%-slimmer successor to the raw event stream) publishes every follow,
post, reply, repost, mention, and like as typed, timestamped events. That
is a temporal interaction network building itself in public: overlays the
way the Twitter/troll-analytics tradition had — `(:User)-[:FOLLOWED {at}]->`,
reply trees, repost amplification with provenance, hashtag co-occurrence,
mention graphs — plus what Twitter never gave: **the protocol layer
between** the same events and the identities' infrastructure homes.

**The infrastructure layer — the graph of the network itself.** Every
account is a DID hosted on a PDS; relays subscribe to PDS event streams and
feed AppViews; feed generators and labelers hang off the relay; bridges
(like the fediverse bridge) connect whole protocol worlds. On the
fediverse side: instances, their versions, moderation policies, peer
visibility, and the server-to-server message flows that define who
actually talks to whom. Nobody can see the whole topology — a
PDS-relay-AppView federation map is exactly the kind of network science
that previously needed a platform's internal logs. Pulsar (the relay
observatory) is one slice of it, already.

The early ecosystem did firehose-graph investigations with Neo4j when the
protocol was barely out the door; the open question is what an *embedded*
version enables: personal firehose slices ("my follows' 30-day
neighborhood, as a file"), community-scale archives as `.cl` datasets with
the same query packs the developer-social-networks family ships, and the
infrastructure map as a living graph (`:PDS {up, lag}` → relay coverage →
AppView freshness — the fediverse instance-graph studies as a sibling).

## Why RelateDB

The firehose is a WAL-shaped event stream ingested exactly the way the
engine ingests everything else (append → temporal graph, the Event Stream
pattern) — and the personal-slice scale (your neighborhood, one
community, one hashtag's lifetime) is precisely where a laptop or a tab
holds the whole thing interactively while the big-graph world needs a
cluster. Overlays are stored query packs. The troll-detection genre
(brigading as coordinated reply bursts, amplification rings as dense
temporal subgraphs) becomes WASM demos — one file per investigation,
shareable like the ICIJ datasets. And the infrastructure map is a
ground-truth graph the protocol itself makes observable: relays publish
their subscriptions; instance peering is public.

## What it needs

- A Jetstream → `.cl` ingester (event types → the overlay schema:
  follow/reply/repost/mention/like, with timestamp and provenance
  properties)
- The overlay query pack: reply-tree extraction, amplification rings,
  hashtag lifecycles, follow-churn windows — port the troll-analytics
  catalog to Cypher
- The infrastructure scraper: DID → PDS resolution, relay subscription
  crawling (the Pulsar slice), fediverse instance metadata + server-to-
  server flow sampling
- The personal-slice tool: "record my follows' firehose for a week" → a
  `.cl` file with its own browser guide
- Honest scale notes: full-firehose is a cluster problem — the personal
  and community slices are the embedded sweet spot

## Lineage & inspiration

- [Jetstream](https://github.com/bluesky-social/jetstream) — the
  firehose this ingests ([introduction](https://atproto.com/blog/jetstream),
  [how it shrank the firehose >99%](https://jazco.dev/2024/09/24/jetstream/))
- [Pulsar — the ATProto relay observatory](https://pulsar.feeds.blue/) —
  infrastructure-as-data, already live: the slice of the protocol map this
  project generalizes
- [AT Protocol architecture](https://atproto.com/guides/streaming-data)
  (PDS/relay/AppView/streaming) — the infrastructure graph's schema;
  [relay ops](https://atproto.com/blog/relay-ops) for the running reality
- The early-day firehose-graph investigations with Neo4j — the proof the
  shape works, pre-dating any of this tooling
- [The Developer Social Networks](developer-social-networks.md) — the
  dataset-family tradition this entry extends (the Twitter/troll-analytics
  overlays are its direct ancestors)
- [The Emergent Interaction Graph](the-emergent-interaction-graph.md) —
  the ingestion pattern; [Your Follow Graph](your-follow-graph.md) — the
  personal-slice framing
