require "json"
require "open3"

# Compare trigger availability, rather than JSON ordering or primary/alias moves.
module BangChanges
  FILES = ["data/bangs.json", "data/kagi_bangs.json"].freeze
  DEFAULT_FORMAT = %w[open_base_path open_snap_domain url_encode_placeholder url_encode_space_to_plus].freeze
  BEHAVIOR_FIELDS = {"u" => "URL", "x" => "Regex pattern", "fmt" => "Format flags", "d" => "Domain", "ad" => "Snap domain"}.freeze
  class InvalidData < StandardError; end

  def self.triggers(entry)
    [entry.fetch("t"), *entry.fetch("ts", [])]
  end

  def self.trigger_map(data)
    raise InvalidData, "Expected an array of bangs" unless data.is_a?(Array)

    data.each_with_object({}) do |entry, map|
      unless entry.is_a?(Hash) && entry["t"].is_a?(String) && entry["u"].is_a?(String) &&
          entry.fetch("ts", []).is_a?(Array) && entry.fetch("ts", []).all? { |t| t.is_a?(String) }
        raise InvalidData, "Expected bangs with string triggers and URLs, and an array of aliases"
      end
      BEHAVIOR_FIELDS.keys.reject { |field| field == "fmt" }.each do |field|
        raise InvalidData, "Expected #{field} to be a string" if entry.key?(field) && !entry[field].is_a?(String)
      end
      if entry.key?("fmt") && !(entry["fmt"].is_a?(Array) && entry["fmt"].all? { |flag| flag.is_a?(String) })
        raise InvalidData, "Expected format flags to be an array of strings"
      end
      triggers(entry).each do |trigger|
        raise InvalidData, "Duplicate trigger: #{trigger}" if map.key?(trigger)

        map[trigger] = entry
      end
    end
  end

  def self.read_at(ref, path)
    contents, error, status = Open3.capture3("git", "show", "#{ref}:#{path}")
    raise "Cannot read #{path} at #{ref}: #{error}" unless status.success?

    JSON.parse(contents)
  end

  # Code spans keep arbitrary contributor-controlled text inert in comments.
  # Use a longer delimiter than any backtick run in the value itself.
  def self.code(value)
    text = value.to_s.gsub(/[\r\n]/, " ")
    delimiter = "`" * ((text.scan(/`+/).map(&:length).max || 0) + 1)
    "#{delimiter} #{text} #{delimiter}"
  end

  def self.bang_line(entry, changed_triggers)
    aliases = (triggers(entry) & changed_triggers) - [entry["t"]]
    suffix = aliases.empty? ? "" : "; aliases: #{aliases.map { |t| code(t) }.join(', ')}"
    "- **#{code(entry['t'])}** (#{code(entry['u'])})#{suffix}"
  end

  def self.behavior(entry, field)
    field == "fmt" ? entry.fetch(field, DEFAULT_FORMAT).uniq.sort : entry[field]
  end

  def self.value(value)
    value.nil? ? "(not set)" : code(value.is_a?(Array) ? JSON.generate(value) : value)
  end

  def self.trigger_line(trigger, entry, removed: false)
    description = if trigger == entry["t"]
      "#{removed ? 'was primary trigger' : 'primary trigger'} for #{code(entry['u'])}"
    else
      "#{removed ? 'was alias' : 'alias'} for **#{code(entry['t'])}**"
    end
    "- **#{code(trigger)}** (#{description})"
  end

  def self.markdown(old_data, current_data, old_map: trigger_map(old_data), current_map: trigger_map(current_data))
    local_old_map = trigger_map(old_data)
    local_current_map = trigger_map(current_data)
    added = local_current_map.keys - old_map.keys
    removed = local_old_map.keys - current_map.keys
    added_bangs = current_data.select { |entry| triggers(entry).none? { |t| old_map.key?(t) } }
    removed_bangs = old_data.select { |entry| triggers(entry).none? { |t| current_map.key?(t) } }

    sections = []
    sections << ["Added Bangs", added_bangs.map { |entry| bang_line(entry, added) }]
    sections << ["Added Triggers", (added - added_bangs.flat_map { |entry| triggers(entry) }).sort.map do |trigger|
      trigger_line(trigger, local_current_map.fetch(trigger))
    end]
    sections << ["Removed Bangs", removed_bangs.map { |entry| bang_line(entry, removed) }]
    sections << ["Removed Triggers", (removed - removed_bangs.flat_map { |entry| triggers(entry) }).sort.map do |trigger|
      trigger_line(trigger, local_old_map.fetch(trigger), removed: true)
    end]

    # Group identical behavioral changes, including those affecting aliases.
    modified = {}
    (local_current_map.keys & old_map.keys).each do |trigger|
      changes = BEHAVIOR_FIELDS.keys.filter_map do |field|
        old_value = behavior(old_map.fetch(trigger), field)
        new_value = behavior(local_current_map.fetch(trigger), field)
        [field, old_value, new_value] unless old_value == new_value
      end
      next if changes.empty?

      key = [local_current_map[trigger]["t"], changes]
      (modified[key] ||= []) << trigger
    end
    sections << ["Modified Bangs", modified.map do |(_, changes), changed|
      details = changes.map do |field, old_value, new_value|
        "  - **#{BEHAVIOR_FIELDS.fetch(field)}**\n    - Before: #{value(old_value)}\n    - After: #{value(new_value)}"
      end.join("\n")
      "- **#{changed.sort.map { |t| code(t) }.join(', ')}**\n#{details}"
    end]

    rendered = sections.reject { |_, lines| lines.empty? }.map do |title, lines|
      "### #{title}\n#{lines.join("\n")}"
    end
    rendered.empty? ? "No changes detected." : rendered.join("\n\n")
  end

  def self.report(base, head)
    snapshots = FILES.map { |path| [path, read_at(base, path), read_at(head, path)] }
    # Trigger availability is global: moving an entry between files isn't a change.
    old_map = trigger_map(snapshots.flat_map { |_, old, _| old })
    current_map = trigger_map(snapshots.flat_map { |_, _, current| current })
    snapshots.map do |path, old, current|
      title = File.basename(path, ".json").split("_").map(&:capitalize).join(" ")
      "## #{title}\n\n#{markdown(old, current, old_map: old_map, current_map: current_map)}\n"
    end.join("\n")
  end
end
