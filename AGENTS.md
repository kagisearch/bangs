# AGENTS.md

Coding agent guidelines for the Kagi Bangs repository.

## Project Overview

This repository contains bang definitions for [Kagi Search](https://kagi.com). Bangs are search shortcuts (e.g., `!gh` for GitHub) that redirect queries to specific websites.

- **Primary data files**: `data/bangs.json` (community bangs), `data/kagi_bangs.json` (internal Kagi bangs)
- **Schema**: `data/bangs.schema.json`
- **Language**: Ruby for scripts/tests, JSON for data

## Build/Test Commands

```bash
# Install dependencies
make install
# or: bundle install

# Run all tests
make test
# or: bundle exec rspec

# Run specific test by line number
bundle exec rspec spec/bangs_spec.rb:127

# Run specific test by description pattern
bundle exec rspec -e "doesn't have duplicate bang triggers"

# Health check all bang URLs (slow)
ruby scripts/health_check.rb

# Other utilities
ruby scripts/generate_alt_domains.rb
ruby scripts/taken_region_codes.rb
ruby scripts/deduplicate_bangs.rb
```

## Code Style

### General (EditorConfig)

- **Charset**: UTF-8
- **Line endings**: LF (`\n`)
- **Indent**: 2 spaces (no tabs)
- **Final newline**: Required
- **Trim trailing whitespace**: Yes

### Ruby Style

```ruby
# Require statements at top
require "json"
require "rspec"

# Double quotes for strings
bangs_json = JSON.parse(File.read("data/bangs.json"))

# Method definitions with snake_case
def find_dups(*arr)
  arr.flatten
    .group_by { |element| element }
    .select { |k, v| v.size > 1 }
    .keys
end

# Guard clauses for early returns
return if bang["u"].start_with?("/")

# Conditional assignment
bang["ts"] ||= []

# String interpolation
puts "#{bang["s"]} (#{bang["t"]})"

# Exception handling
rescue => e
  mutex.synchronize { errored << [bang, e] }
```

### JSON Bang Object Style

Key order: `s`, `d`, `ad`, `t`, `ts`, `u`, `x`, `c`, `sc`, `skip_tests`, `fmt`

Website names in `s` must follow `WEBSITE_NAMING_SPEC.md`. In short: preserve official brand styling for the base site name, and use `Site Name (Qualifier)` for variants such as filters, sections, scoped entities, users, region variants, and translation pairs.

```json
{
  "s": "Site Name",
  "d": "example.com",
  "ad": "alt-domain.com",
  "t": "trigger",
  "ts": ["alias1", "alias2"],
  "u": "https://example.com/search?q={{{s}}}",
  "x": "^pattern$",
  "c": "Category",
  "sc": "Subcategory",
  "skip_tests": false,
  "fmt": ["url_encode_placeholder"]
}
```

#### Required Fields

| Key | Description |
|-----|-------------|
| `s` | Website name (display name, following `WEBSITE_NAMING_SPEC.md`) |
| `d` | Domain (must match URL host) |
| `t` | Trigger (lowercase, letters/numbers/dashes/periods/underscores only) |
| `u` | URL template with `{{{s}}}` placeholder |

#### Optional Fields

| Key | Description |
|-----|-------------|
| `ad` | Alternative/snap domain |
| `ts` | Array of additional trigger aliases |
| `x` | Regex pattern for complex query parsing |
| `c` | Category (see README for valid values) |
| `sc` | Subcategory |
| `skip_tests` | Boolean to skip spec tests |
| `fmt` | Array of format flags (exhaustive): `open_base_path`, `open_snap_domain`, `url_encode_placeholder`, `url_encode_space_to_plus` |

### RSpec Test Patterns

```ruby
describe "bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(bang_triggers)
    expect(dups).to be_empty, "Duplicate triggers(s) found: #{dups.join(", ")}"
  end

  bangs_json.each do |bang|
    it "trigger should be lowercase (#{bang["s"]})" do
      expect(bang["t"]).to eq(bang["t"].downcase)
    end
  end
end
```

## Data Validation Rules

Tests enforce (see `spec/bangs_spec.rb`):

- No duplicate triggers across `bangs.json` and `kagi_bangs.json`
- No duplicate templates or sites
- Triggers must be lowercase
- Templates must contain exactly one `{{{s}}}` placeholder
- Templates must be HTTPS URLs or paths starting with `/`
- Domains must match the URL template host
- Domains must not be URI-encoded
- Alternative domains (`ad`) must not contain protocol, commas, or spaces
- Regex patterns (`x`) must be valid regex
- Bangs with path-only URLs (`/search`) must have an `ad` field and `d: "kagi.com"`

## File Structure

```
bangs/
├── data/
│   ├── bangs.json          # Community bangs (edit this)
│   ├── kagi_bangs.json     # Internal Kagi bangs
│   └── bangs.schema.json   # JSON Schema
├── spec/
│   └── bangs_spec.rb       # RSpec tests
├── scripts/                # Utility scripts
├── Gemfile                 # Ruby dependencies
├── Makefile                # Build commands
└── .editorconfig           # Formatting rules
```

## Common Tasks

### Adding a New Bang

1. Add entry to `data/bangs.json` (alphabetical by trigger)
2. Set `s` according to `WEBSITE_NAMING_SPEC.md`
3. Run `bundle exec rspec` to validate
4. Verify the URL works with a test query

### Adding Additional Triggers

Add to the `ts` array instead of creating duplicate entries:

```json
{
  "s": "GitHub",
  "d": "github.com",
  "t": "gh",
  "ts": ["github", "git"],
  "u": "https://github.com/search?q={{{s}}}"
}
```
