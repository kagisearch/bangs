require 'json'
require 'fileutils'

# Helper function to get all triggers for a bang entry
def get_all_triggers(entry)
  triggers = [entry['t']]
  triggers.concat(entry['ts']) if entry['ts']
  triggers
end

# Function to perform the comparison and output the results
def compare_json_files(file_path)
  # Fetch the latest release tag
  last_release_tag = `git describe --tags --abbrev=0`.strip
  old_file_path = "#{file_path}.old"

  # Checkout the file at the last release tag
  system("git checkout #{last_release_tag} -- #{file_path}")
  FileUtils.cp(file_path, old_file_path)

  # Checkout back to the latest commit
  system("git checkout HEAD -- #{file_path}")

  current_data = JSON.parse(File.read(file_path))
  old_data = JSON.parse(File.read(old_file_path))

  # Build comprehensive trigger mappings
  old_triggers = {}
  current_triggers = {}

  old_data.each { |entry| get_all_triggers(entry).each { |t| old_triggers[t] = entry } }
  current_data.each { |entry| get_all_triggers(entry).each { |t| current_triggers[t] = entry } }

  added_bangs = []
  removed_bangs = []
  added_triggers = []
  removed_triggers = []
  modified_bangs = []

  # Find completely new bangs (primary trigger didn't exist before)
  current_data.each do |entry|
    unless old_triggers.key?(entry['t'])
      added_bangs << entry
    end
  end

  # Find completely removed bangs (primary trigger no longer exists)
  old_data.each do |entry|
    unless current_triggers.key?(entry['t'])
      removed_bangs << entry
    end
  end

  # Find added/removed triggers and modified bangs
  current_data.each do |current_entry|
    old_entry = old_data.find { |e| e['t'] == current_entry['t'] }
    next unless old_entry # Skip new bangs, already handled

    old_entry_triggers = get_all_triggers(old_entry)
    current_entry_triggers = get_all_triggers(current_entry)

    # Check for added triggers (excluding primary)
    new_triggers = current_entry_triggers - old_entry_triggers
    new_triggers.each do |trigger|
      added_triggers << {
        'trigger' => trigger,
        'primary' => current_entry['t'],
        'url' => current_entry['u']
      }
    end

    # Check for removed triggers (excluding primary)
    lost_triggers = old_entry_triggers - current_entry_triggers
    lost_triggers.reject { |t| t == old_entry['t'] }.each do |trigger|
      removed_triggers << {
        'trigger' => trigger,
        'primary' => old_entry['t'],
        'url' => old_entry['u']
      }
    end

    # Check for URL changes
    if old_entry['u'] != current_entry['u']
      modified_bangs << {
        't' => old_entry['t'],
        'old_u' => old_entry['u'],
        'new_u' => current_entry['u']
      }
    end
  end

  File.delete(old_file_path)

  # Markdown formatted output
  File.open('release_notes.md', 'a+') do |file|
    file.puts "## #{File.basename(file_path, '.json').split('_').map(&:capitalize).join(' ')}"
    has_changes = false

    if added_bangs.any?
      file.puts "### Added Bangs"
      file.puts added_bangs.map { |item| "- **#{item['t']}** (`#{item['u']}`)" }.join("\n")
      has_changes = true
    end

    if added_triggers.any?
      file.puts "\n### Added Triggers"
      file.puts added_triggers.map { |item| "- **#{item['trigger']}** (alias for **#{item['primary']}**)" }.join("\n")
      has_changes = true
    end

    if removed_bangs.any?
      file.puts "\n### Removed Bangs"
      file.puts removed_bangs.map { |item| "- **#{item['t']}** (`#{item['u']}`)" }.join("\n")
      has_changes = true
    end

    if removed_triggers.any?
      file.puts "\n### Removed Triggers"
      file.puts removed_triggers.map { |item| "- **#{item['trigger']}** (was alias for **#{item['primary']}**)" }.join("\n")
      has_changes = true
    end

    if modified_bangs.any?
      file.puts "\n### Modified Bangs"
      file.puts modified_bangs.map { |m| "- **#{m['t']}**: URL changed from `#{m['old_u']}` to `#{m['new_u']}`" }.join("\n")
      has_changes = true
    end

    file.puts "\nNo changes detected." unless has_changes
    file.puts "\n"
  end
end

# Paths to the JSON files
json_files = ['data/bangs.json', 'data/kagi_bangs.json']

File.delete('release_notes.md') if File.exist?('release_notes.md')

# Process each file
json_files.each do |file_path|
  compare_json_files(file_path)
end
