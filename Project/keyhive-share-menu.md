---
type: Project
name: keyhive-share-menu
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/Ink & Switch]]"
RELATED_IDEA:
  - kind: complements
    reason: the agent-permission framing; this is its data-layer counterpart
    target: "[[Project/crew-org-chart]]"
  - kind: complements
    reason: the subgraph selection language the grant scopes reuse
    target: "[[Project/graph-clipboard]]"
  - kind: complements
    reason: the temporal-query pattern applied here to access history
    target: "[[Project/graph-native-agent-memory]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Keyhive]]"
  - "[[Technology/MCP]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WAL]]"
---

# Keyhive's Share Menu

> Sharing a subgraph as a capability: a grant is a node, a scope is a
> subgraph selection, a revocation is a delete. The access-control list lives
> inside the graph file it protects — and the same machinery authorizes the
> agents calling over MCP.

## What

Today's answer to "who can see this?" for a database is a separate authority:
a user table, an IAM system, an auth server holding policies the data never
sees. Ink & Switch's [Keyhive](https://www.inkandswitch.com/keyhive/) project
models sharing for local-first documents the other way — **capabilities
issued and revoked at the document**, a share menu whose every action is a
capability operation — and this project is that model for graph files:

- **A grant is a node**: `(:Grant {grantee, rights, expiry})` connected to a
  subgraph selection (labels, property filters, a bounded pattern — the
  [Graph Clipboard](graph-clipboard.md)'s selection language in reverse)
- **A policy check is a query**: the enforcement point at the surface
  (MCP/HTTP/Bolt) resolves the request to the grant subgraph with Cypher —
  the same language as the data, evaluated at retrieval time on every node
  and edge in scope
- **Revocation is a delete**, attenuation (narrowing a grant) is an edit,
  expiry is a timestamp — all first-class graph operations with WAL
  provenance
- **The grants serialize with the file**: a shared `.cl` carries its own
  ACL; revocation at open time, no external service consulted

The agent-native half of the idea: agents are the callers this actually
meets in practice — MCP sessions, agent-to-agent handoffs, tool scopes. A
grant names an agent (or a tool, or a session) as the grantee, scopes what
it may read and write, and expires when the task does. That is the
"authorize agent-to-agent and MCP calls" problem [IndyKite's Agent
Gateway](https://developer.indykite.com/guides/guide-agent-gateway) solves
on a cloud knowledge graph — here the knowledge graph and the authorization
are the same local file.

## Why RelateDB

The embedded shape is the point: no external auth server exists in the
single-binary world, so the *file is the authority* — and a graph engine can
hold its own ACL as native data, checked by its own query language.
`relate-auth` (the shared generated-token auth the network surfaces
already use) is the seam: token → grantee resolution, then the grant
subgraph decides the rest. Bounded subgraph scopes reuse the clipboard's
selection machinery; WAL provenance means every grant and revocation is
auditable ("who could read this, and when?") — the temporal-query pattern
from [Graph-Native Agent Memory](graph-native-agent-memory.md) applied to
access history. And signed grants open the cross-instance path: a grant
minted here, honored by whoever you send the file to (a signing-key story,
without the full identity machinery of a vouching-graph wallet).

## What it needs

- The grant schema: grantee, rights (read/write/expand), subgraph scope,
  expiry, attenuation rules
- Enforcement points in the surface layer (MCP/HTTP/Bolt): request → grantee
  resolution → grant-subgraph check, with denial text that names the missing
  grant (not a silent empty result — the no-silent-fallbacks rule, applied
  to authorization)
- Grant serialization in the `.cl` format and revocation at open
- Signed grants for cross-instance sharing (a signing key story, or an
  honest local-only v1)
- The audit queries ("who could read this, and when?") as a recipe pack

## Lineage & inspiration

- [Keyhive](https://www.inkandswitch.com/keyhive/) (Ink & Switch) —
  capabilities-based access control for local-first software: signed,
  non-extractable local keys, per-document capability checks, and the share
  menu UI mapped onto issuing/revoking capabilities
  ([dispatch 014](https://www.inkandswitch.com/newsletter/dispatch-014/));
  `research/ink-and-switch-catalog.md` has the full project context
- [Nulli](https://www.nulli.com/) — the identity-and-access consultancy whose
  3Edges authorization product was
  [acquired by IndyKite](https://www.nulli.com/news-events-3edges-acquired-by-indykite-to-enhance-modern-authorization-offering);
  the graph-authorization school of thought
- [IndyKite](https://developer.indykite.com/guides/guide-dynamic-authz) —
  dynamic authorization on a knowledge graph, demonstrated as
  [AuthZEN authorization decisions](https://developer.indykite.com/guides/guide-authzen)
  and the [Agent Gateway](https://developer.indykite.com/guides/guide-agent-gateway)
  (authorize agent-to-agent and MCP calls — the cloud version of this
  project's agent-native half)
- RelateDB's `relate-auth` — the existing token seam this extends
- [Crew Org Chart](crew-org-chart.md) — the agent-permission framing; this
  is its data-layer counterpart
