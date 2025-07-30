require 'ripl'

Ripl.config[:multi_line_engine] ||= :error_check
require 'ripl/multi_line'
require 'ripl/multi_line/live_error'

# # # #
# This multi-line implementation uses catches the syntax errors that are yielded by unfinsihed statements
#   works on:         2.0 1.9  1.8  jruby  rbx
#   analyze features: see live_error.rb
#   known issues:     see live_error.rb
module Ripl::MultiLine::ErrorCheck
  VERSION = '0.2.0'

  define_method(:multiline?) do |string|
    break [:forced] if string =~ /;\s*\Z/ # force multi line with ;

    begin
      eval "if nil; #{string}; end"
    rescue SyntaxError => e
      Ripl::MultiLine::LiveError::ERROR_MESSAGES[Ripl::MultiLine::LiveError.ruby_engine].each{ |type, message|
        break type if message === e.message
      }
    end
  end
end

# J-_-L
