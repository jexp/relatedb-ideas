---
type: Project
name: molecules-as-graphs
IN_CATEGORY:
  - "[[Category/Science & Graph Analytics]]"
RELATED_IDEA:
  - kind: complements
    reason: another of science's original graphs made locally queryable
    target: "[[Project/protein-interaction-sandbox]]"
  - kind: complements
    reason: same local-first treatment of a canonical scientific graph
    target: "[[Project/tree-of-life-locally]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/RelateDB]]"
---

# Molecules as Graphs

> Chemical structures as the original graphs: atoms, bonds, reactions,
> and similarity as substructure queries — the cheminformatics world
> (RDKit's lineage) where "graph query" has meant substructure match for a
> century.

## What

Chemistry got there first. A molecule has been drawn as a graph — atoms
as nodes, bonds as edges — since Kekulé's benzene ring, and a century of
cheminformatics is built on that reading: the field's core primitive,
*does this molecule contain that substructure?*, is a graph pattern match.
The mapping to Cypher is almost too direct:
`(:Atom {element, charge})-[:BOND {order, aromatic, stereo}]->(:Atom)`,
and a SMARTS pattern becomes a Cypher `MATCH` over atoms and bonds.

Then the layer cheminformatics formats cannot hold well: reactions and
collections. `(:Molecule)-[:REACTANT]/[:PRODUCT]->(:Reaction {conditions,
yield})` makes synthesis routes traversable — *from this feedstock, which
routes reach this target?*
Compound libraries become one queryable store — PubChem slices, internal
inventory — where "substructure-similar to our lead compound but free of
this toxic pharmacophore" is one pattern query, with inventory and price
as properties on the same nodes.

Every component verifies. RDKit's substructure machinery — SMARTS patterns,
`GetSubstructMatches`, and the `SubstructLibrary` for screening whole compound
libraries — is documented Python and C++ API, the exact primitive this project
re-exposes as a Cypher `MATCH`. The dataset sources are bulk-downloadable:
PubChem via PUG REST and its downloads page, ChEMBL via its web services and
data dumps. And the history is written down: Peter Willett's histories of
cheminformatics document the lineage from punched-card notched-edge matching
to SMARTS — the century the pitch gestures at.

## Why RelateDB

An in-memory pattern match over a compound library is what chemists
waited on batch jobs for — RelateDB runs it from a laptop shell on a
single `.cl` file you can email to a collaborator. For the
kitchen-sink version, RDKit stays in the loop
through the Python bindings: RDKit parses SMILES/SDF into molecular
graphs and computes descriptors, RelateDB stores and queries them —
and the C ABI makes it reachable from any tooling that can load a
library. Vector search covers the modern sibling: molecular
embeddings stored as vectors, so hybrid queries fetch neighbors by
embedding *and* filter by substructure.

## What it needs

- SMILES/SDF/MOL import via RDKit (Python bindings) or a pure-Rust
  SMILES reader → `Molecule`/`Atom`/`Bond` graphs with stereo and charge
- A SMARTS → Cypher pattern compiler (the fixed functional-group
  dictionary as a starter; arbitrary SMARTS as the stretch)
- Reaction-graph import (RDF format, USPTO or proprietary route maps):
  `Reaction` nodes with reactant/product/catalyst edges
- Stored descriptors as properties and fingerprint/model embeddings as
  vectors for hybrid search; a dataset pack (PubChem/ChEMBL slices) as
  `.cl` downloads via `relate-arrow`

## Lineage & inspiration

- RDKit — the open-source cheminformatics toolkit whose everything is
  graph-shaped, and whose lineage (Daylight, the SMARTS tradition)
  defined molecular query as substructure match:
  https://www.rdkit.org/docs/GettingStartedInPython.html and
  https://github.com/rdkit/rdkit
- The dataset sources — PubChem PUG REST:
  https://pubchem.ncbi.nlm.nih.gov/docs/pug-rest (bulk:
  https://pubchem.ncbi.nlm.nih.gov/docs/downloads) | ChEMBL downloads:
  https://chembl.gitbook.io/chembl-interface-documentation/downloads
- Peter Willett, "Searching chemical databases in the pre-history of
  cheminformatics" — the century of substructure search, written down:
  https://doi.org/10.1186/s13321-024-00919-9
- The structure–activity tradition — SAR tables, pharmacophore
  filtering, lead hopping: graph-neighborhood reasoning in disguise
- [Protein Interaction Sandbox](protein-interaction-sandbox.md) and
  [Tree of Life, Locally](tree-of-life-locally.md) — science's original
  graphs, locally
