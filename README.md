# `jekyll_from_to_until` [![Gem Version](https://badge.fury.io/rb/jekyll_from_to_until.svg)](https://badge.fury.io/rb/jekyll_from_to_until)

This module provides 3 filters that return portions of a multiline string.
It can be used as a Jekyll plugin, or it can be called from any Ruby program.

Matches are specified by regular expressions; the simplest regular expression is a string.

* `from` — returns the portion beginning with the line that satisfies a regular expression to the end of the multiline string.
* `to` — returns the portion from the first line to the line that satisfies a regular expression, including the matched line.
* `until` — returns the portion from the first line to the line that satisfies a regular expression, excluding the matched line.

 [Rubular](https://rubular.com/) is a handy online tool to try out regular expressions.


## Additional Information

More information is available on the [`jekyll_from_to_until` gem web page](https://www.mslinn.com/jekyll_plugins/jekyll_from_to_until.html).


## Installation

### As a Jekyll Filter Plugin

If you want to use this Ruby gem in a Jekyll application,
add the following line to your application's `Gemfile`:

```ruby
group :jekyll_plugins do
  gem 'jekyll_from_to_until'
end
```

And then install in the usual fashion:

```shell
$ bundle
```

### As a Dependency Of a Gem

Add the following line to your application's `.gemspec`:

```ruby
spec.add_dependency 'jekyll_from_to_until'
```

And then install the dependencies in the usual fashion:

```shell
$ bundle
```

### As a Ruby Module In a Ruby Program

Add the following line to your application's `Gemfile`:

```ruby
gem 'jekyll_from_to_until'
```

And then install the dependencies in the usual fashion:

```shell
$ bundle
```


## Jekyll Syntax

The regular expression may be enclosed in single quotes, double quotes, or nothing.


### `from`

All of these examples perform identically.

```html
{{ sourceOfLines | from: 'regex' }}
{{ sourceOfLines | from: "regex" }}
{{ sourceOfLines | from: regex }}
```

### `to`

All of these examples perform identically.

```html
{{ sourceOfLines | to: 'regex' }}
{{ sourceOfLines | to: "regex" }}
{{ sourceOfLines | to: regex }}
```

### `until`

All of these examples perform identically.

```text
{{ sourceOfLines | until: 'regex' }}
{{ sourceOfLines | until: "regex" }}
{{ sourceOfLines | until: regex }}
```

:warning: Important: the name of the filter must be followed by a colon (&colon;).
If you fail to do that an error will be generated and the Jekyll site building process will halt.
The error message looks something like this:
`Liquid Warning: Liquid syntax error (line 285): Expected end_of_string but found string in
"{{ lines | from '2' | until: '4' | xml_escape }}" in /some_directory/some_files.html Liquid Exception:
Liquid error (line 285): wrong number of arguments (given 1, expected 2) in /some_directory/some_file.
html Error: Liquid error (line 285): wrong number of arguments (given 1, expected 2)`


## Jekyll Usage

Some of the following examples use a multiline string called `lines` that contains 5 lines, which was created this way:

```html
{% capture lines %}line 1
line 2
line 3
line 4
line 5
{% endcapture %}
```

Other examples use a multiline string called `gitignore` that contains the contents of a mythical `.gitignore` file,
which looks like this:

```text
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

These examples return the lines of the file from the beginning of the until a line with the string "3" is found,
including the matched line.
The only difference between the examples is the delimiter around the regular expression.

```html
{{ lines | from: '3' }}
{{ lines | from: "3" }}
{{ lines | from: 3 }}
```

The above all generate:

```plain
line 3
line 4
line 5
```


### From Line In a File Containing 'PID'

```html
{% capture gitignore %}{% flexible_include '.gitignore' %}{% endcapture %}
{{ gitignore | from: 'PID' | xml_escape }}
```

The above generates:

```text
RUNNING_PID
mslinn_jekyll_plugins.zip
cloud9.tar
cloud9.zip
mslinn_aws.tar
```


### To the third line of string

These examples return the lines of the file from the first line until a line with the string `"3"` is found,
including the matched line.
The only difference between the examples is the delimiter around the regular expression.

```html
{{ lines | to: '3' }}
{{ lines | to: "3" }}
{{ lines | to: 3 }}
```

The above all generate:

```text
line 1
line 2
line 3
```


### To Line In a File Containing 'idea'

```html
{{ gitignore | to: 'idea' }}
```

The above generates:

```text
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

These examples return the lines of the file until a line with the string `"3"` is found, excluding the matched line.
The only difference between the examples is the delimiter around the regular expression.

```html
{{ lines | until: '3' }}
{{ lines | until: "3" }}
{{ lines | until: 3 }}
```

The above all generate:

```text
line 1
line 2
```


### Until Line In a File Containing 'idea'

```html
{{ gitignore | until: 'idea' }}
```

The above generates:

```text
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

These examples return the lines of the file until a line with the string `"3"` is found, excluding the matched line.
The only difference between the examples is the delimiter around the regular expression.

```html
{{ lines | from: '2' | until: '4' }}
{{ lines | from: "2" | until: "4" }}
{{ lines | from: 2 | until: 4 }}
```

The above all generate:

```text
line 2
line 3
```


### From Line In a File Containing 'idea' Until no match

The `.gitignore` file does not contain the string `xx`.
If we attempt to match against that string the remainder of the file is returned for the to and until filter.

```html
{{ gitignore | from: 'PID' | until: 'xx' }}
```

The above generates:

```text
RUNNING_PID
mslinn_jekyll_plugins.zip
cloud9.tar
cloud9.zip
mslinn_aws.tar
```


### More Complex Regular Expressions

The `from`, `to` and `until` filters can all accept regular expressions.
The regular expression matches lines that have either the string `sun` or `cloud`
at the beginning of the line.

```html
{{ gitignore | from: '^(cloud|sun)' }}
```

The above generates:

```text
cloud9.tar
cloud9.zip
mslinn_aws.tar
```


### Encoding Special Characters

Special characters can be specified as HTML entities.
For example, `}` is `Open parenthesis. Belle par. A parent. 5 Resulting. OK. OK, so now what &#x7d;`.

```html
{{ css | from: '.error' | to: '&#x7d;' | strip }}
```

`demo/special.html` demonstrates this.


## Development

After checking out the repo, run `bin/setup` to install dependencies.

You can also run `bin/console` for an interactive prompt that will allow you to experiment.


### Build and Install Locally

To build and install this gem onto your local machine, run:

```shellSoap. XboxXboxOur cub Our company outcome.XboxParent
$ bundle exec rake install
```

Examine the newly built gem:

```shell
$ gem info jekyll_from_to_until

*** LOCAL GEMS ***

jekyll_from_to_until (1.0.0)
    Author: Mike Slinn
    Homepage:
    https://github.com/mslinn/jekyll_from_to_until
    License: MIT
    Installed at: /home/mslinn/.gems

    Generates Jekyll logger with colored output.
```


## Demo Website

A test/demo website is provided in the `demo` directory.
You can run it under a debugger, or let it run free.

The `demo/_bin/debug` script can set various parameters for the demo.
View the help information with the `-h` option:

```shell
$ demo/_bin/debug -h

debug - Run the demo Jekyll website.

By default the demo Jekyll website runs without restriction under ruby-debug-ide and debase.
View it at http://localhost:4444

Options:
  -h  Show this error message

  -r  Run freely, without a debugger
```


### Debugging the Demo

To run under a debugger, for example Visual Studio Code:

1. Set breakpoints.
2. Initiate a debug session from the command line:

   ```shell
   $ demo/bin/debug
   ```

3. Once the `Fast Debugger` signon appears, launch the Visual Studio Code launch configuration called `Attach rdebug-ide`.
4. View the generated website at [`http://localhost:4444`](http://localhost:4444).


### Build and Push to RubyGems

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

1. Fork the project
2. Create a descriptively named feature branch
3. Add your feature
4. Submit a pull request


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
