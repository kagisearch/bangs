require "json"
require "rspec"
require "addressable"
require "uri"
require "cgi"

bangs_json = JSON.parse(File.read("data/bangs.json"))
bang_triggers = bangs_json.map { |b| [b["t"]] + (b["ts"] || []) }.flatten
bang_sites = bangs_json.map { |b| b["s"] }
bang_templates = bangs_json.map { |b| b["u"] + (b["ad"] ? "(ad: #{b["ad"]})" : "") }

kagi_bangs_json = JSON.parse(File.read("data/kagi_bangs.json"))
kagi_sites = kagi_bangs_json.map { |b| b["s"] }
kagi_triggers = kagi_bangs_json.map { |b| [b["t"]] + (b["ts"] || []) }.flatten
kagi_templates = kagi_bangs_json.map { |b| b["u"] + (b["ad"] ? "(ad: #{b["ad"]})" : "") }

assist_bangs_json = JSON.parse(File.read("data/assistant_bangs.json"))
assistant_sites = assist_bangs_json.map { |b| b["s"] }
assistant_triggers = assist_bangs_json.map { |b| [b["t"]] + (b["ts"] || []) }.flatten
assistant_templates = assist_bangs_json.map { |b| b["u"] + (b["ad"] ? "(ad: #{b["ad"]})" : "") }

def find_dups(*arr)
  arr.flatten
    .group_by { |element| element }
    .select { |k, v| v.size > 1 }
    .keys
end

def match_domains(bangs, check_ad = false)
  bangs.each do |bang|
    if bang["u"].start_with?("/")
      it "bangs on kagi.com should have correct domain (#{bang["s"]})" do
        expect(bang["d"]).to eq("kagi.com")
      end

      if check_ad
        it "bangs on kagi.com should have alternative domains (#{bang["s"]})" do
          expect(bang["ad"]).to_not be_nil
        end
      end
    else
      it "domains match template urls (#{bang["s"]})" do
        template = bang["u"].gsub("{{{s}}}", "example")
        uri = Addressable::URI.parse(template)
        domain = bang["d"].gsub("{{{s}}}", "example")

        expect(domain).to eq(uri.host)
      end
    end
  end
end

def uri_decoded_urls(bangs)
  bangs.each do |bang|
    next if bang["skip_tests"]

    # TODO(margret): enforce consistent URI-encoding, disabling for now.
    # See https://github.com/kagisearch/bangs/issues/204.
    #
    # it "template should not be uri encoded (#{bang["s"]})" do
    #   expect(CGI.unescapeURIComponent(bang["u"].gsub(/%20|%23/,"")).to_s).to eq(bang["u"].gsub(/%20|%23/,""))
    # end

    it "domain should not be uri encoded (#{bang["s"]})" do
      expect(CGI.unescapeURIComponent(bang["d"].gsub(/%20|%23/, "")).to_s).to eq(bang["d"].gsub(/%20|%23/, ""))
    end

    if bang["ad"]
      it "alt domain should not be uri encoded (#{bang["s"]})" do
        expect(CGI.unescapeURIComponent(bang["ad"].gsub(/%20|%23/, "")).to_s).to eq(bang["ad"].gsub(/%20|%23/, ""))
      end
    end
  end
end

def ad_format_check(bangs)
  bangs.each do |bang|
    next if bang["skip_tests"]
    next unless ad = bang["ad"]

    it "ad should be formatted correctly (#{bang["s"]})" do
      expect(ad.match?(/http(s)?(:|%3A)\/\//)).to be false
      expect(ad.match?(/.*,.*/)).to be false
      expect(ad.include?("%2F")).to be false
      expect(ad.include?("%20")).to be false
      expect(ad.include?(" ")).to be false
    end
  end
end

def template_format_check(bangs)
  bangs.each do |bang|
    next if bang["skip_tests"] || bang["x"]
    next unless template = bang["u"]

    it "template should contain correct {{{s}}} (#{bang["s"]})" do
      expect(template.include?("{{{s}}}")).to be true
    end

    it "template should only contain one {{{s}}} (#{bang["s"]})" do
      expect(template.scan(/(?={{{s}}})/).count).to eq(1)
    end
  end
end

def trigger_format_check(bangs)
  bangs.each do |bang|
    it "trigger should be lowercase (#{bang["s"]})" do
      expect(bang["t"]).to eq(bang["t"].downcase)
    end
  end
end

def regex_pattern_check(bangs)
  bangs.each do |bang|
    next if bang["skip_tests"]
    next unless regex_pattern = bang["x"]

    it "regex pattern should be valid regex (#{bang["s"]})" do
      Regexp.new(regex_pattern)
    end
  end
end

describe "bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(bang_triggers)

    expect(dups).to be_empty, "Duplicate triggers(s) found: #{dups.join(", ")}"
  end

  it "and kagi_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(bang_triggers, kagi_triggers)

    expect(dups).to be_empty, "Duplicate triggers(s) found: #{dups.join(", ")}"
  end

  it "and assist_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(bang_triggers, assistant_triggers)

    expect(dups).to be_empty, "Duplicate triggers(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang templates" do
    dups = find_dups(bang_templates)

    expect(dups).to be_empty, "Duplicate template(s) found: #{dups.join(", ")}"
  end

  it "and kagi_bangs.json don't have duplicate bang templates" do
    dups = find_dups(bang_templates, kagi_templates)

    expect(dups).to be_empty, "Duplicate template(s) found: #{dups.join(", ")}"
  end

  it "and assist_bangs.json don't have duplicate bang templates" do
    dups = find_dups(bang_templates, assistant_templates)

    expect(dups).to be_empty, "Duplicate template(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang sites" do
    dups = find_dups(bang_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  it "and kagi_bangs.json don't have duplicate bang sites" do
    dups = find_dups(bang_sites, kagi_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  it "and assist_bangs.json don't have duplicate bang sites" do
    dups = find_dups(bang_sites, assistant_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  bangs_json.each do |bang|
    if bang["u"].start_with?("/")
      it "Alternative domain required (#{bang["t"]})" do
        expect(bang["ad"]).to_not be_nil
      end
    end
  end

  match_domains(bangs_json, check_ad: true)
  uri_decoded_urls(bangs_json)
  ad_format_check(bangs_json)
  template_format_check(bangs_json)
  trigger_format_check(bangs_json)
  regex_pattern_check(bangs_json)
end

describe "kagi_bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(kagi_triggers)

    expect(dups).to be_empty, "Duplicate trigger(s) found: #{dups.join(", ")}"
  end

  it "and assistant_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(kagi_triggers, assistant_triggers)

    expect(dups).to be_empty, "Duplicate trigger(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang templates" do
    dups = find_dups(kagi_templates)

    expect(dups).to be_empty, "Duplicate templates(s) found: #{dups.join(", ")}"
  end

  it "and assistant_bangs.json don't have duplicate bang templates" do
    dups = find_dups(kagi_templates, assistant_templates)

    expect(dups).to be_empty, "Duplicate templates(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang sites" do
    dups = find_dups(kagi_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  it "and assist_bangs.json don't have duplicate bang sites" do
    dups = find_dups(kagi_sites, assistant_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  match_domains(kagi_bangs_json)
  uri_decoded_urls(kagi_bangs_json)
  ad_format_check(kagi_bangs_json)
  template_format_check(kagi_bangs_json)
  trigger_format_check(kagi_bangs_json)
  regex_pattern_check(kagi_bangs_json)
end

describe "assistant_bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(assistant_triggers)

    expect(dups).to be_empty, "Duplicate trigger(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang templates" do
    dups = find_dups(assistant_templates)
    expect(dups).to be_empty, "Duplicate templates(s) found: #{dups.join(", ")}"
  end

  it "doesn't have duplicate bang sites" do
    dups = find_dups(assistant_sites)
    expect(dups).to be_empty, "Duplicate sites(s) found: #{dups.join(", ")}"
  end

  match_domains(assist_bangs_json)
  uri_decoded_urls(assist_bangs_json)
  ad_format_check(assist_bangs_json)
  template_format_check(assist_bangs_json)
  trigger_format_check(assist_bangs_json)
  regex_pattern_check(assist_bangs_json)
end
