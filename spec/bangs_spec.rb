require "json"
require "rspec"
require "addressable"
require "uri"
require "cgi"

bangs_json = JSON.parse(File.read("data/bangs.json"))
bang_triggers = bangs_json.map { |b| b["t"] }

kagi_bangs_json = JSON.parse(File.read("data/kagi_bangs.json"))
kagi_triggers = kagi_bangs_json.map { |b| b["t"] }

assist_bangs_json = JSON.parse(File.read("data/assistant_bangs.json"))
assistant_triggers = assist_bangs_json.map { |b| b["t"] }

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
    it "template should not be uri encoded (#{bang["s"]})" do
      expect(CGI.unescapeURIComponent(bang["u"]).to_s).to eq(bang["u"])
    end

    it "domain should not be uri encoded (#{bang["s"]})" do
      expect(CGI.unescapeURIComponent(bang["d"]).to_s).to eq(bang["d"])
    end

    if bang["ad"]
      it "alt domain should not be uri encoded (#{bang["s"]})" do
        expect(CGI.unescapeURIComponent(bang["ad"]).to_s).to eq(bang["ad"])
      end
    end
  end
end

def ad_format_check(bangs)
  bangs.each do |bang|
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
  uri_decoded_urls(kagi_bangs_json)
  ad_format_check(kagi_bangs_json)
end

describe "assistant_bangs.json" do
  it "doesn't have duplicate bang triggers" do
    dups = find_dups(assistant_triggers)

    expect(dups).to be_empty, "Duplicate(s) found: #{dups.join(", ")}"
  end

  match_domains(assist_bangs_json)
  uri_decoded_urls(assist_bangs_json)
  ad_format_check(assist_bangs_json)
end
