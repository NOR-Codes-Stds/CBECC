# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("rake/testtask")
require("rake/clean")

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
  system("gem build modelkit-energyplus.gemspec")
end



file "resources/sizing-map/9-0.csv" => ["resources/idds/9-0.idd"] do
  # On Windows, call with rake -I../modelkit/lib -Ilib sizing_maps
  require("csv")
  require("modelkit/energyplus")
  puts "Generating sizing map for EnergyPlus 9.0"
  idd = OpenStudio::DataDictionary.open("resources/idds/9-0.idd")
  version = OpenStudio::DataDictionary.detect_version("resources/idds/9-0.idd")
  objs = idd.object_list_hash
  klss = idd.class_hash
  puts "IDD Version: #{version}"
  puts "Number of Objects: #{objs.keys.length}"
  puts "Number of Classes: #{klss.keys.length}"
  items = []
  klss.keys.each do |klass_name|
    kls = klss[klass_name]
    kls.field_definitions.each_with_index do |fd, idx|
      if not fd.nil? and fd.autosizable?
        items << {klass: klass_name, field_name: fd.name, index: idx}
      end
    end
  end
  puts "Number of items: #{items.length}"
  CSV.open("resources/sizing-map/9-0.csv", "wb") do |csv|
    items.each do |item|
      csv << [item[:klass], item[:field_name], item[:index]]
    end
  end
  puts "Done!"
end
CLEAN << "resources/sizing-map/9-0.csv"


desc "Create/update sizing maps from IDD data"
task :sizing_maps => ["resources/sizing-map/9-0.csv"]
