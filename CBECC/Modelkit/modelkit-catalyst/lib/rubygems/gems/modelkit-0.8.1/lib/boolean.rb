# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

# NOPUB
# Factory method to convert a value (usually a string) into a boolean data type.
# @return [Boolean]
# def Boolean(value)
#   if (value.to_s == "true")
#     boolean = true
#   elsif (value.to_s == "false")
#     boolean = false
#   elsif (value.kind_of?(String))
#     raise(ArgumentError, "invalid value for Boolean(): #{value.inspect}")
#   else
#     raise(TypeError, "can't convert #{value.class} into Boolean")
#   end
#   return(boolean)
# end

# NOPUB Still not sure which is the right implementation: above or below?

# Convert an object to true/false based on Ruby "truthiness". `false` and `nil`
# evaluate to false, while any other value evaluates to true. The idiomatic but
# cryptic alternative is: `!!object`
def Boolean(object)
  return(object ? true : false)
end

# `Boolean` represents boolean data types (`true` and `false`) and acts as a
# contrived superclass for `TrueClass` and `FalseClass`. The class itself is
# empty and does not permit any instances to be created (much like other basic
# Ruby data types such as `Integer` and `Float`). One purpose of this class is
# to enable the validation of boolean values:
#
#     true.kind_of?(Boolean) => true
#     false.kind_of?(Boolean) => true
#
# `TrueClass` and `FalseClass` are gently monkey-patched to recognize the
# `Boolean` class as one of their ancestors so that `kind_of?` works.
# @see #Boolean Boolean factory method
# @see TrueClass
# @see FalseClass
class Boolean

  # Undefine `new` method on the class same as Ruby does for Integer and Float.
  class << self
    undef_method(:new)
  end

end

# `TrueClass` is gently monkey-patched to recognize the `Boolean` class as one
# of its ancestors so that `kind_of?` works:
#
#     true.kind_of?(Boolean) => true
# @see Boolean
class TrueClass

  ANCESTORS = [TrueClass, Boolean, Object, Kernel, BasicObject]
  private_constant :ANCESTORS

  # Returns an array of the classes and modules in the inheritance hierarchy of
  # this class (including the class itself).
  # @return [Array]
  def self.ancestors
    return(ANCESTORS.dup)
  end

  # Returns `true` if `other_class` is the same class as this class or one of
  # the ancestors of this class.
  def kind_of?(other_class)
    return(ANCESTORS.include?(other_class))
  end

  alias_method :is_a?, :kind_of?

end

# `FalseClass` is gently monkey-patched to recognize the `Boolean` class as one
# of its ancestors so that `kind_of?` works:
#
#     false.kind_of?(Boolean) => true
# @see Boolean
class FalseClass

  ANCESTORS = [FalseClass, Boolean, Object, Kernel, BasicObject]
  private_constant :ANCESTORS

  # Returns an array of the classes and modules in the inheritance hierarchy of
  # this class (including the class itself).
  # @return [Array]
  def self.ancestors
    return(ANCESTORS.dup)
  end

  # Returns `true` if `other_class` is the same class as this class or one of
  # the ancestors of this class.
  def kind_of?(other_class)
    return(ANCESTORS.include?(other_class))
  end

  alias_method :is_a?, :kind_of?

end
