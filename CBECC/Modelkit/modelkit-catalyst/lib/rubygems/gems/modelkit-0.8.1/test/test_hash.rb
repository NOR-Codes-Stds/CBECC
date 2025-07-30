# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("hash")


class TestHash < Minitest::Test

  def setup
    @merge_hash = {:a => 44, :b => 73 }
    @deep_hash = {:a => {:x => 12, :y => 23}, :b => 66}
  end


  def test_deep_dup
    sub_hash = @deep_hash[:a]
    hash = @deep_hash.deep_dup
    assert_equal(@deep_hash, hash)
    assert_equal(false, hash.equal?(@deep_hash))  # Verify different object
    assert_equal(false, hash[:a].equal?(sub_hash))  # Verify different object
  end


  def test_reverse_merge
    hash = @merge_hash.reverse_merge({:a => 12, :c => 99})
    assert_equal({:a => 44, :b => 73, :c => 99}, hash)
    assert_equal(false, hash.equal?(@merge_hash))  # Verify different object
  end


  def test_reverse_merge_argument_errors
    exception = assert_raises(TypeError) { @merge_hash.reverse_merge(nil) }
    assert_equal("no implicit conversion of NilClass into Hash", exception.message)
  end


  def test_reverse_merge!
    @merge_hash.reverse_merge!({:a => 12, :c => 99})
    assert_equal({:a => 44, :b => 73, :c => 99}, @merge_hash)
  end

end
