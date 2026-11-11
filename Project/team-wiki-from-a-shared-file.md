---
type: Project
name: team-wiki-from-a-shared-file
IN_CATEGORY:
  - "[[Category/Knowledge Management & Notes]]"
RELATED_IDEA:
  - kind: variant
    reason: same fork and merge model applied to a single store file
    target: "[[Project/clone-fork-pull-push]]"
  - kind: complements
    reason: same offline-first multi-writer sync problem
    target: "[[Project/the-pouchdb-move]]"
  - kind: variant
    reason: both make a shared wiki a file rather than a service
    target: "[[Project/wiki-as-a-file]]"
USES_TECH:
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/cr-sqlite]]"
  - "[[Technology/litetree]]"
  - "[[Technology/sqlsync]]"
---

# Team Wiki from a Shared File

> A group of friends editing a shared graph on a NAS or a git repo; conflicts
> merge because files are the unit.

## What

A knowledge base for a team — a D&D group's campaign lore, a lab's reading
notes, a family's genealogy — without anyone administering a server. The
store is one `.cl` file on the shared thing everyone already has: a NAS
folder, a Dropbox/Drive sync share, a git repo. Each member's RelateDB
opens it, edits locally, and the file-level sync everyone already trusts
moves the changes. "The wiki" is never a service to keep alive.

The magic requirement is merge. When two people edit while offline, the sync
tool delivers two versions of the file — and this project's job is to make
that a merge, not a conflict wall: nodes and edges as the natural merge units,
per-entity last-writer-wins by default, with a `relate merge a.cl b.cl
--interactive` step for the cases where both sides touched the same property.
The insight worth stealing from cr-sqlite: make the edits themselves CRDT-ish
(adds of distinct nodes/edges commute trivially; the conflict surface shrinks
to property-level edits on the *same* node).

Branching turns the same machinery into a feature: a member forks the shared
file to draft a storyline privately, then merges back — the litetree/
Patchwork model, over a NAS instead of a git remote.

## Why RelateDB

The single-file store is the whole premise — the durable form is one
self-contained artifact (fsync'd WAL + Parquet checkpoints) that syncs as a
file, with no server coordination required for the common case. The WAL gives
the merge machinery its unit of change: edits since the last checkpoint are
log segments, so a merge is "replay both WAL segments against the common
checkpoint," which the engine's storage layer is already built to do. And any
member can serve the group read-only (`relate serve`) from the same file
for the browser-based members.

## What it needs

- `relate merge a.cl b.cl`: common-checkpoint discovery, WAL-segment
  replay, add-wins for structure, LWW for properties, `--interactive` for
  property collisions
- Fork/branch support in the store format (a checkpoint + shared-parent
  pointer)
- A sync-friendliness audit: how Dropbox/Drive/git handle the store file;
  checkpoint-on-close policy to keep file diffs small
- Concurrent-open discipline (lock file or advisory locking on the NAS) for
  the in-person-same-LAN case
- A friendly editing surface: the browser (WASM + HTTP serve) for members who
  will never type Cypher

## Lineage & inspiration

- [cr-sqlite](https://github.com/vlcn-io/cr-sqlite) — CRDT tables over an
  embedded DB for multi-writer offline sync; the merge model to steal
- [sqlsync](https://github.com/orbitinghail/sqlsync) — collaborative
  offline-first sync over SQLite; the collaboration bar
- [litetree](https://github.com/aergoio/litetree) — branches for an embedded
  database; the fork/merge precedent
