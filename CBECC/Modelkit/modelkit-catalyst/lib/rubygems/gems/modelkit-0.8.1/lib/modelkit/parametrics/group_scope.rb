# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")
require("modelkit/parametrics/group")
require("modelkit/parametrics/parameter")
require("modelkit/parametrics/rule")
require("modelkit/parametrics/import_scope")


module Modelkit
  module Parametrics

    class GroupScope

# Scopes just collect info and apply data to a "real" data structure.
# Could be Group, Template, or Interface.

# GroupScope => knows it's "context"/data object, i.e., Group
# Group => knows nothing about GroupScope

# NOPUB  # reverse order?  (template, group)  ?
      def initialize(group, template)
        @parent_group = group
        @template = template
      end

    private

      def group(key, options = {}, &block)
        group = Group.new(key, options)
        @parent_group.add_child(group)
        if (block_given?)
          scope = GroupScope.new(group, @template)
          scope.instance_exec(@template, &block)  # Template is passed as optional block argument
        end
        return(group)
      end

      def parameter(key, options = {})

# NOPUB DEPRECATE - preserved for short-term compatibility
        # Inherit options from a parameter in another template with syntax:
        #   parameter "name", :inherit=>"path:ref_name"
        #
        # If ref_name is omitted, the reference parameter is assumed to have the same name.
        # Any parameter options that are specified will override the reference parameter.
        if (options[:inherit])
          #puts "key=#{key} #{options}"
          ref_path, ref_key = options[:inherit].split(":")

          if (path = @template.resolve_path(ref_path))

            ref_template = Template.read(path, @template.options)
            ref_key ||= key

            ref_parameter = ref_template.parameters.find { |param| param.key == ref_key }
            if (ref_parameter)
              ref_options = {
                :name => ref_parameter.name,
                :description => ref_parameter.description,
                :domain => ref_parameter.domain,
                :default => ref_parameter.default
              }
              options = ref_options.merge(options)
            else
              puts "***PARAMETER INHERIT ERROR: cannot find reference parameter '#{ref_key}' for parameter '#{key}' in '#{path}'; it will be ignored in template '#{@template.path}'\n"
              return
            end
          else
            puts "***PARAMETER INHERIT ERROR: could not resolve path '#{ref_path}' for parameter '#{key}'; it will be ignored in template '#{@template.path}'\n"
            return
          end
        end
# END DEPRECATE

        parameter = Parameter.new(key, options)
        @parent_group.add_child(parameter)
        return(parameter)
      end

  #   options hash:  :key, :prefix, :parameters, :expression
  # condition expression: proc { hvac_type == "SZ-CAV" and fan_eff < 0.5 } do
      def rule(key, options = {}, &block)
        # condition could be:
        # - A hash, e.g., :param1 => value1, :param2 => value2, ...
        #   translates to the expression (param1 == value1 and param2 == value2 and ...)
        # - A proc/lambda, e.g., proc { param1 > value1 }  # evaluated at runtime
        # - Any expression evaluated immediately, e.g., Platform.windows? (for whatever reason)
        #   'true' means always do the block

        # Block is optional; rules with :inherit may not have any block.

        # Within this scope, before creating Rule object, check that:
        # - look up source Rule and apply to this Rule
        # - check that parameter keys are defined for this Template

        # method on Group?
        #prefix_chain = @receiver.ancestors.reduce(@receiver.prefix) { |s, group| group.prefix + s }
        #key = "#{prefix_chain}#{key}"
# possibly just pass in the simple key (no prefix)
# Rule knows it's parent/ancestors; it can always construct its full prefix on demand

        key = "#{@parent_group.prefix}#{key}"
        options[:prefix] = "#{@parent_group.prefix}#{options[:prefix]}"

        rule = Rule.new(key, options, &block)
        @parent_group.add_child(rule)
        return(rule)
      end

      # Allowed options: :group, :prefix
      def import(path, options = {}, &block)
# NOPUB could delegate this to a separate class for processing. not ImportScope, maybe Importer or ImportProcessor
#   The class would return an Array of objects to add to the interface.

        prefix = options[:prefix] ||= ""  # Needs error check
        rule_prefix = prefix  # Temporary hack

        if (options[:group])
          key = options[:group]
          group = Group.new(key, :prefix => prefix)
          @parent_group.add_child(group)
          prefix = ""  # Clear prefix because it is handled by the group
          import_group = group
        else
          import_group = @parent_group  # Import into current group
        end

        if (not full_path = @template.resolve_path(path))
          puts("Error: could not resolve path '#{path}' for import; it will be ignored in template '#{@template.path}'\n")
        else
          # This is not expensive because templates are cached.
          source_template = Template.read(full_path, @template.options)
          # Catch any errors reading/parsing template here.
          source_defs = source_template.parameters

          import_scope = ImportScope.new

          if (block_given?)
            filter_defs = []  # Nothing initially; everything must be included explicitly with `include` or `parameter`
            import_scope.instance_exec(@template, source_template, &block)
          else
            filter_defs = source_defs.dup  # Copy to avoid mutating with delete_if below
          end

          #if (import_scope.includes.empty?)
            # Must copy to avoid mutating with delete_if below.
            #filter_defs = source_defs.dup
          #else
            #filter_defs = []
            import_scope.includes.each do |filter|
              # Needs to loop over Parameters, Groups, and Rules
              filter_defs |= source_defs.select do |param_def|
                param_def.key =~ filter[:filter] and
                (filter[:required].nil? or param_def.required == filter[:required])
# NOPUB how many of these attributes are actually useful?
              end
            end
          #end

          import_scope.excludes.each do |filter|
# Needs to loop over Parameters, Groups, and Rules
            filter_defs.delete_if do |param_def|
# NOTE: this is identical to the logic for include--make a proc or method to stay DRY
              param_def.key =~ filter[:filter] and
              (filter[:required].nil? or param_def.required == filter[:required])
            end
          end

# source_defs is the full set of original source params => [<Parameter>, <Parameter>, ...]
# filter_defs here is the filtered set of source params => [<Parameter>, <Parameter>, ...]
# import_scope.parameters are the parameter overrides => [{options}, {options}, ...]

          import_scope.parameters.each do |param|
            param_def = source_defs.find { |source_def| source_def.key == param[:source]}
            if (param_def)
              filter_defs << param_def if (not filter_defs.include?(param_def))
            else
              puts("Error: unknown key '#{key}' for parameter in import for '#{path}'; it will be ignored in template '#{@template.path}'\n")
            end
          end

          # Check for overrides that don't match any source parameters (after filtering).
          # parameter_keys = import_scope.parameters.map { |param| param[:source] }
          # source_keys = filter_defs.map { |param| param.key }  # Already filtered
          # (parameter_keys - source_keys).each do |key|
          #   puts("Error: unknown key '#{key}' for parameter override in import for '#{path}'; it will be ignored in template '#{@template.path}'\n")
          #   parameter_keys.delete(key)
          # end

          filter_defs.each do |param_def|
            source_key = param_def.key  # this needs to be a String

# NOPUB This is awkward. Better to dup the source Parameter and apply any option
#   overrides individually.
            source_param_options = {
# NOPUB name should also get its own prefix
#   maybe description too
              :name => param_def.name,
              :description => param_def.description,
              :domain => param_def.domain,
              :default => param_def.default
            }

            # Apply any parameter overrides.
            override = import_scope.parameters.find { |hash| hash[:source] == source_key }
            override ||= {}  # hacky
            override.delete(:source)  # again hacky

            if (override[:key])
              key = "#{prefix}#{override.delete(:key)}"
            else
              key = "#{prefix}#{source_key}"
            end

# use this: source_options << override_options
# does merge! on source_options

# Parameter: add source or declaration parameter so that instance-parameters.csv can document where parameter is declared (which template)
            parameter = Parameter.new(key, source_param_options | override)
            import_group.add_child(parameter)
          end

          # Import all rules for now.
          # Should ultimately respond to include/exclude filters where :type => Rule.
          source_template.rules.each do |source_rule|
            source_key = "#{rule_prefix}#{source_rule.key}"
            #source_key = source_rule.key
            #source_options = {:prefix => "#{rule_prefix}#{prefix}"}
            source_options = {:prefix => rule_prefix}
            #source_options = {:prefix => prefix}
            if (source_rule.condition != true)
              # Rule will apply the prefix internally to parameter names.
              # Has to anyway to evaluate the block.
              source_options[:parameters] = source_rule.condition
            end

            # Apply any rule overrides.
            #override = import_scope.rules.find { |hash| hash[:source] == source_key }
            #override ||= {}  # hacky
            #override.delete(:source)  # again hacky

            # Rule overrides can't work the same as parameter overrides.
            # The rule has not even evaluated its block yet. It's not possible to
            # merge the rule actions (default, force, etc.) until after the rule
            # is created. Even then, the block is only evaluated dynamically on demand.
#puts "Rule.new"
#puts "  #{source_key}"
#puts "  #{source_options}"

            rule = Rule.new(source_key, source_options, &source_rule.block)
            import_group.add_child(rule)
          end

        end

        return(import_group)
      end

    end

  end
end
