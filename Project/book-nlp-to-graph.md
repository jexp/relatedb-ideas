---
type: Project
name: book-nlp-to-graph
IN_CATEGORY:
  - "[[Category/Education & Learning]]"
MENTIONS_ORG:
  - "[[Company/Kuzu]]"
MENTIONS_PERSON:
  - "[[Person/Andrew Beveridge]]"
RELATED_IDEA:
  - kind: same-data
    reason: Beveridge's Network of Thrones is the benchmark graph for the extraction
    target: "[[Project/a-song-of-ice-and-fire-queried]]"
  - kind: variant
    reason: automates the hand-built character-network genre with an LLM extractor
    target: "[[Project/every-character-network-ever]]"
  - kind: complements
    reason: named as the pattern for running the extraction entirely in the browser
    target: "[[Project/in-browser-knowledge-extraction]]"
USES_TECH:
  - "[[Technology/BAML]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/Kuzu]]"
  - "[[Technology/Ollama]]"
  - "[[Technology/RelateDB]]"
  - "[[Technology/WASM]]"
  - "[[Technology/web-llm]]"
---

# Book NLP to Graph

> local LLM extracts characters, mentions and sentiment into a graph; a literature
> class argues about the resulting structure.

## What

The character-network genre usually starts from hand-built spreadsheets — a
student reads a book, types every mention of every character into a table, and
gives up around chapter five. This project removes the hand-building: a local LLM
reads the text and extracts, per chapter or scene, the characters present, who
mentions whom, co-occurrence weights, and sentiment between the parties. The
output is a property graph: `Character` nodes, `INTERACTS`/`MENTIONS` edges with
chapter, weight, and sentiment properties, plus ambiguous-identity nodes (the
"Monster"/"Victor"/"the Creature" problem) flagged for human resolution.

The classroom payoff is the *argument*. The extraction is a claim about the text,
not a fact — so the literature class gets a graph with visible provenance and
fights over it: is the model's sentiment edge between Elizabeth and Victor
justified by the passage it cites? Recompute with the disputed edges removed and
see whether the structure of the novel (its communities, its bridges, its
periphery) survives. Close reading meets network reading, on the same object.

## Why RelateDB

This is an embedded + local pipeline by nature: the privacy of running both the
LLM and the graph on the student's laptop (or entirely in the browser — WASM
RelateDB plus a web-llm runtime, the In-Browser Knowledge Extraction pattern)
means any text can go in, including unpublished student work. The WASM build
makes the resulting graph immediately explorable in the same tab it was built
in. Vector/hybrid search earns its place: embed the passages each edge cites so
clicking an edge shows the textual evidence. Temporal properties carry chapter
numbers for the time-slice analyses ("the network after the funeral"), and the
WAL means a class's corrections to the extraction — the human resolution of
ambiguous identities — persist as an editable layer over the machine reading.

## What it needs

- Scene segmentation (chapter/scene boundaries — regex-able in most texts)
- Local extraction: an LLM with a strict JSON schema (characters, co-mentions,
  sentiment, evidence span) — web-llm in-browser or Ollama-class local models
- Identity resolution (nickname/epithet → character, flagged for human review)
- Edge provenance: passage citations as properties, embedded for vector lookup
- Front-end: WASM explorer with click-through-to-evidence; sentiment as edge
  color, chapter as the time slider

## Lineage & inspiration

- BAML + Kuzu: unstructured → graph with an LLM extraction schema — the closest
  existing pipeline: https://github.com/kuzudb/baml-kuzu-demo
- Kuzu Graph RAG (embedded graph + local LLM patterns):
  https://github.com/kuzudb/graph-rag
- Beveridge's Network of Thrones — the hand-built version this automates, and
  the benchmark for "does the extraction match the curated graph?":
  https://github.com/mathbeveridge/asoiaf
- The Cornell INFO-2040 character-network blog genre (the classroom this is
  built for): https://blogs.cornell.edu/info2040/2022/09/15/analyzing-character-networks-with-graph-theory/
- The Wikipedia Republic of Literary Characters — literary networks at corpus
  scale: https://culturalanalytics.org/article/id/1301/
