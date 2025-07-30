# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module Units

    # TO DO:
    #self.add_symbol(key, name, proper_name, type, to_si)
    #self.remove_symbol(key1, key2, key3, ...)
    #self.remove_all_symbols
    #self.symbols => dumps the hash  ?

    # Make it possible to override this externally!
    #   SYMBOLS constant makes that hard?

# check against EnergyPlus IDD conversion factors

      # Energy
# J, therm, cal, kcal, Btu, kBtu

# when "btu/lb-f", "cp-ip"
#   value = self * Modelkit::Units::CP
#
# when "hr-ft2-r/btu"
#   value = self * Modelkit::Units::R_VALUE
#
# when "btu/hr-ft2-r"
#   value = self / Modelkit::Units::R_VALUE
#
# when "btu/hr-ft-r", "k-ip", "k"
#   value = self * Modelkit::Units::CONDUCTIVITY
#
# when "btu/hr/ft", "btu/h/ft", "btuh/ft"
#   value = self * Modelkit::Units::BTUH / Modelkit::Units::FT

# Reference a NIST document as basis for all conversion factors.
# Nice reference for conversion factors:
# https://www.nist.gov/pml/special-publication-811/nist-guide-si-appendix-b-conversion-factors/nist-guide-si-appendix-b8
# https://physics.nist.gov/cuu/pdf/sp811.pdf

    # Temporarily append underscore to distinguish from legacy Units constants.
    # These constants will ultimately go away later.
    IN_ = 0.0254
    FT_ = 0.3048
    FT2_ = FT_ * FT_
    FT3_ = FT2_ * FT_
    DELTA_F_ = 5.0 / 9.0
    CFM_ = 1.0 / 2118.88
    GAL_ = 1.0 / 264.1721
    GPM_ = 1.0 / 15850.32
    FT_H2O_ = 2989.0
    IN_H2O_ = 249.089
    BTUH_ = 1.0 / 3.4121412858518  # old value was 1.0 / 3.415179  ??
    HP_ = 745.699872  # old value was 745.6999
    R_VALUE_ = 0.1761
    CONDUCTIVITY_ = 1.731
    DENSITY_ = 16.02
    CP_ = 4187

    Symbol = Struct.new(:name, :u_name, :full_name, :type, :to_si)
    # :name => canonical ASCII abbreviation
    # :u_name => Unicode abbreviation (with superscripts, special characters)
    # :full_name => full descriptive name
    # :type => dimensional group
    # :to_si => conversion factor to SI units system

    # The Hash keys below should be normalized to strip spaces and carets (^).
    SYMBOLS = {
      # Dimensionless
      "" => Symbol.new("", nil, "scalar", "dimensionless", 1.0),
      "%" => Symbol.new("%", "%", "percent", "dimensionless", 0.01),

      # Time
      "s" => Symbol.new("s", "s", "second", "time", 1.0),
      "min" => Symbol.new("min", "min", "minute", "time", 60.0),
      "hr" => Symbol.new("hr", "hr", "hour", "time", 60.0 * 60.0),
      "day" => Symbol.new("day", "day", "day", "time", 60.0 * 60.0 * 24.0),
      "yr" => Symbol.new("yr", "yr", "year", "time", 60.0 * 60.0 * 24.0 * 365.0),

      # Mass
      "g" => Symbol.new("g", "g", "gram", "mass", 0.001),
      "kg" => Symbol.new("kg", "kg", "kilogram", "mass", 1.0),

      "lb" => Symbol.new("lb", "lb", "pound", "mass", 0.45359237),

      # Length
      "mm" => Symbol.new("mm", "mm", "millimeter", "length", 0.001),
      "cm" => Symbol.new("cm", "cm", "centimeter", "length", 0.01),
      "m" => Symbol.new("m", "m", "meter", "length", 1.0),
      "km" => Symbol.new("km", "km", "kilometer", "length", 1000.0),

      "in" => Symbol.new("in", "in", "inch", "length", IN_),
      "ft" => Symbol.new("ft", "ft", "foot", "length", FT_),
      "yd" => Symbol.new("yd", "yd", "yard", "length", FT_ * 3.0),
      "mi" => Symbol.new("mi", "mi", "mile", "length", FT_ * 5280.0),

      # Area
      "cm2" => Symbol.new("cm2", "cm\u00b2", "square centimeter", "area", 1.0e-4),
      "m2" => Symbol.new("m2", "m\u00b2", "square meter", "area", 1.0),
      "km2" => Symbol.new("km2", "km\u00b2", "square kilometer", "area", 1.0e6),

      #in2
      "ft2" => Symbol.new("ft2", "ft\u00b2", "square foot", "area", FT2_),
      #yd2
      #mi2

      # Volume
      "cm3" => Symbol.new("cm3", "cm\u00b3", "cubic centimeter", "volume", 1.0e-6),
      "m3" => Symbol.new("m3", "m\u00b3", "cubic meter", "volume", 1.0),

      "L" => Symbol.new("L", "L", "liter", "volume", 0.001),

      # in3
      "ft3" => Symbol.new("ft3", "ft\u00b3", "cubic foot", "volume", FT3_),
      # yd3

      "gal" => Symbol.new("gal", "gal", "gallon", "volume", GAL_),  # 1 gal == 231 in3


      # Temperature
      "C" => Symbol.new("C", "°C", "Celsius", "temperature", 1.0),
      # NOTE: Kelvin, Fahrenheit, and Rankine are converted explicitly in Quantity
      "K" => Symbol.new("K", "K", "kelvin", "temperature"),
      "F" => Symbol.new("F", "°F", "Fahrenheit", "temperature"),
      "R" => Symbol.new("R", "°R", "Rankine", "temperature"),

      "deltaC" => Symbol.new("deltaC", "\u2206C", "Celsius", "temperature difference", 1.0),
      "deltaK" => Symbol.new("deltaK", "\u2206K", "kelvin", "temperature difference", 1.0),
      "deltaF" => Symbol.new("deltaF", "\u2206F", "Fahrenheit", "temperature difference", DELTA_F_),
      "deltaR" => Symbol.new("deltaR", "\u2206R", "Rankine", "temperature difference", DELTA_F_),

      # Mass Density
      "kg/m3" => Symbol.new("kg/m3", "kg/m\u00b3", "kilogram per cubic meter", "mass density", 1.0),

      "lb/ft3" => Symbol.new("lb/ft3", "lb/ft\u00b3", "pound per cubic foot", "mass density", 1.0),

      # Specific Volume


      # Resistance/Conductance
      "R-SI" => Symbol.new("R-SI", "R-SI", "R-Value (SI)", "thermal resistance", 1.0),
      "R-IP" => Symbol.new("R-IP", "R-IP", "R-Value (IP)", "thermal resistance", R_VALUE_),
# check this: maybe suggest a small r and small u ?
# distinguish from R = Rankine

      "U-SI" => Symbol.new("U-SI", "U-SI", "U-Value (SI)", "thermal conductance", 1.0),
      "U-IP" => Symbol.new("U-IP", "U-IP", "U-Value (IP)", "thermal conductance", 1.0 / R_VALUE_),


      # other
      "1/m2" => Symbol.new("1/m2", "\u00b9/m\u00b2", "unit per square meter", "intensity", 1.0),

      "1/ft2" => Symbol.new("1/ft2", "\u00b9/ft\u00b2", "unit per square foot", "intensity", 1.0 / FT2_),

      "W/m" => Symbol.new("W/m", "W/m", "watt per meter", "linear power intensity", 1.0),

      "W/ft" => Symbol.new("W/ft", "W/ft", "watt per foot", "linear power intensity", 1.0 / FT_),

# power intensity?
      "W/m2" => Symbol.new("W/m2", "W/m\u00b2", "watt per square meter", "power intensity", 1.0),

      "W/ft2" => Symbol.new("W/ft2", "W/ft\u00b2", "watt per square foot", "power intensity", 1.0 / FT2_),

      # Volumetric Specific Power
      "W/m3-s" => Symbol.new("W/m3-s", "W/m\u00b3-s", "watt per cubic meter per second", "volumetric specific power", 1.0),
      "kW/m3-s" => Symbol.new("kW/m3-s", "kW/m\u00b3-s", "kilowatt per cubic meter per second", "volumetric specific power", 1000.0),
      "W/L-s" => Symbol.new("W/L-s", "W/L-s", "watt per liter per second", "volumetric specific power", 1000.0),

      "W/CFM" => Symbol.new("W/CFM", "W/CFM", "watt per cubic feet per minute", "volumetric specific power", 1.0 / CFM_),
      "W/cfm" => Symbol.new("W/CFM", "W/CFM", "watt per cubic feet per minute", "volumetric specific power", 1.0 / CFM_),
      "kW/CFM" => Symbol.new("kW/CFM", "kW/CFM", "kilowatt per cubic feet per minute", "volumetric specific power", 1000.0 / CFM_),
      "kW/cfm" => Symbol.new("kW/CFM", "kW/CFM", "kilowatt per cubic feet per minute", "volumetric specific power", 1000.0 / CFM_),

      "HP/CFM" => Symbol.new("hp/CFM", "hp/CFM", "mechanical horsepower per cubic feet per minute", "volumetric specific power", HP_ / CFM_),
      "hp/cfm" => Symbol.new("hp/CFM", "hp/CFM", "mechanical horsepower per cubic feet per minute", "volumetric specific power", HP_ / CFM_),

      # Volumetric Flow
      "m3/s" => Symbol.new("m3/s", "m\u00b3/s", "cubic meter per second", "volumetric flow", 1.0),

      "cfm" => Symbol.new("CFM", "CFM", "cubic feet per minute", "volumetric flow", CFM_),
      "CFM" => Symbol.new("CFM", "CFM", "cubic feet per minute", "volumetric flow", CFM_),

      "gpm" => Symbol.new("GPM", "GPM", "gallon per minute", "volumetric flow", GPM_),
      "GPM" => Symbol.new("GPM", "GPM", "gallon per minute", "volumetric flow", GPM_),
      "gal/min" => Symbol.new("GPM", "GPM", "gallon per minute", "volumetric flow", GPM_),

      "gal/day" => Symbol.new("gal/day", "gal/day", "gallon per day", "volumetric flow", GPM_ / 1440.0),


      # Area Volumetric Flow
      "m3/s-m2" => Symbol.new("m3/s-m2", "m\u00b3/s-m\u00b2", "cubic meter per second per square meter", "area volumetric flow", 1.0),

      "cfm/ft2" => Symbol.new("CFM/ft2", "CFM/ft\u00b2", "cubic feet per minute per square foot", "area volumetric flow", CFM_ / FT2_),
      "CFM/ft2" => Symbol.new("CFM/ft2", "CFM/ft\u00b2", "cubic feet per minute per square foot", "area volumetric flow", CFM_ / FT2_),

       # Pressure
      "Pa" => Symbol.new("Pa", "Pa", "pascal", "pressure", 1.0),
      "kPa" => Symbol.new("kPa", "kPa", "kilopascal", "pressure", 1000.0),

      "atm" => Symbol.new("atm", "atm", "standard atmosphere", "pressure", 101_325.0),

      "mmH2O" => Symbol.new("mm H2O", "mm H\u2082O", "millimeter of water", "pressure", 9.80665),
      "mmWC" => Symbol.new("mm H2O", "mm H\u2082O", "millimeter of water", "pressure", 9.80665),
      "mmWG" => Symbol.new("mm H2O", "mm H\u2082O", "millimeter of water", "pressure", 9.80665),
      "cmH2O" => Symbol.new("cm H2O", "cm H\u2082O", "centimeter of water", "pressure", 98.0665),
      "cmWC" => Symbol.new("cm H2O", "cm H\u2082O", "centimeter of water", "pressure", 98.0665),
      "cmWG" => Symbol.new("cm H2O", "cm H\u2082O", "centimeter of water", "pressure", 98.0665),

      "inH2O" => Symbol.new("in H2O", "in H\u2082O", "inch of water", "pressure", IN_H2O_),
      "inWC" => Symbol.new("in H2O", "in H\u2082O", "inch of water", "pressure", IN_H2O_),  # water column
      "inWG" => Symbol.new("in H2O", "in H\u2082O", "inch of water", "pressure", IN_H2O_),  # water gauge
      "ftH2O" => Symbol.new("ft H2O", "ft H\u2082O", "foot of water", "pressure", FT_H2O_),
      "ftWC" => Symbol.new("ft H2O", "ft H\u2082O", "foot of water", "pressure", FT_H2O_),
      "ftWG" => Symbol.new("ft H2O", "ft H\u2082O", "foot of water", "pressure", FT_H2O_),

      # Power
      "w" => Symbol.new("W", "W", "watt", "power", 1.0),
      "W" => Symbol.new("W", "W", "watt", "power", 1.0),

      "kw" => Symbol.new("kW", "kW", "kilowatt", "power", 1000.0),
      "kW" => Symbol.new("kW", "kW", "kilowatt", "power", 1000.0),
      "KW" => Symbol.new("kW", "kW", "kilowatt", "power", 1000.0),

      "MW" => Symbol.new("MW", "MW", "megawatt", "power", 1.0e6),

      "GW" => Symbol.new("GW", "GW", "gigawatt", "power", 1.0e9),

      "btuh" => Symbol.new("BTUh", "BTU/h", "BTU per hour", "power", BTUH_),
      "BTUh" => Symbol.new("BTUh", "BTU/h", "BTU per hour", "power", BTUH_),
      "BTUH" => Symbol.new("BTUh", "BTU/h", "BTU per hour", "power", BTUH_),

      "MBH" => Symbol.new("MBH", "MBH", "thousand BTU per hour", "power", BTUH_ * 1000.0),

      "hp" => Symbol.new("hp", "hp", "mechanical horsepower", "power", HP_),
      "HP" => Symbol.new("hp", "hp", "mechanical horsepower", "power", HP_),

      "TR" => Symbol.new("TR", "TR", "ton refrigeration", "power", BTUH_ * 12000.0),

      # Speed
      "m/s" => Symbol.new("m/s", "m/s", "meter per second", "speed", 1.0)
    }

    def self.symbols
      return(SYMBOLS.map { |symbol| "#{symbol.name} => #{symbol.full_name} (#{symbol.type})" } )
    end

  end
end
