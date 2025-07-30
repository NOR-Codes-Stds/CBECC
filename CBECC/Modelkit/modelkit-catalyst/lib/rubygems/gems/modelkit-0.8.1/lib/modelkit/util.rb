# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("boolean")
require("string")  # Monkey patch for case-insensitive compare
require("modelkit/units")

# NOPUB Move other stuff here out of modelkit.rb (random path stuff)


module Modelkit
  module Util

    # Convert a string (e.g., read from CSV) into a value.
    # NOTE: This uses experimental monkey-patched String operator.
    def self.value_from_string(string)
      # raise error if not String
      short_string = string.strip
# NOPUB can avoid creating another String by including spaces in regex  /\s*.../
# entire thing here can be a case statement with /regex/ matches

# NOPUB this would discard any meaningful empty strings, e.g., "   "
      # Convert field string to implicit data type.
      if (true if Integer(short_string) rescue false)
# NOPUB better to test this with regex; rescue is expensive
#  what does CSV do?
        value = short_string.to_i
      elsif (true if Float(short_string) rescue false)
        value = short_string.to_f
      elsif (short_string == "nil")
        value = nil
# NOPUB this may change to a case-insensitive regex anyway
#  but regex is slower
      elsif (short_string & "false")  # Uses experimental monkey-patched String operator
        value = false
      elsif (short_string & "true")  # Could do casecmp().zero? for better performance
        value = true
      elsif (match = short_string.match(/^\s* ( [+-]?\d+\.?\d* | [+-]?\.\d+ | [+-]?\d+\.?\d*[eE][+-]?\d+ | [+-]?\.\d+[eE][+-]?\d+ ) \s*\|\s* ['"](.*)['"] \s*$/x))
        # Matches legacy units operator: NUMBER | 'UNITS'
# NOPUB should reference regex constants defined earlier for Integer and Float
#   INTEGER = /^\s* ( ([+-]?\d+) | [+-]?\d+[eE][+-]?\d+) \s*$/x
#   FLOAT =
#   could use / ... e ... /i  to handle [eE] ?  probably not as efficient
# NOTE: should change to [0-9] instead of \d
#   [0-9] ensures ASCII numbers only; \d might include digits in other scrips
        # This is close but not perfect; only missing underscore notation: 1_000
        # Not too hard to add: Ruby just basically ignores them because this works: 10_00_0
        number, units = match.captures
        value = number.to_f | units  # Legacy pipe operator

      elsif (match = short_string.match(/^\s* ( [+-]?\d+\.?\d* | [+-]?\.\d+ | [+-]?\d+\.?\d*[eE][+-]?\d+ | [+-]?\.\d+[eE][+-]?\d+) \s*\[\s* ['"](.*)['"] \s*\]\s*$/x))
        # Matches new units operator: NUMBER ['UNITS']
        number, units = match.captures
        value = Units::Quantity.new(number.to_f, units)
        #value = number.to_q(units)

      # Date!

      # Interval!

      else
# NOPUB should empty string be caught here?
        # Must be a String if it gets here; leading/trailing whitespace is preserved.
        value = string.dup
      end
      return(value)
    end

    # Helper routine to convert a string pattern to a Regexp. The pattern is a simplification
    # of a regular expression similar to a "glob" pattern or gitignore pattern.
    # Some examples:
    #   "test" => /^test$/
    #   "aaa*" => /^aaa.*$/
    #   "*aaa|bbb*" => /^.*aaa|bbb.*$/
    def self.pattern_to_regexp(string)
      # Consider allowing only alphanumerics and * and |

      return(Regexp.new("^#{string.gsub("*", ".*")}$"))
    end

    # Validate a string to see if it is an allowable Ruby local variable name.
    # Alphanumerics and underscores are allowed, but the string cannot begin with
    # a number or uppercase letter.
    def self.validate_variable_name(string)
      return(Boolean(string =~ /^[a-z_][a-zA-Z_0-9]*$/))
    end

  end
end
