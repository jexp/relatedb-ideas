---
type: Project
name: kaggle-huggingface-graphloader
IN_CATEGORY:
  - "[[Category/Import, ETL & Data Sources]]"
MENTIONS_ORG:
  - "[[Company/Hugging Face]]"
  - "[[Company/Stanford University]]"
RELATED_IDEA:
  - kind: complements
    reason: the fallback CSV-to-graph inference pipeline used for uncataloged datasets
    target: "[[Project/csv-to-graph-instantly]]"
USES_TECH:
  - "[[Technology/CSV]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Parquet]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/SNAP]]"
  - "[[Technology/WASM]]"
---

# Kaggle/HuggingFace GraphLoader

> One click from a dataset card to a `.cl` file; the dataset's social graph,
> citation graph, or co-occurrence graph, ready.

## What

The open-data world's biggest friction is the last mile: a dataset card on
Kaggle or HuggingFace is one download away from a folder of CSVs/Parquet — and
then you're in pandas-land, flattening everything back into tables to ask
questions that were relational all along. This project closes the gap: paste a
dataset URL, the loader fetches the files, recognizes the graph-shaped ones
(the social network, the citation graph, the co-occurrence matrix, the edge
list), and hands you a `.cl` store plus the starter queries.

The recognition layer is a catalog, not magic: the top ~100 graph-structured
datasets on both platforms have stable schemas (Slashdot, Epinions, Cora,
CiteSeer, SNAP collections, co-purchase matrices). For cataloged datasets the
mapping is pre-written; for anything else it falls back to the CSV→Graph
inference pipeline and shows you its guess. One command either way:
`relate dataset load https://huggingface.co/datasets/... --out snap.cl`.

The payoff is a shared corpus: every cataloged dataset becomes a prebuilt
`.cl` file someone else can open with zero setup — the Netzschleuder-for-
teaching role, fed by the two platforms where the data actually lives.

## Why RelateDB

The `pull` command already does URL → local store; this is the same pipeline
with Kaggle/HF endpoints and file schemas instead of the Query API. The
single-file store is the distribution win: a `.cl` file attached to a course
page or a GitHub repo *is* the dataset — no notebook, no `pip install`, no
pandas ceremony. And because the engine is WASM-capable, the dataset page
itself can host a live query shell over the file: try the dataset before you
download it, in the browser tab.

## What it needs

- Kaggle datasets API + HuggingFace `datasets` hub clients (auth tokens for
  gated datasets)
- A catalog of graph-shaped datasets: source URL, files, model mapping,
  license, starter queries (a YAML file in the repo)
- Fallback inference via the CSV→Graph pipeline for uncataloged datasets
- `.cl` build cache keyed by dataset revision, so re-loads are cheap
- A hosted index page: dataset → `.cl` file → in-browser WASM shell

## Lineage & inspiration

- [Netzschleuder](https://networks.skewed.de/) — the network catalogue this
  project extends to the dataset-card era
- [clickhouse-local's remote URLs as tables](https://clickhouse.com/docs/concepts/features/tools-and-utilities/clickhouse-local)
  — "point the binary at the internet" ergonomics
- [Snap datasets](https://snap.stanford.edu/data/) and
  [the Cora/CiteSeer lineage](https://paperswithcode.com/dataset/cora) — the
  canonical graph datasets the catalog starts from
- [Huey](https://github.com/rpbouman/huey) — in-browser exploration over
  fetched files; the "try before download" pattern
