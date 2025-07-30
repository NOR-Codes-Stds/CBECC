# see https://github.com/cldwalker/ripl-ripper/blob/master/lib/ripl/ripper.rb for a different (standalone) plugin
require 'ripl'
require 'ripper'

Ripl.config[:multi_line_engine] ||= :ripper
require 'ripl/multi_line'

# # # #
# This multi-line implementation uses Ripper
#   works on:         2.0  1.9  1.8(gem)
#   analyze features: [:literal, :string]
#                     [:literal, :regexp]
#                     [:literal, :array]   (mri only)
#                     [:literal, :hash]    (mri only)
#                     [:statement]
#                     [:forced]
#   notes:            statement could also be [
module Ripl::MultiLine::Ripper
  VERSION = '0.1.0'

  def multiline?(string)
    return [:forced] if string =~ /;\s*\Z/

    expr = ::Ripper::SexpBuilder.new(string).parse

    return [:statement] if !expr # not always statements...

    # literals are problematic..
    last_expr = expr[-1][-1]

    return [:literal, :regexp] if last_expr == [:regexp_literal, [:regexp_new], nil]

    delimiters = %q_(?:[\[<({][\]>)}]|(.)\1)_

    return [:literal, :string] if last_expr == [:string_literal, [:string_content]] &&
      string !~ /(?:""|''|%q?#{delimiters})\s*\Z/i # empty literal at $

    return [:literal, :string] if last_expr == [:xstring_literal, [:xstring_new]] &&
      string !~ /(?:``|%x#{delimiters})\s*\Z/i

    return [:literal, :string] if last_expr == [:words_new] &&
      string !~ /%W#{delimiters}\s*\Z/
 
    return [:literal, :string] if last_expr == [:qwords_new] &&
      string !~ /%w#{delimiters}\s*\Z/
  end
end


# J-_-L
