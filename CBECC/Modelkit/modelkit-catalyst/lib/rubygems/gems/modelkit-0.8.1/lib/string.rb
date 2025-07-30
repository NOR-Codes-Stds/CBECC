# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/version_constraint")


class String

if (Modelkit::VersionConstraint("< 2.4.0") === RUBY_VERSION)
#if (Gem::Version.new(RUBY_VERSION) < Gem::Version.new("2.4.0"))

  # Returns true if self and other are equal using a case-insensitive comparison.
  # Returns nil if other is not a String.
  # This method is monkey-patched into String for Ruby versions less than 2.4.0.
  # For Ruby 2.4.0 and greater, this method is built into the language.
  def casecmp?(other)
    # This is nearly the same implementation as Ruby 2.4.0 and later. The main
    # difference is that downcase(:fold) is used to perform a Unicode comparison
    # in later versions. The :fold option is not available before Ruby 2.4.0.
    # Full history of `casecmp?` here: https://bugs.ruby-lang.org/issues/12786
    return((other.class == String) ? (downcase == other.downcase) : nil)
  end

end

# Changed my mind! I was reading some of my code and came across this:
#   elsif (field & "false")
# I didn't remember what it was. I thought it was a logical operation! Looks like boolean op.
# I think the other operator would be more memorable and intuitive:
#   elsif (field =~ "false")
# At least has a sense of equality or matching because of relationship to Regexp.


  # Monkey patching String to have a case-insensitive comparison operator.
  # & operator is currently not used by String.
  # Bit strange because bitwise and would normally return a value, not just true/false; not really comparison op
  # NOTE: I like the =~ syntax better, but the override only starts working correctly in Ruby 2.2+
  def &(other)
    return(casecmp?(other))
  end

  # Used by String, but feasible to override because "abc" =~ "Abc" currently fails with "TypeError: type mismatch: String given"; in other words, not used for String-String comparison.
  # Nice because =~ _looks_ like a comparison operator (although it returns a position index for regexps).
  # Suggests "approximately equal". Case-insensitive comparison is also a kind of pattern match.
  # The F# language (at least) uses the same thing. Can't find other precedence though.
  # def =~(other)
  #   puts "inside override"
  #   # return(99)
  #
  #   if (other.kind_of?(String))
  #     result = casecmp(other).zero?
  #   else
  #     result = match_op(other)
  #   end
  #   return(result)
  # end

end
