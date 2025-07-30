# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/eval_scope")
require("modelkit/path_search")
require("modelkit/console")
require("modelkit/parametrics/group_index")


module Modelkit
  module Parametrics

    # The TemplateScope class provides the scope of limited methods available inside a Template and generates
    # a clean binding for evaluating local variables.
    #
    # CAUTION: Despite the binding, global variables and constants remain available across all Templates--this includes
    # classes loaded to the top-level scope using 'require' from inside or outside a Template. There is some risk of
    # namespace collisions if two files with identical class names are required from within different Templates.
    #
    # Methods that rely on the path of the template file are supported in the same way that
    # they would be when running a normal Ruby file. Specifically, these methods should work
    # as expected:
    #
    #  require_relative => requires files relative to the parent directory of this template file
    #  __FILE__ => returns the canonical absolute path of this template file
    #  __dir__ => returns the canonical absolute path of the parent directory of this template file
    class TemplateScope < EvalScope
# do these need to be accessors??
      #attr_accessor :local_binding,

# See if we can remove these:
      attr_accessor :local_output, :global_output
      attr_accessor :options


      def initialize(template, options = {})
        super()
        @template = template
        @options = options

        options[:depth] ||= 0  # Depth of nested templates; 0 = top-level template
        options[:dirs] ||= []
        options[:inputs] ||= {}

        options[:annotate] ||= false
        options[:esc_begin] ||= ""
        options[:esc_line] ||= ""
        options[:esc_end] ||= ""
        options[:indent] ||= ""

        @caller = nil
        @dirs = options[:dirs]

        if (@template.path)
          # Search first in local directory of this template, if it has a path.
          @path_search = PathSearch.new(File.dirname(@template.path), *@dirs)
        else
          @path_search = PathSearch.new(*@dirs)
        end

        #@local_binding = template_binding

        # This variable contains the accumulated local output generated so far by the current template.
        # The variable is used by ERB as the output variable. The local output can be modified from inside the template.
        @local_output = ""

        # This variable contains the accumulated global output generated so far *before* the current template.
        # The global output can be modified but has no effect on the final output if changed.
        @global_output = ""
        @group = @template.group  # => @template.interface

        @index = @local_binding.eval("__index__ = Parametrics::GroupIndex.new(@local_binding, @group)")
        @index.__hash__.each do |key, value|
          # Assign a local variable for each top-level Group.
          if (value.class == GroupIndex)
            @local_binding.eval("#{key} = #{@group.key}.#{key}")
          end
      end
        @index << options[:inputs]  # Assign initial values to local variables for Parameters

      end

    private

# NOPUB This is now in superclass.
      # Generates a clean binding for evaluating local variables in this TemplateScope.
      #
      # NOTE: The name of this method appears in all template-related error messages back to the user.
      # def template_binding
      #   # Any local variables defined inside this method are available within the Template.
      #   return(binding)
      # end

      def insert(path, parameters = Hash.new)
        # Warning: `insert` is obsolete and will be removed in a future version.
        insert_template(path, parameters)
      end

      def insert_string(string)
        # type check for String?
        @local_output << string
        return(nil)
      end

# Since we're changing the name to `insert_template`, could change the method to be called:
#   `include_template` because we are not conflicting with the built-in `include` anymore!
      def insert_template(path, parameters = Hash.new)
        annotate("INSERT TEMPLATE #{path.inspect}")

        if (@options[:depth] == Template::DEPTH_LIMIT)
          annotate("ERROR: Maximum nesting depth (#{Template::DEPTH_LIMIT}) exceeded; template not inserted.")
# NOPUB if strict, raise TemplateError

        elsif (not full_path = resolve_path(path))
# NOPUB better to use path.inspect because it will reveal invisible Unicode characters
          annotate("ERROR: Could not resolve path #{path.inspect} from possible paths:")
          puts "ERROR:  Could not resolve path #{path.inspect} from possible paths:"
          @dirs.each do |dir|
            annotate("  #{File.expand_path(path, dir).inspect}")
            puts "  #{File.expand_path(path, dir).inspect}"
          end

        else
          annotate("Path resolves to #{full_path.inspect}")

# NOPUB would be nicer to use the short path here--looks better in the annotation vs. big long path
#   any way to do this?
          old_options = {:caller => @template, :dirs => @dirs}
          sub_template = Template.read(full_path, old_options)
          # handle errors here, or they might go to the right place on their own

#puts "call_chain = #{sub_template.call_chain}"

          sub_options = @options.dup  # because changing depth
          sub_options[:depth] += 1
          sub_options[:inputs] = parameters
          composition = sub_template.compose(sub_options).local_output
          #end

          if (@options[:annotate] and not @options[:indent].empty?)
            # Prepend each line with the indent string.
            new_lines = composition.lines.map do |line|
              line.chomp.empty? ? line : line.prepend(@options[:indent])
            end
            composition = new_lines.join
          end

          insert_string(composition)
        end


        # Return nil so that text is not duplicated if used with <%= %> syntax.
        return(nil)
      end

# Inserts a static file. The advantage over 'insert_template' is that it's much faster because
# it doesn't treat it like a Template with all the associated processing overhead.
      def insert_file(path)
        #
      end

      # Convert a list of keys (as Symbols or Strings) into a Hash object mapped to corresponding local variables.
      def local(*keys)
        hash = {}; keys.each do |key|
          if (not key.class == Symbol and not key.class == String)
            raise(TypeError, "no implicit conversion of #{key.class} into Symbol")
          end

          hash[key.to_sym] = @local_binding.eval(key.to_s)
        end
        return(hash)
      end

      def call_chain  # call_stack, ancestors
        if (@caller)
          chain = [@caller, *@caller.call_chain]
        else
          chain = []
        end
        return(chain)
        #return(@caller ? [@caller, *@caller.call_chain] : [])
      end

      def notify(type, message, line)
        puts "notify:#{line}[#{message}]"

        if (@caller)
          @caller.notify(type, message, line)
        end
# elsif ?
        # if (@block)
        #   @block.call(message)
        # end
      end

# should there be __template__ in addition to @template?
# might choose whether to do everything with __xyz__ or @xyz; helps keep things clear, less to learn, comprehend
# some underscore vars are already defined (and can't be removed): __FILE__, __dir__
# maybe only instance vars should be @local and @global, and @local_binding
# BUT, @template cannot be removed

# Needed? already accessible through @template.
#      def __parameters__
#      end

# alias for __FILE__ constant
#  allows usage like this:  __path__:__line__
      def __path__
        return(__FILE__)

# __path__ and __FILE__ also do not work right for console session from inside a template.


      end

      # Returns current line number.
      def __line__
# NOPUB almost identical code from Modelkit.parse_exception

#puts "in __line__"
#puts caller

# doesn't work right for Console:
# Problem is that EvalScope (for console) and TemplateScope both use __binding__
# once in a console session, it finds the first occurence of __binding__ which is
# for the console.

# in Ripl => shell.rb
# def loop_eval(str)
#   eval(str, @binding, "(#{@name})", @line)
# end

# need to pass in template path and line number from template scope!
# - the way the name string is formatted "(#{@name})", I will have to add my own patch for Ripl
# - line number can/should be:  12:1  where 12 is in template, 1 is in console session?

# Modelkit.console(@local_binding, __path__, __line__)

# binding method name must be a unique name in the stack so that it can be found!
# could be multiple levels of scopes deep.
# EvalScope should generate a uniquely named method (based on object id?) every time

  # be careful template_binding method is still named the same!
        template_caller = caller.find { |entry| entry =~ /:in `__binding__'/ }
        if (template_caller)
          line_num = template_caller[/:(\d*):/, 1].to_i
        else
          line_num = 0
        end
        return(line_num)
      end

      # access calling template?
      #def __caller__


      # Hash version of __index__ => same as __index__.to_h
      def __inputs__
        return(@index.to_h)
      end

# DEPRECATE - preserved for short-term compatibility
      def parameters
        return(@index)
      end

# NOPUB Ruby already has a `fail` but this is good to override here for better experience,
#  e.g., capturing the template backtrace.
#  also alias `raise` to the same. Normally fail == raise
      #def fail  # raise
      #end

# NOPUB Also wrap `exit` and `abort` so that it is handled cleanly (i.e., partial output is saved, etc.)

      # Sends a warning message.
      # Overrides Ruby's built-in `warn`
      def warn(message = "")
        line_num = __line__
        string = "WARNING:line #{line_num}: #{message}"
# actually great to have line number in the annotation!
        annotate(string)

        # Pass message up call chain/stack.
        notify("WARN", message, line_num)

# returns formatted message that gets inserted?
# but nice to call this second

# NOPUB Return nil so that text is not duplicated if used with <%= %> syntax.
        return(nil)
      end

# NOPUB old method names:  error, warning, info
#  New ones override Ruby Kernel names: `fail` and `warn`; `note` is my idea

      # Sends an informational note.
      # I like that each of these is a verb.
      def note(message = "")
      end

      # Resolve a path according to the search directories.
      def resolve_path(path)
        return(@path_search.resolve(path))
      end

      # Start an interactive Ruby console session within the scope (i.e., binding) of this template.
      # When the user exits the session, the template should continue processing as normal.
      def console(label = nil)
        #if (label)
          # Set Terminal window title to 'label' or template path?
        #end
        # Useful to indicate which "breakpoint" you're at.
        # Otherwise if multiple calls to console on different logic branches, won't know which one!
        #puts "label = #{label}"

        if (@path)
          puts "template = '#{Modelkit.platform_path(@path)}'"
        end

        Modelkit.console(@local_binding)  # __path__, __line__, backtrace)
        return(nil)
      end

    public

# This is currently called from Template to add "BEGIN" string
# NOPUB Should this be private? Don't want outside users to call `template.annotate("text")`
#   It's more of an internal thing, or utility method. Gets called by TemplateScope though.
#   Put in a mixin module?
      # Adds notes to the output result.
      # The notes can be optionally escaped using user-defined notation, for example, to treat them
      # as comments that can be ignored by whatever program consumes the output result.
      # Annotation can be supressed using a user option.
      # NOTE: The message string can be multi-line.
# can also check the indent and apply based on @depth
      def annotate(text_in)
        if (@options[:annotate])
          text_out = "#{@options[:esc_begin]}#{text_in.gsub(/^/, @options[:esc_line])}#{@options[:esc_end]}\n"
        else
          text_out = ""
        end
        @local_output << text_out.force_encoding("UTF-8")
        return(nil)
      end

      def to_s
        return(@local_output)
      end

      def inspect
        return("#<#{self.class} template=#{@template.inspect}>")
      end

    end

  end
end
