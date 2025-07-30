# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

class Hash

  # Return a deep copy of the receiver Hash. Like #dup, it does not preserve frozen state.
  def deep_dup
    hash = Hash.new
    each_pair { |key, value|
      begin
        new_key = key.dup
      rescue TypeError
        new_key = key  # All classes respond to 'dup' but some raise an exception
      end

      if (value.respond_to?(:deep_dup))
        new_value = value.deep_dup
      else
        begin
          new_value = value.dup
        rescue TypeError
          new_value = value  # All classes respond to 'dup' but some raise an exception
        end
      end

      hash[new_key] = new_value
    }
    return(hash)
  end


  # Return a new Hash with values from the receiver Hash taking precedence over the argument Hash;
  # the opposite of #merge.
  def reverse_merge(hash)
    if (not hash.kind_of?(Hash))
      raise(TypeError, "no implicit conversion of #{hash.class} into Hash")
    end
    return(hash.merge(self))
  end


  # Return the receiver Hash with values from the receiver taking precedence over the argument Hash;
  # the opposite of #merge!.
  def reverse_merge!(hash)
    if (not hash.kind_of?(Hash))
      raise(TypeError, "no implicit conversion of #{hash.class} into Hash")
    end
    return(replace(reverse_merge(hash)))
  end

  # Returns a new Hash with the union of keys from self and the other Hash. For
  # duplicate keys, the values from the other Hash are used. This operator is the
  # same as Hash#merge. It is semantically similar to how Array uses the same
  # operator because it returns a new object that is a set union of the members.
  alias_method :|, :merge

  # Returns the first Hash (self) with the union of keys from self and the other Hash.
  # For duplicate keys, the values from the other Hash are used. This operator is
  # the same as Hash#merge!. It is semantically similar to how Array uses the same
  # operator because it mutates the original object by pushing new members onto it.
  alias_method :<<, :merge!

# NOPUB Python 3.9+ implements the same operator for dictionaries.

# NOPUB Other set operators would make sense here:
#   & for set intersection
#   - for set difference
#   ^ for symmetric difference (or disjunctive union)
end
