# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.


module Modelkit
  class LookupTable

    def initialize(csv_path)
      @input_names = []
      @lookup_hash = {}

      if (not File.exists?(csv_path))
        raise "LookupTable.initialize: file not found #{csv_path}"
      end

      lines = File.readlines(csv_path)

      header_line = lines.shift
      @input_names = header_line.chomp.split(',')
      @input_names.pop  # Throw away last column (output values)

      for line in lines
        values = line.chomp.split(',')
        hash_key = values[0..-2].join('+')
        @lookup_hash[hash_key] = values[-1]
      end
    end


    # Look up output value from hash of input values.
    def lookup(input_hash)

      input_hash_copy = input_hash.dup

      # Sort 'input_hash' into an ordered array that matches the order of the column names.
      input_array = []
      for input_name in @input_names
        enum_value = input_hash[input_name.to_sym]
        if (enum_value)
          input_array << enum_value
          input_hash.delete(input_name.to_sym)
        else
          raise "LookupTable.lookup: missing input key '#{input_name}'"
        end
      end

      unknown_keys = input_hash.keys
      if (not unknown_keys.empty?)
        raise "LookupTable.lookup: unknown input keys '#{unknown_keys.join(', ')}'"
      end

      hash_key = input_array.join('+')
      value = @lookup_hash[hash_key]

      if (value.nil?)
        raise "LookupTable.lookup: bad input values; output value not found for #{input_hash_copy.inspect}"
      end

      return(value)
    end

  end
end
