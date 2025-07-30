# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("boolean")


class TestBoolean < Minitest::Test

  def test_factory_method
    assert_equal(false, Boolean(false))
    assert_equal(false, Boolean(nil))
    assert_equal(true, Boolean(true))
    assert_equal(true, Boolean("true"))
    assert_equal(true, Boolean("false"))
    assert_equal(true, Boolean(0))
  end


  def test_kind_of
    assert_equal(true, Boolean.kind_of?(Class))
    assert_equal(false, Boolean.kind_of?(String))
    assert_equal(true, true.kind_of?(Boolean))
    assert_equal(true, false.kind_of?(Boolean))
    assert_equal(false, 123.kind_of?(Boolean))
    assert_equal(false, "true".kind_of?(Boolean))

    assert_equal(true, true.is_a?(Boolean))
    assert_equal(true, false.is_a?(Boolean))
  end


  def test_true_class_ancestors
    assert_equal([TrueClass, Boolean, Object, Kernel, BasicObject], TrueClass.ancestors)
  end


  def test_false_class_ancestors
    assert_equal([FalseClass, Boolean, Object, Kernel, BasicObject], FalseClass.ancestors)
  end


  def test_undef_method_new
    assert_equal(false, Boolean.respond_to?(:new))
    exception = assert_raises(NoMethodError) { Boolean.new }
    assert_equal("undefined method `new' for Boolean:Class", exception.message)
  end

end
