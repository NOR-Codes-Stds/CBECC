puts "in basic_object_test"

#puts Object.constants.sort
puts ::Ripl


class Scope < BasicObject
  include ::Kernel

  attr_reader :local_binding


  def initialize
    @local_binding = __binding__

    #puts methods.sort
    #puts Object.constants.sort
    puts ::Ripl

  end

  def __binding__
    # Any local variables defined inside this method are available within the Scope.
    return(binding)
  end

end

scope = Scope.new

#puts scope
#puts scope.local_binding
