require "json"
require "rspec"
require "addressable"

bangs_json = JSON.parse(File.read("data/bangs.json"))
bang_triggers = bangs_json.map{|b| b["t"]}

kagi_bangs_json = JSON.parse(File.read("data/kagi_bangs.json"))
kagi_triggers = kagi_bangs_json.map{|b| b["t"]}

assist_bangs_json = JSON.parse(File.read("data/assistant_bangs.json"))
assistant_triggers = assist_bangs_json.map{|b| b["t"]}

def find_dups(*arr)
  arr.map{ |a| a.uniq }
    .flatten
    .group_by { |element| element }
    .select { |k, v| v.size > 1 }
    .keys
end

def match_domains(bangs)
  bangs.each do |bang|
    next if bang["u"].start_with?("/")

    it "domains match template urls (#{bang["s"]})" do
      template = bang["u"].gsub("{{{s}}}", "example").gsub("www.", "")
      uri = Addressable::URI.parse(template)
      domain = bang["d"].gsub("{{{s}}}", "example").gsub("www.", "")

      expect(domain).to eq(uri.host)
    end
  end
end

describe "bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(bang_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  it "and kagi_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(bang_triggers, kagi_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  it "and assist_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(bang_triggers, assistant_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  match_domains(bangs_json)
end

describe "kagi_bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(kagi_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  it "and assistant_bangs.json don't have duplicate bang triggers" do
    dups = find_dups(kagi_triggers, assistant_triggers)

    expect(dups).to be_empty, "Duplicate trigger(s) found: #{dups.join(", ")}"
  end

  match_domains(kagi_bangs_json)
end

describe "assistant_bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(assistant_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  match_domains(assist_bangs_json)
end
