# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/geometry/point")


module Modelkit
  module Geometry

    # Polygon is a simple polygon which is closed, does not cross itself, and has no holes.
    # https://en.wikipedia.org/wiki/Simple_polygon
    # The polygon itself refers to the boundary, i.e., the line segments, not the enclosed area.
    # Polygon accepts a list of Points, Arrays, or LineSegments (yet to be defined).
    class Polygon

      # Alternate constructor.
      # Allows this usage: Polygon[ [0, 0], [10, 0], [10, 10] ]
      def self.[](*args)
        return(self.new(*args))
      end


      attr_accessor :points


      def initialize(*args)
        # Validation checks:
        # - Check that it's an array of Point objects.
        # - Must be 3 or more points.
        # - Must not be self-intersecting.
        # - Reduce any duplicate points (within tolerance).
        # - Reduce any redundant points, i.e., points in the middle of a straight line.
        # - Points must be in the same plane (within tolerance).
        # - "canonicalize" by reordering points so that first point is closest to origin (makes it easier to compare and canonicalize)

        @points = []

        # What SketchUp does instead of this is to add x/y/z methods to Array.
        # That way, Arrays can be used wherever Points are used. All that has to be done here is checking 'respond_to?'...
        for arg in args
          if (arg.class == Point)
            @points << arg
          elsif (arg.class == Array)
            @points << Point.new(*arg)
          else
            raise(ArgumentError, "argument is not valid")
          end
        end

      end


      def eql?(polygon)
        # compare loops within tolerance; order does not matter.
      end


      def normal
        # calculate normal vector
      end


      def area
        # calculate area enclosed by the polygon.
        # algorithms here:
        # https://en.wikipedia.org/wiki/Polygon
        # Also: ask Neal what he likes.
      end


      def reverse!
        # reverse the order of points; flip the normal direction.
      end


      def intersect(polygon)
        # return intersection of two loops as a new loop; return nil if no intersection.
      end


# Probably not needed
#      def congruent?(loop)
         # Is the shape the same, but position different?
#      end


      def test_point(point)  # point_test
        # return inside, outside, or on the boundary.

      end


#      def vertices
        # return points; the points of a polygon are called vertices.
#      end

      def inspect
        hex_value = (object_id * 2).to_s(16)
        array = @points.map { |point| "(#{point.x}, #{point.y}, #{point.z})" }
        return("#<#{self.class}:0x#{hex_value} [#{array.join(", ")}]>")
      end


      def copy
        new_points = @points.map { |point| point.copy }
        return(self.class.new(*new_points))
      end


      def ==(other_object)
        # Rewrite this: Not an ideal test because points must be in same order.
        return(false) if (@points.length != other_object.points.length)
        @points.each_with_index { |point, i|
          return(false) if (@points[i] != other_object.points[i])
        }
        return(true)
      end

    end

  end
end
