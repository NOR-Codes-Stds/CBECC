# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("string")  # Monkey patch for case-insensitive compare
require("modelkit/util")
require("modelkit/units/quantity")


module Modelkit
  module EnergyPlus

    class AutosizeObject < BasicObject

      def class
        return(AutosizeObject)
      end

      def nil?
        return(false)
      end

      def kind_of?(object)
        if (not [::Class, ::Module].freeze.include?(object.class))
          ::Kernel.raise(::TypeError, "class or module required")
        end
        return([::Modelkit::Units::Quantity, ::Object].freeze.include?(object))
      end

      alias is_a? kind_of?

      def respond_to?(method, include_all = false)
        return(true)
      end

      def to_s
        return("Autosize")
      end

      # Returns a formatted representation for display. This is needed for
      # compatibility so that Autosize can be substituted for Quantity objects.
      def format
        return(to_s)
      end

      def inspect
        return(to_s)
      end

    end

  end
end


# Create the top-level constant that should be referenced for most use cases.
Autosize = Modelkit::EnergyPlus::AutosizeObject.new


module Modelkit
  module Util

    class <<self
      alias_method :value_from_string_core, :value_from_string

      # Convert a string (e.g., read from CSV) into a value.
      # This patches the core Modelkit method to support the Autosize object.
      def value_from_string(string)
        if (string.strip & "autosize")
          value = Autosize
        else
          value = value_from_string_core(string)
        end
        return(value)
      end
    end

  end
end
