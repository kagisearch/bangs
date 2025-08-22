require "json"

["data/bangs.json", "data/assistant_bangs.json", "data/kagi_bangs.json"].each do |file|
  bangs_json = JSON.parse(File.read(file))
  output = []

  sort_order = ["s", "d", "ad", "t", "ts", "u", "x", "c", "sc", "skip_tests", "fmt"]

  bangs_json.each_with_index do |bang, idx|
    matches = bangs_json.select { |b|
      (b["u"] == bang["u"]|| b["s"] == bang["s"]) &&
      b["t"] != bang["t"] &&
      b["ad"] == bang["ad"]
    }

    begin
      if !matches.empty?
        puts <<-BANG
          #{bang["s"]} (#{bang["t"]}):
            #{bang["u"]}

          BANG

        matches.each_with_index do |bang, idx|
          puts <<-BANG
            #{idx}: #{bang["s"]} (#{bang["t"]}):
              #{bang["u"]}
            BANG
        end

        print "(#{idx}/#{bangs_json.size}) reject?> "

        rejects = []
        swap = nil
        desc = nil

        gets.split(",").each do |instr|
          instr = instr.strip

          if instr.start_with?("swap")
            swap = instr.sub(/^swap/, "").to_i
          elsif instr.start_with?("desc")
            desc = instr.sub(/^desc/, "").strip
          elsif instr[/([0-9]+)-([0-9]+)/]
            rejects.push(*($1.to_i..$2.to_i).to_a)
          elsif instr == "" || instr == "\n"
            # do nothing
          else
            rejects.push(instr.to_i)
          end
        end

        pp rejects

        accepted = []
        matches.each_with_index {|m, idx| accepted.push(m) unless rejects.include?(idx) }

        if swap && accepted.size > swap
          accepted.push(bang)
          bang = accepted.delete_at(swap)
        end

        if desc
          bang["s"] = desc
        end

        pp accepted

        bang["ts"] ||= []

        accepted.each do |match|
          bang["ts"].push(match["t"])
          if (ts = match["ts"]) && !ts.empty?
            bang["ts"].push(*ts)
          end
          bangs_json.delete(match)
        end
      end
    rescue ex
      pp ex
      if gets.strip == ""
        next
      else
        break
      end
    end

    bang = bang.sort_by { |k, v| sort_order.index(k) }.to_h

    output.push(bang)
  end

  File.write(file, JSON.pretty_generate(output) + "\n")
end
