require_relative "bang_changes"

last_release_tag, error, status = Open3.capture3("git", "describe", "--tags", "--abbrev=0")
raise "Cannot find latest release tag: #{error}" unless status.success?

File.write("release_notes.md", BangChanges.report(last_release_tag.strip, "HEAD"))
