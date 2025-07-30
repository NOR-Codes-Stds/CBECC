# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/util")
require("modelkit/hierarchical")


module Modelkit
  module Parametrics

# NOPUB Parameter, Group, Rule are all declarations. Should they have a common superclass?
#   not really "declaration"--that's something that happens in GroupScope.
#   TemplateEntity?
#   GroupElement
#     Group, Parameter, Rule

# Group must be able to canonicalize itself to a string
# - all imports get expanded; groups become explicit from imports
# - Rules get moved to end (or not?)
# - dynamic Rules are eliminated?
# - used by Citadel

    class Group
      include Hierarchical

      attr_reader :key, :prefix, :variables

      def initialize(key, options = {})
        if (not key.kind_of?(String))
          raise("no implicit conversion of #{key.class} into String for key argument")
        elsif (not Util.validate_variable_name(key))
          raise("invalid key '#{key}'")
        else
          @key = key
        end

        @prefix = options[:prefix] ||= ""  # Needs error check
        @variables = []  # Local variables for this Group and descendants
      end

      def add_child(object)
        if (variables.include?(object.key.to_sym))  # String or Symbol for key?
          # Find and report location of declaration: this will take some looping over children

          # Replace with `raise` when exception call chain is better
          puts("duplicate key '#{object.key}' in Group '#{key}'; first occurrence will be used\n")
          return(self)
        end

        variables << object.key.to_sym

        if (object.class == Group)
          variables.concat(object.variables.map { |symbol| "#{object.prefix}#{symbol}".to_sym })
        end

        super
      end

# Needed?
# implement with traverse_ instead from Hierarchical
      def find_child(key)
        #traverse_depth_first { |object| objects << object }

        return(children.find { |group| group.key == key })
      end

      def to_s
        return(inspect)
      end

      def inspect
        return("#<#{self.class} key=#{@key.inspect} prefix=#{@prefix.inspect}>")
      end

    end

  end
end
