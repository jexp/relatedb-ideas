---
type: Research
name: developer-social-networks
INFORMS:
  - "[[Project/friendship-archipelago]]"
  - "[[Project/use-case-gallery]]"
  - "[[Project/your-follow-graph]]"
IN_CATEGORY:
  - "[[Category/Research]]"
MENTIONS_ORG:
  - "[[Company/Neo4j]]"
MENTIONS_PERSON:
  - "[[Person/Mark Needham]]"
RELATED_IDEA:
  - kind: variant
    reason: same personal-network analysis over open social data
    target: "[[Project/friendship-archipelago]]"
  - kind: complements
    reason: prebuilt dataset loaders are the same impulse as these example-dataset repos
    target: "[[Project/kaggle-huggingface-graphloader]]"
  - kind: variant
    reason: load your personal social subgraph and query it
    target: "[[Project/your-follow-graph]]"
USES_TECH:
  - "[[Technology/Cypher]]"
  - "[[Technology/GitHub]]"
  - "[[Technology/GraphQL]]"
  - "[[Technology/Meetup]]"
  - "[[Technology/Neo4j]]"
  - "[[Technology/Stack Overflow]]"
  - "[[Technology/Twitch]]"
---

# Developer Social Networks \- Example Datasets

Sandbox datasets \+ guides in the spirit of [github.com/neo4j-graph-examples](https://github.com/neo4j-graph-examples)

## General idea

Social networks are the classic way to explain graphs, but the generic ones — Facebook, LinkedIn — keep their data locked away. Developer social networks have open APIs and free data access, and they are more relevant to a developer audience anyway.

See [Exploring the Neo4j Community Graph](https://neo4j.com/videos/exploring-the-neo4j-community-graph-with-michael-hunger-live-stream/) for a worked example of the genre.

The pitch: let people load their **personal** social network, or a "subgraph of interest" (a tag, a topic, an organization), then query, visualize, and analyze it. Good ideas are everywhere — Kaggle competitions and other people's analytics are worth mining for query ideas.

Existing importer code (Python and APOC) for several of these networks lives in [github.com/community-graph](https://github.com/community-graph) — e.g. the [community-graph-cli importers](https://github.com/community-graph/community-graph-cli/tree/master/lib).

**Gotcha**: these datasets have grown over years, so the data models of the blog posts, examples, and guides are not consistent. Query ideas lifted from an article usually need their data model adjusted to the local import.

Per dataset, one repository with a shared template:

* dump files (a pre-selected slice of interesting data)
* browser guide with queries to explore, visualize and analyze
* model image, example image
* example query (parameter name and value, result column, expected result)

Browser guides can use plain Cypher but also APOC, GDS, etc. — interesting, educational, with incremental complexity:

* load data (LOAD CSV, or from the API with APOC)
* intro to Cypher
* top\-n
* recommendations, collaborative filtering
* clustering, PageRank
* similarities

Later: other graph apps (Bloom, charts/dashboards, [neomap](https://github.com/stellasia/neomap/)) on the same data; GraphQL schemas ([GraphQL APIs for developer communities](https://blog.grandstack.io/graphql-apis-for-developer-communities-64ec1b4c0e18)) and Jupyter notebooks for further analysis.

## Twitter

[github.com/neo4j-graph-examples/twitter-v2](https://github.com/neo4j-graph-examples/twitter-v2) — a sandbox that uses Twitter auth and a separate importer to load the user's followers, follows, tweets, tags, urls, …

Browser guide: [guides.neo4j.com/twitter](https://guides.neo4j.com/sandbox/twitter/index.html) — top-follower, follow-back-rate, recommendations.

Reference material:

* [Finding influencers and communities in the graph community](https://medium.com/neo4j/finding-influencers-and-communities-in-the-graph-community-e3d691296325)
* [Twizzard, a tweet recommender using Neo4j](https://lyonwj.com/blog/twizzard-a-tweet-recommender-system-using-neo4j)
* [Neo4j at OSCON: the Twitter graph](https://neo4j.com/blog/oscon-twitter-graph/)
* [Sentiment analysis on Twitter data](https://www.kennybastani.com/2019/09/sentiment-analysis-on-twitter-data.html)

Analytics ideas from the Twitter-trolls dataset:

* [Twitter trolls sandbox guide](https://guides.neo4j.com/sandbox/twitter-trolls/index.html)
* [The story behind the Russian Twitter trolls](https://neo4j.com/blog/story-behind-russian-twitter-trolls/)
* [Scraping Russian Twitter trolls with Python and Neo4j](https://lyonwj.com/blog/scraping-russian-twitter-trolls-python-neo4j)
* [Six ways to explore the Russian Twitter trolls database](https://hackernoon.com/six-ways-to-explore-the-russian-twitter-trolls-database-in-neo4j-6e52394c38f1)
* [Loading tweets with twint, Kafka and Neo4j](https://www.markhneedham.com/blog/2019/05/29/loading-tweets-twint-kafka-neo4j/)

## StackOverflow

Load via the API with APOC (e.g. the last 1000 questions for a tag or user), or from the [SO dump importer](https://github.com/neo4j-examples/neo4j-stackoverflow-import) as a monthly dump of the last 1–6 months.

Data model: users (id, name, url, bio?, location?) · tags (name, url?) · questions (title, id, url, views, favorites) · answers (id, votes) · comments?

Prior art:

* [Import 10M Stack Overflow questions](https://neo4j.com/blog/import-10m-stack-overflow-questions/)
* [LOAD JSON examples: StackOverflow](https://neo4j.com/labs/apoc/4.1/import/load-json/#load-json-examples-stackoverflow)
* [TagOverflow: correlating tags in StackOverflow](https://towardsdatascience.com/tagoverflow-correlating-tags-in-stackoverflow-66e2b0e1117b) — tag correlation as a graph problem
* [BuzzOverflow: a GraphQL/React app on StackOverflow data](https://neo4j.com/videos/building-the-buzzoverflow-com-graphql-react-app-based-on-stackoverflow-data/)
* [I analyzed every book ever mentioned on Stack Overflow](https://www.freecodecamp.org/news/i-analyzed-every-book-ever-mentioned-on-stack-overflow-here-are-the-most-popular-ones-eee0891f1786/)

## GitHub

[github.com/neo4j-graph-examples/github](https://github.com/neo4j-graph-examples/github) — load from the GraphQL API: a user, their interests (keyword/topic/organization search), repositories, languages, issues; or pull live from the GH events API; or ship a dump from the GH Archive.

Correlations worth querying: joint tags/topics/languages · teams and organizations · indirect collaboration (people who worked on different projects together) · joint commits/PRs/issues · follows. GH API: [Topic object](https://docs.github.com/en/graphql/reference/objects#topic).

* [Graphing GitHub](https://cambridge-intelligence.com/graphing-github/)
* [GitHub social network analysis](https://medium.com/@gokulkarthikk/github-social-network-analysis-28f72b2f5e3)
* [GitHub network science: a better project rating](https://blog.datasyndrome.com/github-network-science-creating-a-better-project-rating-595424f9f034)
* [Mining GitHub for social network analysis](https://medium.com/@a.elmajjodi/mining-github-for-social-network-analysis-nework-between-repository-committers-49840f72a7f6)
* jQAssistant on git repositories: [verifying branches](https://jqassistant.org/verifying-branches-using-the-git-plugin/), [shadows of the past](https://jqassistant.org/shadows-of-the-past-analysis-of-git-repositories/)

## Meetup

Meetup data is interesting by geography (my city/country), by interest/topic, and socially (where are my friends going). Load from the API, the RSVP streaming API, or prepared dumps by country/topic.

* [Neo4j meetup reporting](https://github.com/neo4j-contrib/neo4j-meetups-reporting)
* [Modeling worked example](https://github.com/neo4j-meetups/modeling-worked-example)
* Mark Needham's meetup analytics series: [cohort analysis of members](https://markhneedham.com/blog/2015/02/24/r-cohort-analysis-of-neo4j-meetup-members/), [a year in the life of the London meetup group](https://markhneedham.com/blog/2015/12/31/2015-a-year-in-the-life-of-the-neo4j-london-meetup-group/), [grouping members by join timestamp](https://markhneedham.com/blog/2014/06/30/neo4jr-grouping-meetup-members-by-join-timestamp/), [cohort heatmap](https://markhneedham.com/blog/2015/05/11/r-cohort-heatmap-of-neo4j-london-meetup/)
* [Meetup analytics with R and Neo4j](https://www.slideshare.net/neo4j/meetup-analytics-with-r-and-neo4j)
* [Inferred relationships with APOC triggers](https://markhneedham.com/blog/2018/11/05/neo4j-inferred-relationships-apoc-triggers/)

## Slack / Discord

Analyze a Slack workspace or Discord server you can export: channels, members, threads, reactions, mentions — who talks to whom, who answers whose questions.

* [The Neo4j Slack integration](https://neo4j.com/blog/the-neo4j-slack-integration-youve-been-waiting-for-is-here/)
* [How to create a knowledge graph from your Slack archive](https://medium.com/neo4j/how-to-create-a-knowledge-graph-from-your-slack-archive-with-neo4j-6a1a1d59a535)
* [Discovering hidden skills: an enterprise knowledge graph](https://neo4j.com/blog/discovering-hidden-skills-enterprise-knowledge-graph/)

For Discord: the user supplies their own server and pulls the (public) content from there.

## Twitch

* [Twitchverse: constructing a Twitch knowledge graph in Neo4j](https://towardsdatascience.com/twitchverse-constructing-a-twitch-knowledge-graph-in-neo4j-78f03276c1f7) — streamers, teams, games, languages, moderators, VIPs and chatters as one graph; great for Cypher queries, network analysis, node classification and link-prediction scenarios
* Twitch demo database: [demo.neo4jlabs.com](https://demo.neo4jlabs.com:7473/browser/?dbms=neo4j://twitch@demo.neo4jlabs.com&db=twitch)
* [Queries to get started](https://gist.github.com/tomasonjo/a02042fe0808bc757d13cba6cb851a2b)

## Reddit

* [Graphing r/investing and r/wallstreetbets](https://medium.com/geekculture/graphing-r-investing-and-r-wallstreetbets-c9f9f9276d69)
* [Eigenvector centrality on the subreddit hyperlink network](https://tbgraph.wordpress.com/2019/04/04/eigenvector-graph-centrality-analysis-on-subreddit-hyperlink-network-with-neo4j-and-cypher-projection/)
* [The meme graph](https://portal.graphgist.org/graph_gists/the-memegraph)

## YouTube

Via the YouTube API: videos, channels, subscriptions, comments. [YouTube graph gist](https://gist.github.com/jexp/a77399f610b6f42eb5e27e95403b4954) · [academic take](https://hal.inria.fr/hal-01217047/document)

## Others

Instagram (API), TikTok, CSDN, WeChat — same shape, wherever an API allows pulling a user's own social subgraph.

## Tooling

SEO tools like [Ahrefs](https://ahrefs.com/) also sit on a link graph — the same queries (neighborhoods, centralities, paths) apply.
