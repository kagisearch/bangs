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
    "c": "Online Services",     // Category
    "sc": "Search",             // Subcategory
    "fmt": [                    // Format, enum flags
      "open_base_path",
      "url_encode_placeholder",
      "url_encode_space_to_plus"
    ]
  }
]
```

## Contribution Guidelines

New bangs are accepted if:
- The trigger is not a proper word (except for brands/trademarks, i.e. "amazon")
