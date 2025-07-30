require 'ripl'

Ripl.config[:multi_line_engine] ||= :live_error
require 'ripl/multi_line'

# # # #
# This multi-line implementation uses catches the syntax errors that are yielded by unfinsihed statements
#   works on:         2.0  1.9  1.8  jruby  rbx
#   analyze features: [:literal, :string]
#                     [:literal, :regexp]
#                     [:literal, :array]   (mri only)
#                     [:literal, :hash]    (mri only)
#                     [:statement]
#                     [:forced]
#   notes:            rbx support buggy (depends on rubinius error messages)
module Ripl::MultiLine
  module LiveError
    VERSION = "0.2.0"

    def self.ruby_engine
      return @ruby_engine if defined? @ruby_engine
      @ruby_engine = defined?(RUBY_ENGINE) && RUBY_ENGINE.downcase.to_sym
      @ruby_engine = :ruby   if !ERROR_MESSAGES.keys.include?(ruby_engine) # 1.8 is same as 1.9
      @ruby_engine = :ruby19 if ruby_engine == :ruby && RUBY_VERSION <= "2.0"
      @ruby_engine
    end

    ERROR_MESSAGES = {
      :ruby => [
        [[:literal, :string], /unterminated string meets end of file/],
        [[:literal, :regexp], /unterminated regexp meets end of file/],
        [[:literal, :array],  /syntax error, unexpected end-of-input, expecting '\]'/],
        [[:literal, :hash],   /syntax error, unexpected end-of-input, expecting '\}'/], # does not work for ranges or {5=>
        [[:statement],        /syntax error, unexpected end-of-input/],
      ],
      :ruby19 => [
        [[:literal, :string], /unterminated string meets end of file/],
        [[:literal, :regexp], /unterminated regexp meets end of file/],
        [[:literal, :array],  /syntax error, unexpected \$end, expecting '\]'/],
        [[:literal, :hash],   /syntax error, unexpected \$end, expecting '\}'/], # does not work for ranges or {5=>
        [[:statement],        /syntax error, unexpected \$end/],
      ],
      :jruby => [
        [[:literal, :string], /unterminated string meets end of file/],
        [[:literal, :regexp], /unterminated regexp meets end of file/], # array or hash cannot be detected
        [[:statement],        /syntax error, unexpected end-of-file/],
      ],
      :rbx => [
        [[:literal, :string], /unterminated [a-z]+ meets end of file/], # no extra message for regexes
        [[:literal],          /expecting '\\n' or ';'/], # TODO: better rbx regexes or rbx bug report
        [[:literal, :hash],   /expecting '\}'/],
        # [:literal,          /expecting '\]'/],
        # [:literal,          /expecting '\)'/],
        [[:statement],        /syntax error, unexpected \$end/],
        [[:statement],        /missing 'end'/], # for i in [2,3,4] do;
      ],
    }
 
    define_method(:print_eval_error) do |e|
      if e.is_a? SyntaxError
        ERROR_MESSAGES[LiveError.ruby_engine].each{ |type, message|
          handle_multiline(type) if message === e.message
        }
      end
      super(e)
    end

    def eval_input(input)
      if input =~ /;\s*\Z/ # force multi line with ;
        handle_multiline(:forced)
      elsif input =~ /^=begin(\s.*)?$/ && !@buffer
        @ignore_mode = true # MAYBE: change prompt
      elsif !@ignore_mode
        super
      end
    end

    def print_result(result)
      if @ignore_mode && @input == '=end'
        @ignore_mode = false
      elsif !@ignore_mode
        super
      end
    end
  end
end

# J-_-L
