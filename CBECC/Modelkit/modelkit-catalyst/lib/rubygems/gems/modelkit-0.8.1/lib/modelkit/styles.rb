# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.


# NOPUB Should this actually be part of a Console module?
#   - styles are entirely about formatting/coloring text in the Console
#   - other useful ANSI methods could clear the screen, position the cursor
#   - progress bar or spinner, etc.

# Customize styles using .modelkit-config
# [console.styles]
# error = "RED BOLD"
# warning = "YELLOW ITALIC BLUE_BG"

module Modelkit
  module Styles

    BLACK = "\e[30m"
    RED = "\e[31m"  #"\e[31m#{mytext}\e[0m"
    GREEN = "\e[32m"
    YELLOW = "\e[33m"

    BOLD = "\e[1m"   #  Bold off \e[22m  ... doesn't work on Windows the same way...
    ITALIC = "\e[3m"

    INVERSE = "\e[7m"

    RESET = "\e[0m"  # Reset all colors and attributes (i.e., bold, italic)


# class String
# def black;          "\e[30m#{self}\e[0m" end
# def red;            "\e[31m#{self}\e[0m" end
# def green;          "\e[32m#{self}\e[0m" end
# def brown;          "\e[33m#{self}\e[0m" end
# def blue;           "\e[34m#{self}\e[0m" end
# def magenta;        "\e[35m#{self}\e[0m" end
# def cyan;           "\e[36m#{self}\e[0m" end
# def gray;           "\e[37m#{self}\e[0m" end
#
# def bg_black;       "\e[40m#{self}\e[0m" end
# def bg_red;         "\e[41m#{self}\e[0m" end
# def bg_green;       "\e[42m#{self}\e[0m" end
# def bg_brown;       "\e[43m#{self}\e[0m" end
# def bg_blue;        "\e[44m#{self}\e[0m" end
# def bg_magenta;     "\e[45m#{self}\e[0m" end
# def bg_cyan;        "\e[46m#{self}\e[0m" end
# def bg_gray;        "\e[47m#{self}\e[0m" end
#
# def bold;           "\e[1m#{self}\e[22m" end
# def italic;         "\e[3m#{self}\e[23m" end
# def underline;      "\e[4m#{self}\e[24m" end
# def blink;          "\e[5m#{self}\e[25m" end
# def reverse_color;  "\e[7m#{self}\e[27m" end
# end

# Ortho properties:
# - foreground color
# - background color
# - boldness
# - italicness


# prop def can add any extra characters!
#   "style me"  =>  "\e[31m*** style me ***\e[0m"  # notice extra *** chars

# transformations

# don't need a reset after every color change; only at end to go back to default
# "\e[31mred\e[32mgreen\e[0m"

    @@definitions = {}

    def self.definitions
      return(@@definitions)
    end

    def self.keys
      return(@@definitions.keys)
    end

    def self.define(key, props)
      # check props?
      @@definitions[key] = props
      #return ?
    end

    def self.undefine(key)
      @@definitions.delete(key)
      #return ?   true if found, else false
    end

    def self.enabled(boolean)
      # temporarily disable all styles
    end



  end
end


# Add to Kernel
def style(key, string)  # should be inside Styles module, with alias in Kernel

  this_style = Modelkit::Styles.definitions[key]
  # if found

  return("#{this_style}#{string}\e[0m")  # tack reset code on end
end


Modelkit::Styles.define(:em, Modelkit::Styles::RED + Modelkit::Styles::BOLD)

# Most elegant:
module Modelkit::Styles
  define 2, GREEN + ITALIC
end

puts style(:em, "This is the em style!")
puts "This is for #{style :em, "emphasis"}!"  # *really* nice looking!

style :em { "This is the em style!" }  # this could also work

# Easy to clear all the styles for --no-color:
#   Modelkit::Styles.definitions.each_key { |key| Modelkit::Styles.definitions[key] = nil }
# although this syntax is supposed to be bad--changing in place
