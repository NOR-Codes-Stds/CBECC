# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit

# NOPUB this is problematic if a user tries to load Modelkit by doing something like this:
#   $LOAD_PATH.unshift("#{__dir__}/../modelkit/lib")
#   require("modelkit")  # skips loading the file as a Gem; just loads the file
#
# problematic because doesn't add extra directories to $LOAD_PATH, e.g., spec.require_paths = ["lib", "vendor"]


# if Gem.loaded_specs fails, try Gem::Specification.load("#{__dir__}/../modelkit.gemspec")

# Gem::Specification.load => doesn't change $LOAD_PATH; doesn't add to Gem.loaded_specs

# I'm looking for whatever loads the gemspec and activates a gem

# this almost works:
#   spec = Gem::Specification.load("modelkit.gemspec")
#   spec.activate     # adds spec.require_paths and gem dependencies to $LOAD_PATH
# .... still need to require the Gem:  require("modelkit")    still doesn't work

# fails:   require("modelkit")

# may be beneficial so that it can be loaded as if it were a Gem, just by require'ing the file.
# set ups all the $LOAD_PATH stuff

# modelkit-energyplus hits the same problem just for unit tests during development

# upside of this, is that if I can fix it, some things like test.libs = ["lib", "test", "vendor"]
# in Rake::TestTask can be eliminated, i.e., if the gem is handling this itself
# test.libs is just repeating stuff from the gemspec (still needs "test" though).


  GEM_SPEC = Gem.loaded_specs["modelkit"]
  GEM_DIR = GEM_SPEC.gem_dir.freeze
  VERSION = GEM_SPEC.version.to_s.freeze
  BUILD = GEM_SPEC.metadata["build"].freeze

  # Allow patched files for Ruby standard libraries to be found and loaded first in order
  # to override the original files.
  $LOAD_PATH.unshift("#{GEM_DIR}/vendor/ruby/patches")


# NOPUB moves into util.rb
  # Formats and cleans a path.
  def self.format_path(path, options = Hash.new)
    if (options[:a])
      formatted_path = ::File.expand_path(path)
    else
      formatted_path = Pathname.new(path).cleanpath  # remove consecutive slashes and useless dots
    end

    if (options[:q])
      formatted_path = '"' + formatted_path + '"'
    end

    # To do: return path with platform-specific separators.
    return(formatted_path)
  end

# I should be using this in the CLI in a lot of places!:
# No, wait, that's going other direction: standardizing path to forward slashes.
# Create minimal Path library to do either direction.
# and annoying stuff that I use Pathname for currently.

  # Helper method. Belongs in a utility module, not here.
  # Format a path with platform-specific separators.
  def self.platform_path(path)
    if (Platform.windows?)
      new_path = path.gsub('/', "\\")
    else
      new_path = path.dup
    end
    return(new_path)
    # or one liner:
    #return(Platform.windows? ? path.gsub('/', "\\") : path.dup)
  end


  # Helper method. Belongs in a utility module, not here.
  # Unescape any common escape characters that are relevant.
  def self.unescape(string)
    new_string = string.dup
    new_string.gsub!("\\n", "\n")
    new_string.gsub!("\\r", "\r")
    new_string.gsub!("\\t", "\t")
    return(new_string)
  end

end

require("pathname")
require("string")
require("hash")
require("boolean")

# NOPUB Won't need to require this until much later
require("modelkit/version")
require("modelkit/platform")
require("modelkit/units")
