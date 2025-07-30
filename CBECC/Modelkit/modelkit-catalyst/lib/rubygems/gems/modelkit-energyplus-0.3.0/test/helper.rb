# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("minitest/autorun")

# If it's installed, use minitest-reporters gem for better formatted output.
begin
  require("minitest/reporters")
  Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
rescue LoadError
end
