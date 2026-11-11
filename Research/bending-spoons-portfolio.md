---
type: Research
name: bending-spoons-portfolio
INFORMS:
  - "[[Project/argument-mapper-for-debate-prep]]"
  - "[[Project/cy-your-personal-knowledge-graph]]"
  - "[[Project/local-route-brain]]"
  - "[[Project/wiki-as-a-file]]"
  - "[[Project/your-follow-graph]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Bending Spoons]]"
  - "[[Company/Evernote]]"
  - "[[Company/Kialo]]"
  - "[[Company/Komoot]]"
  - "[[Company/Meetup]]"
MENTIONS_PERSON:
  - "[[Person/Errikos Pitsos]]"
  - "[[Person/Francesco Patarnello]]"
  - "[[Person/Luca Ferrari]]"
  - "[[Person/Luca Querella]]"
  - "[[Person/Matteo Danieli]]"
RELATED_IDEA:
  - kind: variant
    reason: Kialo debate trees are the same typed pro/con graph this idea maps
    target: "[[Project/argument-mapper-for-debate-prep]]"
  - kind: complements
    reason: mail and contact graphs are the AOL/email projection in this audit
    target: "[[Project/cy-your-personal-knowledge-graph]]"
  - kind: same-data
    reason: komoot routes and Highlights are the trail-network data this idea already models
    target: "[[Project/local-route-brain]]"
  - kind: inspired-by
    reason: portable single-file archive pattern applied to an acquired app's export
    target: "[[Project/wiki-as-a-file]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/ENEX]]"
  - "[[Technology/GPX]]"
  - "[[Technology/RelateDB]]"
---

# Research findings: the Bending Spoons portfolio — how much of it is actually graph-shaped?

*Collected 2026-10-23 as inspiration research for the relate-ideas list.
Question asked: Bending Spoons (Milan) has spent 2022–2026 serially acquiring
aging consumer/internet brands — Evernote, Meetup, WeTransfer, Vimeo, Brightcove,
Komoot, AOL, Eventbrite, Airtable, and more. Which of those companies' core data
is actually a property graph, what is the honest embedded-graph-engine angle for
each (app-local store vs. user-export re-analysis vs. new app shape), and what is
stealable as a RelateDB idea? Profile used as the lens: RelateDB is an
embedded in-memory property-graph engine, single binary, fsync'd WAL + Parquet
checkpoints, openCypher TCK dialect, WASM/browser build, MCP server, Bolt/HTTP
APIs, C ABI wrapped by Python/JS/Java/Go clients — "the SQLite of graph
databases."*

The honest headline, up front: of the ~22 acquisitions, **three portfolio
companies are genuinely graph-native (Evernote, Meetup, Komoot), one dead
in-house product was (Immuni), and one famous non-acquisition (Kialo) is the
purest graph of all — it was never bought by Bending Spoons**. Most of the
portfolio by count is media editing, delivery, and back-office SaaS that is
flatly not graph-shaped. And the strategic reading cuts against the tempting
idea: Bending Spoons demonstrably does *not* re-platform the apps it buys — so
"be the acquired app's new data layer" is not an honest idea. The honest version
is the escape hatch: every acquisition cycle brings price hikes and caps, and
each capped user base is a pool of people who need to get their data out and
keep querying it somewhere else. That is RelateDB's lane.

## 1. The evidence base: the portfolio, verified

- **The acquirer's own site** — https://bendingspoons.com/ — hero copy "We
  *acquire* and *improve* iconic products," acquiring digital products since
  2014 to "own and operate for the long term." Its **Products** section (there
  is no separate companies/portfolio URL — 404 on `/companies/`) features ten
  acquisitions with months: **Vimeo (November 2025), Evernote (January 2023),
  Remini (June 2021), WeTransfer (July 2024), Eventbrite (March 2026), Meetup
  (January 2024), Komoot (March 2025), AOL (January 2026), StreamYard (April
  2024), Brightcove (February 2025)** — followed by "And many more." The
  in-house side of the site lists proprietary technologies (Minerva, Juno,
  Xina, Galf, Matrix, Pico) rather than apps.
- **The investor-relations newsroom** — https://investors.bendingspoons.com/ —
  confirms the newest deals first-hand: "Bending Spoons completes the
  acquisition of Airtable" (September 4, 2026), "Bending Spoons enters into a
  definitive agreement to acquire Miro for $1.355 billion" (September 10, 2026),
  and "Berkshire Hathaway invests further $330 million in Bending Spoons
  following $600 million IPO investment" (October 14, 2026).
- **The company's scale and model** — TechCrunch's post-IPO profile
  (https://techcrunch.com/2026/07/05/what-is-bending-spoons-everything-to-know-about-aols-acquirer/):
  founded 2013 by four co-founders (Matteo Danieli, Luca Ferrari, Francesco
  Patarnello, Luca Querella) out of the remains of Copenhagen's Evertale;
  went public on Nasdaq (BSP) the week of July 5, 2026, briefly topping a $25
  billion market cap; 2025 revenue $1.31 billion; **over 500 million monthly
  active users and more than 9 million monthly paying customers as of March
  2026**; described as PE-like except it "aims to hold forever, and has never
  sold an acquired business." Wikipedia
  (https://en.wikipedia.org/wiki/Bending_Spoons) adds the IPO mechanics: F-1
  filed June 8, 2026; trading began July 1, 2026, raising $1.68 billion at
  $29.00/share, closing day one at $40.50.
- **Primary-source acquisition announcements, individually verified:**
  - **Evernote** — announced by Evernote itself November 16, 2022
    (https://evernote.com/blog/evernote-next-move-joining-bending-spoons —
    "Evernote has agreed to join Bending Spoons … in a transaction expected to
    complete early in 2023"); closed early January 2023. Purchase price never
    disclosed by the parties (Wikipedia's table lists ~$200M — treat as
    press-derived, not primary).
  - **Meetup** — "A New Home for Meetup,"
    https://www.meetup.com/blog/a-new-home-for-meetup/ (January 11, 2024);
    finalized January 24, 2024 per Bending Spoons' own release
    (https://www.businesswire.com/news/home/20240124551711/en/).
  - **WeTransfer** — Bending Spoons' release "Bending Spoons Acquires
    WeTransfer," July 31, 2024
    (https://www.businesswire.com/news/home/20240731358717/en/), corroborated
    by Reuters and Bloomberg the same day.
  - **Vimeo** — "Vimeo Enters into Definitive Agreement to Be Acquired by
    Bending Spoons for $1.38 Billion," September 10, 2025
    (https://vimeo.com/press/media-release/vimeo-enters-definitive-agreement-be-acquired-bending-spoons-138,
    plus SEC 8-K filings); closed November 24, 2025.
  - **AOL** — bought from Yahoo (which held it via Apollo); Reuters reported
    the near-deal at $1.4 billion on October 1, 2025 and debt financing of
    $2.8 billion on October 29, 2025
    (https://www.reuters.com/business/finance/italys-bending-spoons-acquire-aol-secures-28-bln-debt-financing-2025-10-29/);
    closed January 2026 per bendingspoons.com. **Price is genuinely muddled**
    ($1.4B Reuters, $1.5B TheWrap/TechRadar, "undisclosed" in TechCrunch) —
    flag it, don't pick one.
  - **Komoot** — "Bending Spoons Acquires komoot," March 20, 2025
    (https://www.businesswire.com/news/home/20250320568940/en/), ~€300M
    per German press (Wikipedia's figure; not primary).
  - **Brightcove** — $233M all-cash take-private, announced November 2024
    (TechCrunch), closed February 2025 (bendingspoons.com).
  - **Eventbrite** — announced December 2025 at ~$500M against its $1.76B 2018
    IPO valuation, closed March 10, 2026 (TechCrunch + Wikipedia).
- **The rest of the list** — dated from Wikipedia's acquisition table
  (https://en.wikipedia.org/wiki/Bending_Spoons), cross-checked where possible
  against bendingspoons.com and TechCrunch: **Splice** (from GoPro, 2018),
  **Remini/BigWinePot** (June 2021), **FiLMiC** (September 2, 2022; staff laid
  off December 2023), **Alight Motion** (2023), **Humamy** (May 2023,
  vegetarian meal delivery), **Mosaic Group/Apalon from IAC** (January 10,
  2024, ~$100M — Clime, iTranslate, Robokiller), **StreamYard** (from Hopin,
  April 9, 2024), **Issuu** (July 19, 2024), **Loomly** (January 10, 2025),
  **Harvest** (from Iridesco, June 10, 2025), **MileIQ** (July 8, 2025,
  ~$233M), **Tractive** (May 18, 2026, ~$900M — Wikipedia-table only, weakest
  sourcing in the set). Day-level dates for these come from the aggregator, not
  primary pages — treat as approximate.

### Honest flags on the names we were told to check

- **Kialo is NOT a Bending Spoons company.** No acquisition record exists
  anywhere I could verify: Kialo is run by independent Kialo Inc., founded by
  Errikos Pitsos, Brooklyn/Berlin based
  (https://en.wikipedia.org/wiki/Kialo). It still earns a full entry below
  because its data model is the purest debate graph in consumer software — but
  it is not portfolio evidence, and any idea built on it must say so.
- **Photomath is NOT a Bending Spoons product.** It was built by Microblink
  and acquired by **Google** — EU antitrust clearance March 2023
  (https://www.reuters.com/technology/eu-regulators-clear-googles-maths-app-deal-sources-say-2023-03-22/),
  app published under Google on the Play Store February 2024
  (https://9to5google.com/2024/02/29/photomath-google-app/). Not this audit's
  subject.
- **"Millions" could not be verified** as a Bending Spoons app in any search
  (their own site lists proprietary *technologies*, not an app by that name).
  If it exists, it has no discoverable footprint; flag rather than assert.
  The verifiable in-house products are **Immuni** (Italy's official COVID-19
  contact-tracing app, donated by the company, released June 1 2020,
  decommissioned December 31 2022 — Wikipedia) and **Playond** (2019 gaming
  subscription, defunct March 2020).

## 2. The audit — each company, classified honestly

The bar, borrowed from the SQLite audit: **graph-native** means the core data
is relationships and the user-facing questions are traversals/patterns;
**graph-adjacent** means tabular/document data where a graph projection helps
some queries; **not graph-shaped** is said plainly.

### (a) Graph-native — the data is relationships and the queries are traversals

1. **Evernote** (acquired January 2023). Notes, notebooks, stacks, tags,
   note-to-note links, attachments, reminders — the PKM graph hiding in
   tables. Every interesting user question is a traversal: which notes are
   orphans (no links, one stale tag), which tags should merge (co-occurrence),
   what's related to what I wrote in 2019 (link + tag + notebook paths). The
   export route is real and documented: ENEX, desktop-only, free users
   included, whole notebooks at a time, 300 MB–2 GB per file
   (https://help.evernote.com/hc/en-us/articles/209005557-Export-notes-and-notebooks-from-Evernote).
   **Caveat:** that help page does not promise note-to-note *link* round-trip
   (links ride inside body HTML as `evernote://` URLs); an importer must
   reconstruct the link graph from the bodies and say so.
2. **Meetup** (acquired January 2024). Members, groups, events, RSVPs,
   waitlists, topics/interests, organizers, sponsors, photos. The questions
   users actually ask are graph questions: "which strangers do I keep sharing
   rooms with," "which of my groups' interests overlap," "is this group
   dying" (attendance decay over time). Personal export exists via data
   request (https://help.meetup.com/hc/en-us/articles/360050018571-How-to-request-a-copy-of-your-personal-data),
   and the community already builds scraping/archiving tooling around Meetup
   out of platform anxiety (https://local.acm.org/scripts/archive-meetup/,
   https://github.com/simonbrownsb/meetupdata, rOpenSci's meetupr).
3. **Komoot** (acquired March 2025). Routes (planned and recorded), waypoints,
   sport-specific edges, and — the crown jewel — **Highlights**, which komoot's
   own docs define as "community-recommended places and route segments that
   appear directly on the komoot map," created by users who experienced them,
   always public, with photos and tips layered on over time
   (https://support.komoot.com/hc/en-us/articles/10194639751450-Highlights;
   Collections: https://support.komoot.com/hc/en-us/articles/10269316327578-Collections).
   Routing itself is literally shortest-path over a road/trail network;
   discovery is POI-graph traversal; the community layer is a
   crowdsourced curation graph. 40 million registered users as of June 2024
   (https://newsroom.komoot.com/238612-komoot-breaks-the-40-million-mark-for-registered-users/
   — note the same page's boilerplate says "over 50 million," an internal
   inconsistency worth flagging, not smoothing over).
4. **Immuni** (in-house, 2020–2022, now decommissioned). A contact-tracing app
   is a proximity graph with epidemiology as its query language — exposure
   chains, temporal windows, risk propagation. Historical evidence, not a
   live target; the data is gone with the app.
5. **Kialo — the flag, not the portfolio.** Not acquired, independent
   (Kialo Inc., Errikos Pitsos; https://en.wikipedia.org/wiki/Kialo). But the
   data model is the most literal graph in this whole audit: "argument maps
   in the form of debate trees," "hierarchical branches where the root is the
   main thesis," Pro/Con columns, users rating "the impact on the weight or
   validity of the parent claim," claims under 500 characters linking to
   external sources, comments, edit proposals, evidence requests. That is a
   property graph with edge weights and provenance, rendered as a UI. Included
   because the user asked — and because it is the strongest *app-shape*
   evidence even though it is not Bending Spoons'.

### (b) Graph-adjacent — a graph projection helps some queries

1. **Vimeo** (acquired November 2025, $1.38B). Creator/follow/collection
   graphs exist, but the product's core is hosting, encoding, and streaming
   delivery; the browsable questions ("creators this creator collaborates
   with") are a graph projection over metadata, not the store.
2. **AOL** (acquired January 2026). Mail is one of the classic personal
   interaction graphs — threads, contacts, reply chains, mailing lists — and
   AOL's user base is enormous. But the product is delivery + media; the
   graph belongs in the *user's export*, re-analyzed (the
   your-digital-life lane), not in AOL's servers being rebuilt.
3. **Eventbrite** (acquired March 2026, ~$500M). Events, organizers,
   attendees, ticket classes — a bipartite people↔events graph exists, but
   the product is transactional ticketing; the graph lives in an organizer's
   or attendee's own export.
4. **Airtable** (acquired September 4, 2026, ~$1.29B) and **Miro** (definitive
   agreement September 10, 2026, $1.355B, pending). Airtable's linked records
   are explicit relationships — some bases are property graphs wearing a
   spreadsheet; Miro's boards are literally nodes and connections. Both stop
   short of graph-native *queries*: users pan, zoom, filter, and single-hop
   link — nobody traverses. Graph-shaped storage, table-shaped usage.
5. **WeTransfer** (acquired July 2024). A sharing graph (who sent what to
   whom, which boards collect which files) is latent in the logs — but
   transfers are ephemeral by design; the durable data is thin. Weakest
   adjacency in the set; say so.
6. **Robokiller** (via Mosaic Group, January 2024). The spam-call blocker's
   per-user data is a log, but the spam *campaigns* it fights — spoofed
   near-duplicate numbers, shared voicemail infrastructure, callback
   patterns — are a clustering problem over a caller graph. Niche, but the
   one genuinely unclaimed shape in the Mosaic bundle.
7. **Tractive** (May 2026, ~$900M, Wikipedia-table sourcing only). Pet GPS
   trajectories are paths, not networks; single-subject location history
   barely needs a graph. Adjacent at best.

### (c) Not graph-shaped — said plainly

- **Brightcove** — enterprise video hosting/CDN; an asset-delivery pipeline,
  not relationships.
- **StreamYard** — live-stream production; session-scoped scenes and layouts,
  no persistent traversal data.
- **Remini, Splice, FiLMiC, Alight Motion** — photo/video editing; pixels and
  timelines, not relationships. (These are the volume side of the portfolio:
  the 500M MAU mostly lives here.)
- **Clime** (weather), **iTranslate** (translation), **Humamy** (meal
  delivery), **Harvest** (time tracking), **MileIQ** (mileage logs),
  **Loomly** (social scheduling), **Issuu** (document publishing) — flat,
  single-entity, or single-hop data. Harvest's project/task joins and
  MileIQ's drive classification are one table join each; a graph engine is a
  cost, not a win, for all of these.

## 3. What the portfolio tells us strategically — the honest reading

The tempting idea is "a serial acquirer of consumer apps with big local/legacy
datasets will re-platform their data layers — sell them an embedded graph
engine." **The evidence says no, and the idea should be rejected on the
facts:**

- The TechCrunch profile is explicit about the playbook: acquired products
  are folded into "centralized product, engineering, data, monetization, AI,
  and operating discipline" (Issuu's seller Joe Hyrkin, on the record), with
  price increases, headcount cuts, and hold-forever ownership — not
  data-layer rewrites. Nothing in any primary source suggests a single
  acquired app had its storage engine replaced.
- What acquisitions reliably produce is *user churn pressure*: Evernote's free
  tier capped at 50 notes, WeTransfer's free plan capped at 10 transfers per
  month (with co-founder Nalden publicly building a rival), Harvest renewal
  repricing that reportedly took one customer from ~$211 to over $2,500, and
  repeated post-acquisition layoffs. Each capped, repriced, or worried user
  base is a pool of people who need to **get their data out and keep querying
  it somewhere else** — and the exports exist and are documented (Evernote
  ENEX, Meetup data request, komoot GPX tours, organizer attendee exports).
- The scale is real and renewable: 2,500 acquisition opportunities sourced in
  2025 alone, ~1,000 remaining targets representing ~$400 billion in
  estimated 2025 revenue (Ferrari, in TechCrunch). The acquirer's pipeline is
  a standing generator of "users with export anxiety."
- The community-archiving behavior around Meetup (archiver scripts, meetupdata,
  meetupr) shows the escape-hatch demand predates this research: people
  already scrape their communities' histories out of fear of the platform.
  The graph file is the natural landing zone — one organizer's whole group
  history (members, events, attendance, photos, messages) as a single
  portable, queryable artifact.

So the stealable pattern is not "be the data layer of an acquired app" — it
is **"be the destination of an acquired app's export."** Every acquisition
event is a marketing event for exit tooling.

## 4. Conclusions — what converts, what the list already covers, what's new

**What converts:** Evernote, Meetup, Komoot, (historically) Immuni — plus
Kialo as the non-portfolio benchmark, and graph *projections* inside Vimeo,
AOL mail, Eventbrite, Airtable, Miro, Robokiller.

**What the repo already covers** (checked against the README's sections):
Komoot almost entirely — [Local Route Brain](../projects/local-route-brain.md)
(GTFS/GPX trail networks, offline routing, "rides like this"),
[Running/Cycling/Hiking Graph](../projects/running-cycling-hiking-graph.md)
(activity segments, PRs as shortest-times), and
[OpenStreetMap Wedge](../projects/openstreetmap-wedge.md) own the whole
trail-network territory; komoot is evidence, not a new idea. AOL/email —
[Cy — Your Personal Knowledge Graph](../projects/cy-your-personal-knowledge-graph.md)
and [The Emergent Interaction Graph](../projects/the-emergent-interaction-graph.md)
already model mail/contact/thread graphs. Immuni — the Use-Case Gallery's
Covid/Contact Tracing entry. Debate graphs —
[Argument Mapper for Debate Prep](../projects/argument-mapper-for-debate-prep.md),
[The Fact-Check Engine](../projects/the-fact-check-engine.md), and
[Legal Citation Graphs](../projects/legal-citation-graphs.md) cover claims,
premises, rebuttals, and provenance as typed graphs. Miro/Airtable —
[Arrows on RelateDB](../projects/arrows-on-relate.md),
[Whiteboard to Graph](../projects/whiteboard-to-graph.md),
[Graph Lens over Any Database](../projects/graph-lens-over-any-database.md),
and [Spreadsheets are Graphs](../projects/spreadsheets-are-graphs.md).
Vimeo's follow/collection layer — [Your Follow Graph](../projects/your-follow-graph.md)
and [The Movie Graph, All Grown Up](../projects/the-movie-graph-all-grown-up.md).

**Genuinely-new candidates** (report only — the parent session decides; four
offered, honoring the 0–5 convention):

1. **The Evernote Escape Hatch** — an `.enex` importer that turns a whole
   Evernote export (notebooks, tags, `evernote://` links reconstructed from
   body HTML) into one `.cl` knowledge base, plus the query pack the app never
   gave Free users: orphan notes, mergeable tags, link-reachability ("everything
   two hops from this note via links and shared tags"), notebook health over
   time. Framed honestly as *exit tooling* for a capped and repriced user
   base — the acquisition-anxiety pitch, not a generic PKM pitch. Nothing in
   the list owns the Evernote-specific exit story (Cy and Obsidian/VFS are
   destinations, not importers from a named, worried platform).
2. **Community Archive as a File** — a Meetup group's (or Eventbrite
   organizer's) complete history — members, events, RSVPs, attendance decay,
   photos, message boards — archived into one portable `.cl` file the
   organizer owns, queryable forever, independent of the platform's fate. The
   wiki-as-a-file pattern applied to a community platform; lineage is the
   existing third-party archiver tooling. Distinct from Friendship
   Archipelago (personal multi-source merge) because the unit is *the group*,
   and its survival question is the platform's, not the user's.
3. **Debates as Portable Files (the open Kialo)** — a debate tree as a
   single `.cl` file: thesis-rooted branches, typed pro/con/supports/refutes
   edges, impact ratings as edge weights, external-source links as
   provenance-bearing nodes — forkable, mergeable, no server, no account.
   Genuinely distinct from Argument Mapper (personal debate prep) in the
   fork/share dimension: the debate itself becomes the artifact a community
   passes around, like a dataset. **Must carry the honest flag:** Kialo is
   independent, not Bending Spoons — the idea is inspired by the shape, not
   the portfolio.
4. **Spam-Call Campaign Graph** — the Robokiller angle: your blocked-call log
   as a graph, spoofed near-duplicate numbers clustered into campaigns,
   shared voicemail/callback infrastructure as shared nodes, per-campaign
   pressure over time. Nothing in the repo covers telephony fraud at all; small
   scope, but an uncontested lane with a named (portfolio!) anchor.

**What does not convert, full stop:** the §2c list — and that is most of the
portfolio by count. The finding worth saying out loud: Bending Spoons' 500M
users are mostly in photo/video editing and delivery tools where a graph
engine has nothing to do. The graph-shaped fraction of the portfolio is
small, but it is exactly the fraction with export anxiety — and that is where
the ideas live.

## Sources

- https://bendingspoons.com/ (portfolio/products section with acquisition months)
- https://investors.bendingspoons.com/ (Airtable completion, Miro agreement, Berkshire investments)
- https://en.wikipedia.org/wiki/Bending_Spoons (full acquisition table, IPO mechanics)
- https://techcrunch.com/2026/07/05/what-is-bending-spoons-everything-to-know-about-aols-acquirer/
- https://evernote.com/blog/evernote-next-move-joining-bending-spoons/
- https://help.evernote.com/hc/en-us/articles/209005557-Export-notes-and-notebooks-from-Evernote
- https://www.meetup.com/blog/a-new-home-for-meetup/
- https://www.businesswire.com/news/home/20240124551711/en/Bending-Spoons-finalizes-acquisition-of-U.S.-based-community-building-platform-Meetup-and-announces-%2450000-Community-Fund
- https://help.meetup.com/hc/en-us/articles/360050018571-How-to-request-a-copy-of-your-personal-data
- https://local.acm.org/scripts/archive-meetup/
- https://github.com/simonbrownsb/meetupdata
- https://www.businesswire.com/news/home/20240731358717/en/Bending-Spoons-Acquires-WeTransfer
- https://www.reuters.com/markets/deals/italys-bending-spoons-buys-file-sharing-service-wetransfer-2024-07-31/
- https://vimeo.com/press/media-release/vimeo-enters-definitive-agreement-be-acquired-bending-spoons-138
- https://www.reuters.com/business/finance/italys-bending-spoons-acquire-aol-secures-28-bln-debt-financing-2025-10-29/
- https://www.businesswire.com/news/home/20250320568940/en/Bending-Spoons-Acquires-komoot
- https://support.komoot.com/hc/en-us/articles/10194639751450-Highlights
- https://support.komoot.com/hc/en-us/articles/10269316327578-Collections
- https://newsroom.komoot.com/238612-komoot-breaks-the-40-million-mark-for-registered-users/
- https://en.wikipedia.org/wiki/Kialo (ownership and debate-tree data model)
- https://www.reuters.com/technology/eu-regulators-clear-googles-maths-app-deal-sources-say-2023-03-22/ (Photomath → Google, the negative flag)
- https://9to5google.com/2024/02/29/photomath-google-app/ (Photomath under Google on Play Store)
- https://fsome.com/acquisitions/acquirer/bending-spoons-13453 (aggregator cross-check, not cited as fact source)
