# Website Name (`s` field) Specification

This document defines the naming convention for the `s` (Website Name) field in bang definitions.

## Core Principles

1. **Preserve official brand styling**: Keep the site's own capitalization and spelling where known, such as `eBay`, `iFixit`, `npm`, `dev.to`, `WordReference`, or names in native script
2. **Use Title Case for generic qualifiers**: Capitalize descriptive qualifiers inside parentheses, such as `History`, `Creative Commons`, `Past Day`, or `Orders`
3. **Site name first**: Never lead with qualifier, filter, or feature
4. **Parentheses for variants**: Use `()` consistently for qualifiers, variants, scopes, and filters; do not use dashes or bare suffixes
5. **No redundant "Search"**: Omit "Search" from names unless it is part of the official product name
6. **Prefer user-facing meaning**: Name the bang for what users understand it does, not for raw URL parameters or implementation details

## Format Patterns

| Category | Format | Examples |
|----------|--------|----------|
| **Default** | `Site Name` | `"GitHub"`, `"YouTube"`, `"Amazon"` |
| **Feature/Section** | `Site Name (Feature)` | `"GitHub (Stars)"`, `"GitHub (Notifications)"`, `"YouTube (History)"` |
| **Content Filter** | `Site Name (Filter)` | `"YouTube (Creative Commons)"`, `"YouTube (Past Day)"`, `"YouTube (Long)"` |
| **Item Type** | `Site Name (Type)` | `"YouTube (Video)"`, `"GitHub (Repo)"`, `"Amazon (ASIN)"` |
| **User/Profile** | `Site Name (User)` | `"Reddit (User)"`, `"GitHub (User)"` |
| **Scoped Entity** | `Site Name (Entity)` | `"YouTube (Game Grumps)"`, `"GitHub (NixOS/nixpkgs)"` |
| **Sub-site Community** | `Site Name (/r/name)` | `"Reddit (/r/AskReddit)"`, `"Reddit (/r/ProgrammerHumor)"` |
| **Market/Region Variant** | `Site Name (Region)` | `"Amazon (UK)"`, `"eBay (Germany)"` |
| **Translation Pair** | `Site Name (xx-yy)` | `"Google Translate (de-en)"`, `"DeepL (en-fr)"`, `"DeepL (pt-en)"` |
| **Auto-Detect Translation** | `Site Name (auto-yy)` | `"Google Translate (auto-en)"`, `"DeepL (auto-de)"` |
| **Kagi-Routed** | `Site Name (Kagi)` | `"4chan (Kagi)"`, `"Ada 2005 Manual (Kagi)"` |

## Language and Region Rules

- **Translation codes**: Use lowercase language codes in source-target form: `xx-yy`
- **Auto-detect source**: Use `auto-yy` for automatic source language detection
- **Script or regional language variants**: Keep the canonical code when needed, such as `zh-CN` or `pt-BR`
- **Normalize legacy codes**: Prefer modern standard codes in names, such as `he` instead of `iw`
- **Do not spell out language names**: Use `de-en`, not `German to English`
- **Region or market variants**: Use a stable, human-readable region label such as `US`, `UK`, `Germany`, or `Japan`; do not mix region codes and country names within the same site family

## Variant Model

Use this simple model whenever possible:

- Base bang: `Site`
- Variant bang: `Site (Qualifier)`
- Scoped entity bang: `Site (Entity)` or `Site (/r/Entity)` when the slash form is meaningful to users

Prefer a single qualifier over stacked qualifiers. If multiple qualifiers could apply, create separate bangs instead of combining them.

If combining is truly necessary, order qualifiers as follows:

1. Scope or entity
2. Feature or section
3. Filter or type
4. Region or locale

## Common Mistakes to Avoid

| Don't | Do Instead |
|-------|------------|
| `"YouTube - long"` | `"YouTube (Long)"` |
| `"Google Translate da-en"` | `"Google Translate (da-en)"` |
| `"Translate English to Danish"` | `"Google Translate (en-da)"` |
| `"deepl.com"` | `"DeepL (fr-en)"` |
| `"reddit.com/r/GlobalOffensive"` | `"Reddit (/r/GlobalOffensive)"` |
| `"GitHub Code Search"` | `"GitHub (Code)"` |
| `"Amazon.com order history"` | `"Amazon (Orders)"` |
| `"101 Domain"` and `"101domain"` | Pick one: `"101 Domain"` |
| `"/r/AskReddit"` | `"Reddit (/r/AskReddit)"` |
| `"r/ADHD"` | `"Reddit (/r/ADHD)"` |
| `"GitHub User"` | `"GitHub (User)"` |
| `"YouTube Video"` | `"YouTube (Video)"` |
| `"Google Translate (de2fr)"` | `"Google Translate (de-fr)"` |
| `"Google Translate (to Arabic)"` | `"Google Translate (auto-ar)"` |

## Examples by Site

### GitHub
```json
{ "s": "GitHub" }
{ "s": "GitHub (Code)" }
{ "s": "GitHub (Stars)" }
{ "s": "GitHub (Notifications)" }
{ "s": "GitHub (Trending)" }
{ "s": "GitHub (Topic)" }
{ "s": "GitHub (User)" }
{ "s": "GitHub (Repo)" }
{ "s": "GitHub (Private)" }
{ "s": "GitHub (JavaScript)" }
{ "s": "GitHub (NixOS/nixpkgs)" }
```

### YouTube
```json
{ "s": "YouTube" }
{ "s": "YouTube (Video)" }
{ "s": "YouTube (Playlists)" }
{ "s": "YouTube (Creative Commons)" }
{ "s": "YouTube (Past Day)" }
{ "s": "YouTube (Long)" }
{ "s": "YouTube (DE)" }
{ "s": "YouTube (US)" }
{ "s": "YouTube (Channel)" }
{ "s": "YouTube (History)" }
{ "s": "YouTube (Game Grumps)" }
```

### Reddit
```json
{ "s": "Reddit" }
{ "s": "Reddit (User)" }
{ "s": "Reddit (/r/AskReddit)" }
{ "s": "Reddit (/r/ProgrammerHumor)" }
{ "s": "Reddit (/r/GlobalOffensive)" }
{ "s": "Reddit (Subreddits)" }
```

### Translation Services
```json
{ "s": "Google Translate (de-en)" }
{ "s": "Google Translate (en-ja)" }
{ "s": "Google Translate (fr-en)" }
{ "s": "Google Translate (auto-ar)" }
{ "s": "Google Translate (zh-CN-en)" }
{ "s": "DeepL (en-de)" }
{ "s": "DeepL (en-fr)" }
{ "s": "DeepL (pt-en)" }
```

### Amazon
```json
{ "s": "Amazon" }
{ "s": "Amazon (ASIN)" }
{ "s": "Amazon (Books)" }
{ "s": "Amazon (Kindle)" }
{ "s": "Amazon (Prime Video)" }
{ "s": "Amazon (Orders)" }
{ "s": "Amazon (Fresh)" }
{ "s": "Amazon (Automotive)" }
```
