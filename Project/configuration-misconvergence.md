---
type: Project
name: configuration-misconvergence
IN_CATEGORY:
  - "[[Category/Infrastructure & Operations]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: configs as truth source for a live architecture view; misconvergence is its security audit
    target: "[[Project/architecture-diagram-that-never-lies]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Helm]]"
  - "[[Technology/Kubernetes]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/YAML]]"
---

# Configuration Misconvergence

> Every service's effective config (env, flags, k8s overlays) diffed as a
> graph; "which two services disagree about TLS?"

## What

Nobody knows their effective configuration. Every service's final behavior is
the *convergence* of defaults, config files, environment variables, command-line
flags, k8s ConfigMap/Secret overlays, and Helm values — layered per
environment, drifted per deploy. Model that convergence as a graph: nodes for
services, config keys, sources, and environments; edges for "key K of service
S resolves to value V, because of source F at layer 3". Then convergence
failures become queries: which two services that talk to each other disagree
about TLS version, retry timeout, or the Kafka topic name? Which keys resolve
differently in staging vs prod, and which services consume them?

The payoff question set is endless: every service whose effective log level is
DEBUG in prod; every pair sharing a database credential (via a secret node);
which overlay change flipped this key between last Tuesday and now (WAL
replay over the config graph's own history). Misconfiguration — the top root
cause of security incidents — becomes diffable structure instead of
archaeology.

## Why RelateDB

The config graph is small (thousands of nodes, not millions), so in-memory
Cypher answers every convergence question interactively — no warehouse, no
scanning platform. The WAL makes config history first-class: each
configuration snapshot ingested is a checkpoint, so "what changed and when"
replays exactly like any other temporal graph. Each environment's resolved
config is one `.cl` file, so staging and prod are two files you can open side
by side and query — even in a browser tab via the WASM build. The
`relate lab fs-to-graph` command already walks directory trees; a
config-overlay loader is the same walk with a resolver bolted on. Keep the
whole thing inside the org's network — the config graph is itself sensitive.

## What it needs

- Source resolvers per format: env files, YAML/TOML configs, CLI flag
  definitions (clap/cobra docs), k8s ConfigMaps/Secrets, Helm values with
  overlay precedence; an effective-value resolver emitting `key → resolved
  value → because-of` edges (the hard part)
- A service-to-service communication layer (k8s Service/Ingress, DNS, service
  mesh config) so cross-service disagreement queries can join on it
- Canned policy queries: TLS/version mismatches, shared secrets, prod DEBUG,
  staging-vs-prod drift; snapshot scheduling (each ingest is a WAL append,
  so diffs are free)

## Lineage & inspiration

- [GUAC](https://github.com/guacsec/guac/) — the same "converge messy
  evidence into one queryable graph" discipline, applied to attestations
- The *Architecture Diagram That Never Lies* idea — configs as the truth
  source for a live architecture view; misconvergence is its security audit
- `relate lab fs-to-graph` / `git-to-graph` — existing directory-walking
  loaders this idea extends (see the CLI's lab command family)
- [RelateDB's WAL + Parquet checkpoint model](https://github.com/relatedb/relate) —
  the durability that makes config history replayable rather than
  reconstructable
