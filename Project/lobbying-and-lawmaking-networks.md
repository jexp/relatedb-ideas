---
type: Project
name: lobbying-and-lawmaking-networks
IN_CATEGORY:
  - "[[Category/Security, Investigation & Journalism]]"
MENTIONS_ORG:
  - "[[Company/European Union]]"
  - "[[Company/GovTrack]]"
  - "[[Company/OCCRP]]"
  - "[[Company/OpenSecrets]]"
RELATED_IDEA:
  - kind: complements
    reason: applies the OCCRP Aleph follow-the-money model to lobbying disclosure
    target: "[[Project/company-ownership-rings]]"
  - kind: complements
    reason: same disclosure-and-vote graph read for influence rather than conflicts
    target: "[[Project/conflict-of-interest-finder]]"
USES_TECH:
  - "[[Technology/Akoma Ntoso]]"
  - "[[Technology/Cypher]]"
  - "[[Technology/DIP API]]"
  - "[[Technology/EU Transparency Register]]"
  - "[[Technology/GovTrack]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/OpenSecrets]]"
  - "[[Technology/RelateDB]]"
---

# Lobbying & Lawmaking Networks

> Bills ↔ lobbyists ↔ agencies ↔ votes; "who influenced this clause?" as a graph
> query over public data.

## What

Lobbying disclosure portals publish raw text: registrant filings, client
lists, covered services, per-bill positions. Legislative sites publish bills,
clauses, amendments, committee rosters and roll-call votes. Separately, each is
a PDF-shaped swamp. Joined, they are a graph: Lobbyist → Firm → Client →
position on Bill → Clause → Committee → Member → Vote, every edge carrying its
own properties (amount disclosed, date, position taken) — and the question the
headlines actually ask becomes a query.

"Who influenced this clause?" resolves to path-shape: which lobbyists
registered positions on the bill containing this clause, who their clients
were, which members of the clause's committee took meeting disclosures from
those clients' firms in the quarter before markup, and how each member voted —
a four-hop path with dates, checkable in one `MATCH`. The session is
iterative: start from the bill, expand one hop at a time, watch the network
of disclosed positions assemble around the clause.

The method extends: voting-bloc cohesion, the revolving door (staffers who
became lobbyists on the issues they staffed), the money-graph per issue
("which single client had positions on the most bills this term"). Every
finding is a path, and the path is the citation.

The graph reading has decades of precedent. Fowler's cosponsorship networks
("Connecting the Congress", 2006) and the Cornell congress-bills dataset
established Congress as a network-analysis subject; Colombo, Bernasconi and
Ceri's property-graph legislation model (Neo4j, Akoma Ntoso XML, Italian
statutes as nodes with citation/modification/abrogation edges) is the modern
direct ancestor — laws themselves as a property graph, the legislative
sibling this project extends with the lobbying and votes layers. And the
feeds are open and bulk: OpenSecrets' lobbying bulk data and API, GovTrack's
bills and votes, the EU Transparency Register, and the German Bundestag's
DIP API.

## Why RelateDB

Temporal types on every edge make "in the quarter before markup" a property
predicate instead of application logic. The disclosure datasets are a few
million rows at national scale, trivially small for an in-memory engine, so
the four-hop influence queries answer interactively. The single-file store
makes each session's curation portable: a researcher's hand-cleaned lobbyist
disambiguation (the same person across filings) lives in the file, shareable
as an artifact with the write-log proving what was merged. The WASM build
turns it into a shareable browser exhibit, and `relate serve` puts one
shared copy on a laptop in the room.

## What it needs

- Loaders for 2–3 jurisdictions' disclosure data (US federal LD-JSON and
  congress.gov are the deepest; the EU Transparency Register and Germany's
  DIP as profiles) — entity resolution across lobbyist name variants is the
  honest hard part
- A bill/committee/vote loader, and the clause-level mapping (bill → clause →
  committee markup) — the hand-curation part; Ceri et al.'s
  Akoma-Ntoso-to-property-graph pipeline is the modeled precedent
- An influence-path query gallery with temporal windows; a "path is the
  citation" export format

## Lineage & inspiration

- [OCCRP Aleph](https://aleph.occrp.org/) — the follow-the-money model this applies to the lobbying domain ([architecture](https://docs.aleph.occrp.org/developers/explanation/architecture/))
- Fowler, "Connecting the Congress: A Study of Cosponsorship Networks" — the founding congressional network analysis: https://doi.org/10.1093/pan/mpl002 | the [congress-bills dataset](https://www.cs.cornell.edu/~arb/data/congress-bills/) at Cornell
- Colombo, Bernasconi & Ceri — "Modelling Legislative Systems into Property Graphs to Enable Advanced Pattern Detection" (Neo4j, Akoma Ntoso): https://arxiv.org/abs/2406.14935
- [OpenSecrets bulk data](https://www.opensecrets.org/open-data/bulk-data) and [GovTrack's data](https://www.govtrack.us/about-our-data) — the US feeds; the [EU Transparency Register](https://transparency-register.europa.eu/) and the [Bundestag DIP API](https://dip.bundestag.de/) — the EU and German profiles
- [GIJN: social network analysis for investigative journalism](https://gijn.org/stories/power-social-network-analysis-investigative-journalism/) — the newsroom training model this becomes a tool inside
- Public lobbying-disclosure regimes (US Lobbying Disclosure Act filings, EU Transparency Register) — the open data that makes this buildable without FOIA luck
