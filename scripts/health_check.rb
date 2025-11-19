require "json"
require "net/http"
require "uri"
require "whirly"

bangs_json = JSON.parse(File.read("data/bangs.json"))
kagi_bangs_json = JSON.parse(File.read("data/kagi_bangs.json"))

errored = []
mutex = Mutex.new

def check_url(bang, errored, mutex)
  return if bang["u"].start_with?("/")

  bang_url = bang["u"].gsub("{{{s}}}", "example").strip
  url = URI.parse(bang_url)

  Net::HTTP.get_response(url)
rescue Net::ReadTimeout
  # Do nothing
rescue => e
  mutex.synchronize { errored << [bang, e] }
  # puts "#{bang_url} is offline (#{bang["s"]}). Error: \n  #{e}"
end

Whirly.configure spinner: "dots"
Whirly.start

all_bangs = bangs_json + kagi_bangs_json
threads = []

all_bangs.each_with_index do |bang, idx|
  Whirly.status = "Bang #{bang["s"]} (#{idx + 1}/#{all_bangs.size})"

  threads << Thread.new { check_url(bang, errored, mutex) }

  # Limit the number of concurrent threads to avoid overwhelming the system
  if threads.size >= 10
    threads.each(&:join)
    threads.clear
  end
end

# Ensure all remaining threads are completed
threads.each(&:join)

Whirly.stop

errored.each do |error|
  bang, e = error

  puts "#{bang["u"]} is offline. Error: \n  #{e}"
end

exit 1 if errored.size > 0
