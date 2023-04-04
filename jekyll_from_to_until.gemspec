require_relative 'lib/jekyll_from_to_until/version'

Gem::Specification.new do |spec|
  github = 'https://github.com/mslinn/jekyll_from_to_until'

  spec.authors = ['Mike Slinn']
  spec.bindir = 'exe'
  spec.description = <<~END_DESC
    This Jekyll plugin provides 3 filters that return portions of a multiline string: from, to and until.
    Regular expression is used to specify matches; the simplest regular expression is a string.
  END_DESC
  spec.email = ['mslinn@mslinn.com']
  spec.files = Dir['.rubocop.yml', 'LICENSE.*', 'Rakefile', '{lib,spec}/**/*', '*.gemspec', '*.md']
  spec.homepage = 'https://www.mslinn.com/jekyll/3000-jekyll-plugins.html#from_to_until'
  spec.license = 'MIT'
  spec.metadata = {
    'allowed_push_host' => 'https://rubygems.org',
    'bug_tracker_uri'   => "#{github}/issues",
    'changelog_uri'     => "#{github}/CHANGELOG.md",
    'homepage_uri'      => spec.homepage,
    'source_code_uri'   => github,
  }
  spec.name = 'jekyll_from_to_until'
  spec.post_install_message = <<~END_MESSAGE

    Thanks for installing #{spec.name} v#{JekyllFromToUntilVersion::VERSION}!

  END_MESSAGE
  spec.require_paths = ['lib']
  spec.required_ruby_version = '>= 2.6.0'
  spec.summary = 'This Jekyll plugin provides 3 filters that return portions of a multiline string: from, to and until.'
  spec.test_files = spec.files.grep(%r!^(test|spec|features)/!)
  spec.version = JekyllFromToUntilVersion::VERSION

  spec.add_dependency 'jekyll', '>= 3.5.0'
  spec.add_dependency 'jekyll_plugin_logger'
end
