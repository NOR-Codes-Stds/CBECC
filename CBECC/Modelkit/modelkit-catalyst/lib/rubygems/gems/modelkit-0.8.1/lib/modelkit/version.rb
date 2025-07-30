# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit

# TO DO:
#   [ ] coerce a string ("1.2.3") into Modelkit::Version for comparison
#   [ ] coerce a Gem::Version instance into Modelkit::Version for comparison
#   [ ] Modelkit::Version: should coerce easily to a string; use to_str and maybe coerce
#       want to be able to use it like a String, e.g. `script_text.gsub("$VERSION$", modelkit_version)`   # normally expects a string
#       coerce and to_s is not enough, probably needs to_str
#   [ ] coerce to string to make seamless: "string=" + version => "string=0.8.1"

  class Version

    include Comparable

    def initialize(string)
      if (not string.kind_of?(String))
        raise(TypeError, "no implicit conversion of #{string.class} into String")
      elsif (string.empty?)
        raise(ArgumentError, "version number string must not be empty")
      end

      begin
        @version = Gem::Version.new(string)
      rescue StandardError => exception
        raise(exception.class, exception.message)
      end
    end

# possibly don't need
    # def ==(other)
    #   puts "=="
    #   return(@version == Modelkit::Version(other).version)
    # end

    def <=>(other)
      puts "<=>"
      # if (not other.kind_of?(self.class))
      #   puts "not"
      #   #other = self.class.new(other.to_s)
      #   other = Modelkit::Version(other)
      # end

      # or just run it through Factory method which will always convert anything.
      #return(@version <=> other.version)
      return(@version <=> Modelkit::Version(other).version)
    end

    def eql?(other)
      return(@version.eql?(Modelkit::Version(other).version))
    end

    # Allow objects to be coerced into a Version object for comparison.
    def coerce(other)
      #return([self, self.class.new(other.to_s)])
      #return([self, Modelkit::Version(other)])
      return([self, Modelkit::Version(other)])

      # should maybe be: [Modelkit::Version(other), self]
    end

    # still does not coerce right:
    # "1.2.3" == Version.new("1.2.3") # => false

    def to_s
      #puts "to_s"
      return(@version.to_s)
    end

    # def to_str
    #   puts "to_str"
    #   return(to_s)
    # end

    def inspect
      return(to_s)
    end

  protected
    attr_reader :version

  end

# NOPUB add a Version.convert method as alias to this one?:

  # Factory method to convert an object into a Version object.
  def self.Version(object)
    return(Version.new(object.to_s))
  end

end
