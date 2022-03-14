# frozen_string_literal: true

require 'jekyll'
require 'fileutils'
require_relative '../lib/jekyll_from_to_until'

Jekyll.logger.log_level = :info

RSpec.configure do |config|
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
end
