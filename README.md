`jekyll_from_to_until`
[![Gem Version](https://badge.fury.io/rb/jekyll_from_to_until.svg)](https://badge.fury.io/rb/jekyll_from_to_until)
===========

This Jekyll plugin provides 3 filters that return portions of a multiline string.
Regular expression is used to specify matches; the simplest regular expression is a string.
 * `from` — returns the portion beginning with the line that satisfies a regular expression to the end of the multiline string.
 * `to` — returns the portion from the first line to the line that satisfies a regular expression, including the matched line.
 * `until` — returns the portion from the first line to the line that satisfies a regular expression, excluding the matched line.

 [Rubular](https://rubular.com/) is a handy online tool to try out regular expressions.


### Additional Information
More information is available on my web site about [my Jekyll plugins](https://www.mslinn.com/blog/2020/10/03/jekyll-plugins.html).


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll_from_to_until'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install jekyll_from_to_until


## Syntax
The regular expression may be enclosed in single quotes, double quotes, or nothing.

### `from`
All of these examples perform identically.
```
{{ sourceOfLines | from: 'regex' }}
{{ sourceOfLines | from: "regex" }}
{{ sourceOfLines | from: regex }}
```

### `to`
All of these examples perform identically.
```
{{ sourceOfLines | to: 'regex' }}
{{ sourceOfLines | to: "regex" }}
{{ sourceOfLines | to: regex }}
```

### `until`
All of these examples perform identically.
```
{{ sourceOfLines | until: 'regex' }}
{{ sourceOfLines | until: "regex" }}
{{ sourceOfLines | until: regex }}
```
:warning: Important: the name of the filter must be followed by a colon (:). If you fail to do that an error will be generated and the Jekyll site building process will halt. The error message looks something like this: `Liquid Warning: Liquid syntax error (line 285): Expected end_of_string but found string in "{{ lines | from '2' | until: '4' | xml_escape }}" in /some_directory/some_files.html Liquid Exception: Liquid error (line 285): wrong number of arguments (given 1, expected 2) in /some_directory/some_file.html Error: Liquid error (line 285): wrong number of arguments (given 1, expected 2)`
## Usage

Some of the following examples use a multiline string called `lines` that contains 5 lines, which was created this way:

```
{% capture lines %}line 1
line 2
line 3
line 4
line 5
{% endcapture %}
```

Other examples use a multiline string called `gitignore` that contains the contents of a mythical `.gitignore` file, which looks like this:
```
.bsp/
project/
target/
*.gz
*.sublime*
*.swp
*.out
*.Identifier
*.log
.idea*
*.iml
*.tmp
*~
~*
.DS_Store
.idea
.jekyll-cache/
.jekyll-metadata
.makeAwsBucketAndDistribution.log
.sass-cache/
.yardoc/
__pycache__/
__MACOSX
_build/
_package/
_site/
bin/*.class
doc/
jekyll/doc/
node_modules/
Notepad++/
out/
package/
instances.json
rescue_ubuntu2010
rescue_ubuntu2010.b64
landingPageShortName.md
test.html
RUNNING_PID
mslinn_jekyll_plugins.zip
cloud9.tar
cloud9.zip
mslinn_aws.tar
```

### From the third line of string
These examples return the lines of the file from the beginning of the until a line with the string "3" is found, including the matched line. The only difference between the examples is the delimiter around the regular expression.
```
{{ lines | from: '3' }}
{{ lines | from: "3" }}
{{ lines | from: 3 }}
```
The above all generate:
```
line 3
line 4
line 5
```

### From Line In a File Containing 'PID'
```
{% capture gitignore %}{% flexible_include '.gitignore' %}{% endcapture %}
{{ gitignore | from: 'PID' | xml_escape }}
```
The above generates:
```
RUNNING_PID
mslinn_jekyll_plugins.zip
cloud9.tar
cloud9.zip
mslinn_aws.tar
```

### To the third line of string
These examples return the lines of the file from the first line until a line with the string `"3"` is found, including the matched line. The only difference between the examples is the delimiter around the regular expression.
```
{{ lines | to: '3' }}
{{ lines | to: "3" }}
{{ lines | to: 3 }}
```
The above all generate:
```
line 1
line 2
line 3
```

### To Line In a File Containing 'idea'
```
{{ gitignore | to: 'idea' }}
```
The above generates:
```
.bsp/
project/
target/
*.gz
*.sublime*
*.swp
*.out
*.Identifier
*.log
.idea*
```

### Until the third line of string
These examples return the lines of the file until a line with the string `"3"` is found, excluding the matched line. The only difference between the examples is the delimiter around the regular expression.
```
{{ lines | until: '3' }}
{{ lines | until: "3" }}
{{ lines | until: 3 }}
```
The above all generate:
```
line 1
line 2
```

### Until Line In a File Containing 'idea'
```
{{ gitignore | until: 'idea' }}
```
The above generates:
```
.bsp/
project/
target/
*.gz
*.sublime*
*.swp
*.out
*.Identifier
*.log
```

### From the string "2" until the string "4"
These examples return the lines of the file until a line with the string `"3"` is found, excluding the matched line. The only difference between the examples is the delimiter around the regular expression.
```
{{ lines | from: '2' | until: '4' }}
{{ lines | from: "2" | until: "4" }}
{{ lines | from: 2 | until: 4 }}
```
The above all generate:
```
line 2
line 3
```

### From Line In a File Containing 'idea' Until no match
The `.gitignore` file does not contain the string `xx`. If we attempt to match against that string the remainder of the file is returned for the to and until filter, and the empty string is returned for the from filter.
```
{{ gitignore | from: 'PID' | until: 'xx' }}
```
The above generates:
```
RUNNING_PID
mslinn_jekyll_plugins.zip
cloud9.tar
cloud9.zip
mslinn_aws.tar
```

### More Complex Regular Expressions
The from, to and until filters can all accept more complex regular expressions. This regular expression matches lines that have either the string sun or cloud at the beginning of the line.
```
{{ gitignore | from: '^(cloud|sun)' }}
```
The above generates:
```
cloud9.tar
cloud9.zip
mslinn_aws.tar
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

Install development dependencies like this:
```
$ BUNDLE_WITH="development" bundle install
```

To install this gem onto your local machine, run `bundle exec rake install`. 

To release a new version, 
  1. Update the version number in `version.rb`.
  2. Commit all changes to git; if you don't the next step might fail with an unexplainable error message.
  3. Run the following:
     ```shell
     $ bundle exec rake release
     ```
     The above creates a git tag for the version, commits the created tag, 
     and pushes the new `.gem` file to [RubyGems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mslinn/jekyll_from_to_until.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
