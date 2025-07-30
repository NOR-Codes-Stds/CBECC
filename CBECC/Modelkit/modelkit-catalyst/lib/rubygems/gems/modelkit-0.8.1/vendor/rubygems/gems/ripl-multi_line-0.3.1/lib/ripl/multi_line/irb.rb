require 'ripl'
require 'irb/ruby-lex'
require 'stringio'

Ripl.config[:multi_line_engine] ||= :irb
require 'ripl/multi_line'

# # # #
# This multi-line implementation uses IRB's RubyLex parser
#   works on:         2.0  1.9  1.8  jruby  rbx
#   analyze features: none
module Ripl::MultiLine::Irb
  VERSION = '0.1.0'

  class << self
    attr_reader :scanner
  end
 
  # create scanner and patch it to our needs
  @scanner = RubyLex.new

  def @scanner.multiline?
    initialize_input
    @continue = false
    @found_eof = false

    while line = lex
      @line << line
      @continue = false
    end
      
    !!( !@found_eof or @ltype or @continue or @indent > 0 )
  end

  def @scanner.lex
    until (((tk = token).kind_of?(RubyLex::TkNL) || tk.kind_of?(RubyLex::TkEND_OF_SCRIPT)) &&
	     !@continue or
	     tk.nil?)
      #p tk
      #p @lex_state
      #p self
    end
    @found_eof = true if tk.kind_of?(RubyLex::TkEND_OF_SCRIPT)
    line = get_readed
    #      print self.inspect
    if line == "" and tk.kind_of?(RubyLex::TkEND_OF_SCRIPT) || tk.nil?
      nil
    else
      line
    end
  end

  def multiline?(string)
    Ripl::MultiLine::Irb.scanner.set_input StringIO.new(string + "\0")
    Ripl::MultiLine::Irb.scanner.multiline?
  end
end

# J-_-L
