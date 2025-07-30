# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("pathname")


module Modelkit

# PathList?
  class PathSearch

# NOPUB This is a cool pattern from https://github.com/thomasbaustert/search_path
# Define the search paths. Search paths are considered in the order given; first given, first searched.
#   search_path = SearchPath.new(["/custom/path/to/files", "/standard/path/to/files"])
#
# Case 1: File not in "/custom/path/to/files" but in "/standard/path/to/files":
#   search_path.find("template.erb") # => "/standard/path/to/files/template.erb"
#
# advantage here is that the dirs can be expanded once on creation (or turned into Path objects, etc)

# SketchUp has something too?


# design point:
# - are the search paths expanded (relative to PWD) at time of creation, i.e., on `append` to PathSearch
# - or expanded when `resolve` is called (PWD maybe be changing)

    def initialize(*paths)
      @search_paths = []
      paths.each do |path|
        path = path.gsub(/\\/, '/')  # Replace backslash in new copy of String
        path = File.expand_path(path)  # Expand relative to working directory and clean
        if (not @search_paths.include?(path))
          @search_paths << path
        end
      end
    end

# find?
    def resolve(path)
      resolved_path = nil
      path = path.gsub(/\\/, '/')  # Replace backslash in new copy of String
      if (Pathname.new(path).absolute?)
        if (File.exist?(path))
          resolved_path = path
        end

      else
        @search_paths.each do |dir|
          expanded_path = File.expand_path(path, dir)
          if (File.exist?(expanded_path))
            resolved_path = expanded_path
            break
          end
        end
      end
      return(resolved_path)
    end

# NOPUB is this useful?
    #def glob(*patterns)

    def to_a
      return(@search_paths)
    end

  end
end
