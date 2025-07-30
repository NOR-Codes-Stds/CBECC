# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit")


module Modelkit

# Exception parsing for inside of user-provided code in scope of Template, Console, Worksheet, etc.


# Needs to be improved for Console errors anyway.
# Must be reused for Worksheet also!

# content is optional?

  def self.parse_exception(exception, content)

    puts "MESSAGE"
    puts exception.message
    puts "BACKTRACE"
    #puts exception.backtrace.class  # => Array
    puts exception.backtrace

    # There are two kinds of exceptions: syntax errors and everything else!
    # NOTE: The exact format of 'message' and 'backtrace' for Exceptions may depend on which version of Ruby!

# message.lines
    message_lines = exception.message.split("\n")
    first_line = message_lines.first

    location = "unknown"

    line_num = nil
    line_caret = nil


    if (exception.kind_of?(SyntaxError))
      puts "SyntaxError"

      # Everything is in message; backtrace is not used.

      # COMPILE ERROR:
      #   Has one or more lines in 'message'
      #   Line number of error is in 'message'

      # 'message' format:
      #   First line is the error detail with line number
      #   Second line is the line text; it could also be "; erbout.force_encoding(_ENCODING_)" which indicates the end of the file
      #   Third line is the pointer caret ^ (if available)
      #   Compiler errors often have a domino effect; if so, lines 1-3 can repeat for multiple errors


      line_caret = message_lines[2]

      if (match_data = first_line.match(/:(\d*):\s*(.*)/))
        # Syntax errors are expected to be formatted as follows:
        #   <path>:<line-number>: <description>
        captures = match_data.captures
        description = captures[1]

        if (first_line.match(/unexpected end-of-input/))
          # Missing `end` keyword or curly brace.
          location = "end of file"
        else
          line_num = captures[0].to_i
          location = "line #{line_num}"
        end

# there's also this one: "expecting end-of-input"
# handle?


# this is problematic:
#NameError at line 38 in 'template_binding': undefined local variable or method `x' for #<Modelkit::Parametrics::TemplateScope:0x007f9d8fb42b00>
#3 + x  # => NameError (x is undefined)


# Check Errno errors (from system errors--file doesn't exist)


      else
        # Unexpected format; just return the full line.
        description = first_line

      end

    else  # All other errors
      puts "all other"

      # Most information is in backtrace; message only has the

      # RUNTIME ERROR:
      #   Has one line in 'message'
      #   Line number of error is in 'backtrace' but not necessarily the first line; search for "(erb)"
      #   Has no line text or pointer caret

      description = first_line

      # Method name is best from the last caller, but line number should come from (erb).
      last_caller = exception.backtrace.first
      if (match_data = last_caller.match(/:in `(.*)'/))
        method_name = match_data.captures.first
      else
        method_name = nil
      end

      binding_name = "__binding__"

# this could be better?
#exception.backtrace.select { }

      if (matches = exception.backtrace.grep(/:in `#{binding_name}'/))
        caller =  matches.first
        if (match_data = caller.match(/:(\d*):in `#{binding_name}'/))
          line_num = match_data.captures.first.to_i
          location = "line #{line_num} in '#{method_name}'"
        end
      end

    end

    # Replace ugly backticks with single quotes.
#    error_detail.gsub!(/`/, "'")
#    method_name.gsub!(/`/, "'")

    # Strip unhelpful object references: "for #<Modelkit::Parametrics::Template____>"
#    error_detail.gsub!(/ for #<Modelkit::Parametrics::Template.*?>/, "")


    output = "#{exception.class} at #{location}: #{description}\n"

    if (line_num)
      # Read actual line from content because it may not be present in exception message.
      line_text = content.lines[line_num - 1].chomp!
      output << "#{line_text}\n"
    end

    if (line_caret)
      output << "#{line_caret}\n"
    end

    # After full template is processed, could raise a single final exception if any exceptions were encountered along the way.
    # Better yet, pass up to control framework an error code that can be interpreted somewhere as "TEMPLATE PROCESSING FAILED".

# return Exception class and message?

    return(output)
  end

end
