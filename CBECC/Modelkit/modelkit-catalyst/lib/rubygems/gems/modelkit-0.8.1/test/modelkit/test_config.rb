# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("modelkit/config")


class TestConfig < Minitest::Test
  include Modelkit  # Allow shorter tests by dropping module prefix


  def setup
    @new_file = "#{__dir__}/new-file.config"
    @test_file = "#{__dir__}/../modelkit/test-file.config"  # Try a messy path
    @bad_file = "#{__dir__}/../modelkit/bad-file.config"
  end


  def test_new_constructor
    config = Config.new(@new_file)
    assert_equal(false, File.exist?(@new_file))  # Don't create a file unless it is written to
  end


  def test_new_constructor_argument_errors
    exception = assert_raises(TypeError) { Config.new(nil) }
    assert_equal("no implicit conversion of NilClass into String", exception.message)
  end


  def test_new_constructor_file_parse_errors
    exception = assert_raises(ConfigError) { Config.new(@bad_file) }
    assert_equal("error in #{File.expand_path(@bad_file)}\nFailed to parse input on line 6 at offset 4\nasdf\n\n    ^", exception.message)
  end


  def test_path
    config = Config.new(@new_file)
    assert_equal(File.expand_path(@new_file), config.path)
    config = Config.new(@test_file)
    assert_equal(File.expand_path(@test_file), config.path)
  end


  def test_read
    config = Config.new(@test_file)
    assert_equal(33, config.read("key1"))
    assert_equal(99, config["key4"])
    assert_equal({:key2 => "name"}, config["table1"])
    assert_equal("name", config.read("table1.key2"))
    assert_equal("other", config["nested.table2.key3"])
    assert_equal({:table2=>{:key3=>"other"}}, config.read("nested"))
    assert_nil(config.read("missing"))  # Missing keys are allowed
    assert_nil(config.read("missing-table.key"))
  end


  def test_read_argument_errors
    config = Config.new(@test_file)
    exception = assert_raises(TypeError) { config.read(nil) }
    assert_equal("no implicit conversion of NilClass into String", exception.message)
  end


  def test_to_h
    config = Config.new(@new_file)
    assert_equal({}, config.to_h)
    config = Config.new(@test_file)
    assert_equal({:key1=>33, :key4=>99, :table1=>{:key2=>"name"}, :nested=>{:table2=>{:key3=>"other"}}}, config.to_h)
  end


  def test_inspect
    config = Config.new(@new_file)
    assert_equal("#<Modelkit::Config:#{File.expand_path(@new_file)}>", config.inspect)
    config = Config.new(@test_file)
    assert_equal("#<Modelkit::Config:#{File.expand_path(@test_file)}>", config.inspect)
  end


  def test_to_s
    config = Config.new(@new_file)
    assert_equal(File.expand_path(@new_file), config.to_s)
    config = Config.new(@test_file)
    assert_equal(File.expand_path(@test_file), config.to_s)
  end

end
