# Kagi Bangs

This is a repository of bangs used by [Kagi Search](https://kagi.com). It does not include unmodified DuckDuckGo bangs.

## Bang Format

```jsonc
[
  // ...
  {
    "s": "Metacritic",          // Website name
    "d": "www.metacritic.com",  // Domain
    "t": "mc",                  // Trigger
    "u": "https://www.metacritic.com/search/{{{s}}}/", // Template, `{{{s}}}` corresponds to the query
    "c": "Online Services",     // Category (optional)
    "sc": "Search",             // Subcategory (optional)
    "fmt": [                    // Format, enum flags
      "open_base_path",
      "url_encode_placeholder",
      "url_encode_space_to_plus"
    ]
  }
]
```

## Contribution Guidelines

Kagi Staff and maintainers of this repo have final say, but a good bang submission should follow some basic guidelines.

The website must be reasonably well-known and widely used.
For example, popular commerical services and forums are OK.
Low-traffic independent sites, such as startups, local businesses, or personal blogs, are not OK.

The trigger must be specific to the website, not a generic term or word.
For example, "amazon.com" can have "!amazon" but not "!groceries".

Each trigger must be unique.
You can test your trigger on Kagi to see if a bang already exists with that trigger.

You can use the Categories list below to find the Category and Subcategory that fits best.
If you cannot find one, it can be omitted, or we can consider adding a new one.

## Categories

This is a list of possible categories, with their corresponding subcategories.

- Entertainment:
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
- Man Page:
  - Sysadmin
- Multimedia:
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
- News:
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
- Online Services:
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
- Research:
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
- Shopping:
  - Big box/department
  - Online
  - Online (deals)
  - Online (intl)
  - Online (marketplace)
  - Services
  - Tech
  - Tech (domains)
- Tech:
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
- Translation:
  - General
  - Google
