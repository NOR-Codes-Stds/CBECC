
# Things to fix:
# [x] override __dir__ in Template context  and __FILE__
# [x] template-compose should NOT search first in current working dir when doing `insert`;
# it should look in the same dir as the parent template
#    - might be a unique problem for `insert` at the root template level
# [x] make dirs and files proper Arrays in template_compose
# [x] don't add spaces for indent when it's a blank line
# [x] add `insert_string` method in TemplateScope?
#   [x] alias `insert_template` to `insert`
# [x] use :esc_line symbols everywhere (underscores) -- only CLI should use esc-line
# [ ]  :indent => true   puts the string "true" in front of every line; require a string?
# [ ] add :parameters attribute to options--just needs to be parsed from CLI

task :default do

  #puts "in rakefile = #{__dir__}"
  #puts "in rakefile = #{__FILE__}"

  #require "subdir/file"  # fails, as it should
  #require_relative "subdir/file"  # works, as it should

# Should this use arrays or strings for :dirs and :files?
#   probably these are arrays... these method should be easy to use from Ruby
#   The CLI does the extra parsing to go from string to Ruby objects

options = {
  :annotate => true,
  :indent => "    ",  # true gets converted to "true" and prefixed to each line! - FIX
  :esc_line => "! ",
  :dirs => ["sub_dir/deeper_dir"]
}

#### Plumbing ####
# Modelkit::Parametrics::Template.read:  This is the API form (used internally by above).
# - does not use .modelkit-config
# - fewer options
# - accepts block to handle errors, warnings, and notes

  require("modelkit/parametrics")  # This is needed now, which is good

  template = Modelkit::Parametrics::Template.read("sub_dir/test2.pxt", options)
  #template = Modelkit::Parametrics::Template.read("sub_dir/test-for-erb.pxt", options)
# NOTE: --files, --parameters, and --output are CLI-only options.

  output = template.compose(:req_param => "bob") do |message|
    # Decide what to do with errors, warnings, and notes!
    # - write to STDOUT; echo to console?
    # - use ansi colors? if is_tty? and --color
    # - if --strict, exit on warnings too
    # - if --hard, exit on FIRST exception, otherwise keep going as much as possible

    # A few exceptions should be real exceptions and break immediately from here
    # Most exceptions are template errors and should get rescued and just reported here

#    puts "message=#{message}"

  end

  File.write("sub_dir/test.idf", output)


#### Porcelain ####
# Modelkit::Parametrics.template_compose:  Acts just like CLI!
# - applies .modelkit-config options
# - writes to STDOUT by default, or when used with a block can handle messages here
# - uses ansi colors

  # Modelkit::Parametrics.template_compose "sub_dir/test2.pxt", **options,
  #   :files => ["params.pxv"],
  #   :parameters => {:req_param => "bob"},
  #   :output => "sub_dir/test.idf"


  # works
  #system("modelkit template-compose -a --esc-line=\"! \" --files=params.pxv --dirs=sub_dir/deeper_dir -o sub_dir/test.idf \"sub_dir/test2.pxt\"")

end

# Test streaming a string into a separate process for `ruby -wc -e`
task :rubywc do
  require("open3")

  source = "x = 1\ny = 3\nif (x = 4); end\nBOB = 77\nBOB = 88\n"

  #command = "ruby -wc -e \"#{source}\""
  #  Unused variable warnings don't seem to happen with -e input :(
  command = "ruby -wc"

  output = ""
  err = ""

  # This technique does surface the unused variable warnings!
  # And no temp file is even needed.
  Open3.popen3(command) do |stdin, stdout, stderr, thread|
    stdin.write(source)
    stdin.close
    output = stdout.read
    err = stderr.read
  end

  puts "OUT: #{output}"
  puts "ERR: #{err}"
end
