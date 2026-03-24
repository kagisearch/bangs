require "json"
require "net/http"
require "uri"
require "whirly"

DEFAULT_CONCURRENCY = Integer(ENV.fetch("HEALTH_CHECK_CONCURRENCY", 25))
OPEN_TIMEOUT = Integer(ENV.fetch("HEALTH_CHECK_OPEN_TIMEOUT", 5))
READ_TIMEOUT = Integer(ENV.fetch("HEALTH_CHECK_READ_TIMEOUT", 10))
HEAD_FALLBACK_CODES = [405, 501].freeze
OUTPUT_FILE = ARGV[0]

abort("Usage: ruby scripts/health_check.rb OUTPUT_FILE") if OUTPUT_FILE.nil? || OUTPUT_FILE.empty?

bangs_json = JSON.parse(File.read("data/bangs.json"))
kagi_bangs_json = JSON.parse(File.read("data/kagi_bangs.json"))

errored = []
mutex = Mutex.new
progress_mutex = Mutex.new

def request(url)
  Net::HTTP.start(url.host, url.port, use_ssl: url.scheme == "https") do |http|
    http.open_timeout = OPEN_TIMEOUT
    http.read_timeout = READ_TIMEOUT

    response = http.request(Net::HTTP::Head.new(url.request_uri))
    return response unless HEAD_FALLBACK_CODES.include?(response.code.to_i)

    http.request(Net::HTTP::Get.new(url.request_uri))
  end
end

def check_url(bang, errored, mutex)
  bang_url = bang["u"].gsub("{{{s}}}", "example").strip
  url = URI.parse(bang_url)

  request(url)
rescue Net::ReadTimeout
  # Do nothing
rescue => e
  mutex.synchronize { errored << [bang, e] }
  # puts "#{bang_url} is offline (#{bang["s"]}). Error: \n  #{e}"
end

Whirly.configure spinner: "dots"
Whirly.start

all_bangs = (bangs_json + kagi_bangs_json).reject { |bang| bang["u"].start_with?("/") }
queue = Queue.new
all_bangs.each { |bang| queue << bang }
processed = 0

threads = Array.new(DEFAULT_CONCURRENCY) do
  Thread.new do
    loop do
      bang = queue.pop(true)
      check_url(bang, errored, mutex)

      progress_mutex.synchronize do
        processed += 1
        Whirly.status = "Bang #{bang["s"]} (#{processed}/#{all_bangs.size})"
      end
    rescue ThreadError
      break
    end
  end
end

threads.each(&:join)

Whirly.stop

File.open(OUTPUT_FILE, "w") do |file|
  errored.each do |error|
    bang, e = error
    file.puts("#{bang["u"]} is offline. Error: #{e}")
  end
end

exit 1 if errored.size > 0
