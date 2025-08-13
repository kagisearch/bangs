require "json"

["data/bangs.json", "data/assistant_bangs.json", "data/kagi_bangs.json"].each do |file|
  bangs_json = JSON.parse(File.read(file))
  output = []

  sort_order = ["s", "d", "ad", "t", "ts", "u", "x", "c", "sc", "skip_tests", "fmt"]

  bangs_json.each do |bang|
    matches = bangs_json.select { |b|
      b["u"] == bang["u"] &&
      b["t"] != bang["t"] &&
      b["ad"] == bang["ad"]
    }

    if !matches.empty?
      bang["ts"] ||= []

      matches.each do |match|
        bang["ts"].push(match["t"])
        bangs_json.delete(match)
      end
    end

    bang = bang.sort_by { |k, v| sort_order.index(k) }.to_h

    output.push(bang)
  end

  File.write(file, JSON.dump(output))
end
