# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module Geometry


# Does this need to handle units??? SketchUp does.

# Is there a tolerance for comparing Point values?


# Make observable??


    # A basic class to represent 3-D and 2-D points--a building block for more complex geometric shapes.
    class Point

      # Alternate constructor.
      # Allows this usage: Point[1, 2, 3]
      def self.[](*args)
        return(self.new(*args))
      end


      attr_reader :x, :y, :z


      def initialize(x = 0.0, y = 0.0, z = 0.0)
        @x = x.to_f
        @y = y.to_f
        @z = z.to_f
      end

# gets generated from schema.
      def x=(value)
        # check that it's numeric
        @x = value.to_f
      end

# gets generated from schema.
      def y=(value)
        # check that it's numeric
        @y = value.to_f
      end

# gets generated from schema.
      def z=(value)
        # check that it's numeric
        @z = value.to_f
      end


      def to_a
        return([@x, @y, @z])
      end


      def ==(other_object)
# Add tolerance?
        return((@x == other_object.x) and (@y == other_object.y) and (@z == other_object.z))
      end


      def copy
        return(self.class.new(@x, @y, @z))
      end


      def inspect
        hex_value = (object_id * 2).to_s(16)
        return("#<#{self.class}:0x#{hex_value} (#{@x}, #{@y}, #{@z})>")
      end

    end

  end
end
