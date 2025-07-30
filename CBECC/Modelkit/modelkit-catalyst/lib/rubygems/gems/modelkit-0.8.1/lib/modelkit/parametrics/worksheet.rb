# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("csv")
require("modelkit/util")

# TO DO
# [ ] index should be offset by 1 -- 0 is reserved for header row
# [ ] transform header names to valid Ruby local vars, e.g. "Model Name" => "model_name"; allows prettier headers
# [ ] error checking in .parse
#   [.] Disallow duplicate header names?
# [x] clean up headers in initial parsing? => remove extra spaces
# [ ] Are headers always required?
# [x] move `value_from_string` to...where?  Modelkit.value_from_string
# [x] try Quantity class
# [x] match fixes
# [x] nil vs NULL: what should a blank field mean?  (e.g.: 56,,89)
#     parsed value on read can be nil... that seems okay
#     if "nil" is in the field, it can become a blank field
#     but should it preserve blank, or should it write "nil"?  e.g.: 56,nil,89
#     when parameters are written to .pxv, values of nil are *not* written; parameter is omitted.
#     maybe that's the "nil problem"? it's writing all the nil values currently to .pxv
# [ ] do vars and params share same namespace?
#     do parameters also generate a variable (maybe?)
# [.] allow other parameter symbols:  &  $  *
# [ ] see about passing all variables through


# NOPUB
#   can potentially minimize use of CSV API and rely on just the bare parsing/writing routines:
#   csv_string = ["CSV", "data"].to_csv => string   # to CSV
#   csv_array  = "CSV,String".parse_csv => array    # from CSV; similar to CSV.parse_line(str)


# For Ruby 2.0 specifically:
RUBY_KEYWORDS = ["__ENCODING__", "__LINE__", "__FILE__", "BEGIN", "END", "alias", "and", "begin", "break", "case", "class", "def", "defined?", "do", "else", "elsif", "end", "ensure", "false", "for", "if", "in", "module", "next", "nil", "not", "or", "redo", "rescue", "retry", "return", "self", "super", "then", "true", "undef", "unless", "until", "when", "while", "yield"]


# NOPUB: do I have something general from Template for this now?
class RowContext

  attr_accessor :instance_binding

  def initialize

    @instance_binding = __binding__

    # @instance_binding?
    # just not @binding because this collides with Kernel#binding
    # or maybe that was when my *method* was called 'binding'
    # try againg with @binding
  end

  # Everything is run as if inside of this method!
  def __binding__  #    something else?  whatever it is, make consistent with Template
    return(binding)
  end

end


module Modelkit
  module Parametrics

    class Worksheet

      def self.parse(string, options = {})
        worksheet = self.allocate
        worksheet.send(:initialize, options)
        worksheet.send(:parse, string)
        return(worksheet)
      end

# should this be `read`?
      def self.open(path, options = {})
        string = File.read(path, :encoding => "bom|utf-8")
        # do some error checking of file
        options[:path] = path
        return(self.parse(string, options))
      end

      def initialize(options = {})
        @table = CSV::Table.new([])
        @path = options[:path]  # optional
        @variable_map = {}
        @variables = []
        @parameters = []
      end

# NOPUB Possibly entire Worksheet has already been evaluated.  ?
      def each_row(outer_variables = Hash.new, &block)
        if (not block_given?)
          raise("Error: block not specified")
        end
        # OR if no block, could return an Enumerator. That's what Array#each does without a block.

        new_table = CSV::Table.new([])

        @table.each_with_index do |row, index|
          # NOTE: Rows can be ignored by inserting # as the first character of the line.
          # Completely blank rows are ignored too.
          if (not row.field(0) =~ /^#/ and not row.fields.compact.empty?)
            new_row = evaluate_row(row, index, outer_variables, block)
            new_table << new_row
          end
        end

# NOPUB Should really return a Worksheet with everything evaluated; not a CSV::Table
        return(new_table)
      end

# NOPUB Does much of this belong in a separate class?:
#   WorksheetRow
#     .evaluate(binding) => new_row  # eval row in context of specific binding?? (optional)
# but then how can a cell access the contents of another cell??

      def evaluate_row(row, index, outer_variables, block)

        # Row has method for the getting the *original* unevaluated row data...
        # row.source

        row_num = index + 2  # Row numbers start at 1 and header row has already been removed

        # Returns a new Row with all code evaluated.
        new_row = CSV::Row.new(row.headers, row.fields)  # 'row.dup' is insufficient

        row_context = RowContext.new
        row_binding = row_context.instance_binding

        outer_variables.each do |key, value|
          begin
            object = Marshal.dump(value)
            row_binding.eval("#{key} = Marshal.load(#{object.inspect})")
          rescue
            # From docs: https://ruby-doc.org/core-2.0.0/Marshal.html
            # > Some objects cannot be dumped: if the objects to be dumped include
            # > bindings, procedure or method objects, instances of class IO, or
            # > singleton objects, a TypeError will be raised.
            raise("unable to marshal #{key}")
          end
        end

        variables = Hash.new
        parameters = Hash.new

        row.each do |header, field|
          #puts "row.each #{header} = #{field}"

          col_num = row.index(header) + 1  # Column numbers start at 1
          variable = @variable_map[header]  # Look up Ruby variable name

# NOTE: for %=, %# syntax, this must be FIRST thing in the cell--no leading whitespace.
          if (field.nil? or field =~ /^%#/)
            # Blank or commented out, but still have to create a local variable.
            operand = "nil"

          elsif (match = field[/^%=\s*(.*)\s*/, 1])
            # Evaluate expression and set local variable.
            # NOTE: CSV parser automatically removes any quotes around expressions.
            operand = "(#{match})"

          # should there be a % field type? evaluates, but just leaves behind nil
          # maybe good for symmetry; could use for processing-only directives
          #elsif (match = field[/^%\s*(.*)/, 1])
# will force some restructuring

          else
            # Just set local variable for literal fields.
            operand = Util.value_from_string(field).inspect
          end

          expression = "#{variable} = #{operand}"

          #puts "row.each: #{header} = #{field} => #{operand.inspect} is #{operand.class}"
          #puts "  expression: #{expression}"

          letters = integer_to_letters(col_num)
# only applies for %= or %
          expression.prepend("this_cell = \"#{letters}#{row_num}\"; ")  # For debugging

# NOPUB make file_name format match other outputs and error messages
          path = @path ? @path : "modelkit"
          file_name = "#{path} at #{letters}#{row_num} => col:#{col_num} row"
# NOPUB in newer Ruby versions, can switch to `set_local_variable` on Binding ... maybe?
          result = row_binding.eval(expression, file_name, row_num)

          new_row[header] = result

          variables[variable.to_sym] = result

# NOPUB could save space by ONLY storing everything in `variables` hash.
#   List of parameters is saved somewhere; `parameters` hash is generated on demand later from variables one.

# NOPUB header will be normalized by now; no whitespace
          if (name = header[/^:(\w*)/, 1])
            parameters[name.to_sym] = result
          end

        end

        block.call(row, index, variables, parameters)  # pass in new_row?  YES

        return(new_row)
      end

    private

# NOPUB these should become class level methods

# int_col_key, int_col_name, convert_to_col_name   alpha_name  int_to_alpha   int_to_letter
# column_letters, convert_to_letters
# number_to_letters
# r1c1_to_a1  nice except just doing column conversion
# int_to_chars   letters is more precise
      def integer_to_letters(integer)  # 58 => "BF" with one-based index
        letters = ""
        while (integer > 0) do
          integer, remainder = (integer - 1).divmod(26)
          letters.prepend((remainder + 65).chr)
        end
        return(letters)
      end


      def letters_to_integer(letters)  # "BF" => 58 with one-based index
        chars = letters.reverse.codepoints
        integer = chars.each_with_index.reduce(0) { |sum, (char, index)| sum + (char - 64) * 26 ** index }
        return(integer)
      end

# NOPUB to fix:
# + blank column header => error
# + strip whitespace on header
# - validate the variable/parameter name (no special chars; has to be acceptable Ruby variable)
# - disallow duplicate header names
# - add other parameter symbols:  &  $
# + strip whitespace on fields

# NOPUB reference method in Parameter class--this is kind of duplicate
      def valid_variable_name?(name)
        return(name =~ /^[a-z_][a-zA-Z_0-9]*$/ and not RUBY_KEYWORDS.include?(name))
      end

      def parameter_name(header)
        return(header =~ /^[:&]/ ? header[1..-1] : nil)
      end

# above is better
#       def parameter?(header)
# # might need extra parens:    !! (header =~ /^[:&]/)
#         return(!! header =~ /^[:&]/)
#       end

      def parse(string)
        @table = CSV.parse(string, :headers => true)

# NOPUB: to consider:
# Transform header names to valid instance variables names, e.g.: "Model Name" => "@model_name"
# with secondary accessor method:  @variables["Model Name"]

        # Separate variables and parameters.
        @table.headers.each_with_index do |header, index|
          # Fields that should be treated as parameters are indicated with an initial colon:
          #   e.g., :field
          # All other fields are treated as instance variables.

          #puts "header=#{header.inspect}"

          # if (header.nil?)
          #   raise("nil header at column #{index + 1} (#{integer_to_letters(index + 1)}1)")
          # else
          #   header.strip!  # Normalize header (permanently) for this table
          # end

# doing strip cuts the "     " to "" for outputting.



          #if (not header =~ /^:?[a-z_][a-zA-Z_0-9]*$/)

          #if (not match = header.match(/^:?([a-z_][a-zA-Z_0-9]*)$/))   # won't work with nil


          #if (header.nil? or header.empty?)
          #  raise("empty header at column #{index + 1} (#{integer_to_letters(index + 1)}1)")

# I want to report with:
# - strip! no leading/trailing spaces
# - colon removed
# - don't strip if string is empty!

          #if (no)

# check valid variable name: call a remote function somewhere
#   checks: /^[a-z_][a-zA-Z_0-9]*$/
#   checks: RUBY_KEYWORDS.include?(variable_name)

          #if (header =~ "/^:/")

# must strip and remove colon first!

          #if (not valid_variable_name?(name))

          if (header.nil? or header.empty?)
            raise("nil/empty header at column #{index + 1} (#{integer_to_letters(index + 1)}1)")
          end

          header.strip!

          if (not header =~ /^:?[a-z_][a-zA-Z_0-9]*$/)
            # if (header)
            #   header.strip!
            # end
            raise("bad header at column #{index + 1} (#{integer_to_letters(index + 1)}1); " \
              "#{header.inspect} is not a valid Ruby variable name")

# might use: header.start_with?(":")   ...faster
        elsif (name = header[/^:(\w*)/, 1])
            if (@parameters.include?(name))
              raise("duplicate header parameter at column #{index + 1} (#{integer_to_letters(index + 1)}1); " \
                "'#{name}' is already specified in another column")
            else
              @parameters << name  # Colon has been removed
            end

          else
            name = header
            if (@variables.include?(name))
              raise("duplicate header variable at column #{index + 1} (#{integer_to_letters(index + 1)}1); " \
                "'#{name}' is already specified in another column")
            else
              @variables << name
            end
          end

          if (RUBY_KEYWORDS.include?(name))
# NOPUB won't actually do this
            puts "Warning: '#{name}' is a reserved keyword for Ruby; the variable name has been modified to '#{name}_'"
            name << "_"
          end

          @variable_map[header] = name
        end

        #puts "variables = #{@variables}"
        #puts "parameters = #{@parameters}"

        # return ?
      end

    end

  end
end


# the entire Row gets evaluated BEFORE the block is called.


# need to really evaluate cells based on dependency order.
# set constant on initial RowContext set up:  @climate = UNDEFINED means need to eval other cell first


# header => the user specified column label; might not be a valid Ruby variable name: "Model Name"
# variable => a valid Ruby variable name, transformed from header string: "model_name"

# variable_map["Model Name"] => "model_name"  # set this up once

# block arg: variables[:model_name] or variables["Model Name"] -- possible to allow lookup by either?
