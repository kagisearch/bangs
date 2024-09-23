require "json"

bangs_json = JSON.parse(File.read("data/bangs.json"))

bangs_json.each do |bang|
  next unless bang["u"]&.start_with?("/")
  next if bang["ad"]

  re = /site(?::|%3A)(.+?)(?:\+| |$)/
  if data = re.match(bang["u"])
    bang["ad"] = data[1]
  else
    puts "Can't find site operator for #{bang["t"]}"
  end
end

File.write("data/bangs.json", JSON.dump(bangs_json))
