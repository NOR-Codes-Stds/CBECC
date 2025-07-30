# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require('fileutils')
require('pathname')
require('csv')

require('modelkit')
require('modelkit/version')
require('modelkit/util')
require('modelkit/energyplus/logger')  # mine, not the standard library one
require('modelkit/energyplus/sqloutput')
require('modelkit/energyplus/iterators')
require('modelkit/energyplus/autosize_object')

# Add Legacy OpenStudio library to load path.
$LOAD_PATH << "#{File.expand_path(__dir__)}/energyplus/legacy_openstudio/lib"
require('inputfile/DataDictionary')
require('inputfile/InputFile')

require('modelkit/energyplus/data_dictionary')


module Modelkit
  module EnergyPlus

    GEM_SPEC = Gem.loaded_specs["modelkit-energyplus"]
    GEM_DIR = GEM_SPEC.gem_dir.freeze
    VERSION = GEM_SPEC.version.to_s.freeze
    BUILD = GEM_SPEC.metadata["build"].freeze

    REPLACE_ALL_AUTOSIZABLE_FIELDS = false

    # keep in mind:  there should be equivalent classes for other engines with the same interface
    #  General interface:  arguments:  engine dir, input file, weather file,
    def self.run(input_file_path, options = Hash.new)

      if (options[:"output-files"] and not options[:"output-files"].empty?)
        output_files = options[:"output-files"].split(";").map { |f| f.strip }
      else
        raise("no output files were specified; use the --output-files flag")
      end

      if (options[:engine] and not options[:engine].empty?)
        energyplus_dir = File.expand_path(options[:engine].gsub("\\", "/"))
      else
        raise("must specify the directory for EnergyPlus")
      end

      if (energyplus_dir and not File.exist?(energyplus_dir))
        raise("cannot find the specified directory for EnergyPlus at: " + Modelkit.platform_path(energyplus_dir))
      end

      if (input_file_path.nil?)
        raise("must specify the path to the input file as the first argument")
      else
        input_file_path = File.expand_path(input_file_path.gsub("\\", "/"))
      end

      if (not File.exist?(input_file_path))
        raise("cannot find an input file at the specified path: " + Modelkit.platform_path(input_file_path))
      end

      weather_path = File.expand_path(options[:weather].gsub("\\", "/"))  # Expand to replace user home directory from tilde
      # NOTE: File.expand_path fails with back slashes!
      if (weather_path and not File.exist?(weather_path))
        raise("cannot find a weather file at the specified path: " + Modelkit.platform_path(weather_path))
      end

      input_dir = File.dirname(input_file_path)
      input_file_base = File.basename(input_file_path, '.*')

      # Option:  specify where working dir should be created
      working_dir = input_dir + '/'+ input_file_base + Time.now.strftime("%m%d%H%M%S")
      working_dir = Pathname.new(working_dir).cleanpath.to_s  # remove consecutive slashes and useless dots

      # Create temporary working directory
      if (not File.exist?(working_dir))
        FileUtils.mkdir_p(working_dir)
      end


      log = Modelkit::EnergyPlus::Logger.new(working_dir + '/log.txt', STDOUT)
      #$stderr = log  # Pipe all error messages to the logger


      # Echo all selected options
      log.puts "EnergyPlus Dir:  " + Modelkit.platform_path(energyplus_dir)
      log.puts "Input File:      " + Modelkit.platform_path(input_file_path)
      log.puts "Weather File:    " + Modelkit.platform_path(weather_path)
      log.puts "Working Dir:     " + Modelkit.platform_path(working_dir)
      log.puts "EPMacro:  " + options[:epmacro].to_s
      log.puts "ExpandObjects:  " + options[:expand].to_s
      log.puts "ReadVarsESO:  " + options[:readvars].to_s
      log.puts "Output Files:  " + output_files.join("; ")


      self.clean(input_file_path, :"output-files"=>output_files.join("; "))

      version = OpenStudio::DataDictionary.detect_version(energyplus_dir + '/Energy+.idd')
      if (Version.new(version) < Version.new("8.3"))
        energyplus_name = "EnergyPlus"
      else
        energyplus_name = "energyplus"
      end

      # NOTE:  File names and paths are generally platform specific!
      # This could be a second run after a sizing-only pass; might not have to copy everything over.
      # Add 'Sandbox' class to prepare working directory for a simulation?
      FileUtils.cp(energyplus_dir + '/Energy+.idd', working_dir)
      FileUtils.cp(energyplus_dir + '/PostProcess/convertESOMTRpgm/convert.txt', working_dir)

      # Copy input file and weather file
      FileUtils.cp(input_file_path, working_dir + '/in.idf')
      FileUtils.cp(weather_path, working_dir + '/in.epw')


      # Run executables via shell commands.
      Dir.chdir(working_dir){
        if (options[:epmacro])
          log.puts "\nStarting EPMacro...\n\n"

          File.rename('in.idf', 'in.imf')

          pipe = IO::popen("\"#{energyplus_dir}/EPMacro\"", "r") do |io|
            while (line = io.gets)
              log.puts(line)
            end
          end

          if (File.exist?('out.idf'))
            File.rename('out.idf', 'in.idf')
          end
        end


        # ExpandObjects tends to rearrange a lot of objects for no good reason; only run it as an option.
        if (options[:expand])
          log.puts "\nStarting ExpandObjects...\n\n"

          pipe = IO::popen("\"#{energyplus_dir}/ExpandObjects\"", "r") do |io|
            while (line = io.gets)
              log.puts(line)
            end
          end

          if (File.exist?('expanded.idf'))
            File.rename('in.idf', 'unexpanded.idf')
            File.rename('expanded.idf', 'in.idf')
          end
        end


        log.puts "\nStarting EnergyPlus...\n\n"

        pipe = IO::popen("\"#{energyplus_dir}/#{energyplus_name}\"", "r") do |io|
          while (line = io.gets)
            log.puts(line)
          end
        end
        success = $?.success?  # Exit status of EnergyPlus

        if (success and options[:ip])
          # Convert .eso files to inch-pound units.
          # Always convert, even if readvars is false; other applications might read .eso directly.
          if (File.exist?('eplusout.eso') or File.exist?('eplusout.mtr'))
            log.puts "\nStarting convertESOMTR...\n\n"

            pipe = IO::popen("\"#{energyplus_dir}/PostProcess/convertESOMTRpgm/convertESOMTR\"", "r") do |io|
              while (line = io.gets)
                log.puts(line)
              end
            end

            if (File.exist?('ip.eso'))
              File.rename('ip.eso', 'eplusvar.eso')
            end

            if (File.exist?('eplusout.eso'))
              File.delete('eplusout.eso')
            end

            if (File.exist?('ip.mtr'))
              File.rename('ip.mtr', 'eplusmtr.eso')
            end

            if (File.exist?('eplusout.mtr'))
              File.delete('eplusout.mtr')
            end
          end

        else
          # Rename .eso files to have more useful output names.
          if (File.exist?('eplusout.eso'))
            File.rename('eplusout.eso', 'eplusvar.eso')
          end

          if (File.exist?('eplusout.mtr'))
            File.rename('eplusout.mtr', 'eplusmtr.eso')
          end
        end


        if (success and options[:readvars])
          if (File.exist?('eplusvar.eso'))
            log.puts "\nStarting ReadVarsESO for variables...\n\n"

            FileUtils.cp('eplusvar.eso', 'eplusout.eso')

            pipe = IO::popen("\"#{energyplus_dir}/PostProcess/ReadVarsESO\"", "r") do |io|
              while (line = io.gets)
                log.puts(line)
              end
            end

            File.rename('eplusout.csv', 'eplusvar.csv')
            File.delete('eplusout.eso')
          end

          if (File.exist?('eplusmtr.eso'))
            log.puts "\nStarting ReadVarsESO for meters...\n\n"

            FileUtils.cp('eplusmtr.eso', 'eplusout.eso')

            pipe = IO::popen("\"#{energyplus_dir}/PostProcess/ReadVarsESO\"", "r") do |io|
              while (line = io.gets)
                log.puts(line)
              end
            end

            File.rename('eplusout.csv', 'eplusmtr.csv')
            File.delete('eplusout.eso')
          end
        end
      }

      # Copy back selected output files
      log.puts "\nCopying output files..."

      output_files.each { |output_file|
        output_file_suffix = output_file[5..-1]  # chop off 'eplus' prefix
        output_file_name = input_file_base + '-' + output_file_suffix

        if (File.exist?(working_dir + '/' + output_file))
          log.puts output_file + " -> " + output_file_name
          FileUtils.cp(working_dir + '/' + output_file, input_dir + '/' + output_file_name)
        end
      }

    rescue Interrupt
      log.puts "\nRun interrupted!"
      exit

    ensure
      if (not options[:keep])
        log.puts "\nDeleting working directory..."
        log.puts "\nCompleted."
        log.close  # Can't delete the working directory until the log is closed

        FileUtils.rm_rf(working_dir)
      else
        log.puts "\nCompleted."
        log.close
      end

    end


    # Clean up EnergyPlus output files.
    def self.clean(input_file_path, options = Hash.new)

      if (options[:"output-files"])
        output_files = options[:"output-files"].split(";").map { |f| f.strip }
      else
        output_files = ['eplusout.err', 'eplustbl.htm', 'eplusvar.csv', 'eplusout.sql']
      end

      if (input_file_path.nil?)
        raise("must specify the path to the input file as the first argument")
      end

      if (not File.exist?(input_file_path))
        raise("cannot find an input file at the specified path: " + Modelkit.platform_path(input_file_path))
      end

      input_dir = File.dirname(input_file_path)
      input_file_base = File.basename(input_file_path, '.*')

      output_files.each { |output_file|
        output_file_suffix = output_file[5..-1]  # chop off 'eplus' prefix
        output_file_name = input_file_base + '-' + output_file_suffix
        output_file_path = input_dir + '/' + output_file_name

        if (File.exist?(output_file_path))
          begin
            File.delete(output_file_path)

          rescue Errno::EACCES
            raise("permission denied: #{Modelkit.platform_path(output_file_path)}\nFile might be locked by another application.")
          rescue
            raise("failed to delete output file: #{Modelkit.platform_path(output_file_path)}")
          end
        end
      }
    end


    def self.sql(sql_paths, query_file_path, options = Hash.new)

      # like sql but interprets structure for every sql_path (each file) so a bit slower but doesn't fail on disimilar HVAC runs
      # This is a complete hack as I did not have a firm grasp on all the ways to manipulate arrays.
      # Basically a separate querytable was established so that it could be updated without interferring with the data accumalating in table rows
      # The table hash and columns are set at the beginning.  The querytables are set for every sql.

      # sql_paths is list of sql output files
      # query_file_path is list with items to fetch. This is one query_line per row in results.txt
      # each block of items in results.txt, separated by a blank line, will be stored in a table.  A table will include an item for every row in results.txt block

      query_lines = File.readlines(query_file_path)
      tables = []
      querytables = []
      table = nil
      firstsqlpath=true

      for sql_path in sql_paths
        yield(sql_path) if (block_given?)  # Progress can be tracked by using a block

        querytables.clear
        querytable = nil

        if (options[:dir])
          parent_dir = options[:dir]
          if (File.exist?(parent_dir))
            full_sql_path = "#{parent_dir}/#{sql_path}"
          else
            raise("parent directory not found: #{Modelkit.platform_path(parent_dir)}")
          end
        else
          full_sql_path = sql_path
        end

        if (not File.exist?(full_sql_path))
          puts("WARNING: file not found: #{Modelkit.platform_path(full_sql_path)}")

        else
          sql = Modelkit::EnergyPlus::SQLOutput.new(full_sql_path)
          bad_sql = false

  # start of structure fetch- try to update structure but not overwrite previous results
  # creates table for each group of items in query line - aka for each block of items listed in results.txt
          query_lines = File.readlines(query_file_path)
          for query_line in query_lines
            query_line.strip!
            if (query_line.empty?)
              table = nil
              querytable = nil
  #                 puts " query empty."
            elsif (querytable.nil?)
              if (firstsqlpath)
  #                 puts " first time."
                table = Hash.new
                table[:column_labels] = []
                table[:rows] = []
                tables << table
                querytable = Hash.new
                querytable[:query_paths] = []
                querytables << querytable
              else
  #                 puts " next time."
                querytable = Hash.new
                querytable[:query_paths] = []
                querytables << querytable
              end
            end

    #       if (table)
            if (querytable)
              query_array = query_line.split(',')
              query_path = query_array[0]
              user_column_name = query_array[1]

              results = sql.query_table(query_path)
              if (results.empty?)
                puts("WARNING: query found no results: #{query_path}")
              else
                for result in results
                  querytable[:query_paths] << result[:QueryPath]
                  if (firstsqlpath) then
                    if (user_column_name.nil?)
                      column_label = "#{result[:ColumnName]}/#{result[:RowName]} (#{result[:Units]})"
                    else
                      column_label = "#{query_array[1].strip} (#{result[:Units]})"  # Override with user-specified label
                    end
                    table[:column_labels] << column_label
                  end
                end
              end
            end
          end #for query_line

          firstsqlpath=false
  # end of structure fetch

          tableidx=0

          for table in tables
            row = [sql_path]  # Apply file name transformation here
  #            puts " table #{table} ."  # temporary for debugging
            querytable = querytables[tableidx]
  #            puts " querytable #{querytable} ."  # temporary for debugging

            for query_path in querytable[:query_paths]

  #              puts " qp #{query_path} ."  # temporary for debugging

              result = sql.query_table(query_path).first  # Results should just be single records now
  #              puts " rs #{result} ."  # temporary for debugging
              if (result)
                row << "#{result[:Value].strip}"
              else
                bad_sql = true
                row << "nil"
              end
            end

            table[:rows] << row
            tableidx += 1
          end

          if (bad_sql)
            raise("possible bad sql file #{Modelkit.platform_path(full_sql_path)}")
          end

          sql.close
        end

        if (options[:output])
          output_path = options[:output]
        else
          # default output path based on query_file_path
          output_path = File.dirname(query_file_path) + '/' + File.basename(query_file_path, '.*') + '.csv'
        end

        if (File.exist?(output_path))
          begin
            File.delete(output_path)

          rescue Errno::EACCES
            raise("permission denied: #{Modelkit.platform_path(output_path)}\nFile might be locked by another application.")
            # clean up
          rescue
            raise("failed to delete output file: #{Modelkit.platform_path(output_path)}")
            # clean up
          end
        end

        # check output path is valid
        output_file = File.open(output_path, 'w')

        #output_file.puts "TITLE"

        for table in tables
          output_file.puts "File Name,#{table[:column_labels].join(',')}"  # Write column header
          for row in table[:rows]
            output_file.puts row.join(',')
          end
          output_file.puts
        end

        output_file.close
      end
    end

    def self.modify_objects(input_file, value_map)
      output_file = input_file.copy

      count = 0
      for object_class, values in value_map
        object_class = object_class.to_s  # Could be a symbol if parsed from JSON
        for value in values
          object = output_file.find_object_by_class_and_name(object_class, value[:object])
          if (object)
            object.fields[value[:field]] = value[:value]
            count += 1
          else
            puts "WARNING: Unable to find #{object_class} named #{value[:object]}"
          end
        end
      end
      return output_file, count
    end

    # size - perform hardsize replacement
    # - sql: Modelkit::EnergyPlus::SQLOutput, sql file path
    # - input_file: OpenStudio::InputFile, input file
    # - options? Hash with possible fields
    #   - :version : String, the version of energyplus to use (e.g., "8-0", "9-0")
    #   - :replacement_strategy : String, one of "autosize_fields_only", "autosize_or_blank", "all"
    #   - :json : String, if present write output log as JSON
    #   - :output : String, the output file to write to
    # RETURNS: (Tuple (Or String Nil), Int, OpenStudio::InputFile)
    #   returns the output file path written (or nil if not written), the
    #   number of changes made, and the modified IDF object
    def self.size(sql, input_file, options = nil)
      options = Hash.new if options.nil?
      version = options.fetch(:version, "8-0")
      strategy = options.fetch(:replacement_strategy, "autosize_fields_only").to_sym
      rows = ::CSV.read("#{GEM_DIR}/resources/sizing-map/#{version}.csv")

      sizing_map = {}
      map_errors = 0
      for row in rows
        class_name_dc = row[0].downcase
        if (not sizing_map.key?(class_name_dc))
          sizing_map[class_name_dc] = {}
        end
        if row[2] == "nil"
          index = nil
        else
          index = row[2].to_i
        end
        sizing_map[class_name_dc][row[1]] = index
      end

      value_map = {}

      # Make table from SQL
      common_query = "FROM ComponentSizes"
      ## query for available classes
      class_query = "SELECT DISTINCT CompType " + common_query

      classes = sql.database.execute(class_query)

      ## loop through classes
      for object_class in classes
        class_name = object_class[0]
        class_name_dc = class_name.downcase
        ### query for available objects within classes
        object_query = "SELECT DISTINCT CompName " + common_query + " WHERE CompType='#{class_name}'"

        objects = sql.database.execute(object_query)

        ### loop through objects
        for object in objects
          object_name = object[0]
          #### query for SQL fields within object
          field_query = "SELECT DISTINCT Description " + common_query + " WHERE CompType='#{class_name}' AND CompName='#{object_name}'"

          fields = sql.database.execute(field_query)
          #### loop through columns
          for field in fields
            field_name = field[0]
            value_query = "SELECT Value " + common_query + " WHERE CompType='#{class_name}' AND CompName='#{object_name}' AND Description='#{field_name}'"

            # TODO: Figure out IP units
            map_error = false
            map_warning = false
            value = sql.database.execute(value_query)[0][0].to_f
            if (!sizing_map.key?(class_name_dc))
              puts "ERROR: Class not found in sizing map: '#{class_name}'"
              map_error = true
            elsif (!sizing_map[class_name_dc].key?(field_name))
              # TODO: Change back to errors
              #puts "WARNING: Sizing table column name not found in sizing map: #{class_name},#{field_name},nil"
              map_warning = true
            end

            if (not map_error and not map_warning)
              field_number = sizing_map[class_name_dc][field_name]

              if (field_number)
                original_value = input_file
                  .find_object_by_class_and_name(class_name, object_name)
                  .fields[field_number].to_s  # avoids a Nil exception with .strip
                  .strip
                  .downcase
                # Only replace a value if it is explicitly set to 'autosize'
                # That is, blank fields stay blank.
                is_autosize = original_value == 'autosize'
                is_blank = original_value == ''
                doit = ((strategy == :all) or
                        (strategy == :autosize_fields_only and is_autosize) or
                        (strategy == :autosize_or_blank and
                         (is_autosize or is_blank)))
                if doit
                  if (!value_map.key?(class_name_dc))
                    value_map[class_name_dc] = []
                  end
                  value_map[class_name_dc] << {object: object_name, field: field_number, value: value}
                else
                  # TODO: Remove this clause; just for debugging
                  #puts "SKIPPING: #{class_name},#{field_name},#{field_number} for #{object_name}"
                end
              end
            elsif map_error
              map_errors += 1
            end
          end

        end

        if (map_errors > 0)
          raise("Exiting: #{map_errors} errors encountered")
        end

      end

      if (options[:json])
        require('json')
        File.open(options[:json], "w") do |f|
          f.write(value_map.to_json)
        end
      end

      output_file, count = modify_objects(input_file, value_map)

      output_file.write(options[:output])

      return options[:output], count, output_file
    end

  end
end
