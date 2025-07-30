# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("modelkit/version")


# NOPUB Testing for bundling
# require("gli")  # which GLI is it going to use??
#
# spec = Gem.loaded_specs["gli"]
# puts "using GLI at #{spec.gem_dir}"

puts $LOAD_PATH

puts GLI


class TestVersion < Minitest::Test
  include Modelkit  # Allow shorter tests by dropping module prefix


  def test_new_constructor
    version = Version.new("1.2.3")
    assert_equal("1.2.3", version.to_s)
  end


  def test_new_constructor_argument_errors
    exception = assert_raises(TypeError) { Version.new(nil) }
    assert_equal("no implicit conversion of NilClass into String", exception.message)

    exception = assert_raises(ArgumentError) { Version.new("") }
    assert_equal("version number string must not be empty", exception.message)
  end


  def test_factory_method
    version = Modelkit::Version("1.2.3")
    assert_equal("1.2.3", version.to_s)
  end


  def test_inspect
    version = Version.new("1.2.3")
    assert_equal("#<Modelkit::Version \"1.2.3\">", version.inspect)
  end

end
