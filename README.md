# Kagi Bangs

This is an open-source, community maintained repository of [bangs](https://help.kagi.com/kagi/features/bangs.html) used by [Kagi Search](https://kagi.com).

You can submit changes to improve accuracy of existing bangs as well as create new bangs for use in Kagi Search.

Accepted changes are deployed to our website weekly.


## Contribution Guidelines

Kagi Staff and maintainers of this repo have final say, but a good bang submission should follow some basic guidelines.

- The website must be reasonably well-known and widely used.
  For example, popular commercial services and forums are OK.
  Low-traffic independent sites, such as startups, local businesses, or personal blogs, are not OK.

- The trigger must be specific to the website, not a generic term or word.
  For example, "amazon.com" can have "!amazon" but not "!groceries".

- Each trigger must be unique.
  You can test your trigger on Kagi to see if a bang already exists with that trigger.

- You can use the [Categories](#categories) list below to find the Category and Subcategory that fits best.
  If you cannot find one, it can be omitted, or we can consider adding a new one.

- If the bang you wish to add does not fit the above criteria, you can still create a custom bang on your own Kagi account for your own use!
  See our [documentation](https://help.kagi.com/kagi/features/bangs.html#custom-bangs) for details.

- Any modifications to bangs should be made to `/data/bangs.json`. `/data/kagi_bangs.json` provides bangs internal to Kagi itself (i.e., image search, search in a specific region)

### Region Bangs

Currently, not all 2-char ISO country codes for regions Kagi supports are mapped to region bangs.
Adding new region bangs will be handled on a case-by-case basis.

<details>
<summary>List of region codes with existing triggers</summary>

| Trigger | Current site                      | Category        | Region                                       |
| ------- | --------------------------------- | --------------- | -------------------------------------------- |
| ac      | Allociné                          | Entertainment   | Ascension Island                             |
| ad      | Ask Different                     | Entertainment   | Andorra                                      |
| ae      | aliexpress.com                    | Shopping        | United Arab Emirates                         |
| af      | Acronym Finder                    | Research        | Afghanistan                                  |
| ag      | Android Geeks                     | Tech            | Antigua and Barbuda                          |
| ai      | Kagi Assistant                    |                 | Anguilla                                     |
| al      | AniList                           | Entertainment   | Albania                                      |
| am      | Amazon.com                        | Shopping        | Armenia                                      |
| ao      | Amazon Orders                     | Shopping        | Angola                                       |
| as      | Kagi Assistant                    |                 | American Samoa                               |
| aw      | Arch Linux Wiki                   | Tech            | Aruba                                        |
| ax      | androidxref                       | Tech            | Åland Islands                                |
| az      | Amazon.com                        | Shopping        | Azerbaijan                                   |
| ba      | Beer Advocate                     | Entertainment   | Bosnia and Herzegovina                       |
| bb      | Bitbucket                         | Tech            | Barbados                                     |
| bd      | baidu                             | Online Services | Bangladesh                                   |
| bf      | BuzzFeed                          | Entertainment   | Burkina Faso                                 |
| bg      | BibleGateway                      | Online Services | Bulgaria                                     |
| bh      | B&H Photo Video                   | Shopping        | Bahrain                                      |
| bi      | Bing Images                       | Online Services | Burundi                                      |
| bl      | The British Library Catalogue     | Research        | Saint Barthélemy                             |
| bm      | bing maps                         | Online Services | Bermuda                                      |
| bn      | Barnes and Noble                  | Shopping        | Brunei                                       |
| bo      | Boerse Online                     | News            | Bolivia                                      |
| bq      | BloombergQuint                    | News            | Bonaire, Sint Eustatius and Saba             |
| bs      | Bing Shopping                     | Shopping        | Bahamas                                      |
| bt      | Microsoft/Bing Translator         | Online Services | Bhutan                                       |
| bv      | Bing Videos                       | Online Services | Bouvet Island                                |
| bw      | Bing Weather                      | News            | Botswana                                     |
| cc      | Openverse Creative Commons Search | Online Services | Cocos (Keeling) Islands                      |
| cd      | Collins Dictionary                | Research        | Congo, Democratic Republic of the            |
| cg      | CultureGraph                      | Research        | Congo                                        |
| ci      | CodeIgniter                       | Tech            | Côte d'Ivoire                                |
| ck      | Chefkoch.de                       | Research        | Cook Islands                                 |
| cl      | Craigslist                        | Shopping        | Chile                                        |
| cr      | codereview.stackexchange.com      | Tech            | Costa Rica                                   |
| cu      | CanIUse                           | Tech            | Cuba                                         |
| cv      | Cross Validated                   | Tech            | Cabo Verde                                   |
| cw      | CodeWars                          | Tech            | Curaçao                                      |
| dj      | Django documentation              | Tech            | Djibouti                                     |
| dm      | Daily Motion                      | Multimedia      | Dominica                                     |
| do      | DigitalOcean                      | Tech            | Dominican Republic                           |
| dz      | Deezer                            | Multimedia      | Algeria                                      |
| ec      | Ecosia                            | Online Services | Ecuador                                      |
| eg      | Kagi Search                       | Entertainment   | Egypt                                        |
| eh      | English Heritage                  | Entertainment   | Western Sahara                               |
| er      | Erowid                            | Research        | Eritrea                                      |
| et      | El Tiempo                         | News            | Ethiopia                                     |
| fi      | finanzen.net                      | Online Services | Finland                                      |
| fj      | Funnyjunk                         | Entertainment   | Fiji                                         |
| fk      | Flipkart                          | Shopping        | Falkland Islands                             |
| fm      | Filmaster                         | Multimedia      | Micronesia (Federated States of)             |
| fo      | File.org                          | Research        | Faroe Islands                                |
| ga      | Google Australia                  | Online Services | Gabon                                        |
| gd      | Google Docs                       | Online Services | Grenada                                      |
| ge      | Google Encrypted                  | Online Services | Georgia                                      |
| gf      | Google Finance                    | Online Services | French Guiana                                |
| gg      | Google Groups                     | Online Services | Guernsey                                     |
| gh      | GitHub                            | Tech            | Ghana                                        |
| gi      | Google Images                     | Online Services | Gibraltar                                    |
| gl      | OpenGL                            | Tech            | Greenland                                    |
| gm      | Google Maps                       | Online Services | Gambia                                       |
| gn      | Google News                       | News            | Guinea                                       |
| gp      | Google Play                       | Tech            | Guadeloupe                                   |
| gq      | GQ                                | News            | Equatorial Guinea                            |
| gr      | Goodreads                         | Multimedia      | Greece                                       |
| gs      | Google Shopping                   | Online Services | South Georgia and the South Sandwich Islands |
| gt      | Google Translate                  | Online Services | Guatemala                                    |
| gu      | Kagi Search                       | News            | Guam                                         |
| gw      | Gentoo Wiki                       | Tech            | Guinea-Bissau                                |
| gy      | Google                            | Online Services | Guyana                                       |
| hk      | HackTips                          | Tech            | Hong Kong                                    |
| hm      | HERE maps                         | Online Services | Heard Island and McDonald Islands            |
| hn      | Hacker News                       | Tech            | Honduras                                     |
| ht      | HookTube                          | Multimedia      | Haiti                                        |
| ie      | Kagi Search                       | Online Services | Ireland                                      |
| is      | Ilmainen Sanakirja                | Online Services | Iceland                                      |
| je      | Tanoshii Japanese                 | Research        | Jersey                                       |
| jm      | Joe Monster                       | Entertainment   | Jamaica                                      |
| jo      | Jotrin Electronics                | Shopping        | Jordan                                       |
| kg      | KG-Portal                         | Entertainment   | Kyrgyzstan                                   |
| kh      | Kubeapps Hub                      | Tech            | Cambodia                                     |
| ki      | Kagi Assistant (with Ki)          | Tech            | Kiribati                                     |
| km      | Karaoke Mugen                     | Multimedia      | Comoros                                      |
| kn      | Knoema                            | Research        | Saint Kitts and Nevis                        |
| kp      | Kupujemprodajem                   | Shopping        | North Korea                                  |
| la      | Langenscheidt                     | Research        | Laos                                         |
| lb      | letterboxd                        | Entertainment   | Lebanon                                      |
| lc      | Laracasts                         | Tech            | Saint Lucia                                  |
| li      | LinkedIn                          | Online Services | Liechtenstein                                |
| lk      | LolKing                           | Entertainment   | Sri Lanka                                    |
| ls      | LittleSis                         | Research        | Lesotho                                      |
| lt      | LibraryThing                      | Multimedia      | Lithuania                                    |
| lu      | Liberty University                | Research        | Luxembourg                                   |
| lv      | Livermore library                 | Research        | Latvia                                       |
| ma      | Memory Alpha                      | Entertainment   | Morocco                                      |
| mc      | Metacritic                        | Online Services | Monaco                                       |
| md      | Microsoft Docs                    | Tech            | Moldova                                      |
| me      | Mass Effect Wiki                  | Entertainment   | Montenegro                                   |
| mf      | Morguefile                        | Multimedia      | Saint Martin                                 |
| mh      | The Monster Hunter Wiki           | Entertainment   | Marshall Islands                             |
| mk      | Mechanical Keyboards              | Shopping        | North Macedonia                              |
| ml      | Google Maps Lite                  | Online Services | Mali                                         |
| mm      | Macmillan Dictionary              | Online Services | Myanmar                                      |
| mn      | medicinanet                       | Research        | Mongolia                                     |
| mo      | MathOverflow                      | Research        | Macao                                        |
| mp      | MenuPages                         | Research        | Northern Mariana Islands                     |
| mq      | MapQuest                          | Online Services | Martinique                                   |
| mr      | Mac Rumors                        | Tech            | Mauritania                                   |
| ms      | Microsoft                         | Tech            | Montserrat                                   |
| mt      | Multitran                         | Research        | Malta                                        |
| mu      | MacUpdate                         | Tech            | Mauritius                                    |
| mv      | Myvideo                           | Multimedia      | Maldives                                     |
| mw      | Merriam-Webster Dictionary        | Research        | Malawi                                       |
| mx      | MxToolbox                         | Tech            | Mexico                                       |
| mz      | Mittelbayerische Zeitung          | News            | Mozambique                                   |
| na      | NAVER                             | Online Services | Namibia                                      |
| nc      | Namecheap                         | Tech            | New Caledonia                                |
| ne      | Newegg                            | Shopping        | Niger                                        |
| nf      | Netflix                           | Entertainment   | Norfolk Island                               |
| ng      | AngularJS                         | Tech            | Nigeria                                      |
| ni      | National Instruments              | Tech            | Nicaragua                                    |
| np      | The Noun Project                  | Multimedia      | Nepal                                        |
| nr      | Nixpkgs Repository                | Tech            | Nauru                                        |
| nu      | nu.nl                             | News            | The Netherlands                              |
| pa      | Páginas Amarillas                 | Online Services | Panama                                       |
| pe      | Dicionário Porto Editora          | Research        | Peru                                         |
| pf      | PrintFriendly                     | Online Services | French Polynesia                             |
| pg      | Project Gutenberg                 | Multimedia      | Papua New Guinea                             |
| ph      | Product Hunt                      | Shopping        | Philippines                                  |
| pk      | Peekier                           | Research        | Pakistan                                     |
| pm      | pubmed                            | Research        | Saint Pierre and Miquelon                    |
| pn      | Amazon Prime NOW                  | Shopping        | Pitcairn                                     |
| pr      | PR Vademecum Argentina            | Research        | Puerto Rico                                  |
| ps      | Playstation                       | Shopping        | Palestine                                    |
| pw      | Pricewatch                        | Shopping        | Palau                                        |
| py      | Python                            | Tech            | Paraguay                                     |
| ro      | admin.ch                          | Research        | Romania                                      |
| ru      | RedUSERS                          | Tech            | Russia                                       |
| rw      | RationalWiki                      | Research        | Rwanda                                       |
| sa      | Scientific American               | News            | Saudi Arabia                                 |
| sb      | SwagBucks                         | Online Services | Solomon Islands                              |
| sc      | SoundCloud                        | Multimedia      | Seychelles                                   |
| sd      | SlickDeals                        | Shopping        | Sudan                                        |
| sg      | Sourcegraph                       | Tech            | Singapore                                    |
| sh      | Shodan                            | Tech            | Saint Helena, Ascension and Tristan da Cunha |
| sj      | sitejabber                        | Online Services | Svalbard and Jan Mayen                       |
| sk      | Songkick                          | Entertainment   | Slovakia                                     |
| sl      | Setlist.fm                        | Multimedia      | Sierra Leone                                 |
| sm      | Smashing Magazine                 | News            | San Marino                                   |
| sn      | SoylentNews                       | News            | Senegal                                      |
| so      | Stack Overflow                    | Tech            | Somalia                                      |
| sr      | reddit                            | Entertainment   | Suriname                                     |
| ss      | SurreySearch                      | Research        | South Sudan                                  |
| st      | stocktwits                        | News            | Sao Tome and Principe                        |
| sv      | Voat                              | Entertainment   | El Salvador                                  |
| sx      | Stack Exchange                    | Online Services | Sint Maarten                                 |
| sy      | Big Huge  Thesaurus               | Research        | Syria                                        |
| sz      | Süddeutsche Zeitung               | News            | Eswatini                                     |
| ta      | tripadvisor                       | Research        | Tristan da Cunha                             |
| tc      | Techcrunch                        | Tech            | Turks and Caicos Islands                     |
| td      | TimeAndDate                       | Online Services | Chad                                         |
| tf      | Tensor Flow                       | Tech            | French Southern Territories                  |
| tj      | Taco John's                       | Shopping        | Tajikistan                                   |
| tl      | Team Liquid                       | Entertainment   | Timor-Leste                                  |
| tm      | Trade Me                          | Shopping        | Turkmenistan                                 |
| tn      | Times Now                         | News            | Tunisia                                      |
| tr      | Google Translate                  | Translation     | Turkey                                       |
| tt      | Texas Tribune                     | News            | Trinidad and Tobago                          |
| tv      | tv.com                            | Entertainment   | Tuvalu                                       |
| tz      | timeanddate                       | News            | Tanzania                                     |
| ug      | Ultimate Guitar                   | Entertainment   | Uganda                                       |
| va      | Vim Awesome                       | Tech            | Vatican City                                 |
| vc      | VoucherCodes                      | Shopping        | Saint Vincent and the Grenadines             |
| ve      | VideoETA                          | Entertainment   | Venezuela                                    |
| vg      | Google                            | Online Services | British Virgin Islands                       |
| wf      | fr.wikipedia.org                  | Online Services | Wallis and Futuna                            |
| ws      | Wikisource                        | Multimedia      | Samoa                                        |
| yt      | YouTube                           | Multimedia      | Mayotte                                      |
| zw      | Zelda Wiki                        | Entertainment   | Zimbabwe                                     |

</details>

## Bang Format

```jsonc
{
  "s": "Metacritic",
  "d": "www.metacritic.com",
  "t": "mc",
  "u": "https://www.metacritic.com/search/{{{s}}}/",
  "c": "Online Services",
  "sc": "Search"
}
```

Key   | Description  | Required | Notes
------|--------------|----------|------
`s`   | Website name | yes      |
`d`   | Domain       | yes      |
`ad`  | Alternate Domain | no   | Can be used to specify the domain of the results if the bang searches another website. See `hn` bang.
`h`   | Homepage URL | no       | URL to redirect to when the bang is invoked with no query. If not specified, defaults to the domain root.
`t`   | Trigger      | yes      | May contain letters, numbers, dashes (`-`), periods (`.`), and underscores (`_`). No spaces or other special characters.
`ts`  | Additional triggers     | Additional triggers that invoke this bang
`u`   | URL template | yes      | Use `{{{s}}}` for query placeholder.
`x`   | Regex pattern | no      | Regex pattern that can be used for parsing the query for more complex bangs, allowing substition using `$1`, `$2`, etc.
`c`   | Category     | no       |
`sc`  | Subcategory  | no       |
`fmt` | Format flags | no       | Array of strings; See below.

### Format Flags

The `fmt` field exists to tweak the behavior of how the bang is executed.
For the majority of bangs, you do not need to specify this - we use defaults that work for 99.9% of bangs.
But, it can be useful depending on the behavior of the website.

The field is an array of strings that act as a list of flags:

Flag                       | Description
---------------------------|----------------------
`open_base_path`           | When the bang is invoked with no query, opens the base path of the URL (`/`) instead of any path given in the template (e.g., `/search`)
`url_encode_placeholder`   | URL encode the search terms. Some sites do not work with this, so it can be disabled by omitting this.
`url_encode_space_to_plus` | URL encodes spaces as `+`, instead of `%20`. Some sites only work correctly with one or the other.

By default, all of these are enabled.
If you specify `fmt`, you must exhaustively specify each options you would like enabled.

## Categories

This is a list of possible categories, with their corresponding subcategories.

#### Entertainment

<details>
<summary>Subcategories</summary>

  - Audio
  - Blogs
  - Blogs (intl)
  - Comics
  - Events
  - Forum
  - Games (Minecraft)
  - Games (Pokemon)
  - Games (WOW)
  - Games (general)
  - Games (offline)
  - Games (specific)
  - Misc
  - Movies
  - Music
  - Radio
  - Sports
  - TV

</details>

#### Man Page

<details>
<summary>Subcategories</summary>

  - Sysadmin

</details>

#### Multimedia

<details>
<summary>Subcategories</summary>

  - Books
  - Docs
  - Games (general)
  - General
  - Images
  - Movies
  - Music
  - Music (Folk)
  - Music (Lyrics)
  - Video

</details>

#### News

<details>
<summary>Subcategories</summary>

  - Aggregators
  - Broadcast
  - Business
  - International
  - Magazine
  - Magazine (car)
  - Magazine (fashion)
  - Newspaper
  - Newspaper (intl)
  - Online
  - Specialty
  - Weather

</details>

#### Online Services

<details>
<summary>Subcategories</summary>

  - AI Chatbots
  - Events
  - Google
  - Jobs
  - Maps
  - Search
  - Search (DDG)
  - Search (Private)
  - Search (Real-time)
  - Search (non-US)
  - Social
  - Social (intl)
  - Social news/links
  - Sysadmin
  - Tools
  - Tools (URLs)
  - Tools (fundraising)
  - Tracking

</details>

#### Region search

No corresponding subcategories.

#### Research

<details>
<summary>Subcategories</summary>

  - Academic
  - Academic (biology)
  - Academic (math/cs)
  - Food
  - Government
  - Health
  - Law
  - Learning
  - Learning (intl)
  - Local
  - Real Estate
  - Reference
  - Reference (fun)
  - Reference (religion)
  - Reference (science)
  - Reference (words intl)
  - Reference (words)
  - Topical
  - Travel

</details>

#### Shopping

<details>
<summary>Subcategories</summary>

  - Big box/department
  - Online
  - Online (deals)
  - Online (intl)
  - Online (marketplace)
  - Services
  - Tech
  - Tech (domains)

</details>

#### Tech

<details>
<summary>Subcategories</summary>

  - Blogs
  - Blogs (intl)
  - Chakra
  - Companies
  - Cryptocurrency
  - Design
  - Domains
  - Downloads
  - Downloads (add-ons)
  - Downloads (apps)
  - Downloads (code)
  - Downloads (software)
  - Language (perl)
  - Languages (.net)
  - Languages (Crystal)
  - Languages (Mathematica)
  - Languages (Matlab)
  - Languages (c++)
  - Languages (clojure)
  - Languages (cocoa)
  - Languages (coldfusion)
  - Languages (csharp)
  - Languages (d)
  - Languages (erlang)
  - Languages (go)
  - Languages (haskell)
  - Languages (html)
  - Languages (java)
  - Languages (javascript)
  - Languages (latex)
  - Languages (lisp)
  - Languages (lua)
  - Languages (other)
  - Languages (perl)
  - Languages (php)
  - Languages (python)
  - Languages (r)
  - Languages (racket)
  - Languages (ruby)
  - Languages (scala)
  - Languages (scheme)
  - Languages (vala)
  - Languages (nix)
  - Libraries/Frameworks
  - Libraries/Frameworks (KDE)
  - Libraries/Frameworks (wordpress)
  - Programming
  - Search (DDG)
  - Startups
  - Sysadmin
  - Sysadmin (Arch)
  - Sysadmin (Fedora)
  - Sysadmin (FreeBSD)
  - Sysadmin (Gentoo)
  - Sysadmin (RedHat)
  - Sysadmin (Ubuntu)
  - Sysadmin (debian)
  - Sysadmin (man)
  - Sysadmin (network)
  - Sysadmin (packages)
  - Tools
  - Tools (URLs)

</details>

#### Translation

<details>
<summary>Subcategories</summary>

  - General
  - Google

</details>

## Did you know?

As a Kagi user, you can make your own custom bangs right now in the [Custom Bangs settings page](https://help.kagi.com/kagi/features/bangs.html#custom-bangs) or the [Search Shortcuts menu](https://help.kagi.com/kagi/features/search-shortcuts.html).

These will be instantly available to you and will override any global bangs.

This repository is for adding new or fixing existing *global* bangs to Kagi.


## Credits

Kagi bangs are made possible by [DuckDuckGo](https://duckduckgo.com) which invented the concept in 2008.
