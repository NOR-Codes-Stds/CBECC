# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/units/symbols")


module Modelkit
  module Units

    class Quantity

      include Comparable

      def initialize(magnitude = 0.0, units = "")
        if (not magnitude.kind_of?(Numeric))
          raise(TypeError, "no implicit conversion of #{magnitude.class} into Numeric for magnitude")
        end

        @magnitude = magnitude.to_f
        key = units.delete(" \\^")  # Strip spaces and caret characters (^ escaped with \\)

        if (not @units = Units::SYMBOLS[key])
          raise("unknown units '#{units}' specified")
        elsif (key == "K")
          @magnitude_si = @magnitude - 273.15  # Convert Kelvin to C
        elsif (key == "F")
          @magnitude_si = (@magnitude - 32.0) / 1.8  # Convert Fahrenheit to C
        elsif (key == "R")
          @magnitude_si = (@magnitude - 491.67) / 1.8  # Convert Rankine to C
        else
          @magnitude_si = @magnitude * @units.to_si
        end
      end

      def to_a
        return([@magnitude, @units])
      end

      def to_f
        return(@magnitude_si)
      end

      def to_s
        return(to_f.to_s)
      end

      def <=>(other)
        return(to_f <=> other)
      end

      # Unary operator.
      def +@
        return(to_f)
      end

      # Unary operator, negates a Quantity, e.g.,:
      #  q = 30["ft"]
      #  -q => -30.0
      def -@
        return(-to_f)
      end

      def +(other)
        return(to_f + other)
      end

      def -(other)
        return(to_f - other)
      end

      def *(other)
        return(to_f * other)
      end

      def /(other)
        # NOTE: Unnecessary to catch divide by zero; Float / 0 returns Infinity.
        return(to_f / other)
      end

      def **(other)
        return(to_f ** other)
      end

      def coerce(other)
        return([other, to_f])
      end

      def inspect
        return("#{@magnitude}['#{@units.name}']")
      end

# NOPUB not quite ready to be user-definable
#   there's one special case I'm worried about--when unitless, u_name = "" or maybe nil
#   user may want to pad out string in strange ways:   "  1200   mm"   don't want to just strip
#   special additions: digit grouping separators => 12,345   or  12.345  or  12 345
      def format
        return(sprintf("%g%s", @magnitude, @units.u_name && " #{@units.u_name}"))
      end

# NOPUB To Do:
      # Factory method to create a Quantity from a string representation.


    end

  end
end


# Starting with Ruby 2.4 Fixnum and Bignum are deprecated in favor of Integer.
# if (Modelkit::Version(RUBY_VERSION) < Modelkit::Version("2.4"))
#   integer_classes = [Fixnum, Bignum]
# else
#   integer_classes = [Integer]
# end

# Starting with Ruby 2.4 Fixnum and Bignum are merged into Integer.
if (1.class == Integer)
  integer_classes = [Integer]
else
  integer_classes = [Fixnum, Bignum]
end

integer_classes.each do |object|
  object.send(:alias_method, :bit, :[])  # Nth bit of binary representation
  object.send(:remove_method, :[])  # Remove so it can be inherited from Numeric

  # object.send(:alias_method, :bitwise_or, :|)
  # object.send(:remove_method, :|)  # Remove so it can be inherited from Numeric
end


class Numeric

  def to_q(units = "")
    return(Modelkit::Units::Quantity.new(self, units))
  end

  # Syntactic sugar to create a {Modelkit::Units::Quantity} object from a number, e.g., 33.0['ft'].
  # @return [Modelkit::Units::Quantity]
  def [](units = "")
    return(units.kind_of?(Integer) ? bit(units) : to_q(units))
  end

  # Syntactic sugar to create a {Modelkit::Units::Quantity} object from a number, e.g., 33.0|'ft'.
  # NOTE: This syntax will be deprecated in a future version--use [] instead.
  # @return [Modelkit::Units::Quantity]
  # def |(units = "")
  #   return(units.kind_of?(Integer) ? bitwise_or(units) : to_q(units))
  # end

end
