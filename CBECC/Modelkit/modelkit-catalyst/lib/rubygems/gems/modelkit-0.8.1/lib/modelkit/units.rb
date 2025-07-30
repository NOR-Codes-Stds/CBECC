# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

# The new Units module is implemented using the Quantity class:
require("modelkit/units/quantity")


# Legacy Units module--this will be deprecated but is preserved for now for
# backward compatibility:
module Modelkit
  module Units  # Native units are in SI

    # Read as:  x * UNITS_CONSTANT = x in SI units

    IN = 0.0254
    FT = 0.3048
    DELTA_F = 5.0 / 9.0
    CFM = 1.0 / 2118.88
    GAL = 1.0 / 264.1721
    GPM = 1.0 / 15850.32
    FT_H2O = 2989.0
    IN_H2O = 249.089
    BTUH = 1.0 / 3.415179
    HP = 745.6999
    R_VALUE = 0.1761
    CONDUCTIVITY = 1.731
    DENSITY = 16.02
    CP = 4187

    # Derived
    FT2 = FT * FT
    FT3 = FT2 * FT

  end
end


class Float

  #attr_accessor :basis  # Small hack to be able to preserve the original value before conversion
  # Better approach might be to have Quantity class that knows its basis and can convert to any target unit system.


  # Pipe "|" operator declares a quantity with the desired units as the argument.
  # Returns a Float converted to native (SI) units.
  # Usage examples:
  #   23.0.|("ft") => returns 7.0104  (23 ft = 7.0104 m)
  #   or short and clean form:  23|'ft'
  #
  #  The operator "<-" might be used instead if paired with "->" as the "convert to" method.
  def |(units)

    #puts "Requested: #{self} #{units}"

    case units.downcase
    when "ft"
      value = self * Modelkit::Units::FT

    when "in"
      value = self * Modelkit::Units::IN

    when "ft2", "ft^2"
      value = self * Modelkit::Units::FT2

    when "ft3", "ft^3"
      value = self * Modelkit::Units::FT3

    when "f"
      # More complicated; replace with lambda later.
      value = (self - 32.0) * Modelkit::Units::DELTA_F

    when "deltaf"
      value = self * Modelkit::Units::DELTA_F

    when "cfm"
      value = self * Modelkit::Units::CFM

    when "gpm", "gal/min"
      value = self * Modelkit::Units::GPM

    when "gal/person/day"
      value = self * Modelkit::Units::GPM / 1440.0

    when "gal"
      value = self * Modelkit::Units::GAL

    when "ft h2o"
      value = self * Modelkit::Units::FT_H2O

    when "in h2o"
      value = self * Modelkit::Units::IN_H2O

    when "btuh"
      value = self * Modelkit::Units::BTUH

    when "hp"
      value = self * Modelkit::Units::HP

    when "1/ft2", "1/ft^2"
      value = self / Modelkit::Units::FT2

    when "w/ft2", "w/ft^2"
      value = self / Modelkit::Units::FT2

    when "lb/ft3", "lb/ft^3"
      value = self * Modelkit::Units::DENSITY

    when "btu/lb-f", "cp-ip"
      value = self * Modelkit::Units::CP

    when "cfm/ft2", "cfm/ft^2"
      value = self * Modelkit::Units::CFM / Modelkit::Units::FT2

    when "hr-ft2-r/btu", "r-ip", "r"
      value = self * Modelkit::Units::R_VALUE

    when "btu/hr-ft2-r", "u-ip", "u"
      value = self / Modelkit::Units::R_VALUE

    when "btu/hr-ft-r", "k-ip", "k"
      value = self * Modelkit::Units::CONDUCTIVITY

    when "btu/hr/ft", "btu/h/ft", "btuh/ft"
      value = self * Modelkit::Units::BTUH / Modelkit::Units::FT

    when "tr"  # Ton of Refrigeration (TR)
      value = self * Modelkit::Units::BTUH * 12000.0

# SI units are just passed through for now:
    when "m", "m2", "m3", "c", "deltac", "m3/s"
      value = self

    when "pa", "w", "w/m2", "shgc", "ach", "m/s", "m3/s-m2", "degrees", "1/m2"
      value = self

    else
      raise "Undefined units specified '#{units}'"
    end

    #value.basis = self  # Preserve a copy of the original value

    return(value)
  end

end


class Fixnum
  alias_method :original_pipe, :|
  # Redefines bitwise 'or' for integers, but probably seldom used in this context
  def |(units)
    if units.instance_of?("".class)
      return(self.to_f|units)
    else
      self.original_pipe(units) unless units.instance_of?("".class)
    end
  end
end
