# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("modelkit/location")


class TestLocation < Minitest::Test

  def setup
    @location1 = Modelkit::Location.new(
      :name => "Somewhere",
      :latitude => 45.0,
      :longitude => -90.0,
      :elevation => 200.0,
      :time_zone_offset => -6.0,
      :azimuth => 15.0)
  end


  def test_constructor_with_defaults
    location = Modelkit::Location.new

    assert_equal("", location.name)
    assert_equal(0.0, location.latitude)
    assert_equal(0.0, location.longitude)
    assert_equal(0.0, location.elevation)
    assert_equal(0.0, location.time_zone_offset)
    assert_equal(0.0, location.azimuth)
  end


  def test_constructor_with_arguments
    assert_equal("Somewhere", @location1.name)
    assert_equal(45.0, @location1.latitude)
    assert_equal(-90.0, @location1.longitude)
    assert_equal(200.0, @location1.elevation)
    assert_equal(-6.0, @location1.time_zone_offset)
    assert_equal(15.0, @location1.azimuth)
  end


  def test_convert_to_floats
    location = Modelkit::Location.new
    location.latitude = 45
    location.longitude = -90
    location.elevation = 200
    location.time_zone_offset = -6
    location.azimuth = 15

    assert_equal(45.0, location.latitude)
    assert_equal(-90.0, location.longitude)
    assert_equal(200.0, location.elevation)
    assert_equal(-6.0, location.time_zone_offset)
    assert_equal(15.0, location.azimuth)
  end


  def test_argument_errors
    location = Modelkit::Location.new

    exception = assert_raises(ArgumentError) { location.latitude = nil }
    assert_equal("argument is not numeric", exception.message)
    exception = assert_raises(ArgumentError) { location.longitude = nil }
    assert_equal("argument is not numeric", exception.message)
    exception = assert_raises(ArgumentError) { location.elevation = nil }
    assert_equal("argument is not numeric", exception.message)
    exception = assert_raises(ArgumentError) { location.time_zone_offset = nil }
    assert_equal("argument is not numeric", exception.message)
    exception = assert_raises(ArgumentError) { location.azimuth = nil }
    assert_equal("argument is not numeric", exception.message)
  end


  def test_bounds_errors
    location = Modelkit::Location.new

    exception = assert_raises(ArgumentError) { location.latitude = -100 }
    assert_equal("argument is out of bounds; must be between -90 and 90", exception.message)
    exception = assert_raises(ArgumentError) { location.latitude = 100 }
    assert_equal("argument is out of bounds; must be between -90 and 90", exception.message)
    exception = assert_raises(ArgumentError) { location.longitude = -190 }
    assert_equal("argument is out of bounds; must be between -180 and 180", exception.message)
    exception = assert_raises(ArgumentError) { location.longitude = 190 }
    assert_equal("argument is out of bounds; must be between -180 and 180", exception.message)
  end


  def test_longitude_negative_180
    location = Modelkit::Location.new
    location.longitude = -180.0

    assert_equal(180.0, location.longitude)
  end


  def test_instances_equal
    location2 = Modelkit::Location.new(
      :name => "Somewhere",
      :latitude => 45.0,
      :longitude => -90.0,
      :elevation => 200.0,
      :time_zone_offset => -6.0,
      :azimuth => 15.0)

    assert_equal(@location1, location2)
    assert(!@location1.equal?(location2))
  end


  def test_instances_not_equal
    location2 = Modelkit::Location.new(
      :name => "Somewhere",
      :latitude => 44.0,
      :longitude => -90.0,
      :elevation => 200.0,
      :time_zone_offset => -6.0,
      :azimuth => 15.0)

    assert(@location1 != location2)
  end


  def test_copy_instance
    location2 = @location1.copy

    assert_equal(@location1, location2)
    assert(!@location1.equal?(location2))
  end

end
