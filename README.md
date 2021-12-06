# nytall

A simple one-function package that uses a timed loop and some field
simplification to collect all New York Times article search API data for
a given search term. Collects a max of 2,000 articles in each search
year at a rate of 75 articles/min. Warning: May take a significant
amount of time to collect large amount of articles.

## Installation

Currently, you can only install through github.

    devtools::install_github("toldham2/nytall")

*Dependents will be downloaded automatically: jsonlite (>= 1.7.2), plyr
(>= 1.8.6), stringr (>= 1.4.0)*

## Overview

First, create an account or sign in to the [The New York Times Developer
Network](https://developer.nytimes.com/), create a new app, and copy the
API key. You’ll need the key later.

    nyt_key <- "ENTER_YOUR_KEY_HERE"

### Get Data

After installing, library this package and run `get_articles`:

    library(nytall)

    df <- get_articles(term = "google", start = 1999, nyt_key = nyt_key, years = 1)

|  | response.docs.pub_date | response.docs.headline.main | response.docs.byline.original |
|-|:--|:--|:--|
| 1 | 1999-09-30T05:00:00+0000 | Searching For Less, Not More | By Peter H. Lewis |
| 2 | 1999-12-15T05:00:00+0000 | It's Charlie Brown's Last Christmas | By Rick Lyman |
| 3 | 1999-09-02T05:00:00+0000 | LIBRARY/POLITICAL RESOURCES; Democracy Finds Fertile Ground on Line | By Steven R. Knowlton |
| 4 | 1999-12-26T05:00:00+0000 | Carrying Tune Is Easy. Carrying Her Tuba is Hard. | By Margo Nash |
| 5 | 1999-11-21T05:00:00+0000 | The Way We Live Now: 11-21-99: Word & Image; Comehither.com | By Max Frankel |
| 6 | 1999-07-22T05:00:00+0000 | I Link, Therefore I Am: a Web Intellectual's Diary | By Katie Hafner |
| 7 | 1999-01-24T05:00:00+0000 | On the Road, Again | By Ann Douglas |

*Extra variables cut for presentation, see documentation for all 31 text variables*

You may also run `get_articles` without the `years` argument to get all years up to the present year:

    df <- get_articles(term = "biden", start = 2018, nyt_key = nyt_key)

### Clean and export

In order to export to a spreadsheet, run:

    df <- subset(df, select = -c(response.docs.multimedia, response.docs.keywords, response.docs.byline.person))

    write.csv(df, "path/to/file.csv")

## Documentation

- `term`: A string defining the search term. Use single apostrophes around
#' term for exact matches.
- `start`: A numeric year (YYYY) to start the search in.
- `nyt_key` A string defining your New York Times API key: https://developer.nytimes.com/
- `years`: (Optional) A numeric number of years to search after the start year. Default or NULL gets all data from start to current year.

[Click here for NYT's documentation of the output data
available.](https://developer.nytimes.com/docs/articlesearch-product/1/types/Article)

|  | status | copyright | response.docs.abstract | response.docs.web_url | response.docs.snippet | response.docs.lead_paragraph | response.docs.print_section | response.docs.print_page | response.docs.source | response.docs.pub_date | response.docs.document_type | response.docs.news_desk | response.docs.section_name | response.docs.type_of_material | response.docs._id | response.docs.word_count | response.docs.uri | response.docs.subsection_name | response.docs.headline.main | response.docs.headline.kicker | response.docs.headline.content_kicker | response.docs.headline.print_headline | response.docs.headline.name | response.docs.headline.seo | response.docs.headline.sub | response.docs.byline.original | response.docs.byline.organization | response.meta.hits | response.meta.offset | response.meta.time | keyword |
|---|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|:--|
| 1 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Peter H Lewis (State of the Art) column evaluates next generation of faster Web search engines, including Gurunet (www.gurunet.com), which he calls remarkable but still unfinished instant information utility, and Google (www.google.com), which he describes as very fast and which uses clever intuitive techniques to rank search results by relevancy (M) | https://www.nytimes.com/1999/09/30/technology/state-of-the-art-searching-for-less-not-more.html | Peter H Lewis (State of the Art) column evaluates next generation of faster Web search engines, including Gurunet (www.gurunet.com), which he calls remarkable but still unfinished instant information utility, and Google (www.google.com), which he ... | IMAGINE New York's Greenwich Village with millions of jumbled streets, add Tokyo's chaotic street numbering system, have it grow faster than Las Vegas, Nev., with a million new addresses a day, add all the languages of the United Nations, and make sure that every map is hopelessly outdated. That is today's World Wide Web. | G | 1 | The New York Times | 1999-09-30T05:00:00+0000 | article | Circuits | Technology | News | nyt://article/03280f81-2dad-5081-b5c0-67a281b1bedc | 1178 | nyt://article/03280f81-2dad-5081-b5c0-67a281b1bedc | NA | Searching For Less, Not More | STATE OF THE ART | NA | STATE OF THE ART; Searching For Less, Not More | NA | NA | NA | By Peter H. Lewis | NA | 7 | 0 | 13 | google |
| 2 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Charles Schulz, creator of Charlie Brown comic strips, will retire because of ill health and will stop producing strips immediately; final daily strip will run on January 4; is suffering from colon cancer and says he needs to devote himself to fighting illness; photo (M) | https://www.nytimes.com/1999/12/15/us/it-s-charlie-brown-s-last-christmas.html | Charles Schulz, creator of Charlie Brown comic strips, will retire because of ill health and will stop producing strips immediately; final daily strip will run on January 4; is suffering from colon cancer and says he needs to devote himself to fig... | You're on your own, Charlie Brown. | A | 18 | The New York Times | 1999-12-15T05:00:00+0000 | article | National Desk | U.S. | News | nyt://article/78aa22a3-1544-52b3-bb49-87393af645af | 730 | nyt://article/78aa22a3-1544-52b3-bb49-87393af645af | NA | It's Charlie Brown's Last Christmas | NA | NA | It's Charlie Brown's Last Christmas | NA | NA | NA | By Rick Lyman | NA | 7 | 0 | 13 | google |
| 3 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Finding Web sites with reliable political information is getting easier, because some groups are, in effect, beginning to catalogue worthwhile material; some sites appraised (M) | https://www.nytimes.com/1999/09/02/technology/librarypolitical-resources-democracy-finds-fertile-ground-on-line.html | Finding Web sites with reliable political information is getting easier, because some groups are, in effect, beginning to catalogue worthwhile material; some sites appraised (M) | RELIABLE INFORMATION | G | 10 | The New York Times | 1999-09-02T05:00:00+0000 | article | Circuits | Technology | News | nyt://article/4e8aec4b-637f-5e1f-a883-1c21fd43367f | 792 | nyt://article/4e8aec4b-637f-5e1f-a883-1c21fd43367f | NA | LIBRARY/POLITICAL RESOURCES; Democracy Finds Fertile Ground on Line | NA | NA | LIBRARY/POLITICAL RESOURCES; Democracy Finds Fertile Ground on Line | NA | NA | NA | By Steven R. Knowlton | NA | 7 | 0 | 13 | google |
| 4 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Article on Hackensack, NJ, tub | https://www.nytimes.com/1999/12/26/nyregion/music-carrying-tune-is-easy-carrying-her-tuba-is-hard.html | Article on Hackensack, NJ, tub | What's the hardest thing about playing the tuba? | NJ | 14 | The New York Times | 1999-12-26T05:00:00+0000 | article | New Jersey Weekly Desk | New York | News | nyt://article/c444c39e-40e4-539b-86b2-92ce6a9be187 | 810 | nyt://article/c444c39e-40e4-539b-86b2-92ce6a9be187 | NA | Carrying Tune Is Easy. Carrying Her Tuba is Hard. | MUSIC | NA | MUSIC; Carrying Tune Is Easy. Carrying Her Tuba is Hard. | NA | NA | NA | By Margo Nash | NA | 7 | 0 | 13 | google |
| 5 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Max Frankel article on advertising spending by E-commerce dot-com companies in traditional old media: television and newspapers; notes most of these dot-com companies still lose money on every sale, which means more successful their ads, greater their losses; says that even in primitive stages of Web commerce, struggle for name recognition has grown fierce, so much so that it seems that such firms want to be famous in old world media even before they are well defined in the new (M) | https://www.nytimes.com/1999/11/21/magazine/the-way-we-live-now-11-21-99-word-image-comehithercom.html | Max Frankel article on advertising spending by E-commerce dot-com companies in traditional old media: television and newspapers; notes most of these dot-com companies still lose money on every sale, which means more successful their ads, greater t... | So how come my television screen and newspapers are filling up with come-ons for dot-coms? Besides cars and telephones, the ads on ''Ally McBeal'' are pushing eToys.com and petstore.com and drugstore.com. Dot-coms flash on my screen between murders and disasters on the 11 o'clock news. Ads in The Times shout Yahoo and Excite and eBay and E*Trade and ask me to think AltaVista every time I dream of Michelangelo's ceiling. | 6 | 52 | The New York Times | 1999-11-21T05:00:00+0000 | article | Magazine Desk | Magazine | News | nyt://article/596bfa62-a327-59d9-8671-f4a4637ae9e6 | 966 | nyt://article/596bfa62-a327-59d9-8671-f4a4637ae9e6 | NA | The Way We Live Now: 11-21-99: Word & Image; Comehither.com | NA | NA | The Way We Live Now: 11-21-99: Word & Image; Comehither.com | NA | NA | NA | By Max Frankel | NA | 7 | 0 | 13 | google |
| 6 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Heather Anne Halpert, software designer, maintains diary of ephemera on Web; her stream-of-consciousness narrative is one of her site's most compelling aspects; she says she tries for balance between personal tidbits and purely intellectual ruminations; she does not track number of visitors to her site, but says she gets constant flow of E-mail from people around the world who want to tell her about their own daily encounters; photo (M) | https://www.nytimes.com/1999/07/22/technology/i-link-therefore-i-am-a-web-intellectual-s-diary.html | Heather Anne Halpert, software designer, maintains diary of ephemera on Web; her stream-of-consciousness narrative is one of her site's most compelling aspects; she says she tries for balance between personal tidbits and purely intellectual rumina... | ONCE in a great while a Web site appears, seemingly out of nowhere, and casts a spell. Such is the case with Lemonyellow.com, an on-line intellectual diary that makes the reader want to dig deeper and deeper. | G | 7 | The New York Times | 1999-07-22T05:00:00+0000 | article | Circuits | Technology | News | nyt://article/03d2f270-b8f3-581e-8488-f06492a9f936 | 981 | nyt://article/03d2f270-b8f3-581e-8488-f06492a9f936 | NA | I Link, Therefore I Am: a Web Intellectual's Diary | NA | NA | I Link, Therefore I Am: a Web Intellectual's Diary | NA | NA | NA | By Katie Hafner | NA | 7 | 0 | 13 | google |
| 7 | OK | Copyright (c) 2021 The New York Times Company. All Rights Reserved. | Ann Douglas reviews book Jack Kerouac, King of the Beats: A Portrait by Barry Miles (M) | https://www.nytimes.com/1999/01/24/books/on-the-road-again.html | Ann Douglas reviews book Jack Kerouac, King of the Beats: A Portrait by Barry Miles (M) | JACK KEROUAC, KING OF THE BEATSA Portrait.By Barry Miles.332 pp. New York:Henry Holt & Company. $25. | 7 | 21 | The New York Times | 1999-01-24T05:00:00+0000 | article | Book Review Desk | Books | Review | nyt://article/059bf497-57d2-537b-bf2d-39a8901ee2ea | 1443 | nyt://article/059bf497-57d2-537b-bf2d-39a8901ee2ea | Book Review | On the Road, Again | NA | NA | On the Road, Again | NA | NA | NA | By Ann Douglas | NA | 7 | 0 | 13 | google |

## Copyright

Articles and accompanying data belongs to the New York Times and subsidiary publications, noted in data. The package author is not responsible for any breaches of the [NYT API ToS](https://developer.nytimes.com/terms), the user is responsible for understanding the ToS agreement.
