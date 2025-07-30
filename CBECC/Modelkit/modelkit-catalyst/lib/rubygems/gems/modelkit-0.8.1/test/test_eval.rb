# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("helper")
require("modelkit/eval_scope")


class TestEvalScope < Minitest::Test

  def test_one
    puts "in test"

    puts "test".encoding  # => UTF-8

    eval_scope = Modelkit::EvalScope.new

    puts eval("'test'.encoding", eval_scope.local_binding)
    puts eval("'test'", eval_scope.local_binding).encoding

  end

end
