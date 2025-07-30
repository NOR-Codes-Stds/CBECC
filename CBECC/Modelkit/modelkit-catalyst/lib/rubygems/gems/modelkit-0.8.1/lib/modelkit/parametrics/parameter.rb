# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("boolean")
#require("modelkit/interval")
require("modelkit/hierarchical")
require("modelkit/util")
require("modelkit/units/quantity")


# Alias Quantity to the top-level scope so that it can be used in short form in
# parameter declarations and other places.
Quantity = Modelkit::Units::Quantity


module Modelkit
  module Parametrics

    class Parameter
      include Hierarchical

      # Override from Hierarchical
      def add_child(object)
        raise("Parameter objects cannot add child nodes")
      end

      # This is the full variable name with all prefixes added.
      def variable_name
        var_name = key.to_s.dup  # depends if symbol or string
        ancestors.each { |object| var_name.prepend(object.prefix) }
        return(var_name)
      end


      OPTIONS = [:name, :description, :domain, :default, :required, :inherit]
      DEPRECATED_OPTIONS = [:fullname, :units, :type, :range, :valuelist]
      ALL_OPTIONS = OPTIONS + DEPRECATED_OPTIONS

      DOMAIN_TYPES = [Boolean, Integer, Numeric, String, Array, Object, Quantity]

      attr_reader :key, :name, :description, :domain, :default, :required
      attr_reader :options  #deprecate

      def initialize(key, options = Hash.new)
        if (not key.kind_of?(String))
          raise("no implicit conversion of #{key.class} into String for key argument")
        elsif (not Util.validate_variable_name(key))
          raise("invalid key '#{key}'")
        else
          @key = key
        end

# NOPUB do one-time warning about deprecated options
        # Check for bad keys in options hash.
# NOPUB This can be cleaner.
#   options.keys - ALL_OPTIONS => [bad options]
        options.each_key do |option_key|
          if (not ALL_OPTIONS.include?(option_key))
            puts("no option for '#{option_key}' in parameter definition")
            puts(" in parameter '#{key}'")
# NOPUB Needs full error path.
            # raise? or warn only?
            #options.delete(option_key)  # don't need to delete
          end
        end

        # If no name is specified, use the key string instead.
        @name = options[:name] ? options[:name].dup.freeze : key.dup.freeze

        @description = options[:description] ? options[:description].dup.freeze : "".freeze

        if (options[:domain].nil?)
          @domain = Object
        elsif (DOMAIN_TYPES.include?(options[:domain]))
          @domain = options[:domain]
        else
          raise("bad domain type '#{options[:domain]}' for parameter '#{key}'")
        end

        if (options.key?(:required))
          # If required is explicitly specified, use the value regardless of default attribute.
          @required = Boolean(options[:required])  # error check for true/false specifically; this forces it for now
        else
          # If required is not specified, set it based on presence of default attribute.
          # NOTE: This provides compatibility with old Parameter declaration.
          @required = (not options.key?(:default))
        end

        if (not options.key?(:default))
          # If default is not specified, do NOT check it against the domain.
          # (Required parameters usually do not have a default value, but allowing
          # the domain check on nil would fail.)
          @default = nil
        elsif (valid?(options[:default]))  # Check that default is in the domain
          @default = options[:default]
# NOPUB dup the value?  many basic types can't be duped: true/false, integers, floats
        else
          raise("default value '#{options[:default].inspect}' is not in the domain '#{options[:domain]}' for parameter '#{key}'")
        end

# DEPRECATE - preserved for short-term compatibility
        @options = {
          :inherit => options[:inherit] ? options[:inherit].dup.freeze : nil  # goes away; no attribute
        }
      end

      def required?
        return(@required)
      end

      def valid?(value)
        return(value.kind_of?(@domain))
      end

      def to_s
        return("#<Parameter key=#{@key.inspect} name=#{@name.inspect} domain=#{@domain.inspect} default=#{@default.inspect} required=#{@required} description=#{@description.inspect}>")
      end

      def inspect
        return(to_s)
      end

    end

  end
end
