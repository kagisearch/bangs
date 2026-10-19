require "rspec"
require "tmpdir"
require_relative "../scripts/bang_changes"

describe BangChanges do
  def bang(trigger = "example", aliases = [], url = "https://example.com/?q={{{s}}}")
    {"t" => trigger, "ts" => aliases, "u" => url}
  end

  it "lists new bangs with all their newly available aliases" do
    summary = described_class.markdown([], [bang("example", ["ex", "eg"])])

    expect(summary).to include("### Added Bangs", "` example `", "aliases: ` ex `, ` eg `")
    expect(summary).not_to include("### Added Triggers")
  end

  it "lists removed bangs with all their removed aliases" do
    summary = described_class.markdown([bang("example", ["ex"])], [])

    expect(summary).to include("### Removed Bangs", "aliases: ` ex `")
    expect(summary).not_to include("### Removed Triggers")
  end

  it "lists aliases added to and removed from an existing bang" do
    summary = described_class.markdown([bang("example", ["old"])], [bang("example", ["new"])])

    expect(summary).to include("### Added Triggers", "` new `", "### Removed Triggers", "` old `")
    expect(summary).not_to include("### Added Bangs", "### Removed Bangs")
  end

  it "groups URL changes for a primary trigger and its aliases" do
    summary = described_class.markdown([bang("example", ["ex"])], [bang("example", ["ex"], "https://new.example/")])

    expect(summary).to include("### Modified Bangs", "` ex `, ` example `", "https://new.example/")
    expect(summary.scan("  - **URL**").length).to eq(1)
  end

  it "renders each changed field with separate before and after lines" do
    old = bang("pmck", [], "https://www.planetminecraft.com/resources/skins/?keywords={{{s}}}").merge("d" => "www.planetminecraft.com")
    current = old.merge("u" => old["u"].sub(".com", ".con"), "d" => "www.planetminecraft.con")

    expect(described_class.markdown([old], [current])).to eq(<<~MARKDOWN.chomp)
      ### Modified Bangs
      - **` pmck `**
        - **URL**
          - Before: ` https://www.planetminecraft.com/resources/skins/?keywords={{{s}}} `
          - After: ` https://www.planetminecraft.con/resources/skins/?keywords={{{s}}} `
        - **Domain**
          - Before: ` www.planetminecraft.com `
          - After: ` www.planetminecraft.con `
    MARKDOWN
  end

  it "ignores ordering and metadata-only changes" do
    old = [bang("example", ["ex", "eg"]), bang("other")]
    current = [bang("other"), bang("example", ["eg", "ex"]).merge("s" => "New name")]

    expect(described_class.markdown(old, current)).to eq("No changes detected.")
  end

  it "does not report a promoted alias as an addition or removal" do
    expect(described_class.markdown([bang("example", ["ex"])], [bang("ex", ["example"])])).to eq("No changes detected.")
  end

  it "does not report deduplicated bangs as removed when their triggers survive" do
    old = [bang("example"), bang("ex")]
    current = [bang("example", ["ex"])]

    expect(described_class.markdown(old, current)).to eq("No changes detected.")
  end

  it "reports aliases reassigned to a different URL as modified, not added or removed" do
    old = [bang("example", ["ex"]), bang("other", [], "https://other.example/")]
    current = [bang("example"), bang("other", ["ex"], "https://other.example/")]
    summary = described_class.markdown(old, current)

    expect(summary).to include("### Modified Bangs", "` ex `")
    expect(summary).not_to include("### Added", "### Removed")
  end

  it "reports URL changes even if the primary trigger changes" do
    summary = described_class.markdown([bang("example", ["ex"])], [bang("ex", ["example"], "https://new.example/")])

    expect(summary).to include("### Modified Bangs", "https://new.example/")
  end

  it "reports a newly named primary as an added trigger when an existing alias survives" do
    summary = described_class.markdown([bang("example", ["ex"])], [bang("new", ["example", "ex"])])

    expect(summary).to include("### Added Triggers", "` new `", "primary trigger for")
    expect(summary).not_to include("### Added Bangs", "alias for **` new `**")
  end

  it "reports a removed primary as a removed trigger when an alias survives" do
    summary = described_class.markdown([bang("example", ["ex"])], [bang("ex")])

    expect(summary).to include("### Removed Triggers", "` example `", "was primary trigger for")
    expect(summary).not_to include("### Removed Bangs")
  end

  it "reports regex additions, edits and removals" do
    [
      [bang, bang.merge("x" => "(.*)")],
      [bang.merge("x" => "(.*)"), bang.merge("x" => "(.+)")],
      [bang.merge("x" => "(.*)"), bang]
    ].each do |old, current|
      expect(described_class.markdown([old], [current])).to include("  - **Regex pattern**")
    end
  end

  it "reports format-flag changes including an explicitly empty list" do
    summary = described_class.markdown([bang], [bang.merge("fmt" => [])])

    expect(summary).to include("  - **Format flags**", "` [] `")
  end

  it "compares omitted format flags using the documented defaults" do
    expect(described_class.markdown([bang], [bang.merge("fmt" => described_class::DEFAULT_FORMAT.reverse)])).to eq("No changes detected.")
  end

  it "ignores format-flag ordering" do
    old = bang.merge("fmt" => %w[open_base_path url_encode_placeholder])
    current = bang.merge("fmt" => %w[url_encode_placeholder open_base_path])

    expect(described_class.markdown([old], [current])).to eq("No changes detected.")
  end

  it "reports domain and snap-domain changes" do
    old = bang.merge("d" => "example.com", "ad" => "snap.example.com")
    current = bang.merge("d" => "other.example.com")

    expect(described_class.markdown([old], [current])).to include("  - **Domain**", "  - **Snap domain**", "(not set)")
  end

  it "groups aliases only when all their behavioral changes match" do
    old = [bang("example", ["ex"])]
    current = [bang("example").merge("x" => "(.*)"), bang("ex").merge("fmt" => [])]
    summary = described_class.markdown(old, current)

    expect(summary).to include("**` example `**\n  - **Regex pattern**", "**` ex `**\n  - **Format flags**")
    expect(summary.lines.grep(/^- /).length).to eq(2)
  end

  it "ignores descriptive metadata and test controls" do
    current = bang.merge("s" => "New name", "c" => "Tech", "sc" => "Tools", "skip_tests" => true)

    expect(described_class.markdown([bang], [current])).to eq("No changes detected.")
  end

  it "ignores moves between data files when the effective behavior is unchanged" do
    allow(described_class).to receive(:read_at).with("base", "data/bangs.json").and_return([bang])
    allow(described_class).to receive(:read_at).with("base", "data/kagi_bangs.json").and_return([])
    allow(described_class).to receive(:read_at).with("head", "data/bangs.json").and_return([])
    allow(described_class).to receive(:read_at).with("head", "data/kagi_bangs.json").and_return([bang])

    expect(described_class.report("base", "head").scan("No changes detected.").length).to eq(2)
  end

  it "reports behavior changes during a move only under the destination file" do
    allow(described_class).to receive(:read_at).with("base", "data/bangs.json").and_return([bang])
    allow(described_class).to receive(:read_at).with("base", "data/kagi_bangs.json").and_return([])
    allow(described_class).to receive(:read_at).with("head", "data/bangs.json").and_return([])
    allow(described_class).to receive(:read_at).with("head", "data/kagi_bangs.json").and_return([bang.merge("x" => "(.*)")])
    summary = described_class.report("base", "head")

    expect(summary).to include("## Bangs\n\nNo changes detected.", "## Kagi Bangs\n\n### Modified Bangs")
    expect(summary.scan("  - **Regex pattern**").length).to eq(1)
    expect(summary).not_to include("### Added", "### Removed")
  end

  it "rejects duplicate primary triggers and aliases instead of overwriting entries" do
    [[bang, bang], [bang("example", ["example"])], [bang("example", ["ex"]), bang("ex")]].each do |data|
      expect { described_class.markdown([], data) }.to raise_error(described_class::InvalidData, /Duplicate trigger/)
    end
  end

  it "rejects duplicate triggers across data files" do
    allow(described_class).to receive(:read_at).and_return([bang])

    expect { described_class.report("base", "head") }.to raise_error(described_class::InvalidData, /Duplicate trigger/)
  end

  it "rejects malformed data with an explicit validation error" do
    [{}, [nil], [{"t" => "example"}], [bang.merge("ts" => "ex")], [bang.merge("fmt" => nil)], [bang.merge("x" => 3)]].each do |data|
      expect { described_class.markdown([], data) }.to raise_error(described_class::InvalidData)
    end
  end

  # Regression cases from published July–October 2026 changelogs.
  it "reports the August 10 rymf alias split as a URL change, not a removal" do
    old = [bang("rym", ["rymf"], "https://rateyourmusic.com/search?searchterm={{{s}}}")]
    current = [
      bang("rym", [], "https://rateyourmusic.com/search?searchterm={{{s}}}"),
      bang("rymf", ["rymfilms", "rateyourfilms"], "https://rateyourmusic.com/search?searchtype=F&searchterm={{{s}}}")
    ]
    summary = described_class.markdown(old, current)

    expect(summary).to include("### Added Triggers", "` rymfilms `", "` rateyourfilms `", "**` rymf `**\n  - **URL**")
    expect(summary).not_to include("### Removed", "### Added Bangs")
  end

  it "reports the October 5 navm consolidation as a URL change, not an addition" do
    old = [
      bang("navm", [], "https://map.naver.com/p/search/{{{s}}}"),
      bang("nmap", [], "https://map.naver.com/?query={{{s}}}")
    ]
    current = [bang("nmap", ["navm"], "https://map.naver.com/?query={{{s}}}")]
    summary = described_class.markdown(old, current)

    expect(summary).to include("**` navm `**\n  - **URL**")
    expect(summary).not_to include("### Added", "### Removed")
  end

  it "reports the August 31 forum reassignment across files without a false removal" do
    old = bang("dc", ["forum"], "https://duck.co/forum/search?q={{{s}}}").merge("d" => "duck.co")
    surviving = old.merge("ts" => [])
    current = bang("forums", ["forum"], "/search?q={{{s}}}&lens=forums").merge(
      "d" => "kagi.com", "fmt" => %w[url_encode_placeholder url_encode_space_to_plus]
    )
    allow(described_class).to receive(:read_at).with("base", "data/bangs.json").and_return([old])
    allow(described_class).to receive(:read_at).with("base", "data/kagi_bangs.json").and_return([])
    allow(described_class).to receive(:read_at).with("head", "data/bangs.json").and_return([surviving])
    allow(described_class).to receive(:read_at).with("head", "data/kagi_bangs.json").and_return([current])
    summary = described_class.report("base", "head")

    expect(summary).to include("### Added Triggers", "` forums `", "**` forum `**\n  - **URL**", "  - **Format flags**", "  - **Domain**")
    expect(summary).not_to include("### Removed", "### Added Bangs")
  end

  it "reports the October 5 snap-domain additions even without URL changes" do
    old = bang("brave", [], "https://search.brave.com/search?q={{{s}}}").merge("d" => "search.brave.com")
    current = old.merge("ad" => "brave.com")
    summary = described_class.markdown([old], [current])

    expect(summary).to include("### Modified Bangs", "  - **Snap domain**\n    - Before: (not set)\n    - After: ` brave.com `")
    expect(summary).not_to include("  - **URL**")
  end

  it "keeps contributor-controlled HTML, Markdown and mentions inside code spans" do
    summary = described_class.markdown([], [bang("<script>@someone</script>", [], "https://example.com/`[link](url)<img>")])

    expect(summary).to include("` <script>@someone</script> `", "`` https://example.com/`[link](url)<img> ``")
  end

  it "handles multiple backticks and newlines without breaking out of a code span" do
    expect(described_class.code("before```\n# heading")).to eq("```` before``` # heading ````")
  end

  it "reads git snapshots without changing the working file" do
    Dir.mktmpdir("bang-changes") do |directory|
      Dir.chdir(directory) do
        system("git", "init", "-q", exception: true)
        File.write("bangs.json", JSON.generate([bang]))
        system("git", "add", "bangs.json", exception: true)
        system("git", "-c", "user.name=Test", "-c", "user.email=test@example.com", "commit", "-qm", "Initial data", exception: true)
        File.write("bangs.json", "uncommitted work")

        expect(described_class.read_at("HEAD", "bangs.json")).to eq([bang])
        expect(File.read("bangs.json")).to eq("uncommitted work")
      end
    end
  end

  it "fails explicitly when a git snapshot cannot be read" do
    expect { described_class.read_at("HEAD", "data/nonexistent.json") }.to raise_error(/Cannot read/)
  end
end
