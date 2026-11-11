---
type: Project
name: legal-citation-graphs
IN_CATEGORY:
  - "[[Category/Reference & Research Data]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
RELATED_IDEA:
  - kind: complements
    reason: reuses the claim-to-authority model over legal citation edges
    target: "[[Project/argument-mapper-for-debate-prep]]"
  - kind: complements
    reason: candidate-match entity resolution pattern reused across citations
    target: "[[Project/gedcom-importer-merger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/RelateDB]]"
---

# Legal Citation Graphs

> Laws, statutes, court cases, courts, judges, parties, and the
> reference edges between them: precedent chains as citation paths
> ("which decisions did this ruling rely on, and which later
> overturned it"), the argument mapper's grown-up sibling for briefs —
> every claim in a legal memo traceable to its authorities as one query.

## What

The law is the most explicitly graph-shaped corpus in public life: statutes
cite statutes, cases cite cases, courts overrule courts. This project models it
straight: `(:Case {decided})-[:RELYED_ON]->(:Case)`, `-[:DISTINGUISHED]->`,
`-[:OVERRULED_BY]->`, `(:Judge)-[:WROTE {role}]->
(:Opinion)-[:PART_OF]->(:Case)`, `(:Statute {section})`, courts in a hierarchy,
parties as nodes. Precedent chains — "which decisions did this ruling rely on,
and which later overturned it" — become traversals that include the overruling
path: good law vs. bad law as a status computed per query, what commercial
citators sell as a subscription.

The brief-writing side pays daily: a memo's propositions as claim
nodes linked to their cited authorities (the Argument Mapper's model,
over legal edges), so "every claim traceable to its authorities" is one query —
and so is the nightmare check: any claim whose supporting authority has since
been *overruled, doubted or abrogated* anywhere in the graph, the citation path
to that bad edge returned with it. Supplementation: which recent cases cite my
line, and which courts distinguish my controlling authority.

The precedent work is on the record, and the German line is graph-native.
Iryna Feuerstein's *graph-of-codes* (JavaLand 2018, "Zwischen den Zeilen
lesen – Datenanalyse mit Graphen") already chopped German statutes into
pieces, regex-extracted norm citations from openJur court documents, and
linked norms and documents in one Neo4j graph — the ancestor this project
inherits. Harvard's Caselaw Access Project published its whole-collection
citation graph (6.7 M cases as a case-to-cite CSV); Livermore et al.'s network
analyses asked the influence questions over it; the ECHR side now has
HUDOC-derived precedent datasets (ECtHR-PCR), and the formal line (LKIF,
the EU Lynx Legal Knowledge Graph) mapped the vocabulary half.

## Why RelateDB

The public citation corpus (CourtListener's millions of edges) is
columnar exports — `relate-arrow` is the import path, and the
in-memory engine puts a whole circuit (or the Supreme Court's full
history) on a laptop at query speed, which no hosted service matches
for exploratory work. Temporal types are the good-law engine:
decided dates, effective dates, overruling dates as native values
make "authority status as of filing date" a time-window query — the question
that matters in a brief. One `.cl` file per practice area or matter: portable
and archivable with the case. Python bindings drive the ingest pipeline and
statute-code parsers; `serve --http` gives a research front end; and MCP turns
the citation graph into an authority-checking tool for the drafting agent —
citations it suggests arrive pre-validated instead of confidently invented.

## What it needs

- Importers: CourtListener/F.L.P. bulk citation data and Caselaw
  Access Project text via `relate-arrow`, plus statute code
  structure; ECtHR-PCR as the second-jurisdiction importer
- Typed citation edges (relied on / distinguished / overruled /
  abrogated) with extraction confidence and pin-cites — graph-of-codes'
  regex pipeline as the extraction precedent, the confidence added
- Good-law-at-time-t derivation: authority status computed per query,
  never stored stale
- Entity resolution across citations (which *Smith*, which court,
  which decade) — the GEDCOM merger's candidate-match pattern

## Lineage & inspiration

- CourtListener / Free Law Project — the public bulk citation corpus and the graph model to match: https://www.courtlistener.com/ | bulk data: https://www.courtlistener.com/help/api/bulk-data/
- Caselaw Access Project (Harvard) — the full-text archive feeding the opinion layer, plus its published 6.7 M-case citation graph: https://case.law/ | https://lil.law.harvard.edu/blog/2020/04/22/caselaw-access-project-citation-graph/
- Iryna Feuerstein — *graph-of-codes*: German law norms + openJur documents as one Neo4j graph, shown at JavaLand 2018; the German law-graph ancestor: https://irare.github.io/graph-of-codes/ | https://github.com/IraRe/graph-of-codes | https://neo4j.com/blog/graph-database/knoten-auf-der-achterbahn-neo4j-beim-javaland-bruhl/
- Livermore, Leibon, Rockmore et al. — "Bending the Law", citation-network analysis of US case law: https://papers.ssrn.com/sol3/papers.cfm?abstract_id=2740136
- Fowler & Jeon's Supreme Court citation-network research — precedence as a graph problem in the political-science canon: https://journals.sagepub.com/doi/10.1177/1532673X0800300402
- ECtHR-PCR (TU Munich Legal Tech) — precedent understanding and prior case retrieval for the European Court of Human Rights: https://github.com/TUMLegalTech/ECHR-PCR
- LKIF core and the Lynx Legal Knowledge Graph — the formal-ontology cousins: https://github.com/RinkeHoekstra/lkif-core | https://www.lynx-project.eu/doc/lkg/
- Ravel Law (acquired by LexisNexis) — the commercial citation-graph visualizer that proved the market; this is its embedded, public-data descendant
