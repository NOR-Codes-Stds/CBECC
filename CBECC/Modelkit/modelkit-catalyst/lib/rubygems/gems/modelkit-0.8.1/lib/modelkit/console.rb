# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")

# Package the Ripl gems directly into the distribution to avoid a pesky dependency on the Bond gem.
# (Bond requires Xcode or Ruby DevKit in order to build the native extension.)
$LOAD_PATH << "#{Modelkit::GEM_DIR}/vendor/rubygems/gems/ripl-0.7.1/lib"
$LOAD_PATH << "#{Modelkit::GEM_DIR}/vendor/rubygems/gems/ripl-multi_line-0.3.1/lib"

require("ripl")
require("rubygems/patches/ripl-0.7.1/lib/ripl")
require("rubygems/patches/ripl-0.7.1/lib/ripl/shell")
require("ripl/multi_line")


# NOPUB Does this merit its own file? There is no class here (at least yet).
#       If no class, put it in top-level modelkit.rb file.


module Modelkit

  # Starts an interactive Ruby console session (like IRB or pry) in the context of the specified binding.
  # Use `Modelkit.console(binding)` to start from inside a script. Type `exit` at the console to return to the script.
  def self.console(target_binding = TOPLEVEL_BINDING.dup)
    options = {
      :binding => target_binding,
      :readline => true,
      :completion => {:readline => :ruby},  # Use pure Ruby Readline gem
      :history => nil,  # Don't use ".irb_history" option; it seems better to reset history for each new session
      :name => "modelkit",
      :prompt => "modelkit>> "
    }

    puts "Starting interactive Ruby console session."
    puts "Type 'exit' or Ctrl-D to end session."

    Ripl.config.merge!(options)
    Ripl::Runner.load_rc(Ripl.config[:riplrc])  # Load .riplrc configuration file
    Ripl.shell = Ripl::Shell.create(Ripl.config)

    # Ripl sends exceptions to STDERR. To ensure that exceptions are printed on
    # the screen for a console session, temporarily redirect STDERR to STDOUT.
    # (STDERR *is* redirected to a StringIO object elsewhere.)
    _stderr, $stderr = $stderr, $stdout
    retval = Ripl.shell.loop
    $stderr = _stderr  # Restore previous STDERR

    puts "Exiting console session."
    return(nil)
  end

end
