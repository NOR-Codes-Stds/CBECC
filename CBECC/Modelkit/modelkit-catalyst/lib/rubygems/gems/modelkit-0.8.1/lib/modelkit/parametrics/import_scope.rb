# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")
require("modelkit/util")
require("modelkit/eval_scope")


module Modelkit
  module Parametrics

    # This is just the DSL context that collects the inputs. It does not act on the data.
    # The Interface uses the data. Want to minimize the methods that are exposed in the scope.
    class ImportScope < EvalScope

      attr_reader :includes, :excludes, :parameters, :rules

      def initialize
        super()
        @includes = []
        @excludes = []
        @parameters = []
        @rules = []
      end

    private

# Want to hide this method...
# how to keep it DRY without adding a new method in this scope...
# - could have anon method?
# - assign a proc to an instance method? class method?
# - class method?
      def validate(filter, options)  # validate_filter
        # Do all validation here
        # options without filter is allowed; just need to detect if first arg is a string or a hash.

        if (filter.kind_of?(String))
          filter = Util.pattern_to_regexp(filter)
        elsif (filter.kind_of?(Hash))
          # Filter string can be omitted
          options = filter  # this is clumsy
          filter = options[:filter] || //
          # is :filter allowed as a string: :filter => "ahu*"  ?
        end

# NOPUB all of the options together actually make the filter...
        options[:filter] = filter

        return(options)
      end

      def include(filter, options = {})
        options = validate(filter, options)
        @includes << options
        #puts "include #{options}"
        return(options)
      end

      def exclude(filter, options = {})
        options = validate(filter, options)
        @excludes << options
        #puts "exclude #{options}"
        return(options)
      end

      def parameter(source_key, options = {})
        # validate here? some validation should happen in Parameter class
# at least need to check for duplicate overrides; a key can't be used more than once
# rename to :origin instead of :source?   origin as in source, but also original
        options[:source] = source_key
        @parameters << options
        #puts "parameter #{options}"
        return(options)
      end

      def rule(source_key, options = {}, &block)
        puts "WARNING: Rule overrides in import are not yet supported."
        puts "  Rule '#{source_key}' was not overridden."
        #options[:source] = source_key
        #options[:block] = block
        #@rules << options
        #return(options)
      end

    end

  end
end
