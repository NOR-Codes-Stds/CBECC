# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")
require("modelkit/parametrics/template")
require("fileutils")
require("csv")


module Modelkit

  module Parametrics
    # This module should not depend on the current working directory in any way.
    # Don't use 'Dir.pwd' or 'File.expand_path' without an explicit reference directory.

# NOPUB Not sure this is the right place for `template_compose`.
#   Do like the idea of having "porcelain" calls that you can make in Ruby that are equivalent
#   to the CLI. But maybe these should belong to CLI module?
#
#   Modelkit::CLI.template_compose(arguments, options)  # arguments can be object or Array
#
# In that case, it should also apply the .modelkit-config options. This is useful.
#
# This is a "porcelain" call. (The underlying API calls are the "plumbing"--to borrow from Git).
# The CLI is a wrapper on the porcelain calls.

    # Compose a template with parameter values and files.
    def self.template_compose(path, options)
      if (options[:output])
        output_path = options[:output]
      else
        # default output path based on template path
        output_path = "#{File.dirname(path)}/#{File.basename(path, ".*")}.out"
      end
# begin
      # Create the full directory path if it doesn't exist yet.
      FileUtils.mkdir_p(File.dirname(output_path))

      # Open output file here to ensure that old content is cleared out at the beginning
      # in case compose fails for some reason. This prevents the user from being misled
      # into thinking that the command actually succeeded, if there is old content.
      # Opening here is also useful for locking access or streaming content.
      output_file = File.open(output_path, "w")
# rescue
# NOPUB Should handle errors here: bad path, no write permission, etc.

# NOPUB NOTE: global_options don't find their way into this method call. The CLI preprocesses them,
#  namely: --ignore-config, --load-paths, --gems
#  That just means this method can't stand alone and emulate a terminal command.
#  --ignore-config is maybe most relevant, if this is claiming to apply .modelkit-config normally (which it does not)
#
# Solution: Need a method to invoke here first to apply all of the global options. That method would be called from every

      # Type check these options
# Check for invalid options

      #puts "parametrics.rb: template_compose #{File.basename(path)}, options[:esc_begin].to_s => #{options[:esc_begin].to_s.encoding}"  # =>

# NOPUB These should be checked _inside_ of Template, not here
#  Then any exceptions are rescued a level above at the CLI.
      compose_options = {}
      compose_options[:annotate] = options[:annotate]  # Boolean only
      compose_options[:indent] = Modelkit.unescape(options[:indent].to_s)  # String only
      compose_options[:esc_begin] = Modelkit.unescape(options[:esc_begin].to_s)  # String only
      compose_options[:esc_line] = Modelkit.unescape(options[:esc_line].to_s)  # String only
      compose_options[:esc_end] = Modelkit.unescape(options[:esc_end].to_s)  # String only

      template_opts = {}
# NOPUB what's up with the unescaping again?
#   I guess tab (\t) could be used for indent.

      if (options[:dirs])
        # Check directories for bad paths  ? or not
        # NOTE: dirs must be passed to both sets of options.
        compose_options[:dirs] = options[:dirs]
        template_opts[:dirs] = options[:dirs]
      end

      if (options[:environment])
        template_opts[:environment] = options[:environment]
      end

      if (options[:parameters])
        template_opts[:environment] = options[:parameters]
      end

      template = Template.read(path, template_opts)

# NOPUB Allow for JSON format--should be easy


      parameters = Hash.new

      if (options[:files] and not options[:files].empty?)
      # Construct parameters Hash
      # A Hash is easier to construct and process than a closure for now.
      # This should reuse a routine from Template.

# NOPUB better to split on operating system separators?
#   Use : for Mac, ; for Windows (prob is Win uses :)
         options[:files].each { |file_path|
          # Check for bad path
          string = File.read(file_path)
          #some_parameters = Hash.new
          # hash_string = "some_parameters = {\n" + hash_string + "\n}\n"
          # eval(hash_string)
          # parameters.merge!(some_parameters)

          # Fix invalid byte sequences.
          if (not string.valid_encoding?)
            #puts "parametrics.rb: fix encoding => #{File.basename(file_path)}"
            string = string.encode("UTF-16be", :invalid => :replace, :replace => "?").encode("UTF-8") # check
          end

# NOPUB could parse with JSON lib instead?
# strip comments first
# JSON.parse(hash_as_string.gsub("=>", ":").gsub(":nil,", ":null,"))
          hash = eval("{ #{string} }")

# NOPUB rescue formatting errors
          parameters.merge!(hash)
# NOPUB is merge even needed here? parameters is just an empty Hash up to here
        }
      end

      if (options[:parameters])
        parameters.merge!(options[:parameters])  # Individual parameters override parameter files
      end

# NOPUB is this needed anymore? did I change my mind and decide `require` should work the same as in a normal
#   Ruby script? i.e., require doesn't work in your same dir?
      # Prepend root template directory to load path so that 'require' always works relative to the root template path.
      # NOTE: This allows files to be loaded from a fixed location relative to the project root, e.g., project/scripts.
      # For some reason, 'require' with parent directories (../../file.rb) doesn't work evaluated against load paths.
      # root_dir = File.dirname(path)
      # saved_load_paths = $LOAD_PATH
      # $LOAD_PATH.unshift(root_dir)

      #puts "parametrics.rb: #template_compose, output #{File.basename(path)} => #{output.encoding}"  # => US-ASCII
      compose_options[:inputs] = parameters
      template_scope = template.compose(compose_options)

      #$LOAD_PATH.replace(saved_load_paths)  # Prevent local template dirs from accumulating

# begin
      output_file.write(template_scope.local_output)
      output_file.close
# rescue
# NOPUB Should handle errors here: hard drive might be full, etc.

      # Optional: Write out audit CSV file of parameter definitions.
      params_path = "#{File.dirname(output_path)}/#{File.basename(output_path, ".*")}-parameters.csv"
      CSV.open(params_path, 'w') do |csv|
        # Write Byte Order Mark (BOM) for UTF-8 encoding to help Excel to recognize
        # and render Unicode UTF-8 characters correctly.
        csv.to_io.write("\uFEFF")

        csv << ["key", "name", "default", "domain", "description"]
        template.parameters.each do |param|
          default = param.default
          if (default.kind_of?(Units::Quantity))
            display_default = default.format
          elsif (default.kind_of?(Boolean))
            # Add space at the end of true/false so that Excel does not
            # automatically format as TRUE/FALSE.
            display_default = "#{default} "
          else
            display_default = default.inspect
          end

          if (param.domain == Units::Quantity)
            display_domain = "Quantity"  # Otherwise displays Modelkit::Units::Quantity
          else
            display_domain = param.domain
          end

          csv << [param.variable_name, param.name, display_default, display_domain, param.description]
        end
      end

      # Optional: Write out audit CSV file of parameter values.
      # NOTE: This is a temporary hack.
      #   Big downside here is that all the warnings about parameters and rules get duplicated.
      begin
        _stdout = $stdout
        $stdout = StringIO.new  # Capture STDOUT so that warnings are not duplicated - big kludge
        _, audit_string = template.normalize(parameters)
      ensure
        $stdout = _stdout
      end

      inputs_path = "#{File.dirname(output_path)}/#{File.basename(output_path, ".*")}-inputs.csv"
      CSV.open(inputs_path, 'w') do |csv|
        # Write Byte Order Mark (BOM) for UTF-8 encoding to help Excel to recognize
        # and render Unicode UTF-8 characters correctly.
        csv.to_io.write("\uFEFF")

        csv << ["hint", "parameter", "value", "source"]

        audit_string.each_line do |line|
          matches = line.scan(/^(.)\s(.*)\s=\s(.*)\s\((.*)\)/)
          if (not matches.empty?)
            array = matches.first
            hint = array[0].strip
            parameter = array[1]
            source = array[3]

            quantity = array[2].scan(/^([0-9]\S*)\s(.*)$/)
            if (quantity.empty?)
              value = array[2]
              units = " "  # Blank space hides overflow for longer values
            else
              value, units = quantity.first
            end

            if (value == "true" or value == "false")
              # Add space at the end of true/false so that Excel does not
              # automatically format as TRUE/FALSE.
              display_value = "#{value} "
            else
              display_value = "#{value} #{units}".strip
            end

            csv << [hint, parameter, display_value, source]
          end
        end
      end

      # Optional: Write out audit CSV file of rules.
      group_keys = []
      groups = Hash.new
      parameters = Hash.new
      template.rules.each do |rule|
        # Should be a Hash; ignore expressions for now
        test_condition = rule.condition  # {:atu_type=>"VAV", :atu_reheat_coil_type=>"NONE"}
        if (test_condition.kind_of?(Boolean))
          test_key = ""
        else
          symbols = test_condition.keys.map { |key| key.inspect }  # [":atu_type", ":atu_reheat_coil_type"]
          test_key = symbols.join(", ")  # ":atu_type, :atu_reheat_coil_type"
        end

        # Sort rules into mutually exclusive groups.
        if (not group_keys.include?(test_key))
          group_keys << test_key  # Save ordered list of all unique test_key values
          groups[test_key] = []
          parameters[test_key] = []
        end

        groups[test_key] << rule  # Append to this group

        rule_scope = rule.evaluate  # Shouldn't have to call evaluate again here

        parameters[test_key] |= rule_scope.parameter_keys  # Collect superset of all parameters
      end

      # Loop over groups and write output CSV.
      rules_path = "#{File.dirname(output_path)}/#{File.basename(output_path, ".*")}-rules.csv"
      CSV.open(rules_path, 'w') do |csv|
        # Write Byte Order Mark (BOM) for UTF-8 encoding to help Excel to recognize
        # and render Unicode UTF-8 characters correctly.
        csv.to_io.write("\uFEFF")

        group_keys.each do |test_key|
          rule_keys = groups[test_key].map { |rule| rule.key }
          csv << [nil, *rule_keys]

          test_rules = groups[test_key].map do |rule|
            if (rule.condition.kind_of?(Boolean))
              "#{rule.condition} "
            elsif (rule.condition.length == 1 and rule.condition.values.first.kind_of?(Boolean))
              # Add space at the end of true/false so that Excel does not
              # automatically format as TRUE/FALSE. Only needed if there is one
              # condition value.
              "#{rule.condition.values.first} "
            else
              (rule.condition.values.map { |value| value.inspect } ).join(", ")
            end
          end
          csv << ["#{test_key} =>", *test_rules]  # Group label and rule column headers

          parameters[test_key].each do |parameter_key|
            row = [parameter_key]

            # Look up default value in template interface.
            parameter_default = nil
            template.parameters.each do |parameter|
              if (parameter.key == parameter_key)
                parameter_default = parameter.default
                break
              end
            end

            # Loop over rules and fill in values and symbol/formatting for state for this row.
            groups[test_key].each do |rule|
              if (rule.rule_scope.disabled.include?(parameter_key))
                row << "\u00d7"  # ×

              elsif (rule.rule_scope.forced.key?(parameter_key))
                value = rule.rule_scope.forced[parameter_key]
                if (value.kind_of?(Units::Quantity))
                  display_value = value.format
                #elsif (value.kind_of?(Boolean))
                  # Not needed because symbol prevents Excel from upcasing.
                else
                  display_value = value.inspect
                end
                row << "\u25fc #{display_value}"  #  ◼

              elsif (rule.rule_scope.defaulted.key?(parameter_key))
                value = rule.rule_scope.defaulted[parameter_key]
                if (value.kind_of?(Units::Quantity))
                  display_value = value.format
                #elsif (value.kind_of?(Boolean))
                  # Not needed because symbol prevents Excel from upcasing.
                else
                  display_value = value.inspect
                end
                row << "\u2022 #{display_value}"  # •

              elsif (parameter_default)
                value = parameter_default  # Default value from template interface

                if (value.kind_of?(Units::Quantity))
                  display_value = value.format
                elsif (value.kind_of?(Boolean))
                  # Add space at the end of true/false so that Excel does not
                  # automatically format as TRUE/FALSE.
                  display_value = "#{value} "
                else
                  display_value = value.inspect
                end
                row << display_value

              else
                row << nil  # No parameter default
              end
            end

            csv << row
          end

          csv << []  # Blank row between groups
        end
      end

      return(output_path)
      #return(format_path(output_path, options))
    end

  end
end
