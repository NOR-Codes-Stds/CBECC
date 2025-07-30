# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("rake/testtask")


if (Gem::Version.new(Rake::VERSION) < Gem::Version.new("10.0"))
  puts "Warning: You should update Rake to avoid various problems."
  puts "  Type 'gem install rake' to update the gem."
end


task :default => :gem


# To run just one specific test, use: rake test TEST=test/<dir>/test_<name>.rb
Rake::TestTask.new do |test|
  test.libs = ["lib", "test", "vendor"]
  test.test_files = FileList["test/**/test_*.rb"]
  test.verbose = false
  test.warning = false
end


desc "Generate API documentation"
task :yard do
  if (Gem::Specification.find_all_by_name("yard").empty?)
    puts "Warning: The YARD gem is not installed. YARD is required to generate API documentation; nothing was generated."
    puts "  Type 'gem install yard' to get the gem."
  else
    # NOTE: The [source files] argument is intentionally omitted in order to default to {lib,app}/**/*.rb files.
    # The glob expansion lib/**/*.rb does not work on Mac because it ships with an old version of Bash which does not support globstar.
    system("yard doc --no-cache --private --protected --embed-mixins --markup=markdown --main=readme.md --output-dir=doc/api - readme.md releases.md license.txt")
  end
end


desc "Package gem file from gemspec"
task :gem do
  system("gem build modelkit.gemspec")
end
