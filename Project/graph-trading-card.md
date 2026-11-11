---
type: Project
name: graph-trading-card
IN_CATEGORY:
  - "[[Category/Content & Publishing]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: same-data
    reason: the personal-subgraph framing supplies the badge variant's payload
    target: "[[Project/developer-social-networks]]"
  - kind: complements
    reason: the copy/paste protocol whose physical last mile this idea is
    target: "[[Project/graph-clipboard]]"
USES_TECH:
  - "[[Technology/C ABI]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# The Graph Trading Card

> A small subgraph as a QR code on your phone, a card in your wallet, a
> sticker on a conference badge — physical handoff for graph files: tap,
> scan, and the subgraph hops to your device.

## What

The Graph Clipboard made subgraph copy/paste a protocol between instances;
this idea pushes it through the *physical* last mile. Small graphs fit in
surprising places: a QR code holds ~2-3 KB comfortably (3,000 characters);
a compact subgraph — a character sheet, a recipe with its ingredient
graph, a vocab unit, a debate subtree, a route, a person's "graph card"
(their public claims: follows, affiliations, vouches) — encodes in the
single-KB range, especially with schema-crunched encodings.

The form factors:

- **The trading card**: a QR-encoded `.cl` snippet printed on a card — a
  collectible that *is data*: scan a science museum's species card and
  its position in the tree of life merges into your collection
- **The badge/conference variant**: your profile subgraph as a QR on a
  badge — tap-to-exchange in the hallway, the graph greeting (who you
  are, in relationships, merging into the other person's contacts)
- **The NFC card**: same payload on an NTAG — the wallet/tap version for
  the workshop and trade-show floor
- **The pocket-merge ritual**: two people tap phones; a chosen subgraph
  each way; both walk away with a mergeable artifact and a WAL record of
  the exchange — the Backchannel handshake's physical little sibling

## Why RelateDB

The entire exchange needs no infrastructure beyond the medium itself:
encode, decode, merge — all single-binary work, offline, with the merge
semantics (MERGE on canonical keys) that the engine already expresses in
one statement. A museum, a conference, a classroom hands out graph data
with a printer. And it is the friendliest possible demo artifact: the
"one file" story compressed to its physical extreme — nobody distrusts a
card.

## What it needs

- The compact subgraph encoding: schema-crunched, dictionary-compressed
  `.cl` snippet format with a documented envelope (and its size table —
  what fits in 1 KB, 3 KB)
- The QR/NFC encoders and the merge-on-scan flow (camera → decode →
  MERGE → confirm screen)
- The card formats per venue: species cards, vocab cards, badge profiles,
  conference trails
- A print-shop story: PDF templates so a museum or conference can run a
  batch

## Lineage & inspiration

- [Graph Clipboard](graph-clipboard.md) — the copy/paste protocol whose
  physical edge this is
- QR-code capacity (v40, ~3 KB) — the honest envelope that bounds what
  a card can carry
- [The Developer Social Networks](developer-social-networks.md) personal-
  subgraph framing — the badge variant's data
- Collectible-card culture (museum species cards, PKM sticker swaps) —
  the physical exchange ritual this digitizes
