# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")
require("gli")
require("rubygems/patches/gli-2.13.2/lib/gli/app_support")
require("rubygems/patches/gli-2.13.2/lib/gli/commands/help")


ENV["GLI_DEBUG"] = "true"  # Set true to show the full error message and backtrace for exceptions


# This module defines the *Modelkit* command-line interface.
#
# General usage:
#
#     modelkit [global options] command [command options] [arguments...]
#
# For a list of commands, type:
#
#     modelkit help
#
module Modelkit::CLI

  include(GLI::App)
  extend self  # Add all methods as class methods

  ARGUMENTS = ARGV.dup.freeze  # Save a frozen copy to prevent changes

  program_desc "Command-line interface for the Modelkit framework"
  version Modelkit::VERSION

  GLI::AppSupport.config_file_name = ".modelkit-config"  # .modelkit is reserved for a hidden project directory

  # Define global options.
  switch [:i, :"ignore-config"], :desc => "Ignore all config files", :negatable => false

  flag [:"load-paths"], :desc => "Load paths for Ruby require", :arg_name => "paths"

  flag [:g, :gems], :desc => "Apply gem version constraints", :arg_name => "constraints"

  # Evaluate global options before processing the specified command.
  pre do |global_options, command, options, args|
    # Warn about deprecated options.
    if (command.name == :"template-compose")
      if (options[:"load-paths"])
        puts "Warning: The --load-paths option for 'template-compose' is deprecated. Use the --load-paths global option instead."
        puts "  Do this: modelkit --load-paths=\"dir1;dir2\" template-compose root.pxt"
        # Could get fancy and show user's corrected command based on actual options and arguments.

        # Pass old option forward to new one as long as new one is not being used.
        global_options[:"load-paths"] = options[:"load-paths"] if (not global_options[:"load-paths"])
      end

      if (options[:gems])
        puts "Warning: The --gems option for 'template-compose' is deprecated. Use the --gems global option instead."
        puts "  Do this: modelkit --gems=\"sqlite3,~>1.3\" template-compose root.pxt"

        # Pass old option forward to new one as long as new one is not being used.
        global_options[:gems] = options[:gems] if (not global_options[:gems])
      end
    end

    if (not global_options[:"ignore-config"])
      # Apply gem version constraints; in this context, this only applies gems from the config file.
      # NOTE: This duplicates code that is included in the 'compose' command. Should be generalized later.
      if (global_options[:gems])
        gems = global_options[:gems].split(";")
        gems.each { |gem_data|
          # NOPUB Not sure I like the --gems format anymore:  --gems="sqlite3,~>1.3"  yuck that comma...
          #  better?:  --gems="sqlite3 ~>1.3"  or  --gems=sqlite3~>1.3  maybe?
          gem_array = gem_data.split(",")
          gem_name = gem_array.shift

          begin
            # Use RubyGems to activate the correct gem which adds the gem directory to $LOAD_PATH.
            # An exception is raised if a gem cannot be found with matching name and requirements.
            gem(gem_name, gem_array)

            # NOTE: Gem still needs to be loaded using 'require_gem' or 'require' inside a template.

          rescue Exception => exception
            puts "***GEM CONSTRAINT ERROR:  bad gem name or requirements for '#{gem_name}'; gem ignored"
            puts exception
            # Annotate message to output file.
          end
        }
      end

      # Add directories to load path. Directories should be absolute paths.
      # Just like adding strings to $LOAD_PATH, paths are not validated for existence; bad paths just won't find anything.
      if (global_options[:"load-paths"])
        load_paths = global_options[:"load-paths"].split(";")
        load_paths.reverse_each do |load_path|
          load_path = File.expand_path(load_path.strip.gsub("\\", "/"))  # cleanpath?
          $LOAD_PATH.unshift(load_path)
        end
      end
    end

    next(true)
  end


  # Command:  template-compose
  # Format:  modelkit template-compose [template_path] [params_path_1] [params_path_2] [params_path_n]
  # Returns:  output document file path, if successful
  desc "Compose a template with parameter values and files"
  arg_name "[template path]"
  command :"template-compose" do |c|

    c.switch [:a, :annotate], :desc => "Include annotations in output text", :default_value => nil

    c.flag [:"esc-begin"], :desc => "Escape sequence beginning", :arg_name => "string"

    c.flag [:"esc-line"], :desc => "Escape sequence line prefix", :arg_name => "string"

    c.flag [:"esc-end"], :desc => "Escape sequence ending", :arg_name => "string"

    c.flag [:i, :indent], :desc => "Indentation sequence", :arg_name => "string"

    c.flag [:p, :parameters], :desc => "Apply parameter values", :arg_name => "values"

    c.flag [:f, :files], :desc => "Apply parameter files", :arg_name => "paths"

    c.flag [:d, :dirs], :desc => "Search directory paths", :arg_name => "paths"

    c.flag [:"load-paths"], :desc => "DEPRECATED; see --load-paths global option", :arg_name => "paths"

    c.flag [:g, :gems], :desc => "DEPRECATED; see --gems global option", :arg_name => "constraints"

    c.flag [:o, :output], :desc => "Output file path", :arg_name => "path", :default_value => "*.out"

    c.flag [:b, :batch], :desc => "List of template paths in a single batch file", :arg_name => "path"

    c.action do |global_options, options, args|

      require("modelkit/parametrics")

      # Not sure what the behavior should be if both args and standard input are specified.
      # "Unix utilities will ignore standard input if filenames are given." quoting some web page
      # Need to confirm best practice.
      if (not $stdin.tty?)
        # When reading from STDIN, each line is a template path.
        args = $stdin.readlines
        args.map! { |arg| arg.chomp }  # Record separator must be removed from each line

        # Depending on the use, 'each' might better than 'readlines' because the program can process
        # each line as soon as it's received instead of waiting until all lines are read.
        #$stdin.each { |line| puts line.chomp }  # Record separator must be removed from each line
      end

      if (options[:output] == "*.out")
        options[:output] = nil
      end

      # Clear deprecated options. These are handled as global options.
      options[:"load-paths"] = nil
      options[:gems] = nil

      if (options[:dirs])
        options[:dirs] = options[:dirs].split(";")
      end

      if (options[:files])
        options[:files] = options[:files].split(";")
      end

      if (batch_path = options[:batch])
        # If batch file is specified, overwrite any args.
        if (not File.exists?(batch_path))
          raise "batch file not found"
          exit
        else
          args = File.readlines(batch_path)
        end
      end

# NOPUB need to parse parameters from string format to Hash

# NOPUB what's the format?
#  --parameters="aaa=>45;bbb=>67"   semicolon delimited
#  --parameters="aaa=>45,bbb=>67"   comma delimited
#  --parameters=aaa=>45,bbb=>67     quotes optional (as long as no spaces)
#  --parameters=:aaa=>45,:bbb=>67   include colons
#  --parameters=a=45,b=67           just equal signs
#  --parameters=a:45,b:67           new hash syntax
#  -p aaa=>45 -p bbb=>67            multiple occurences...does GLI allow? NO--doesn't work, uses last one only
#
# NOTE: GLI defect: doesn't warn you when multiple occurences of an option are used, e.g., -p 6 -p 7
#  could easily confuse yourself.
#
# Fully proper parsing has to anticipate quoted strings with commas/semicolons inside.
# --parameter="string=>\"what, the\""
      # if (options[:parameters])
      #   array = options[:parameters].split(";").map { |parameter|  }
      # end

      # NOPUB options hash from GLI has a super redundant list of keys, for example:
      #   --parameters generates: "p"=>nil, :p=>nil, "parameters"=>nil, :parameters=>nil
      #
      # Temporary solution: Filter and map the options to a new hash with just the ones we want.
      # Probably want this everywhere...
      # NOTE: global_options are handled before this point: --ignore-config, --load-paths, --gems
      local_keys = [:annotate, :"esc-begin", :"esc-line", :"esc-end", :indent, :parameters, :files, :dirs, :output, :batch]  # omitting the deprecated ones
      new_options = {}
      local_keys.each do |key|
        new_key = key.to_s.gsub(/-/, "_").to_sym
        new_options[new_key] = options[key]
      end

      if (args.empty?)
        puts "ERROR:  No template was referenced!"
        # show help
        exit
      end

      args.map! { |arg| arg.gsub('\\', '/') }  # Convert slashes otherwise Dir.glob fails
      paths = []; args.each { |arg| paths += Dir.glob(arg.chomp) }  # Expand glob patterns

      paths.each { |path|
        # Must specify full path here, expanded against current working directory.
        output_path = Modelkit::Parametrics.template_compose(File.expand_path(path), new_options)
        # Could trim result string so that it shows same relative path as the input argument.

        puts Modelkit.platform_path(output_path)

        # Need to check for and omit failed templates
      }

      # If you have any errors, just raise them
      # raise "that command made no sense"
    end
  end


  desc "Show config file paths in effect for current directory"
  skips_pre
  command :config do |c|

    c.action do |global_options, options, args|

      config_file_name = GLI::AppSupport.config_file_name

      search_dirs = [ENV["HOME"] + "/"]

      # Walk the directory nodes from top to bottom stacking up config options.
      search_dir = ""
      for dir_node in Dir.pwd.split("/")
        search_dir += dir_node + "/"
        search_dirs << search_dir
      end

      for dir in search_dirs
        config_path = dir + config_file_name

        if (File.exist?(config_path))
          puts Modelkit.platform_path(config_path)
        end
      end
    end

  end


  desc "Start interactive Ruby console session"
  command :console do |c|

    c.action do |global_options, options, args|

      require("modelkit/console")

      # Prepend current working directory to load path so that 'require' always works relative to this directory.
# NOPUB what does IRB do?
#     IRB needs the dot first:  require "./myfile"
      #$LOAD_PATH.unshift(Dir.pwd)

      #puts "cli.rb #{"test".encoding}"  # => UTF-8

      Modelkit.console

# NOPUB Console could rescue errors and reraise with colors for errors, etc.

    end

  end


# NO PUB  "Execute some Ruby code in Modelkit environment"
  desc "Execute Ruby script in Modelkit environment"
  command :ruby do |c|

    c.switch [:l, :lines], :desc => "Execute arguments as lines of Ruby code", :negatable => false

    c.action do |global_options, options, args|
      if (args.empty?)
        puts "ERROR: no arguments specified"
        exit
      end

      if (options[:lines])
        lines = args.join("\n")
        eval(lines, binding, "argument", 1)

      else
        path = ARGV.shift  # Remove script path to prepare ARGV for the arguments the script is expecting

        if (not File.exist?(path))
          puts "ERROR: file not found at #{path}"
          exit
        else
          require(File.expand_path(path))
          # Set exit code?
        end
      end
    end

  end


  desc "Execute Rake tasks in Modelkit environment"
  command :rake do |c|
    # This is a subset of the full Rake command-line options; some options have also been modified.
    # Usage is initially limited to basic commands but can be expanded as needed.
    # Flag and switch options must be specified below in order for GLI to accept them.

    c.flag [:f, :rakefile], :desc => "Use specified file name as Rakefile to search for", :arg_name => "[file-name]"

    c.switch [:T, :tasks], :desc => "Show tasks with descriptions (matching optional pattern argument)", :negatable => false

    c.switch [:A, :all], :desc => "Show all tasks including uncommented tasks (use with -T)", :negatable => false

    c.switch [:P, :prereqs], :desc => "Show tasks with prerequisite dependencies", :negatable => false

    c.switch [:n, :"dry-run"], :desc => "Perform a dry run without executing tasks", :negatable => false

    c.switch [:B, :"build-all"], :desc => "Build all prerequisites including up-to-date dependencies", :negatable => false

    c.switch [:N, :"no-search"], :desc => "Do not search parent directories for Rakefile", :negatable => false

    c.flag [:trace], :desc => "Turn on invoke/execute tracing and enable full backtrace; output can be stderr or stdout", :arg_name => "[output]", :default_value => "stderr"

    c.action do |global_options, options, args|
      require("rake")

      # Pass the unmodified CLI arguments to Rake for processing.
      argv = ARGUMENTS[1..-1]  # Remove initial 'rake' command
      Rake.application.run(argv)
    end

  end

end
