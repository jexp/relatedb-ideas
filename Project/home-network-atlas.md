---
type: Project
name: home-network-atlas
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
MENTIONS_ORG:
  - "[[Company/FalkorDB]]"
  - "[[Company/Home Assistant]]"
  - "[[Company/Neo4j]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GUAC]]"
  - "[[Technology/Home Assistant]]"
  - "[[Technology/Raspberry Pi]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# Home Network Atlas

> Every device, service, port and VLAN in your LAN as a graph; query blast radius ("what can reach the camera?") when something misbehaves.

## What

Home networks accrete: a router, three generations of IoT junk, a NAS, a couple of
laptops, VLANs someone set up in 2021 and forgot. Nobody can answer "what can
reach the IP camera?" — which is exactly the question you ask the night it starts
phoning Romania. This project turns periodic LAN scans into a property graph:
`(:Device)-[:CONNECTS_TO]->(:Network)`, `(:Device)-[:RUNS]->(:Service)`,
`(:Service)-[:LISTENS_ON]->(:Port)`, plus observed traffic edges.

Then blast radius becomes a query, not a guess: `MATCH path = (p:Port {number:554})
<-[:LISTENS_ON]-(:Service)<-[:RUNS]-(:Device {name:'camera'})` and traverse
`CONNECTS_TO`/`REACHES` edges up through the router's forwarding rules. "What can
reach the camera?" returns the VLAN, the devices on it, and the one legacy rule
that lets the guest network in. Asset inventory + reachability = the security
posture of an enterprise, for the price of a Raspberry Pi.

The atlas also answers domestic archaeology: "what's still running that thing we
bought in 2019?", "which devices stopped checking in", a diff of last month's
scan vs this one — new devices appear as new nodes, not as an ignored log line.

Home Assistant is the adjacent production proof: its device and entity model
gives every home object a structured identity — entity IDs, per-entity state
and attributes, `last_changed`/`last_updated` history — and the recorder keeps
that history queryable. The atlas keeps the identity model and adds the edges
those registries deliberately leave out: listening ports, VLAN membership,
forwarding-rule reachability. The same deployment story applies — one
always-on binary under the stairs, everything else in the house a client.

## Why RelateDB

The natural home is a small always-on box (Pi, NAS) running the single binary —
`relate serve --bolt/--http` there gives every laptop and phone in the house a
query endpoint, zero setup. Scan results land as incremental WAL writes, so the
history of your network is replayable — "when did this device first appear" is a
time-window query over the WAL, not a log archive. In-memory Cypher means the
blast-radius query returns in the time it takes the page to paint; no enterprise
graph DB in the closet. The CLI's table/JSON output makes the atlas scriptable
into alerts (new device on the IoT VLAN → notification). Nmap/lanscan outputs are
already list-shaped — a loader is a day's work, and the graph adds the paths that
the lists can't express.

## What it needs

- Scanners: nmap XML, mDNS/SSDP/UPnP discovery, router ARP/DHCP leases, maybe a
  passive traffic sampler — each mapped into the Device/Service/Port model
- Router config ingestion (port-forwards, VLAN rules) as the `REACHES` edges —
  this is the hard, valuable part; without it blast radius is guesswork
- A front end: a LAN map view (room/floor properties on devices help), a "diff
  this month" view, an alert hook
- Scheduled incremental scans + as-of timestamps so the atlas is temporal
- An honesty module: MAC OUI lookups, naming heuristics ("Shenzhen-unknown-3")

## Lineage & inspiration

Blast-radius-as-reachability is the same query shape as
[research/graph-world.md](../research/graph-world.md) §6:
[FalkorDB DepGraph](https://github.com/FalkorDB/DepGraph) (attack paths in an
in-memory graph — here the assets are your own devices) and
[GUAC](https://github.com/guacsec/guac/) (posture questions as graph traversals).
The asset-inventory-as-graph idea also echoes the "Cy" personal-KG lane in
[research/agent-native.md](../research/agent-native.md) — your home, like your
work life, is a graph you already own but can't query. Home Assistant's
[state model](https://developers.home-assistant.io/docs/dev_101_states/) is
the verified precedent for the device/entity half of the atlas model.
