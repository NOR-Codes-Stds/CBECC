# Releases

## 0.6.0

- Rename *Params* to *Modelkit* to begin transition to a more general framework that moves beyond just parametrics and templates. Command-line options are changed (type `modelkit help` for new commands) and config file is changed to the ".modelkit-config" file name.
- Merge *Unitary* gem back into *Modelkit* as `Modelkit::Units`.

## 0.5.0

- Add `resolve_path` command to the template scope. It allows Ruby code within a template to search for a file path across any of the directories specified with the `--dirs` CLI option. The local template directory is always searched first. If found, the command returns the absolute path.
- Change preferred template header block keyword from `<%#INITIALIZE ... %>` to `<%#INTERFACE ... %>`.
  - NOTE: `INITIALIZE` will continue to work for several future versions before a change is required.
- Change `insert` command to write directly to the output file without using `<%= insert ... %>` syntax. This means multiple calls to `insert` can be used within one big `<% ... %>` code block.
- Add `console` command that launches an interactive Ruby session (like [IRB](https://en.wikipedia.org/wiki/Interactive_Ruby_Shell)) in a shell/terminal window. `console` can be called from inside of a template to allow interactive access to the local variables. Typing `exit` returns to the template environment to complete the output file (along with any variable changes). An interactive Ruby session can also be launched directly from a shell/terminal window for testing by typing: `params console`
- Fix the error reporting for Ruby exceptions in the template header.
- Fix the line number reporting for Ruby exceptions.
- Move units conversion capability to an external gem called *Unitary*.
- Modify `require_relative` within the template scope to automatically search the local template directory. (See related change to `require` below.)
- Add CLI option `--load-paths` to prepend custom directories to $LOAD_PATH which is used for loading Ruby libraries using `require`.
  - NOTE: This changes the previous behavior of `require` which added the local template directory to $LOAD_PATH automatically. `require_relative` should now be used to achieve the same result.
- Add `require_gem` keyword to template header to enforce compatibility between gem dependencies and the template. `require_gem` is similar to the way that [*Bundler*](http://bundler.io/) sets gem constraints with a Gemfile. It also loads the gem just like `require`.
- Add CLI option `--gems` to set gem version constraints. The `--gems` option can be used like [*Bundler*](http://bundler.io/)'s Gemfile.lock to enforce an exact version requirement. Gems still must be loaded with `require_gem` (see above) or `require`.
- Add `params_version` keyword to template header to enforce compatibility between the *Params* version and the template.
- Add annotation to output file to echo default and override values for parameters.
- Add cascading config file ".params-config" to set CLI options globally and for individual projects. See the example project for syntax.
- Add CLI options to set indent characters, escape sequence (e.g., comment characters like `!`), and option to toggle annotation on/off. See `--annotate`, `--indent`, `--esc-begin`, `--esc-end`, and `--esc-line` options.
- Other miscellaneous bug fixes.

## 0.4.0

- Fix bug with invalid byte sequences (bad encodings) in text files.
- Add `description` keyword to template header.
- Add `:inherit` attribute for parameters to copy attributes from another template.
- Add error checking for bad parameter names.
- Add error checking for duplicate parameter names.
- Update code for compatibility with Ruby 2.0.
- Separate *EnergyPlus*-specific code into a new *EPkit* gem.
- Restructure *Params* as a stand-alone Ruby gem without packaging a Ruby interpreter.
- Other miscellaneous bug fixes.


## 0.3.2

- Early version shared with closed beta testers.
