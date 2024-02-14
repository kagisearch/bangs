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
    "r": 590,                   // Rank
    "u": "https://www.metacritic.com/search/{{{s}}}/", // Template, `{{{s}}}` corresponds to the query
    "c": "Online Services",     // Category
    "sc": "Search",             // Subcategory
    "fmt": 3                    // Format, enum flags
                                // (1 - open base path, 2 - url encode placeholder, 4 - url encode space to plus)
  }
]
```

## Contribution Guidelines

New bangs are accepted if:
- The trigger is not a proper word (except for brands/trademarks, i.e. "amazon")
