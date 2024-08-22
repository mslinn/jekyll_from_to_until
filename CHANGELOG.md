# Change Log

## 1.0.5 / 2024-08-22

* Fixed method forwarding
* Regexes are now subjected to an HTML unescape, so special characters are now supported,
  such as the right closing squiggly bracket:

   ```html
   {{ css | from: '.error' | to: '&#x7d;' | strip }}
   ```


## 1.0.4 / 2023-11-18

* Now callable from any Ruby program


## 1.0.3 / 2023-02-25

* Fixed `undefined method 'registers' for nil:NilClass (NoMethodError)`


## 1.0.2 / 2023-02-21

* Improved how the logger was used.
* Added `demo` website


## 1.0.1 / 2022-04-05

* Updated to `jekyll_plugin_logger` v2.1.0


## 1.0.0 / 2022-03-14

* Made into a Ruby gem and published on RubyGems.org as [jekyll_from_to_until](https://rubygems.org/gems/jekyll_from_to_until).
* `bin/attach` script added for debugging
* Rubocop standards added
* Proper versioning and CHANGELOG.md added


## 0.1.0 / 2020-12-29

* Initial version published
