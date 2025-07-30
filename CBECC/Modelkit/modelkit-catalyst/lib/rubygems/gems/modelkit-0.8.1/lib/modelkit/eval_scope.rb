# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit

# check out TOPLEVEL_BINDING for a clean binding in EvalScope
# it's a built in constant
# ERB uses it; IRB uses it


# NOPUB update comment
  # The TemplateScope class provides the scope of limited methods available inside a Template and generates
  # a clean binding for evaluating local variables.
  #
  # CAUTION: Despite the binding, global variables and constants remain available across all Templates--this includes
  # classes loaded to the top-level scope using 'require' from inside or outside a Template. There is some risk of
  # namespace collisions if two files with identical class names are required from within different Templates.

# NOPUB Check the closures book (or scope gate one?) for what to call this class?

  # class EvalScope < BasicObject
  #   include ::Kernel

# Check this out:
#XmlMarkup class in Builder inherits from BasicObject  (BlankSlate pattern)


# NOPUB This seems good enough. Not too many extra methods.
  class EvalScope

    attr_reader :local_binding


    def initialize
      @local_binding = __binding__
    end

  private

    # def binding
    #   return(::Kernel.send(:binding))
    # end



# binding method name must be a unique name in the stack so that it can be found!
# could be multiple levels of scopes deep.
# EvalScope should generate a uniquely named method (based on object id?) every time
# use metaprogramming to create the method below (with unique name) on init.

    # Generates a clean binding for evaluating local variables in this Scope.
    #
    # NOTE: The name of this method appears in error messages back to the user.
    def __binding__
      # Any local variables defined inside this method are available within the Scope.
      return(binding)
    end

    # NOPUB needs an inspect method
    #def inspect; end

  end

end
