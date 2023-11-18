require_relative '../lib/jekyll_from_to_until'

module Demo
  include FromToUntil

  FromToUntil.from("line1\nline 2\nline 3", '2').each_line { |line| puts line }
end
