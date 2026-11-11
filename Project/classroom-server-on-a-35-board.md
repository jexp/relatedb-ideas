---
type: Project
name: classroom-server-on-a-35-board
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Kuzu]]"
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Albert-László Barabási]]"
USES_TECH:
  - "[[Technology/Bolt]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/HTTP]]"
  - "[[Technology/MCP]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/Raspberry Pi]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
---

# Classroom Server on a $35 Board

> A Raspberry Pi + `relate serve` gives a whole classroom a shared graph
> database each. Zero setup for the students.

## What

The class walks in; there is a Raspberry Pi (or any $35-ish board, or a
repurposed laptop) on the teacher's desk. The teacher ran one command before
class:

```
relate serve --database classgraph.cl --http 8080 --bolt 7687
```

Now every student in the room has a graph database. Over HTTP from a browser
tab; over Bolt from any driver or notebook; over MCP from an agent or the CLI's
own query surface — every student the same store, every student the standard
Cypher language, zero cloud accounts, zero installs, zero cost per seat. The
network diagram for the lesson *is* a lesson.

The pedagogical wrinkle is per-group stores: the class is not forced into one
shared graph. `classgroup1.cl`, `classgroup2.cl`, … — a handful of instances of
one small binary on one small board, each group building its own dataset,
competing on the same exercises. And because each store is a single file, the
teacher collects homework by file-copy at the end of the hour.

## Why RelateDB

This is the embedded proposition at its purest: a single static binary, no
runtime deps, no daemon zoo, modest RAM needs, running happily on ARM —
`relate serve` stacks the accept loop, HTTP and Bolt (and MCP, including
stdio) in one process, and the shared-accept machinery is built for exactly
this many-clients-one-process shape. The in-memory engine means a classful of
small exploratory queries answers interactively even on a Pi's CPU. Durable is
the WAL + Parquet checkpoint in the same directory — so a board that loses
power mid-lesson loses nothing, and the next morning's class starts from
yesterday's checkpoint. And the whole thing swaps for the WASM build when a
school has no hardware budget at all: the same exercises run in a browser tab.

## What it needs

- One board (any ARM SBC or old laptop; Pi 4/5 comfortable), the static
  `relate` binary, the lesson's `.cl` files
- A class pack: 3–5 exercise datasets and a printed query card per group
- Optional: systemd unit for auto-start, and a per-group store launcher script
- The teacher-facing cheatsheet: collect stores, checkpoint, reset to clean

## Lineage & inspiration

- Kuzu (the "DuckDB of graphs", CIDR 2023) — the embedded-graph thesis validated
  academically, and by Apple's acquisition of the company: graph-shaped storage
  going on-device at the largest possible scale — a Pi classroom is the modest
  end of the same curve
- The Neo4j movies/northwind starter-example tradition — the load-a-graph-and-
  teach-Cypher lesson format, minus the server license and install
- The network-science course model (Barabási) — the course content this hardware
  serves
