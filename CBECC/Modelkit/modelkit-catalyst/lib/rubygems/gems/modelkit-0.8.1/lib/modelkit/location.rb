# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

#require("tzinfo")
require("observer")


module Modelkit

  # Location is a class that can be referenced by multiple other objects: Model Documents, Weather Documents, other...
  # Location (and its peers) have no knowledge about documents or formats.
  # This object doesn't know anything about writing to any specific format.
  class Location # < Object   # Object has general stuff like observers
    include Observable

# gets generated from schema.
    attr_accessor :mediator
    attr_reader :name, :latitude, :longitude, :elevation, :time_zone_offset, :azimuth, :custom
    attr_writer :custom


    def initialize(args = {})
      default_args = {
        :name => "",
        :latitude => 0.0,
        :longitude => 0.0,
        :elevation => 0.0,  # Native units are SI
        :time_zone_offset => 0.0,
        :azimuth => 0.0,
        :custom => ""  # Include with every object as a place to add extra info    annotations, comments, vendor, optional
      }
      args = default_args.merge(args)

      # other candidates:
      # address
      # us_zip_code
      # time_zone_name

# gets generated from schema.
      self.name = args[:name]
      self.latitude = args[:latitude]
      self.longitude = args[:longitude]
      self.elevation = args[:elevation]
      self.time_zone_offset = args[:time_zone_offset]
      self.azimuth = args[:azimuth]
      self.custom = args[:custom]

      @mediator = nil  # Set when attached to a document; allows conjugate object to be referenced
    end


    # Needed by Euclid.
    def key
      return("Location:#{@name}")
    end


    def name=(value)
      # check for string

      @name = value.to_s

# check that the value is actually different!
      changed
      notify_observers#  (self, :latitude)
    end


# gets generated from schema.
    def latitude=(value)
      if (not value.is_a?(Numeric))
        raise(ArgumentError, "argument is not numeric")
      elsif (value <= -90 or value >= 90)
        raise(ArgumentError, "argument is out of bounds; must be between -90 and 90")
      else
        @latitude = value.to_f
      end

# automatically trim significant digits?

# check that the value is actually different!
      changed
      notify_observers#  (self, :latitude)
    end


    def longitude=(value)
      if (not value.is_a?(Numeric))
        raise(ArgumentError, "argument is not numeric")
      elsif (value < -180 or value >= 180)
        raise(ArgumentError, "argument is out of bounds; must be between -180 and 180")
      elsif (value == -180.0)
        @longitude = 180.0  # Set to positive value to eliminate ambiguity
      else
        @longitude = value.to_f
      end

# automatically trim significant digits?

# check that the value is actually different!
      changed
      notify_observers#  (self, :longitude)
    end


    def elevation=(value)
      if (not value.is_a?(Numeric))
        raise(ArgumentError, "argument is not numeric")
      # NOTE: Elevation is allowed to be negative.
      else
        @elevation = value.to_f
      end

# automatically trim significant digits?

# check that the value is actually different!
      changed
      notify_observers#  (self, :elevation)
    end


    def azimuth=(value)
      if (not value.is_a?(Numeric))
        raise(ArgumentError, "argument is not numeric")
      else
        @azimuth = value.to_f
      end

      changed
      notify_observers#  (self, :elevation)
    end


    def time_zone_offset=(value)
      if (not value.is_a?(Numeric))
        raise(ArgumentError, "argument is not numeric")
      else
        @time_zone_offset = value.to_f
      end

# needs bounds

      changed
      notify_observers#  (self, :elevation)
    end


    def copy
      new_object = self.class.new(
        :name => @name.dup,
        :latitude => @latitude,
        :longitude => @longitude,
        :elevation => @elevation,
        :time_zone_offset => @time_zone_offset,
        :azimuth => @azimuth,
        :custom => @custom.dup)
      return(new_object)
    end


    def ==(other_object)
      # tolerance for lat/long/elevation?
      return(@name == other_object.name and
        @latitude == other_object.latitude and
        @longitude == other_object.longitude and
        @elevation == other_object.elevation and
        @time_zone_offset == other_object.time_zone_offset and
        @azimuth == other_object.azimuth and
        @custom == other_object.custom)
    end

# These validation checks are all stuff that could/should? come from an XML schema...
# Or at least this info will be duplicated in both places: a schema and here in the object logic.

# Use something to generate Ruby classes, or at least the methods, from an XSD.
#  try: https://github.com/rubyjedi/soap4r

# I can live with the duplication for now. There doesn't seem to be any good Ruby XSD code generation options.




# try to abstract XML processing to make it pluggable between Nokogiri and Ox (and REXML?).


# Problem:
# Want to keep the validators and helper stuff (look up time zone offset).
# But also need this to dynamically write to the target format.

# if the target format is being written _in this object_,
#  then this object has to know its parent: @document.

# This object (or someone else) needs to maintain a link to the native format object (@input_object or the XML node object).



# Two approaches:
# 1. The native format (e.g. IDF, gbXML) can be updated instantly every time something changes.
#    - This has benefit that don't get one big time-consuming hit at save time.
#    - Individual processing may slow down some things that could lead to bad user experience, like moving many zones at once--a lot gets updated.
#    - Output native text is immediately ready for inspection in Object Info.
#
# 2. The native formatting can be updated (i.e., dumped from Ruby object state) on request, such as save of document, or inspection of this object.
#    -

# Want to keep the native format writing code either in this class, or very nearby!
#  The format code gets overwritten in subclasses for EnergyPlus or gbXML.



# this does not convey the sense of writing to different formats.
    #def serialize

    #end


    #def add_observer(&proc)
    # observers are called with a notification when values have changed.

    # observers tied to the parent document allow it to know when it's been modified!

  end

end
