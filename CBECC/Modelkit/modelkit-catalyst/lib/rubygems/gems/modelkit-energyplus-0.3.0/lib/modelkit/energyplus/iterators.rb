# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module EnergyPlus

    # The 'each' iterator requires a collection (e.g., Array, Hash, or Set) as an argument.
    # Much like the 'each' method of Enumerable objects, the iterator loops through a collection
    # evaluating its code block. Note that Arrays and Sets accept one block parameter for |value|;
    # Hashes accept two block parameters for |key, value|.
    #
    # The unique behavior of this iterator in the context of EnergyPlus is that if the block
    # yields a String object, the last iteration receives special treatment: The last comma in the
    # result string that is *not* part of an EnergyPlus comment is replaced with a semicolon to
    # terminate the EnergyPlus object syntax.
    #
    # Example from template:
    #
    # AirLoopHVAC:ZoneSplitter,
    #   <%= system_name %> Supply Air Splitter,  !- Name
    #   <%= system_name %> Zone Equipment Inlet Node,  !- Inlet Node Name
    # <% Modelkit::EnergyPlus.each(zone_names) do |zone_name| %>
    #   <%= zone_name %> ATU Inlet Node,  !- Outlet Node Name
    # <% end %>
    #
    # Example from stand-alone code:
    #
    # result_string = "AirLoopHVAC:ZoneSplitter,
    #   #{system_name} Supply Air Splitter,  !- Name
    #   #{system_name} Zone Equipment Inlet Node,  !- Inlet Node Name\n"
    # Modelkit::EnergyPlus.each(zone_names) do |zone_name|
    #   result_string << "  #{zone_name} ATU Inlet Node,  !- Outlet Node Name\n"
    # end
    #
    def self.each(collection, &block)
      return(call_iterator(:each, collection, &block))
    end


    # See the 'each' method for this module. This iterator accepts block parameters for |value, index|.
    def self.each_with_index(collection, &block)
      return(call_iterator(:each_with_index, collection, &block))
    end


    # Perform iteration and replace last comma with a semicolon for EnergyPlus object syntax.
    def self.call_iterator(method, collection, &block)
      result = nil
      collection.send(method) do |*args|
        result = yield(*args)
      end

      if (result.class == String)
        # Perform an in-place Regexp substitution to modify ERB's accumulator result string.
        # ERB holds a pointer to the result string and does not use the return value.
        # The result string contains all of the evaluated ERB content (so far) for this one template.
        # The result string does not include the content of any parent templates.

        # Use "positive lookahead" to match and replace last comma that is not part of a comment.
        #result.sub!(/,(?= [^,]*\z | ([^,]*!.*\n*)+\z )/x, ";")  # original--hangs

        #result.sub!(/,(?= [^,]*\z )/x, ";")  # works
        #result.sub!(/,(?= ([^,]*!.*\n*)+\z )/x, ";")  # hangs

        result.sub!(/,(?= \s*\z | \s*!.*\s*\z )/x, ";")
        # Above is efficient, but not perfect!
        # Fails for cases where extra lines after the last comma have comments containing commas:
        #   ...
        #   123,  !- comment
        #   ! more comments, and unhandled comma

      end

      return(collection)  # Same behavior as Enumerable iterator methods
    end

    private_class_method :call_iterator

  end
end
