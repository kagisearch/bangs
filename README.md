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

When adding a new bang:
- The website must be reasonably well-known and widely used
- The trigger must be specific to the website, not a generic term or word
  (i.e., "amazon.com" can have "!amazon" but not "!groceries")
- Each trigger must be unique
- Category / subcategory are optional

## Categories

This is a list of possible categories, with their corresponding subcategories. New subcategories can be added as-needed.

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
