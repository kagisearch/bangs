require 'json'
require 'fileutils'

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

  old_index = old_data.map { |item| item['t'] }
  current_index = current_data.map { |item| item['t'] }

  added = current_data.reject { |item| old_index.include?(item['t']) }
  removed = old_data.reject { |item| current_index.include?(item['t']) }
  modified = []

  old_data.each do |old_entry|
    current_entry = current_data.find { |e| e['t'] == old_entry['t'] }
    next unless current_entry && old_entry['u'] != current_entry['u']

    modified << {
      't' => old_entry['t'],
      'old_u' => old_entry['u'],
      'new_u' => current_entry['u']
    }
  end

  File.delete(old_file_path)

  # Markdown formatted output
  puts "## #{File.basename(file_path, '.json').split('_').map(&:capitalize).join(' ')}"
  has_changes = false

  if added.any?
    puts "### Added"
    puts added.map { |item| "- **#{item['t']}** (`#{item['u']}`)" }.join("\n")
    has_changes = true
  end

  if removed.any?
    puts "\n### Removed"
    puts removed.map { |item| "- **#{item['t']}** (`#{item['u']}`)" }.join("\n")
    has_changes = true
  end

  if modified.any?
    puts "\n### Changed"
    puts modified.map { |m| "- **#{m['t']}**: URL changed from `#{m['old_u']}` to `#{m['new_u']}`" }.join("\n")
    has_changes = true
  end

  puts "\nNo changes detected." unless has_changes
  puts "\n"
end

# Paths to the JSON files
json_files = ['data/bangs.json', 'data/kagi_bangs.json', 'data/assistant_bangs.json']

# Process each file
json_files.each do |file_path|
  compare_json_files(file_path)
end
