# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("csv")

# Issues with CSV standard library:
# - Table class doesn't have method for 'shift' like CSV class does (has .each instead)
# - Table class doesn't have method for 'add_row' like CSV class does (has << instead)
# - can't seem to build a Table/CSV object from scratch by creating empty and adding rows
#   table = CSV.new([], :headers => headers)
#   table.add_row(row)
#   row = table.shift
#
#   this finally worked:
#   table = CSV::Table.new([row])  # but then no 'shift' method on it!
#
# - each Row stores its own headers apparently...seems like a lot of wasted memory!



module Modelkit
  class MultiTable

    attr_accessor :title

# change to .open with parse
    def initialize(csv_path)
      @title = ""
      @tables = {}

      # Don't keep original CSV as an instance variable (i.e., @csv) because it
      # makes it impossible to Marshal this object and get it into Worksheet.
      this_csv = CSV.open(csv_path)  # don't do headers here on purpose

      table = nil

      while (row = this_csv.shift) do
      #this_csv.each do |row|

        #puts "first=#{row.first}  match=#{(row.first =~ /title/).inspect}"

        if (row.compact.empty?)
          #puts "blank row"  # skip
          next

        elsif (row.first =~ /^\s*#/)
          #puts "comment row"
          # later allow end of line comments too
          next

        #elsif (row.first =~ /^\s*title:/)  # make case insensitive
        elsif (row.first =~ /title/)  # need to fix; above wasn't working?
          #puts "title: row"
          #match = row.first.match(/title:(.*)/)
          #@title = match.first
          @title = row.first

          #puts "title=#{@title}"
          next

        elsif (row.first =~ /table/)  # need to fix
          #puts "table: row"

          string = row.first
          table_name = string.match(/^\s*table:\s*(.*?)\s*$/).captures.first
          #puts "*#{table_name}*"

          # Process into a sub table!
          headers = this_csv.shift  # headers are expected, but may not always be needed?

          # puts "HEADERS"
          # puts headers.class
          # puts headers.inspect

          #table = CSV.new([], :headers => headers)  # instead of CSV::Table.new
          table = CSV::Table.new([])  # don't need header row apparently!

          new_table = false

          # Start new inner loop.
          while (row = this_csv.shift) do

            if (row.compact.empty?)
              #puts "blank row"  # skip
              next
            elsif (row.first =~ /^\s*#/)
              #puts "comment row"
              # later allow end of line comments too
              next

            #elsif title ... shouldn't have any title rows   error

            elsif (row.first =~ /table/)  # need to fix
              new_table = true
              break
            else
              #table.add_row(row.dup)

              # puts "ROW"
              # puts row.class # => Array
              # puts row.inspect

              # `row` is just an Array because the parent CSV does NOT have common headers

              new_row = CSV::Row.new(headers, row)
              table << new_row
            end
          end

          #puts "*********"
          #puts table_name
          #puts table.inspect
          #table.each do |row2|
          #  puts row2.inspect
          #end
          #puts "done"
          @tables[table_name] = table

          redo if (new_table)

          # row = this_csv.shift
          # while (not row.first =~ /table/) do
          #   table.add_row(row)
          #   puts "  adding row: #{row.inspect}"
          #   row = this_csv.shift
          # end

        else
          puts "Should never get here"  # something unhandled
          puts row.inspect  # normal row

        end
      end  # while

      # puts "\nTABLES\n"
      # puts @tables.inspect

    end


    def lookup(table_name, row_name, col_name)
      #puts "Lookup..."
      table = @tables[table_name]
      value = nil

      # puts table.class
      # puts table.inspect

      table.each do |row|
        if (row[0] == row_name)
          # puts "FOUND IT"
          # puts row.inspect
          field = row[col_name]

# Copied from Worksheet!

          # Convert field string to implicit data type.
          if (true if Integer(field) rescue false)
            value = field.to_i
          elsif (true if Float(field) rescue false)
            value = field.to_f
          elsif (field == "nil")
            value = nil  # "nil"  # Has to be string version, otherwise nil.to_s => ""
# something's wrong with nil;
# the evaluated output CSV renders this as blank.
          elsif (field & "false")  # Uses experimental monkey-patched String operator
            value = false
          elsif (field & "true")  # Could do casecmp().zero? for better performance
            value = true  # just gets converted back to String, but that's okay
          else
            # Must be a String if it gets here.
            #value = "\"#{field.gsub(/\"/, "\\\"")}\""  # Escape any double quotes
            value = field
          end


        end
      end

      if (not value)
        raise "Error: value not found"
      end

      return(value)
    end



  end
end
