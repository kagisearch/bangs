require_relative "bang_changes"

base, head, output = ARGV
abort "Usage: ruby scripts/generate_pr_comment.rb BASE_SHA HEAD_SHA OUTPUT" unless output
abort "Expected full commit SHAs" unless [base, head].all? { |ref| ref.match?(/\A[0-9a-f]{40}\z/) }

body = <<~MARKDOWN
  <!-- bang-changes -->
  # Effective bang changes

  Comparing base #{BangChanges.code(base)} with PR head #{BangChanges.code(head)}.
  Lists added/removed bangs and triggers, plus URL, regex, format-flag, and domain changes. Ordering and metadata-only changes are ignored.

MARKDOWN

begin
  body += BangChanges.report(base, head)
rescue JSON::ParserError
  body += "Unable to summarize changes: a bang data file contains invalid JSON. Please check the validation workflow.\n"
rescue BangChanges::InvalidData => error
  body += "Unable to summarize changes: #{BangChanges.code(error.message)}. Please check the validation workflow.\n"
end

# Leave room below GitHub's comment limit, including for multibyte triggers.
if body.bytesize > 60_000
  lines = body.lines
  body = ""
  lines.each do |line|
    break if body.bytesize + line.bytesize > 59_000

    body += line
  end
  body += "\n_Summary truncated because it exceeds GitHub's comment size limit. See the PR diff for the remaining changes._\n"
end

File.write(output, body)
