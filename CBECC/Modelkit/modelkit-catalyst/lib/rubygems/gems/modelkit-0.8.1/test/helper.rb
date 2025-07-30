# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("minitest/autorun")

# NOPUB There's a better way to programmatically check if this is available--look for Gem

# If it's installed, use minitest-reporters gem for better formatted output.
begin
  require("minitest/reporters")
  Minitest::Reporters.use!(Minitest::Reporters::SpecReporter.new)
rescue LoadError
end
