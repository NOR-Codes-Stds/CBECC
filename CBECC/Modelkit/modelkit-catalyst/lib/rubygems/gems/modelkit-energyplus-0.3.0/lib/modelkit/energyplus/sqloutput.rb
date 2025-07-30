# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("sqlite3")


# Methods:
#   select_table  # queries TabularDataWithStrings only
#   execute  # general select/execute on sql file
#   time_series  # pulls time series data from sql file
#   errors  # pulls errors and warnings; filters dumb ones
#   sizes  # queries ComponentSizes; filters fake/magic ones
#   monthly
#
# IDF must specify "Output:SQLite, SimpleAndTabular;"
# Units (SI/IP) are matched by whatever is in the tables:  "OutputControl:Table:Style, All, InchPound;"
# SQL only contains tables that are requested, just like the HTML version.
#
module Modelkit
  module EnergyPlus

    class SQLOutput

      attr_reader :path, :database


      def initialize(sql_file)
        if (File.exist?(sql_file))
          @path = sql_file
          @database = SQLite3::Database.new(sql_file)
        else
          puts "SQLOutput.new:  bad path '#{sql_file}'"
          raise(IOError)
        end
      end


      # Primitive method to execute an arbitrary SQL query on the database.
      def execute(query)
        return(@database.execute(query))
      end


      # Primitive method to select data from the database table TabularDataWithStrings--the table output.
      # Treats a database query like a path with * wildcard allowed.
      # Builds a query like this:
        #query = "SELECT Value FROM TabularDataWithStrings" # WHERE ReportName='#{report_name}' " +
          #"AND ReportForString='#{report_for_name}' AND TableName='#{table_name}' AND ColumnName='#{column_name}' AND RowName='#{row_name}'"
      # Could add an OR operator || to the path, e.g., to select the Max Flow Rate and Rated Power columns.
      #'EquipmentSummary/Entire Facility/Fans/Max Flow Rate||Rated Power/*'
      # But that would still result in duplicate rows for each object.
      def select_table(query_path)
        # exception if cant find TabularDataWithStrings...possible if not requesting it

        query_path = query_path.gsub("//", "%SLASH%")  # Encode forward slashes that are escaped as //

        query_array = query_path.split('/')
        report_name = query_array[0].gsub("%SLASH%", "/")
        report_for_name = query_array[1].gsub("%SLASH%", "/")
        table_name = query_array[2].gsub("%SLASH%", "/")
        column_name = query_array[3].gsub("%SLASH%", "/")
        row_name = query_array[4].gsub("%SLASH%", "/")

        columns = "ColumnName,RowName,Value,Units"  # Is there a time hit for asking for all columns?

        # Need at least a report name, else exception
        query = "SELECT #{columns} FROM TabularDataWithStrings WHERE ReportName='#{report_name}'"

        if (report_for_name and report_for_name != '*')
          query << " AND ReportForString='#{report_for_name}'"
        end

        if (table_name and table_name != '*')
          query << " AND TableName='#{table_name}'"
        end

        if (column_name and column_name != '*')
          query << " AND ColumnName='#{column_name}'"
        end

        if (row_name and row_name != '*')
          query << " AND RowName='#{row_name}'"
        end

        begin
          database_results = @database.execute(query)
        rescue
          database_results = []  # Bad query or possible bad sql file
        end

        results = []
        for result in database_results
          if (not result[1].strip.empty?)  # Make sure row name is not blank
            # Could use OpenStruct instead of Hash here.
            hash = Hash.new
            hash[:ColumnName] = result[0].strip
            hash[:RowName] = result[1].strip

            # Consider converting to actual data types, e.g., Float, String, etc.
            # Database returns all strings, even for numbers.
            hash[:Value] = result[2].strip

            hash[:Units] = result[3].strip
            hash[:QueryPath] = [
              report_name.gsub("/", "%SLASH%"),  # Encode forward slashes again
              report_for_name.gsub("/", "%SLASH%"),
              table_name.gsub("/", "%SLASH%"),
              hash[:ColumnName].gsub("/", "%SLASH%"),
              hash[:RowName].gsub("/", "%SLASH%")].join('/')
            results << hash
          end
        end

        return(results)
      end


      # Preferred query interface for tables; defines additional queries not part of standard EnergyPlus.
      # Note: Query paths are case sensitive.
      # Format:  query_path = "ReportName/ReportForString/TableName/ColumnName/RowName"
      #
      # Examples:
      # - Use "AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/Total Energy/Heating" to get heating energy summed across all fuel types.
      # - Use "AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/*/Heating" to get heating energy reported separately for each fuel type.
      # - Use "AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/Electricity/*" to get electricity reported separately for each end use.
      # - Use "AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/*/*" to get complete end use table reported--a lot of columns.
      def query_table(query_path)
        results = select_table(query_path)

        if (results.empty?)
          # Check for special queries that are not part of standard EnergyPlus.
          query_array = query_path.split('/')
          report_name = query_array[0]
          report_for_name = query_array[1]
          table_name = query_array[2]
          column_name = query_array[3]
          row_name = query_array[4]

          # Define a query to add a Total Energy column to the End Uses table.
          if (query_path =~ /AnnualBuildingUtilityPerformanceSummary\/Entire Facility\/End Uses\/Total Energy\//)
            if (row_name != "*")
              # Sum the given row name (End Use) across all fuel types except water.
              value = 0.0
              units = ''
              column_results = select_table("AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/*/#{row_name}")
              if (not column_results.empty?)
                for result in column_results
                  if (result[:ColumnName] != "Water")
                    value += result[:Value].to_f
                    units = result[:Units]
                  end
                end

                hash = Hash.new
                hash[:ColumnName] = "Total Energy"
                hash[:RowName] = row_name
                hash[:Value] = value.to_s
                hash[:Units] = units
                hash[:QueryPath] = query_path

                results = [hash]
              end

            else  # query_path = "AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/Total Energy/*"
              # Iterate over each row name and query Total Energy.
              column_results = select_table("AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/Electricity/*")
              for result in column_results
                results += query_table("AnnualBuildingUtilityPerformanceSummary/Entire Facility/End Uses/Total Energy/#{result[:RowName]}")
              end
            end
          end

        end

        return(results)
      end


      def close
        @database.close
      end

    end

  end
end
