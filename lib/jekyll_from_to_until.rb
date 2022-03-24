# frozen_string_literal: true

# @author Copyright 2020 Michael Slinn
# Jekyll filters for working with multiline strings.

require "liquid"
require "jekyll_plugin_logger"
require_relative "jekyll_from_to_until/version"

module JekyllPluginFromToUntilName
  PLUGIN_NAME = "jekyll_from_to_until"
end

module Jekyll
  # Filters a multiline string, returning the portion beginning with the line that satisfies a regex.
  # The regex could be enclosed in single quotes, double quotes, or nothing.
  # @param input_strings [String] The multi-line string to scan
  # @param regex [String] The regular expression to match against each line of `input_strings` until found
  # @return [String] The remaining multi-line string
  # @example Returns remaining lines starting with the line containing the word `module`.
  #   {{ flexible_include '/blog/2020/10/03/jekyll-plugins.html' | from 'module' }}
  def from(input_strings, regex)
    return "" unless check_parameters(input_strings, regex)

    regex = remove_quotations(regex.to_s.strip)
    matched = false
    result = ""
    input_strings.each_line do |line|
      matched = true if !matched && line =~ %r!#{regex}!
      result += line if matched
    end
    result
  end

  # Filters a multiline string, returning the portion from the beginning until and including the line that satisfies a regex.
  # The regex could be enclosed in single quotes, double quotes, or nothing.
  # @example Returns lines up to and including the line containing the word `module`.
  #   {{ flexible_include '/blog/2020/10/03/jekyll-plugins.html' | to 'module' }}
  def to(input_strings, regex)
    return "" unless check_parameters(input_strings, regex)

    regex = remove_quotations(regex.to_s.strip)
    result = ""
    input_strings.each_line do |line|
      result += line
      return result if line.match?(%r!#{regex}!)
    end
    result
  end

  # Filters a multiline string, returning the portion from the beginning until but not including the line that satisfies a regex.
  # The regex could be enclosed in single quotes, double quotes, or nothing.
  # @example Returns lines up to but not including the line containing the word `module`.
  #   {{ flexible_include '/blog/2020/10/03/jekyll-plugins.html' | until 'module' }}
  def until(input_strings, regex)
    return "" unless check_parameters(input_strings, regex)

    regex = remove_quotations(regex.to_s.strip)
    result = ""
    input_strings.each_line do |line|
      return result if line.match?(%r!#{regex}!)

      result += line
    end
    result
  end

  private

  def check_parameters(input_strings, regex)
    if input_strings.nil? || input_strings.empty?
      Jekyll.warn { "Warning: Plugin 'from' received no input for regex #{regex}." }
      return false
    end

    regex = regex.to_s
    if regex.nil? || regex.empty?
      Jekyll.warn { "Warning: Plugin 'from' received no regex for input #{input_strings}." }
      return false
    end
    true
  end

  def remove_quotations(str)
    str = str.slice(1..-2) if (str.start_with?('"') && str.end_with?('"')) ||
                              (str.start_with?("'") && str.end_with?("'"))
    str
  end
end

PluginMetaLogger.instance.info { "Loaded #{JekyllPluginFromToUntilName::PLUGIN_NAME} v#{JekyllFromToUntil::VERSION} plugin." }
Liquid::Template.register_filter(Jekyll)
