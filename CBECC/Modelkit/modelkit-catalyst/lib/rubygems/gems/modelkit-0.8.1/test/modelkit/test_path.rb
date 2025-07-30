# Copyright (c) 2011-2019 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("modelkit/path")


class TestPath < Minitest::Test
  include Modelkit  # Allow shorter tests by dropping module prefix
  extend Modelkit

  def setup
    @relative_posix_string = "a/b/c"
    @absolute_posix_string = "/d/e/f"
    @relative_windows_string = "a\\b\\c"
    @absolute_windows_string = "C:\\a\\b\\c"
  end

  def test_constructors
    path = Path.new(@relative_posix_string)
    assert_equal(Path, path.class)
    path2 = Path(@relative_posix_string)
    assert_equal(Path, path2.class)
  end

  def test_add
    path = Path.new("a/b") + Path.new("c/d")
    assert_equal(Path, path.class)
  end

  def test_file_compatibility
    path = Path.new(@relative_posix_string)
    File.exist?(path)  # Raises an exception, if not compatible
    Dir.exist?(path)
  end

  def test_inspect
    path = Path.new(@relative_posix_string)
    assert_equal("#<Modelkit::Path:#{@relative_posix_string}>", path.inspect)
    path = Path.new(@relative_windows_string)
    assert_equal("#<Modelkit::Path:#{@relative_posix_string}>", path.inspect)
  end

  def test_to_s
    path = Path.new(@relative_posix_string)
    assert_equal(@relative_posix_string, path.to_s)
    path = Path.new(@relative_windows_string)
    assert_equal(@relative_posix_string, path.to_s)
  end

end
