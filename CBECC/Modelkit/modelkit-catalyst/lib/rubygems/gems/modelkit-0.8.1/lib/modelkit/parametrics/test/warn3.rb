#puts "warning flag (-w) => #{$VERBOSE.inspect}"

# CONCLUSIONS:
# - unused variables and literal in conditional only get checked on parse and reported with -w.
#   $VERBOSE within the file can't turn it on or off.
# - $VERBOSE does turn on/off other interesting warnings; whether it's in ERB or not doesn't matter.
# - unused variables never get reported for ERB no matter what.
# - only sure way to get all the warnings (on demand) is to call `ruby -cw`.


# $VERBOSE _does_ work with ERB. It happens on .result call.
#   nil turns off all warnings; false only sets the level to 1 (still some warnings)
#   true turns on all warnings (level 2), regardless of what the CLI flag was.
#   "assigned but unused variable" never seems to get reported from ERB either way.
$VERBOSE = true


my_var = 99  # gives warning, but only if -w flag is used

# Strangely the above does not give a warning unless -w is set in CLI.

#eval("z = 333; if (z = 3); end")  # this even gets detected correctly, but not unused var

x = 3
if (x = 4); end  # setting $VERBOSE nil does NOT turn of this warning :(

BOB = 77

BOB = 88



require "erb"

content = "<% y = 1 %> \nSTART\n<% x = 4; if (x = 3); end; BOB = 7 %> \n <% BOB = 9 %>\n END\n"
erb = ERB.new(content, nil, "%<>")
erb.result  #(binding)
puts erb.src
File.write("erb-src.txt", erb.src)

# This works! Reports unused variable y and the = in conditional.
# Does not report already initialized constant BOB -- only reported at runtime.
#   ruby -cw erb-src.txt


# Do other random stuff
time = Time.now
time.inspect
