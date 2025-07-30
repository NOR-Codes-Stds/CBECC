# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("pathname")


module Modelkit

# NOPUB convention is factory method takes various objects (not just strings) and makes it into a path.
#   could take a Path and return a new Path

# A little strange. Most important thing is want to be able to call this
# internally within Modelkit without the .new method.
  def Path(path)
    return(Path.new(path))
  end

# Good to keep this immutable. Always return a new Path object.
# A "path" is literally a path or route to a resource.
# Multiple paths can end up at ("resolve") to the same resource but the
# paths themselves are not equivalent:
#   a/b/../c != a/c
# The two paths may both point to c, they just get there by a different route.
# This becomes especially relevant when considering symbolic links.
# In the example above, if 'b' is a symlink, the paths may _not_ end up at the
# same resource.
  class Path

# could pass in a string or another Path or a Pathname
#   accept anything that responds to to_path?
# how to handle no arg?
    def initialize(path)
      @pathname = Pathname.new(path.to_s.gsub("\\", "/"))  # Pathname DOES NOT replace backslashes

      # DON'T do cleanpath--it eliminates any ..
      # but DO want to remove extra slashes, redundant single dots, etc.
    end

    def +(path)
      # Can really implement this myself...there's nothing tricky here except
      # to be careful when adding an absolute path; the first path gets ignored.
      other_path = self.class.new(path)  # won't work with anything other than string
      new_pathname = @pathname + other_path.pathname
      new_path = self.class.new(new_pathname.to_s)
      return(new_path)
    end

    # This method allows Path objects to be passed to File, Dir, etc.
    def to_path
      return(to_s)
    end

    # Return a canonical string representation.
    def inspect
      return("#<#{self.class}:#{to_s}>")
    end

    # This method is called for string interpolation.
    def to_s
      return(@pathname.to_s)
    end

  protected
    attr_reader :pathname

  end

end
