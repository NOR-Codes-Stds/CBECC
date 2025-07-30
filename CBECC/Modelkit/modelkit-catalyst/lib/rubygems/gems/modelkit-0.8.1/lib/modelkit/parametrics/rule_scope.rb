# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/eval_scope")


module Modelkit
  module Parametrics

    class RuleScope < EvalScope  # maybe BasicObject? might make sense here; but do need Units available

      attr_reader :prefix, :parameter_keys, :defaulted, :restricted, :forced, :enabled, :disabled

      def initialize(prefix = "")
        # All this needs to happen in a temporary object (scope?)
        # instance separate from definition
        @prefix = prefix
        @parameter_keys = []  # Preserve order of original parameters
        @defaulted = {}
        @restricted = {}
        @forced = {}
        @enabled = []
        @disabled = []
      end

      def default(hash)
        # values must be a parameter hash
        # disallow if param has already been used with default/restrict/force
        # although default and restrict can be compatible
        #puts "defaulted: #{parameters}"

        inputs = Hash[ hash.map { |k, v| ["#{prefix}#{k}".to_sym, v] } ]
        @parameter_keys |= inputs.keys
        @defaulted.merge!(inputs)
        return(nil)
      end

      # restrict could ultimately reference a new Domain object that would override the one
      # in the original parameter definition. This would allow min/max limits to be changed,
      # as well as enums.
      def restrict(hash)
        # values must be a parameter hash
        # disallow if param has already been used with default/restrict/force
        # although default and restrict can be compatible
        #puts "restricted: #{parameters}"

        inputs = Hash[ hash.map { |k, v| ["#{prefix}#{k}".to_sym, v] } ]
        @parameter_keys |= inputs.keys
        @restricted.merge!(inputs)
        return(nil)
      end

      def force(hash)
        # values must be a parameter hash
        # disallow if param has already been used with default/restrict/force
        #puts "forced: #{parameters}"

        inputs = Hash[ hash.map { |k, v| ["#{prefix}#{k}".to_sym, v] } ]
        @parameter_keys |= inputs.keys
        @forced.merge!(inputs)
        return(nil)
      end

      def enable(*array)
        # disallow if also disabling the same keys
        #puts "enabled: #{keys}"

        keys = array.map { |k| "#{prefix}#{k}".to_sym }
        @parameter_keys |= keys
        @enabled.concat(keys)
        return(nil)
      end

      def disable(*array)
        # disallow if also enabling the same keys
        #puts "disabled: #{keys}"

        keys = array.map { |k| "#{prefix}#{k}".to_sym }
        @parameter_keys |= keys
        @disabled.concat(keys)
        return(nil)
      end

      # def note
      # def warn
      # def fail
      # def raise
      # def exit

    end

  end
end
