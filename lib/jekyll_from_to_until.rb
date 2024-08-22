# Jekyll filters for working with multiline strings.

require 'htmlentities'
require_relative 'jekyll_from_to_until/version'

module JekyllPluginFromToUntilName
  PLUGIN_NAME = 'jekyll_from_to_until'.freeze
end

CALLED_FROM_JEKYLL = !$LOADED_FEATURES.grep(/.*liquid.rb/).empty?

module Jekyll
  module FromToUntil
    @logger = if CALLED_FROM_JEKYLL
                require 'liquid'
                require 'jekyll_plugin_logger'
                PluginMetaLogger.instance.new_logger "FromToUntil", PluginMetaLogger.instance.config
              else
                require 'logger'
                Logger.new $stdout
              end

    # Filters a multiline string, returning the portion beginning with the line that satisfies a regex.
    # The regex could be enclosed in single quotes, double quotes, or nothing.
    # @param input_strings [String] The multi-line string to scan
    # @param regex [String] The regular expression to match against each line of `input_strings` until found
    # @return [String] The remaining multi-line string
    # @example Returns remaining lines starting with the line containing the word `module`.
    #   {{ flexible_include '/blog/2020/10/03/jekyll-plugins.html' | from 'module' }}
    def from(input_strings, regex)
      return '' unless check_parameters(input_strings, regex)

      regex = remove_quotations(regex.to_s.strip)
      matched = false
      result = ''
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
      return '' unless check_parameters(input_strings, regex)

      regex = remove_quotations(regex.to_s.strip)
      result = ''
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
      return '' unless check_parameters(input_strings, regex)

      regex = remove_quotations(regex.to_s.strip)
      result = ''
      input_strings.each_line do |line|
        return result if line.match?(%r!#{regex}!)

        result += line
      end
      result
    end

    private if CALLED_FROM_JEKYLL

    def check_parameters(input_strings, regex)
      if input_strings.nil? || input_strings.empty?
        @logger.warn { "Warning: Plugin 'from' received no input for regex #{regex}." }
        return false
      end

      regex = regex.to_s
      if regex.nil? || regex.empty?
        @logger.warn { "Warning: Plugin 'from' received no regex for input #{input_strings}." }
        return false
      end
      true
    end

    def remove_quotations(str)
      str = str.slice(1..-2) if (str.start_with?('"') && str.end_with?('"')) ||
                                (str.start_with?("'") && str.end_with?("'"))
      str
    end

    module_function :from, :to, :until, :check_parameters, :remove_quotations
  end

  # See https://www.mslinn.com/jekyll/10400-jekyll-plugin-template-collection.html#module_function
  module FromToUntilFilter
    def from(input_strings, regex)
      input_strings = extra_decode HTMLEntities.new.decode input_strings
      regex         = extra_decode HTMLEntities.new.decode regex
      FromToUntil.from(input_strings, regex) # method forwarding
    end

    def to(input_strings, regex)
      input_strings = extra_decode HTMLEntities.new.decode input_strings
      regex         = extra_decode HTMLEntities.new.decode regex
      FromToUntil.to(input_strings, regex) # method forwarding
    end

    def until(input_strings, regex)
      input_strings = extra_decode HTMLEntities.new.decode input_strings
      regex         = extra_decode HTMLEntities.new.decode regex
      FromToUntil.until(input_strings, regex) # method forwarding
    end

    # HTMLEntities does not support enough HTML entities
    def extra_decode(line)
      line.gsub('&lcub;', '{')
          .gsub('&rcub;', '}')
          .gsub('&lpar;', '(')
          .gsub('&rpar;', ')')
          .gsub('&lparen;', '(')
          .gsub('&rparen;', ')')
          .gsub('&lsqb;', '[')
          .gsub('&rsqb;', ']')
          .gsub('&lbrack;', '[')
          .gsub('&rbrack;', ']')
    end
  end

  if CALLED_FROM_JEKYLL
    PluginMetaLogger.instance.info { "Loaded #{JekyllPluginFromToUntilName::PLUGIN_NAME} v#{JekyllFromToUntilVersion::VERSION} plugin." }
    Liquid::Template.register_filter(FromToUntilFilter)
  end
end
