# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

# The command-line interface that was always missing from EnergyPlus.

require("modelkit/energyplus")
require("gli")
require("rubygems/patches/gli-2.13.2/lib/gli/app_support")
require("rubygems/patches/gli-2.13.2/lib/gli/commands/help")


ENV["GLI_DEBUG"] = "true"  # Set true to show the full error message and backtrace for exceptions


module Modelkit::EnergyPlus::CLI

  include(GLI::App)
  extend self  # Add all methods as class methods

  program_desc "EnergyPlus command-line interface"
  version Modelkit::EnergyPlus::VERSION

  GLI::AppSupport.config_file_name = ".modelkit-config"

  # Command:  energyplus-run
  desc 'Run an EnergyPlus input file'
  arg_name '[idf paths...]'
  command :"energyplus-run" do |c|

    c.switch [:m, :epmacro], :desc => "Preprocess with EPMacro"

    c.switch [:x, :expand], :desc => "Preprocess with ExpandObjects"

    c.switch [:i, :ip], :desc => "Postprocess to IP units"

    c.switch [:r, :readvars], :desc => "Postprocess with ReadVarsESO"

    c.switch [:k, :keep], :desc => "Keep temporary working directory"

    c.flag [:e, :engine], :desc => "EnergyPlus engine directory", :arg_name => "directory"

    c.flag [:w, :weather], :desc => "Weather file path", :arg_name => "path"
    # required, but should make optional--if none, assumes it's a design day run only

    # flag to select where working directory should be created

    # flag to select output dir

    c.flag [:o, :"output-files"], :desc => "Output files list", :arg_name => "list", :default_value => "eplusout.err; eplusout.sql; eplustbl.htm; eplusvar.csv"

    c.flag [:b, :batch], :desc => "List of idf paths in a single batch file", :arg_name => "path"

    c.action do |global_options, options, args|

      if (options[:engine].nil?)
        raise("engine directory not specified (use -e flag)")
      else
        options[:engine] = File.expand_path(options[:engine].gsub('\\', '/'))

        if (not File.exist?(options[:engine]))
          raise("engine directory not found")
        end
      end

      if (options[:weather].nil?)
        raise("weather file not specified (use -w flag)")
        # try: exit_now!(message,exit_code)
        # would be nice to show help for this command here.
      else
        options[:weather] = File.expand_path(options[:weather].gsub('\\', '/'))

        if (not File.exist?(options[:weather]))
          raise("weather file not found")
        end
      end

      if (batch_path = options[:batch])
        # If batch file is specified, overwrite any args.
        if (File.exists?(batch_path))
          args = File.readlines(batch_path)
        else
          raise("batch file not found")
        end
      end

      if (args.empty?)
        raise("no input file was referenced")
        # show help
      end

      args.map! { |arg| arg.gsub('\\', '/') }  # Convert slashes otherwise Dir.glob fails
      paths = []; args.each { |arg| paths += Dir.glob(arg.chomp) }  # Expand glob patterns

      # Loop through multiple input files and run each file sequentially.
      # NOTE:  One limitation is that the one weather file must be used for all runs.
      paths.each { |path|
        Modelkit::EnergyPlus.run(path, options)
        # STDOUT?
      }

    end
  end


  # Command: energyplus-clean
  desc 'Clean up EnergyPlus output files'
  arg_name '[idf paths...]'
  command :"energyplus-clean" do |c|

    c.flag [:o, :"output-files"], :desc => "Output files list", :arg_name => "list", :default_value => "eplusout.err; eplusout.sql; eplustbl.htm; eplusvar.csv"

    c.action do |global_options, options, args|

      if (args.empty?)
        raise("no input file was referenced")
        # show help
      end

      args.map! { |arg| arg.gsub('\\', '/') }  # Convert slashes otherwise Dir.glob fails
      paths = []; args.each { |arg| paths += Dir.glob(arg) }  # Expand glob patterns

      # Loop through multiple input files and run each file sequentially.
      # NOTE:  One limitation is that the one weather file must be used for all runs.
      paths.each { |path|
        Modelkit::EnergyPlus.clean(path, :"output-files"=>options[:"output-files"])
        # STDOUT?
      }

    end
  end


  # Command: energyplus-sql
  desc 'Process an EnergyPlus sql file'
  arg_name '[sql paths...]'
  command :"energyplus-sql" do |c|

    c.flag [:q, :query], :desc => "Query file path", :arg_name => "path"

    #c.desc 'Output path (default: queryname.csv)'
    c.flag [:o, :output], :desc => "Output path", :arg_name => "path"

    c.flag [:b, :batch], :desc => "List of SQL paths in a single batch file", :arg_name => "path"

    c.flag [:d, :dir], :desc => "Parent directory path for shorter relative paths", :arg_name => "path"

    c.switch [:v, :verbose], :desc => "Print each SQL path as it is processed"

    c.action do |global_options, options, args|

      query_path = options[:query]
      if (query_path.nil?)
        raise("query file not specified (use -q flag)")
      elsif (not File.exists?(query_path))
        raise("query file not found")
      end

      if (batch_path = options[:batch])
        if (File.exists?(batch_path))
          paths = File.readlines(batch_path)
          paths.map! { |path| path.chomp.gsub("\\", "/") }  # Convert slashes for downstream
        else
          raise("batch file not found")
        end
      else
        # Expand any glob patterns in the arguments, e.g., runs/**/instance-out.sql
        args.map! { |arg| arg.gsub("\\", "/") }  # Convert slashes otherwise Dir.glob fails
        paths = args.reduce(Array.new) { |array, arg| array + Dir.glob(arg.chomp) }
        # Is chomp needed here? Test with pipe to STDIN.
      end

      # Works aggregately on the full set, not individually on each file.
      Modelkit::EnergyPlus.sql(paths, query_path, options) do |path|
        if (options[:verbose])
          puts "Processing: #{Modelkit.platform_path(path)}"
        end
      end
    end
  end

  # Command:  energyplus-size
  desc 'Set equipment sizes based on output from previous run'
  arg_name '[idf paths...]'
  command :"energyplus-size" do |c|

    c.flag [:class], :desc => "Regular expression for class name match", :arg_name => "list", :default_value => ".*" #TODO: hook up

    c.flag [:object], :desc => "Regular expression for object name match", :arg_name => "list", :default_value => ".*" #TODO: hook up

    c.flag [:o, :output], :desc => "Output file path", :arg_name => "path", :default_value => "*.sized.idf"

    c.flag [:j, :json], :desc => "Export object field map to a specified JSON file", :arg_name => "path"

    c.flag [:s, :sql], :desc => "Path to SQLite output with sizing results", :arg_name => "path"

    c.flag [:i, :idd], :desc => "Path to IDD corresponding to idf files", :arg_name => "path"

    c.action do |global_options, options, args|

      if (args.empty?)
        raise("no input file was referenced")
        # show help
      end

      if (not options[:sql])
        raise("SQL file required")
      end

      # Load IDD
      idd = OpenStudio::DataDictionary.open(options[:idd])

      output_pattern = options[:output]

      if (output_pattern.include?("*") and args.size > 1)
        raise("output path for multiple idf paths must include a wildcard character (*)")
      end

      # Loop through multiple input files and run each file sequentially.
      # NOTE:  One limitation is that the one weather file must be used for all runs.
      args.each { |input_file_path|
        relative_path = output_pattern.gsub("*",File.basename(input_file_path, ".*"))
        if (File.path(input_file_path) == File.absolute_path(input_file_path))
          options[:output] = relative_path
        else
          options[:output] = File.dirname(input_file_path) + "/" + relative_path
        end

        input_file = OpenStudio::InputFile.open(idd, input_file_path)

        sql = Modelkit::EnergyPlus::SQLOutput.new(options[:sql])

        output_file_path, count = Modelkit::EnergyPlus.size(sql, input_file, options)

        puts "#{Modelkit.platform_path(output_file_path)} (#{count} fields replaced)"
        # STDOUT?
      }

    end
  end

end
