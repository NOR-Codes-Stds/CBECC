# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/version")


module Modelkit

  class VersionConstraint

    def initialize(*constraints)
      # must be strings

      # if (not string.kind_of?(String))
      #   raise(TypeError, "no implicit conversion of #{string.class} into String")
      #
      # elsif (string.empty?)
      #   raise(ArgumentError, "version number string must not be empty")
      # end

      @requirement = Gem::Requirement.new(*constraints)

      # rescue errors
    end

    def include?(version)
      if (not version.kind_of?(Version))
        raise(TypeError, "no implicit conversion of #{version.class} into Modelkit::Version")
      end

      # Must take a Gem::Version
      version = Gem::Version.new(version.to_s)

      return(@requirement.satisfied_by?(version))
    end

    # Same as include? but converts strings to Version object first.
    def ===(version)
      if (version.kind_of?(String))
        version = Version.new(version)
      elsif (not version.kind_of?(Version))
        raise(TypeError, "no implicit conversion of #{version.class} into Modelkit::Version")
      end

      return(include?(version))
    end

    # need to_s and inspect, otherwise shows Gem::Requirement details
    #def inspect
      # this is important for modelkit_version
    #end

  end

  # Factory method to create a VersionConstraint object from a string representation.
  def self.VersionConstraint(string)
    # split with commas
    return(VersionConstraint.new(string))
  end

end
