# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/hierarchical")
require("modelkit/util")
require("modelkit/parametrics/rule_scope")


module Modelkit
  module Parametrics

    class Rule
      include Hierarchical

      # Override from Hierarchical
      def add_child(object)
        raise("Rule objects cannot add child nodes")
      end

      attr_reader :key, :prefix, :block
      attr_accessor :condition  # temporary!
      attr_reader :rule_scope

      def initialize(key, options, &block)
        if (not key.kind_of?(String))
          raise("no implicit conversion of #{key.class} into String for key argument")
        elsif (not Util.validate_variable_name(key))
          raise("invalid key '#{key}'")
        else
          @key = key
        end

# NOPUB Parameter saves its 'key' as a symbol--might want to do that here for consistency??
#   no Parameter should save key as String.
#   same here, so that this makes sense
#   rule = get_rule
#   Rule.new(rule.key, rule.options)

        @prefix = options[:prefix] ||= ""  # Needs error check
        @block = block  # Block is optional?
        @rule_scope = nil

  # NOPUB could just have :rule which is used with any type
  #  type is handled later
        if (options[:parameters])
          if (options[:parameters].kind_of?(Hash))
            @condition = Hash[ options[:parameters].map { |k, v| ["#{prefix}#{k}".to_sym, v] } ]
          else
            raise("expecting Hash for :parameters option in rule '#{options[:key]}'")
          end
        elsif (options[:expression])
          if (options[:expression].kind_of?(Proc))
            @condition = options[:expression]  # Proc
          else
            raise("expecting Proc for :expression option in rule '#{options[:key]}'")
          end
        else
          @condition = true  # If condition not specified, default to true
        end
              end

      # Test the rule based on current something.
      def test(parameters = {})
        # This is tricky:
        # - a Hash of parameters could be passed in, or
        # - a fully populated binding with the parameters instantiated as local variables (how to do)
        #     the Hash could still be used here, and then the binding is created in here real quick.
        #     Can probably use EvalScope right here.

        # Should have the full set of parameters populated by now.

        # parameters = { :a => 5, :b => 42, :c => 7}  # Full set of parameters from user
        # condition = { :b => 42 }

        result = true
        if (@condition.kind_of?(Hash))
          @condition.each do |key, value|
            # What to do if the key doesn't exist in the parameters? error or warning?

            # Prefix has already been applied.

            # Any wrong value will break it; all pairs in the condition must match the user parameters.
            if (parameters[key] != value)
              result = false
              break
            end
          end
        elsif (@condition.kind_of?(Proc))
          # eval it
          # need context of current parameter values

        else
          # Assume true
        end
        return(result)
      end

      def evaluate
        # Current parameters hash may optionally be passed in as a block argument.
        # This is why the block must be evaluated dynamically (instead of once at the beginning).
        #  *** caution: this starts to get less declarative!
        #      not sure if want to allow any math or if-else logic... messes up Citadel
        # rule(...) do |parameters|
        #   force :fan_type => parameters[:fan_type]  # this would be silly
        #   default :fan_eff => parameters[:other_fan_eff]  # this could happen
        #   warn "uh oh!" if (parameters[:other_fan_eff] < 0.4)

        @rule_scope = RuleScope.new(@prefix)
        if (@block)
          @rule_scope.instance_eval(&@block)  # Template calls this just before compose when new parameters are injected
        else
          #puts "no block"
        end

        return(@rule_scope)  # errors?
      end

# NOPUB For now, to_s and inspect are the same.
      def to_s
        return("#<Rule key=#{@key.inspect} prefix=#{@prefix.inspect} condition=#{@condition.inspect}>")
      end

      def inspect
        return(to_s)
      end

    end

  end
end
