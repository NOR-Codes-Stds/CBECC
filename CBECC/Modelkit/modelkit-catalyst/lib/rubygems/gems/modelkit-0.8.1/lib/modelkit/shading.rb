# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("observer")
require("simple_uuid")
require("modelkit/geometry/polygon")


module Modelkit

  # Should inherit from Face/Surface base class, or use a mixin.
  # Type and bounds checking should eventually be generated from a schema.
  class Shading
    include Observable

# should these be frozen?
    TYPE_SITE_SHADE = "Site Shade"
    TYPE_BUILDING_SHADE = "Building Shade"
    TYPE_SITE_PHOTOVOLTAIC = "Site Photovoltaic Array"
    TYPE_BUILDING_PHOTOVOLTAIC = "Building Photovoltaic Array"


    attr_accessor :mediator
    attr_reader :uuid, :name, :type, :polygon, :custom
    attr_writer :custom


    def initialize(args = {})
      default_args = {
        :uuid => "n#{SimpleUUID::UUID.new.to_guid}",
        :name => "",
        :type => TYPE_BUILDING_SHADE.dup,
        :polygon => Geometry::Polygon.new,
        :custom => ""
      }
      args = default_args.merge(args)

      self.uuid = args[:uuid]
      self.name = args[:name]
      self.type = args[:type]
      self.polygon = args[:polygon]
      self.custom = args[:custom]

      @mediator = nil  # Set when attached to a document; allows conjugate object to be referenced
    end


    def uuid=(value)
      if (not value.is_a?(String))  # Or check: value.respond_to?(:to_str)
        raise(ArgumentError, "argument is not a string")

      # Optionally check that the string is formatted as a UUID.

      else (@uuid != value)  # Check if value changed
        @uuid = value
        changed
        notify_observers  #(self, :uuid)
      end
    end


    def name=(value)
      if (not value.is_a?(String))  # Or check: value.respond_to?(:to_str)
        raise(ArgumentError, "argument is not a string")

      elsif (@name != value)  # Check if value changed
        @name = value
        changed
        notify_observers  #(self, :name)
      end
    end


    def type=(value)
      valid_types = [TYPE_SITE_SHADE, TYPE_BUILDING_SHADE, TYPE_SITE_PHOTOVOLTAIC, TYPE_BUILDING_PHOTOVOLTAIC]

      if (not valid_types.include?(value))
        raise(ArgumentError, "argument is not a valid type")

      elsif (@type != value)  # Check if value changed
        @type = value
        changed
        notify_observers  #(self, :type)
      end
    end


    # NOTE: It's possible to change the Polygon internally (i.e., set the points)
    # which would not trigger the observer.
    # This is hard to do without a whole chain of observers.
    def polygon=(value)
      if (not value.is_a?(Geometry::Polygon))
        raise(ArgumentError, "argument is not a polygon")

      # Still needs a deeper compare to be added to Polygon.
      elsif (@polygon != value)  # Check if value changed
        @polygon = value
        changed
        notify_observers  #(self, :polygon)
      end
    end


    #def inspect
    #  hex_value = (object_id * 2).to_s(16)
    #  return("#<#{self.class}:0x#{hex_value} @uuid=#{@uuid} @mediator=#{@mediator.inspect} @polygon=#{}>")
    #end

    def copy
      return(self.class.new(:name => @name.dup, :type => @type.dup, :polygon => @polygon.copy, :custom => @custom.dup))
    end


    def ==(other_object)
      # tolerance for lat/long/elevation?
      return(@name == other_object.name and
        @type == other_object.type and
        @polygon == other_object.polygon and
        @custom == other_object.custom)
    end


    # Needed by Euclid for now.
    def key
      return("Shading:#{@name}")
    end

  end

end
