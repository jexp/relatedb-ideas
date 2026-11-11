---
type: Research
name: jev-longtail
INFORMS:
  - "[[Project/policy-impact-knowledge-graphs]]"
  - "[[Project/scripture-cross-reference-navigation]]"
  - "[[Project/strategy-graphs-as-shipped-artifacts]]"
  - "[[Project/the-graph-walking-agent-cursor]]"
  - "[[Project/the-judgment-ledger]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/TypeSafe AI]]"
MENTIONS_PERSON:
  - "[[Person/David Braun]]"
RELATED_IDEA:
  - kind: inspired-by
    reason: bible-jev-climb builds a KJV cross-reference graph today in memory
    target: "[[Project/scripture-cross-reference-navigation]]"
  - kind: inspired-by
    reason: dungeon-jev and jev-semantic bake walked decision surfaces into portable artifacts
    target: "[[Project/strategy-graphs-as-shipped-artifacts]]"
  - kind: inspired-by
    reason: the graph lists the options and the model only scores them
    target: "[[Project/the-graph-walking-agent-cursor]]"
  - kind: complements
    reason: the log is the seed and the graph grows from it is the tail's consensus architecture
    target: "[[Project/the-judgment-ledger]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/JEV]]"
  - "[[Technology/MCP]]"
  - "[[Technology/OpenBible]]"
  - "[[Technology/SQLite]]"
---

# Research findings: the JEV long tail — what the zero-star corpus is actually building

*Collected 2026-10-23 as adversarial, out-of-comfort-zone research for the
relate-ideas list. Companion pass, same date: [jev-head.md](jev-head.md)
(the popular 20★+ tier — boundary data, heavyweight flags, and graph-fit
verdicts for the head). Question asked: the prior JEV audit
([jev-ecosystems.md](jev-ecosystems.md)) leaned on curated lists and vendor-
adjacent showcases, which the parent session judged thin and
prior-confirming. This pass goes the opposite direction: GitHub search
in breadth (including the zero-star tail, sorted by fewest stars), the
newer independent directories, HN launch threads, and domain-targeted
hunts (games/D&D, dating, astrology, dreams, cooking, weather,
geopolitics, finance, genealogy, weddings, negotiation, personality,
marketplaces, moderation, art, poetry, fandom). Lens unchanged: RelateDB
is an embedded in-memory property-graph engine — single binary, WAL +
Parquet, openCypher, WASM, Bolt/HTTP/MCP, C ABI.*

The honest headline: **the tail is much weirder and much more
engineered than the curated lists show, and the most graph-native things
in it have nothing to do with agents, RAG, or coding.** The zero-star
corpus has a distinctive culture — pre-registration, per-call receipts,
budget ceilings, fail-closed fallbacks, "the log is the seed; the graph
grows from it" — and the surprising graph-shaped projects are in games,
scripture, civic policy, climate accounting, and prediction-market
contract logic. The bulk of the tail is still flat judgment plumbing
(the prior audit's verdict holds), but the exceptions are better than
anything in the curated lists.

## 1. Corpus scale, calibrated

GitHub repository search counts (2026-10-23, authenticated API):

| Query | Total repos |
| --- | --- |
| `jev` (name/description/readme) | 18,630 |
| `jev in:name` | 14,409 |
| `jev in:name created:>2026-09-01` (post-launch) | **11,088** |
| `jev in:name created:<2026-01-01` (pre-model noise) | 2,651 |
| `jev in:readme created:>2026-09-01` | 28,741 |
| `topic:jev` | 2,881 |
| `typesafe jev` | 4,005 |
| `noul` (the question primitive) | 470 |

Calibration, because raw `jev` counts lie: most pre-2026 hits are false
positives (the JeVois machine-vision camera, jEveAssets for EVE Online,
a JS framework called Jeva, JEVis building automation, wedding websites
for people named Jev — see §5). Splitting by creation date shows the
model-name explosion is real: ~11.1k repos *named* something-jev were
created in the ~6 weeks after launch, versus 2.7k ever created before
2026. The "~20,000 GitHub projects" framing from the mandate is therefore
conservative for the *mentions-Jev* corpus (28.7k post-launch readmes)
and about right, slightly generous, for the *is-a-JEV-shaped-project*
corpus after false-positive discount — call it **10–15k model-related
repos**, of which curated directories vouch for ~2k.

The curated/directory layer (each verified reachable):

- **jevlist.ai** — "306 apps you can use and 1595 libraries, integrations
  and starters you can build with" across 17 categories (862 developer
  tools, 242 SDKs, 209 independent-model-research, 151 web apps, 102
  browser/computer-use, 94 search, 52 games and simulation, 62 browser
  extensions, 49-ish moderation/community bots, 29 customer
  feedback/marketing, 29 macOS apps, 22 CLI, 18 desktop, 10 Windows,
  8 Android, 5 home automation, 4 Discord, 2 Telegram). Claims no paid
  placement; listings are reviewed against upstream commits.
- **At least 11 independent awesome lists**, more than the nine the dev.to
  survey (2026-09-21) found: valentynkit/awesome-jev-typesafe (415
  entries, the prior audit's base), Amal-David/awesome-jev (241★),
  cobanov/awesome-jev ("source-backed"), daftAI2026/awesome-jev,
  heyjunpenn/awesome-jev, yibie/awesome-jev, AbdelStark/awesome-typesafe-jev,
  walidboulanouar/awesome-jev-use-cases, robokrunch/awesome-jev,
  logicrw's awesome-jev-projects radar, awesomejev.vercel.app /
  awesomejev.app. Two-plus SEO squatter sites (jev001.org, jev-ai.org)
  already exist to farm the name — the Jevons-paradox brand tax.
- **Topic-specific directories**: usejev.dev (12 guides with code + 98
  community posts), devwithjev.com (builds + reddit roundups),
  jevfast.com, jevlibrary.dev, jev.show, jevradar.com.
- **Model momentum**: Jev 1.14.0 shipped "experimental features for
  dreamers" (HN https://news.ycombinator.com/item?id=50095353) — image
  input with a new `box` bounding-box type, composable images, and
  opt-in long context behind a header literally named
  `TypeSafe-Danger-Zone-Long-Context: true`. The same thread's loudest
  complaints matter for an embedded-engine pitch: data residency
  ("ZDR enterprise-only… a hard showstopper"), rate limits, and
  repeated "why is this an API at all — a small decision model belongs
  on the edge" (local replicas run at ~1.1 GB RAM, no GPU).

## 2. What the zero-star tail looks like

Sampled via `stars:0` search and per-domain queries. Characteristics:

- **One-author, one-idea, zero stars, updated this week.** The tail is
  alive, not abandoned: 30+ repos under these domain searches pushed
  commits on 2026-10-21..23 alone.
- **A receipts culture the head lacks.** Even zero-star repos ship
  per-call JSONL receipts (provider, model, purpose, tokens, latency,
  http status, *failures too*), monthly/daily spend ceilings, recorded
  judgments for offline replay, pre-registered claims sealed before
  runs, and fail-closed fallbacks to deterministic behavior.
- **Multilingual by default.** Chinese (DreamDM, WeChat companions,
  Stardew agent), Japanese (badminton form coach, VTuber IME),
  Korean (housing-policy hackathon, radar digest), Portuguese (Dwarf
  Fortress autoplay), French (the entire gbesse climate/PII/prediction-
  market cluster), Spanish (browser-use experiments). The
  English-language awesome lists under-sample this badly.
- **Vendor drop-ins from unexpected companies**: TencentEdgeOne/jev-holdem
  (Tencent's edge network published a poker demo), Vonage's
  demo-video-javascript-jev-starter (video-call escalation on
  frustration detection).

## 3. The surprising-pattern catalog

Every repo below was reached by search and its README read this pass.
Star counts are 2026-10-23.

### (a) The model as a game-world brain — a five-genre, multi-author corpus

Not one flagship: an entire genre. "Code owns rules, numbers and state;
Jev picks at branches" recurs verbatim across unaffiliated authors:

- **Pokémon, five independent implementations.** christianmat/jev-pokemon
  (130★) — beat Pokémon Red in 37h 40m; valentynkit/jev-plays-pokemon-red
  — "code owns the route and the arithmetic, Jev picks at branches in
  about 100 ms", and with unusually honest calibration hygiene ("the
  longest labelled run so far is n=5 with a confidence interval that
  covers everything… a Brier score on that sample would be decoration");
  milanboers, anxkhn (Pokémon Showdown), daniel4x/JevEmon.
- **Minecraft: rmalde/minecraft-agent (600★)** — Astra planner + JEV
  controller, native recording, "tested routes, and run verification".
  Also teknium1/hermes-and-jev-play-minecraft (11★), mrubens/jevcraft,
  selmakcby (Turkish).
- **Factorio, four unrelated repos** (kgaspard, jevplay-games,
  MudassarZia — which preserves "unsuccessful results" —, Adibrill1).
  The archetypal supply-chain-graph game attracting decision-model
  controllers is itself a data point.
- **Chess ×5 + Elo**: TholeG/typesafe-chess (both players are Jev),
  DevItaliya22/jev-chess (vs itself, graded by Stockfish),
  sliday/jev-chess-algo ("every legal move as the options of one typed
  Choice question"), pulkitxm/jev-chess-agent, an Elo-rating harness.
  Plus **shogi** (jammaru/jev-lab, USI-legal replies), **hold'em ×3**
  (TencentEdgeOne and yf-git6080 jev-holdem — "the local engine deals
  and settles; Jev answers typed questions, and code composes the bet" —
  and carlaiau/can-jev-play, a gambling-psychology audit asking whether
  recent wins/losses sway Jev's payout-table choices).
- **Colony/story sims**: RimWorld Autopilot (listed at jevlist.ai), a
  Rust/Bevy **ant colony** driven by Jev orders, Dwarf Fortress autoplay
  (frederico-kluser/dwarf-fortress-agent-skill — Jev decision fleet +
  DeepSeek narrator + CoALA memory, Portuguese), Stardew Valley
  (rottenpen/agent-stardew), burger-rush kitchen sim (BHD110).
- Corroboration that this is now canonical: both Amal-David's and
  cobanov's awesome lists carry dedicated "Games and Creative Projects"
  sections; jevlist.ai counts 52.

Graph fit: **the world model is graph-native, the decision layer is
flat** — which is the README's existing World-Model Storage idea, now
corroborated across ten games. The *new* observation is §3(b).

### (b) NPC societies and worlds with an agenda — the decision log as social memory

The genuinely new thing in the games cluster is not "model plays game"
but **model populates world**, with the world keeping relationship and
event state:

- **jammaru/jev-lab — "Hundred" (8★)**: "100 NPCs live in a tiny town
  with hunger, money, jobs, relationships, and memories. Jev only
  answers *what should this person do next?*"
- **lmvdz/rpg-jev (3★)**: "a persistent multiplayer RPG whose world
  keeps its own agenda… Jev makes every in-world decision, Claude authors
  the world on a background thread, and code owns rules, numbers and
  state." Its gating spike is a research question, not a feature:
  *does Jev judge social fiction the way people do?* World server is
  SpacetimeDB.
- **DreamDM (YuanzheYanggg, 0★, Chinese)**: a local fantasy-RPG DM where
  Codex/GPT-6 authors scenes/options/consequences and **foreshadowing
  ("伏笔") with later convergence ("合流")**, Jev Score grades risk,
  Jev Choice picks pre-written consequences, Jev Noul checks whether an
  existing route can still accept a necessary condition — "branch merges
  preserve the accumulated differences". NPC side-agreements, inventory
  and prerequisite chains are the state.
- **ericosg/doj, CodeAlchemyML/jev-dungeon, tildaslashalef/decision-dungeons**
  (0★): dungeon crawlers / playgrounds where every enemy or seeded
  decision is a typed question; decision-dungeons pits Jev against an
  open replica and baselines on the same seeded dungeons.
- **The D&D table itself**: coredweller/MonsterJevActionalizer (0★,
  D&D monster decision maker); and a detailed measured report,
  **iambraun.com/jevreports/co-dm/** — a co-DM on campaign-mcp: five
  judgment points (table rules, canon contradictions per faction, message
  routing, art-library kinds, fact triage), answer keys written blind,
  reviewer assuming the benchmark was rigged. Its canon check scores a
  proposal against the facts already on file for its faction — 64 rows
  of world state, plus an art library of 181,805 files.
- Lucineer/dmlog-ai (DM session logging + AI), David Braun's "Worth
  Asking" Co-DM report above.

Graph fit: **strong, and stronger than the prior audit credited.** A
hundred-NPC town is a social graph plus an event/decision log; faction
canon is an assertion store; DreamDM's foreshadow-and-converge is
literally a provenance chain over a branching DAG. These projects keep
that state in ad-hoc JSON/SQLite/SpacetimeDB today.

### (c) The esoteric tail: tarot, ouija, astrology — engineered with a straight face

- **CyberSecDef/tarot.trackr.live (0★)**: seeded tarot with **ChaCha20
  keystream** draws ("unpredictable when drawn, exactly reproducible
  from the seed"), Jev reads only the question (domain · register ·
  facet per card · anchor pair, as state, never instructions), every
  word pre-written from a content lattice of **78 cards × 2 orientations
  × 6 domains × 6 registers × 3 variants** plus openings, position
  lead-ins and closings; share links carry the seed + Jev's
  classification so a reading rebuilds exactly without a second call;
  $10/month hard spend ceiling with fallback-to-deterministic. This is
  a pre-computed typed content graph walked by a decision model, with
  the walk encoded in a portable link.
- **duc-minh-droid/hollow-hand (0★)**: occult-tarot roguelike
  deckbuilder; Jev is the Dealer, and *between fights it studies your
  habits and writes counter-rules into its ledger* — "what Jev saw, the
  rule it wrote to punish it, and the card it stole." Taunts reference
  your habits.
- **jevboard.dev** — an ouija/talking board where the model "decides; it
  does not generate": the server prepares a word pack per turn, Jev
  picks one word via Choice ("HELLO 0.86, I 0.13, YOU 0.01"), the
  planchette spells it, a new pack opens. "Ghost Jev is a character,
  not a supernatural claim."
- **horace-maxwell/horosa-skill** (via jevfast.com, ★437): an
  astrology/divination skill — western natal, bazi, ziwei, liuren, yijing,
  numerology-shenshu — where Jev is the *router* over technique families,
  gated by confidence thresholds, shadow mode and local redaction of the
  user's request.
- **Academia joins in**: Nouar-NYUAD/LLM_friendship_recommendation (0★)
  — "The Jev decision model applies astrological and demographic
  stereotypes when recommending friends" (AlDahoul & Zaki, 2026):
  20,000 forced-choice conjoint calls ×2 studies; zodiac sign was a
  randomized attribute and the stereotype was measurable.
- Also in this spirit: the Jev-Powered Smart Magic 8 Ball
  (devwithjev.com build) and quinnjr/scaramucci-jev (0★) — "Is this date
  range X Scaramuccis long? A zero-dependency ES module + CLI that asks
  the TypeSafe Jev decision model to settle it."

Graph fit: **tarot.trackr.live's content lattice is a real typed
overlay graph** (card → orientation → domain → register → variant →
text), and its share link is a serialized walk — but the walk is one
request per reading and the lattice is small; an embedded graph engine
is overkill for the current shape and *exactly right* the moment the
lattice grows joins (per-user reading history, per-card corpus
statistics) — which none of these projects do yet. hollow-hand's
habit-observation → counter-rule ledger is a decisions-over-time
provenance graph with real queries ("show me every rule the Dealer
wrote against me and the observation behind it") — good fit, tiny
project. The ouija board and the 8-ball: flat, say so.

### (d) Romance and social-reading — the weirdest cluster, and mostly Chinese

- **TurboGuo/jev-dating (0★, live at jevdating.pages.dev)**: "Red Flag
  Detector" (paste a message/bio/listing → red/green flag with
  probability) and "Is She/He Interested?" (paste a chat line-by-line,
  both sides score every message, message-by-message chart from
  "You're cooked" to "Yes, go for it"), Jev vs four chat models on the
  same standard, arena-style, run-once-or-ten-times consistency check.
  Its sibling **TurboGuo/jev-fedspeech** scores real Fed press
  conferences "Hawk or Dove?" — the same relationship-reading engine
  aimed at a central bank.
- **rishi-raj-jain/date-with-jev (0★)**: anonymous dating-chat
  screenshot evaluator ("get the tea") — OCR in the browser (tesseract),
  five narrow typed questions in one call, Postgres keeps transcript +
  read "for good" (`expires_at` kept as a marker, nothing acts on it).
- **dennisonbertram/hot-or-not-jev (0★)**: picks your best dating-profile
  lead photo. (Same author pattern on the devwithjev "Automated Tinder
  Profile Decisions" build.)
- **The WeChat companionship cluster**: Goutoujunshi Jev Chat (OCRs the
  chat, Jev strategy judgment, ranked draft replies you send), Jev Chat
  Windows (offline OCR + three fill-only reply candidates — never
  auto-send), **JevIntent** (an LSPosed *hook inside WeChat itself*:
  long-press any message → intent/emotion/urgency/stance overlay, "no
  reply text"). A whole family of "read my relationship for me" tools
  exists in Chinese that the English awesome lists barely index.
- **Input methods as decision surfaces**: AsheeHuang/Jevboard (17★) —
  a Windows tray tool that re-selects **Bopomofo homophones** in
  Microsoft's IME: Jev judges which positions got wrong candidates
  (「想在去一次芮氏」→「想再去一次瑞士」), restricted to candidates the IME
  itself offered. HisuiKoh/jev-vtuber-ime-core (1★) does the same for
  Japanese readings → VTuber-specific spellings, grounding each pick in
  web-search evidence, no dictionary data. The conversion lattice of an
  IME is a classic weighted graph; both projects currently treat it as
  ephemeral per-sentence state.
- **Synthetic-respondent psychometrics**: Miraai-io/qarin-digital-twins
  (1★) — digital twins of 100 real people built from their Miraai
  Personality + HEXACO-100 answers; "give the twins your own
  questionnaire items and they answer as those people would" so you can
  pilot items/scales before recruiting anyone (33 of 36 defective items
  flagged). opaielsheikh/ai-elo-ranker (7★) — recursive **Swiss-
  matchmaking Elo/TrueSkill tournaments** where Jev judges duels between
  "poems, startup pitches, rap lyrics, cold emails, ad hooks" (~70k
  matches instead of 50M pairs, SQLite WAL audit logs).

Graph fit: honest verdicts differ sharply inside this cluster. The
dating chat meters and red-flag detectors are **flat** — a conversation
is a list, a verdict per message; nothing there needs a graph engine,
and pretending "relationships between people → graph" would be exactly
the forced-fit this audit exists to prevent. The WeChat cluster's
*longitudinal* state (per-contact history, what you decided last time)
is relationship-shaped, but none of the projects persist it that way
today. The **Elo tournament is a real graph** (items, matches, rating
dynamics; "who beat whom, by what margin, when ratings crossed") — modest
but genuine. The IME lattice is a graph worn flat; only a per-user
correction-history layer would earn a store, and neither project builds
it.

### (e) Accountability, civic policy, and climate — the graph-native tail the curated lists don't index

The strongest genuinely new pattern. These projects are small, mostly
zero-star, mostly French/Korean, and they all build relationship
structure *because the domain demands auditability*:

- **aen07/jev-grievance-triage (0★)**: triage for **development-finance
  grievance mechanisms** (the World-Bank-Inspection-Panel world). Jev
  answers 23 narrow questions in one request; versioned thresholds turn
  probabilities into booleans; plain Python applies policy rules P1–P8;
  "every field traces back to a probability, a threshold, a rule and an
  exact model version." Offline replay from recorded answers.
- **Aiden-Kwak/SweetHome (0★, Google DeepMind AI Hackathon, live app)**:
  Korean housing-policy simulator — upload a policy document, inspect
  extracted changes, compare regional scenarios; "an **editable
  knowledge graph connects policies, evidence, regions, and
  households** so users can examine the relationships behind each
  scenario", with assumption/source quotations kept per step. A temporal
  policy KG + household impact simulation.
- **gbesse's French cluster** (all 0★, all MIT, all with CI and offline
  fixtures): **jev-carbone-factor-fit** (ranks ADEME carbon-emission
  factor candidates for an activity/expense label, explicit outcome
  categories, human-review thresholds), **jev-contract-graph**
  (below), jev-brandsafety, jev-pii, jev-rncp-claim-proof, jev-crypto-lab.
- **dpshde/bible-jev-climb (0★)**: **cross-reference hill climb over
  KJV verses — "The graph lists the options; Jev only scores them."**
  An in-memory graph built from public-domain KJV JSON + OpenBible.info
  vote-weighted cross-reference edges + topical co-occurrence edges;
  dry-run mode replays recorded judgments with no key and no corpus.
  Companion: mccartykim/keyed_james_bible (turn a question into a span
  of KJV verses, keyed via Jev). Scripture navigation is a
  60k-verse-scale graph problem with free CC-BY corpora.
- **Health/clinical**: PAI-CUHK/SLEEPJEV (3★) — a CUHK sleep lab running
  "JEV-inspired typed runtime decisions over long-horizon PSG"
  (overnight polysomnography, reusable overnight encoding, sparse
  retrieval); PAI-CUHK/MEDJEV (clinical evidence, biomedical NLP);
  ChenReuven/jev-triage-hospital; medjev. Also VeChain-adjacent
  adverse-drug-event sentence flagging in the usejev community list.
- **Embodied coaching**: masanori-takada's badminton/golf swing-form
  coach (Japanese) — MediaPipe Pose **in the browser**, only a few dozen
  pose-derived numbers ever leave the device, Jev scores 5 axes,
  an LLM verbalizes coaching. Privacy-first embodied judgment.
- vedssharma/jev-drive: browser 3D driving over a **connected city-grid
  road graph** — four parallel Choice questions (pace/lane/route/
  attention), weather (clear/rain/fog/snow), injectable hazards,
  inspectable observations and distributions per tick.

Graph fit: **this is where the tail is graph-native.** Grievance
provenance chains, policy→evidence→region→household knowledge graphs,
contract-implication DAGs (below), emission-factor mapping, scripture
cross-reference graphs, clinical-evidence trails. Every one of these
keeps its graph in ad-hoc in-memory structures, SQLite, or a JSON file
today. The pattern they share is *judgment + provenance + audit*, and
the judgment is the least graph-shaped part — the chain of custody is.

### (f) Prediction markets and calibration science

- **gbesse/jev-contract-graph (0★)**: implications between reviewed
  binary contracts derived from nested thresholds/windows ("an
  implication is derived from seuils et fenêtres emboîtés"), conditional
  payoff proofs, order-book simulation of both legs; Jev is optional and
  explicitly "neither certifies the clauses nor the reality of an
  incident."
- **sbayer2/crowd-calibration (0★)**: *is the prediction-market crowd
  baked into Jev?* Pre-registered experiments comparing blind Jev
  (given only league, teams, date) vs Polymarket vs Pinnacle sharp lines
  across NHL/MLB/NCAAF/NBA seasons, with live collectors and failed
  predictions published.
- MojoAI-King/jev-paper-trader (3★, paper-trading real Polymarket/Kalshi
  with a fake $100k), devsoniclk/jev-polymarket, mehek-builds/prediction-market,
  ashish24142/jev-clm (contract-clause screening on CUAD, pre-registered:
  "three bets hit, two missed, all published"), TurboGuo/jev-fedspeech
  (Hawk/Dove on Fed transcripts), erichers/jev-odds.

Graph fit: jev-contract-graph is **graph-native by name and by
construction** — a small implication DAG between financial instruments
where the queries ("what does this contract's resolution imply about
that one; prove the payoff under these books") are traversals with
provenance. The calibration science is flat experimental data — no fit.

### (g) The meta-weird: abusing the API, auditing the model, distilling it away

- **Text generation from a non-generating model**: kesku/jev-freeform
  (3★) — successive Choice over 98 ASCII characters ("I gave it
  characters"); uhhfeef/jev-lm (3★) — "a character-level language model
  built on Jev"; ronibandini/JevPoet (0★) — "They say Jev cannot
  generate text, so who wrote this poem?"; cocktailpeanut/jevthoven
  (15★) — MIDI generation. All deliberately slow, and all flat.
- **SuperInstance/dungeon-jev (0★)** — "the JEV waveform player": each
  tick decomposes the game state into typed cells (threat-level,
  loot-pull, hp-pressure…); the Jev call's job is a *superposed
  distribution over 5 actions* which is receipted per tick, then
  collapsed locally; post-run analysis asks **"what fraction of ticks
  actually need the model?"** — where the wave is flat (top-2 within ε)
  a free local tiebreak suffices. Then Jev is fed the aggregate and
  asked to *propose new cell weights*, after which the game runs with
  **zero model calls**. Pre-registered claims, sealed before runs.
  This is decision *distillation into a portable rule artifact* — the
  strategy-graph candidate of the prior audit, built by a zero-star
  repo nobody curated.
- **SuperInstance/jev-semantic (0★)** — "the semantic layer for the
  Jev: a judgment log, a window compiler, and the question tree."
  Every judgment append-only, keyed by `(subject, question, judge)`
  blob hashes; the question tree is directory-nested files with
  `root.md` as "the one question every Jev can condition on";
  "Two bodies may log the same key; their disagreement is data." And
  the line that should be quoted everywhere: **"The log is the seed;
  the graph grows from it."** Status: "The log is live. The graph comes
  next."
- jev-enhanced-plugin (JiaWeiXie, 0★) — a Claude Code plugin that adds
  one typed Jev judgment to existing skills at the points where the
  skill "relied on the agent's own impression." stackable-specs/decide
  (0★) — reusable typed decision templates across Jev/Laya/LLMs "with
  capability negotiation, probability provenance". bojansandhaus/
  jev-decisions-hermes — local decision journal. SuperInstance/
  jev-harness — "a client that cannot fail quietly."
- **The oracle as a character**: rehan-remade/open-annie (53★) — a
  voice-driven 3D companion where "the model that talks is not the model
  that moves: GPT-Live-1 talks, Jev moves her." FORIFOR/jev-vtuber-
  studio — an AI VTuber studio where "AI and a person share one
  character mid-show" (NOA Studio). JackZH26/Jev-Live — streaming game
  host studio.

Graph fit: flat for the generative-abuse toys; **strong for the
receipts/judgment-log/question-tree layer**, which is the tail's
consensus architecture and corroborates the prior audit's judgment-
ledger candidate harder than any curated-list source did.

### (h) What the community itself says is the shape

usejev.dev's 98 community posts census (Agents 26, Benchmarks 15,
Search 14, Developer tools 7, Games 8, Moderation 8, Productivity 5,
Browser extensions 3, Trading 3, Robotics 2, …) matches the GitHub tail:
agents/routing/compaction dominate by count, but the *distinctive*
projects concentrate in games, moderation, household, and civic/climate
tools. Two notable not-found lists: usejev.dev reports **no dating,
astrology, dreams, cooking, weddings, personality, art, music, or
fandom entries** — all of which nevertheless exist in the GitHub zero-
star tail (this pass found them), i.e., **the curated community layer
systematically under-indexes exactly the weirdest material**. That is
the confirmation-bias mechanism the parent session suspected, verified.

## 4. The verdict table

| Pattern | Verified exemplars | Graph core? | Honest verdict |
| --- | --- | --- | --- |
| Game playing (Pokémon/Minecraft/chess/Factorio) | 25+ repos, 130–600★ | World model yes; decisions no | Corroborates World-Model Storage; not new |
| NPC societies / worlds with an agenda | jev-lab Hundred, rpg-jev, DreamDM, co-DM report | Social graph + event/decision log + branch provenance | **Strong fit** — the decision log as social memory is genuinely new |
| Tarot / ouija / horoscope | tarot.trackr.live, hollow-hand, jevboard.dev, horosa-skill | Content lattice (real typed overlay); habit ledger (provenance) | tarot lattice fits only once joins/history appear; **hollow-hand's counter-rule ledger fits**; ouija/8-ball flat |
| Dating / social-reading | jev-dating, date-with-jev, WeChat cluster, IME pair | Mostly flat lists per conversation | **Flat — drop**, except per-user longitudinal state nobody builds, and the Elo tournament graph (modest) |
| Grievance / civic / climate accountability | jev-grievance-triage, SweetHome, jev-carbone-factor-fit | Provenance chains, policy-evidence-region-household KG | **Strong fit** — built ad hoc today |
| Scripture cross-reference navigation | bible-jev-climb, keyed_james_bible | Vote-weighted xref edges + topical co-occurrence over 31k verses | **Strong fit** — public-domain corpora, in-memory graph today |
| Prediction-market contract logic | jev-contract-graph, crowd-calibration | Implication DAG between contracts | **Good fit** for jev-contract-graph; calibration science flat |
| Judgment receipts / question trees / distillation | jev-semantic, dungeon-jev, decide, tarot share-links, ai-elo-ranker | Judgment log keyed by content hashes; question tree; waveform receipts | **Strong fit** — "the log is the seed; the graph grows from it" |
| Embodied/daily-life (sport form, driving, sleep, home, cooking) | SportsForm, jev-drive, SLEEPJEV, HA integrations, tadka | City grid (real); PSG time-series; rest flat | jev-drive's road graph fits; cooking 68-dish list is flat |
| Text-gen abuse / poems / MIDI / character boards | jev-freeform, jev-lm, JevPoet, jevthoven, Jevboard | No | Flat — and charming; not for us |

## 5. Negative findings — hunted for, not found

Calibration cuts both ways; these domains were searched and came back
empty or false-positive, and the report should say so:

- **Genealogy / family trees: zero JEV repos** (`jev genealogy`, `jev
  ancestry`, `jev family tree` → 0). The graph world's most familiar
  consumer domain has no JEV presence.
- **Weddings: all false positives** — nine repos, all personal wedding
  websites for people named Jev/Jevlyn/Jet-and-Jev. (These are also the
  reminder that ~2.7k pre-2026 "jev" repos are noise.)
- **Fanfic / fandom / horoscope-generation repos: zero.** Horoscope
  material exists only as the horosa routing skill and a search-listed
  app page (zodico.app, unverified as JEV-based — excluded).
- **Geopolitics as a product: nothing** — one usejev community post
  applies a noul to one geopolitical question; no project.
- **Obituary/grief, negotiation beyond one CLI toy (open-jev-negotiator),
  personality quizzes beyond Qarin/HEXACO, art (beyond the Photoshop
  MCP router and MIDI tools): nothing graph-shaped.**
- IASols/jevt — matched on the name — is a **name collision**: "Journal
  Entry Verification Tool" for SAP exports, no Jev model. The acronym
  space is already colliding.

## 6. Stress-testing the existing JEV candidates (jev-ecosystems.md §5)

1. **InstantCypher (decisions → deterministic Cypher).** Verdict:
   **corroborated with new evidence, and tempered.** New corpus support:
   Jev used *inside a query engine* is live and popular — "Jev as a
   DuckDB UDF scoring flight destinations" (smhumair), "fuzzy classifier
   joins as an inlined SQL function" (Jev 1.14.0 HN thread), Gallant (a
   single-binary Go linter checking code and text against fuzzy rules),
   jev-seo live-site audits. Temper: system-one-decision-bench (jevlist)
   compares Jev vs a chat model on banking77 routing **and reports
   negative results** — the accuracy story for composed-decision query
   planning is not free; a Cypher port should promise inspectability and
   safety, not accuracy. Lane still empty for graphs.
2. **The pre-baked strategy graph as a shipped artifact.** Verdict:
   **strongly corroborated by three independent zero-star builds.**
   SuperInstance/dungeon-jev's worksheet quilt (typed cells, weights
   proposed by Jev then baked in, runs with zero model calls);
   SuperInstance/jev-semantic's question tree (directory nesting,
   blob-hash identity, root question); tarot.trackr.live's content
   lattice + seed-carrying share links that rebuild a walk without a
   second call. Nobody ships the surface as a *portable store* yet — the
   gap stands, now with three more named lineages.
3. **The judgment ledger.** Verdict: **the tail's consensus architecture
   — strongest candidate of the five.** jev-semantic ("the log is the
   seed; the graph grows from it", keyed by subject/question/judge
   hashes, disagreement-is-data), dungeon-jev's receipts (waveform +
   model-calls with failures), grievance-triage ("every field traces
   back to a probability, a threshold, a rule and an exact model
   version"), decide's "probability provenance", ai-elo-ranker's SQLite
   WAL audit logs, tarot's replayable share links. The tail already
   believes in judgment provenance; it just has nowhere graph-shaped to
   put it.
4. **Confidence-gated entity resolution, embedded.** Verdict: **no new
   tail evidence either way.** Still rests on the two curated sources
   from the prior audit; unchanged, unweakened, not strengthened.
5. **Graph-walking agent cursor (`next_hop` over MCP).** Verdict:
   **corroborated by the purest instance yet.** bible-jev-climb — "The
   graph lists the options; Jev only scores them" — is exactly the
   neo4jev pattern, built by a stranger on scripture. Reinforced by
   valentynkit's Pokémon ("code owns the route… Jev picks at branches"),
   the 600★ Minecraft agent's "tested routes", jev-drive's junction
   decisions over a road graph, and horosa's gated technique-routing.
   The pattern generalizes further than the prior audit claimed.

## 7. Surprise candidates for the README

Report only; each with an honest fit assessment attached.

1. **NPC societies as world-state graphs — "the town that remembers."**
   The Hundred/DreamDM/RimWorld-autopilot cluster, where 100 agents'
   relationships, side-agreements and memories are the store and every
   Jev decision is an event edge on it. The queries are retrospective —
   "who met whom, what did each decide, who owes whom, which promise
   converged into which consequence." Fit: **genuinely graph-native**
   (social graph + event log + branch provenance), currently ad-hoc
   JSON/SQLite/SpacetimeDB. Distinct from the README's World-Model
   Storage (single game world) because the *decision log is the social
   memory*. The user did not think of this one.
2. **Scripture cross-reference navigation in a browser tab.** One `.cl`
   file: KJV + OpenBible's vote-weighted xref edges + topical co-
   occurrence edges; hop-by-hop "which cross-reference answers this
   question" with the model only scoring graph-listed options (the
   bible-jev-climb pattern); pilgrim's walk recorded as a path for
   revisit. Fit: **strong** — 31k+ verses, two free CC-BY edge
   corpora, and a verified zero-star project building it in memory
   today. Surprising garment: devotional tooling on a decision oracle.
3. **Policy-impact knowledge graphs with assumption provenance.**
   SweetHome's shape generalized: policy documents → editable typed
   graph of policies/evidence/regions/households → scenario simulation
   where every number traces to a source quotation and a judgment. Fit:
   **strong** — the domain (housing policy, carbon accounting,
   grievance accountability) demands the provenance chain; today it's a
   hackathon prototype on an ad-hoc store. The graph world never looks
   at development-finance grievance mechanisms; the JEV tail does.
4. **The player-model ledger — opponents that study you.** hollow-hand's
   habit observations → counter-rules → stolen cards, generalized as a
   persisted adversary-memory: every rule an opponent wrote against
   you, the observation behind it, and the fight where it paid off.
   Fit: **good but small** — provenance-shaped, real queries, tiny
   project today; a fun README entry, an honest "not a platform" label.
5. **Prediction-market contract implication DAGs.** jev-contract-graph
   as the seed: binary contracts with nested thresholds/windows imply
   each other; payoff proofs and book simulations over the edges; Jev
   only for optional semantic review. Fit: **good** — a real, if niche,
   graph workload with provenance ("why does this contract imply that
   one"), zero-star today. The finance section of the prior audit
   wanted fraud rings; what actually exists is contract-logic graphs.
6. **The tarot content lattice as a strategy-surface artifact in
   disguise.** The joke that proves the architecture: 78 × 2 × 6 × 6 × 3
   typed content nodes, a decision model choosing a path through them,
   and a share link that serializes the whole walk. It is the prior
   audit's "pre-baked strategy graph, shipped" candidate wearing the
   one costume nobody would pitch — and it ships replayable walks
   before any of the serious projects do. Fit: **moderate** (lattice
   joins/reading-history would earn the store; today one call per
   reading), but as a README illustration of the pattern it is
   unforgettable.
7. **Decision-necessity receipts — "what fraction of ticks actually
   needed the model?"** dungeon-jev's waveform experiment generalized:
   every repeated decision loop receipts its full per-decision
   distribution; analysis marks which decisions were flat enough to
   collapse locally, and the sharp ones become the distillation set
   (weights baked in, zero model calls after). Fit: **moderate-to-good**
   — a time-graph of decisions with a real new query shape ("show me
   every decision where the model moved the outcome") that no log file
   answers. Genuinely not what a graph person would have pitched; the
   tail invented it.

## Sources

- GitHub repository search API (queries and counts in §1, sampled 2026-10-23)
- https://jevlist.ai/ and its category pages
- https://github.com/Amal-David/awesome-jev · https://github.com/cobanov/awesome-jev ·
  https://github.com/daftAI2026/awesome-jev · https://github.com/heyjunpenn/awesome-jev ·
  https://github.com/yibie/awesome-jev · https://github.com/AbdelStark/awesome-typesafe-jev ·
  https://github.com/walidboulanouar/awesome-jev-use-cases · https://github.com/robokrunch/awesome-jev ·
  https://github.com/valentynkit/awesome-jev-typesafe · https://awesomejev.vercel.app/ · https://www.awesomejev.app/
- https://usejev.dev/use-cases/ (12 guides + 98 community posts census)
- https://news.ycombinator.com/item?id=50095353 (Jev 1.14.0 "features for dreamers")
- https://news.ycombinator.com/item?id=49877434 · https://news.ycombinator.com/item?id=50167617 ·
  https://news.ycombinator.com/item?id=49883844 (Jevpipe, Jev Cards, Jeff)
- https://iambraun.com/jevreports/co-dm/ (the Co-DM report)
- https://www.jevboard.dev/ (the talking board)
- https://jevfast.com/horosa-skill/ (horosa-skill listing)
- Repos read in full or in part this pass:
  https://github.com/jammaru/jev-lab · https://github.com/lmvdz/rpg-jev ·
  https://github.com/YuanzheYanggg/DreamDM · https://github.com/coredweller/MonsterJevActionalizer ·
  https://github.com/christianmat/jev-pokemon · https://github.com/valentynkit/jev-plays-pokemon-red ·
  https://github.com/rmalde/minecraft-agent · https://github.com/frederico-kluser/dwarf-fortress-agent-skill ·
  https://github.com/rottenpen/agent-stardew · https://github.com/kgaspard/jev-factorio ·
  https://github.com/TholeG/typesafe-chess · https://github.com/TencentEdgeOne/jev-holdem ·
  https://github.com/carlaiau/can-jev-play · https://github.com/CyberSecDef/tarot.trackr.live ·
  https://github.com/duc-minh-droid/hollow-hand · https://github.com/quinnjr/scaramucci-jev ·
  https://github.com/Nouar-NYUAD/LLM_friendship_recommendation · https://github.com/TurboGuo/jev-dating ·
  https://github.com/rishi-raj-jain/date-with-jev · https://github.com/dennisonbertram/hot-or-not-jev ·
  https://github.com/AsheeHuang/Jevboard · https://github.com/HisuiKoh/jev-vtuber-ime-core ·
  https://github.com/Miraai-io/qarin-digital-twins · https://github.com/opaielsheikh/ai-elo-ranker ·
  https://github.com/aen07/jev-grievance-triage · https://github.com/Aiden-Kwak/SweetHome ·
  https://github.com/gbesse/jev-carbone-factor-fit · https://github.com/gbesse/jev-contract-graph ·
  https://github.com/dpshde/bible-jev-climb · https://github.com/mccartykim/keyed_james_bible ·
  https://github.com/sbayer2/crowd-calibration · https://github.com/PAI-CUHK/SLEEPJEV ·
  https://github.com/vedssharma/jev-drive · https://github.com/poojaverma-me/tadka ·
  https://github.com/kesku/jev-freeform · https://github.com/uhhfeef/jev-lm ·
  https://github.com/ronibandini/JevPoet · https://github.com/cocktailpeanut/jevthoven ·
  https://github.com/SuperInstance/dungeon-jev · https://github.com/SuperInstance/jev-semantic ·
  https://github.com/stackable-specs/decide · https://github.com/bojansandhaus/jev-decisions-hermes ·
  https://github.com/JiaWeiXie/jev-enhanced-plugin · https://github.com/rehan-remade/open-annie ·
  https://github.com/FORIFOR/jev-vtuber-studio · https://github.com/skvertl/open-jev-negotiator ·
  https://github.com/ericosg/doj · https://github.com/tildaslashalef/decision-dungeons ·
  https://github.com/masanori-takada/260920_SportsForm_ver1.1 · https://github.com/ajbmachon/jev-navigator
