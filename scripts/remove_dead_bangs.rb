require "json"

bangs_json = JSON.parse(File.read("data/bangs.json"))
usage_json = JSON.parse(File.read("test.json"))

bangs_json.reject! do |bang|
  !usage_json["series"].any? { |series|
    series["fields"].any?{ |f|
      f["type"] == "number" && f["labels"]["t"] == bang["t"]
    }
  }
end

File.write("data/bangs_filtered.json", JSON.dump(bangs_json))
