# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/parametrics/group")
require("modelkit/parametrics/parameter")


module Modelkit
  module Parametrics

# group_index = {
#   :var1 => :var1,  # top-level; no prefixes - easy
#   :var2 => :var2,
#   :ext_light => {  # prefix is "ext_light_"
#     :power => :ext_light_power,
#     :control => :ext_light_control
#   }
#   :ext_light_power => :ext_light_power,  # Generated automatically from Group above
#   :ext_light_control => :ext_light_control,
#
#   :group1 => {  # defined with prefix "pre_"
#     :var3 => :pre_var3,
#     :var4 => :pre_var4,
#     :group2 => {  # defined with prefix "other_"
#       :var5 => :pre_other_var5
#     },
#     :pre_group2 => <GroupIndex> copy of group2,  # Generated automatically from Group above
#     :other_var5 => :pre_other_var5  # Generated automatically from Group above
#   },
#   :pre_var3 => :pre_var3,  # Generated automatically from Group above
#   :pre_var4 => :pre_var4,  # Generated automatically from Group above
#   :pre_other_var5 => :pre_other_var5  # Generated automatically from Group above
# }

# Expected results for behavior:

# group_index[:var1] => binding.local_variable_get(:var1)  # trivial; binding is actually always current binding, I think
# group_index["var1"] => binding.local_variable_get(:var1)  # set/get by String is also allowed

# group_index[:var1] = 99 => 99  # binding.local_variable_set(:var1, 99)  # can also set local variables
#   error if :var1 doesn't exist in index, for both cases

# group_index[:some_key] = #<GroupIndex>  # what does it mean to try to set a key with a GroupIndex?
#   conflict between :some_key and the GroupIndex name? ...remove name?

# group_index[] = {:key1 => value1, :key2 => value2}  # bulk setter; merges a Hash in place
# group_index << {:key1 => value1, :key2 => value2}  # same as above

# group_index[:ext_light_power] => binding.local_variable_get(:ext_light_power)  # prefix _is_ applied
#   this means prefix must be stored somewhere!

# group_index.ext_light[:power] => binding.local_variable_get(:ext_light_power)  # same result as above

# group_index.ext_light =>  # returns child GroupIndex; not a Hash
# {
#   :power => :ext_light_power,
#   :control => :ext_light_control
# }

# group_index[:ext_light] => child GroupIndex, same as above

# group_index.ext_light = other_group_index   # is this allowed as setter??  in theory, maybe; but not now
#   same question with:  group_index[:ext_light] = other_group_index

# group_index.ext_light.to_h =>  # returns "true" Hash; same as ** and/or to_hash
# {
#   :power => binding.local_variable_get(:ext_light_power),
#   :control => binding.local_variable_get(:ext_light_control)  # current local var values filled in
# }

# group_index.to_h =>  # returns Hash, with subgroups flattened and prefixes applied recursively
# {
#   :var1 => local_variable_get(:var1),
#   :var2 => local_variable_get(:var2),
#
#     :ext_light_power => local_variable_get(:ext_light_power),   # prefix applied
#     :ext_light_control => local_variable_get(:ext_light_control)
#
#     :pre_var3 => local_variable_get(:pre_var3),
#     :pre_var4 => local_variable_get(:pre_var4),
#
#       :pre_other_var5 => local_variable_get(:pre_other_var5)  # sub-sub-group, NOTE: two levels of prefixes applied
#
# }

# group_index.__top__ =>  # returns GroupIndex of top parameters only
# {
#   :var1 => :var1,
#   :var2 => :var2
# }
# limited use? I could see using to separate ahu-only params from ahu+unitary


#  a list of names or topics given in alphabetical order showing where each is to be found
# this could be Group::Index
#   nested classes like this could indicate it's really internal--not user facing, even as an API
#   but not as far as not documenting; user should just never have to instantiate it. Take away .new?
# this is (loosely) called an "inner class"; probably makes a lot of sense here.
# GroupIndex is closely tied to Group. Can't have GroupIndex with Group.
# But Group doesn't need GroupIndex...so maybe this is wrong.
## NOTE: Favor operators for methods instead of named methods. Allows more namespace
#   to be available for dot-lookup.
# keep lightweight, minimal methods, don't use namespace for groups
# throw away data structure! new one created with each call of Template#compose
# things can be added, but no other changes can be made
    class GroupIndex

      attr_reader :__group__, :__parent__, :__hash__

      def initialize(local_binding, group, parent = nil)
        @local_binding = local_binding
        @__group__ = group  # Group object
        @__parent__ = parent  # Parent GroupIndex object (optional)
        @__hash__ = {}

        # Build index recursively from the Group hierarchy.
        group.children.each do |object|
          next if (not object.class == Group and not object.class == Parameter)

          indexes = []
          next_index = self
# NOPUB may be able to get absolute variable name from Group/Parameter directly now
          variable_name = object.key.to_s.dup  # Parameter/Group/Rule.key   string or symbol?  Must dup because it's a string!
#          puts "variable_name = #{variable_name}"
          while (next_index) do
            indexes << next_index
            variable_name.prepend(next_index.__group__.prefix)
#            puts "  variable_name = #{variable_name}"
            next_index = next_index.__parent__
          end

          if (object.class == Group)
            value = self.class.new(local_binding, object, self)
          elsif (object.class == Parameter)
            value = variable_name.to_sym
          end

          local_name = object.key.to_s.dup
          indexes.each do |index|
            index.__hash__[local_name.to_sym] = value
            local_name.prepend(index.__group__.prefix)
          end

# is __top__ just a method? returns what? a GroupIndex?
#   __index__.g1 => GroupIndex
#   __index__.__top__ =>  ???
#     => GroupIndex - would be extra object created, no corresponding Group?
#     => Hash - would be boring anyway: no Groups by definition!
#          {:timestep=>:timestep, :run_control=>:run_control, :run_name=>:run_name, :fan_flow=>:fan_flow}  # not proposing this
#          {:timestep=>4, :run_control=>"ANNUAL", :run_name=>"Run 1", :fan_flow=>Autosize}  # eval'd dynamically
#          would still allow referencing:  __top__[:timestep] => current value
#          would NOT allow setting:  __top__[:timestep] = new value    # or have to write it as GroupIndex
#         def feels sketchy
#          if __top__ is wanted in the top-level template scope, need to add __top__ method in TemplateScope

        end

        __hash__.freeze  # Prevent external changes
      end

      # Get the current value of the local variable associated with key.
      # Returns `nil` if local variable is undefined, rather than raising an error.
      # This is consistent with default Hash behavior and simplifies syntax in
      # some Template situations.
      def [](key)
        if (not key.class == Symbol and not key.class == String)
          raise(TypeError, "no implicit conversion of #{key.class} into Symbol")
        end

        object = __hash__[key.to_sym]
        if (object.class == Symbol)
          # Evaluate symbol as local variable; returns nil if variable is undefined.
          # NOTE: Starting with Ruby 2.1 this should use `binding.local_variable_get`.
          value = @local_binding.eval("if defined?(#{object}); #{object} end")
        else
          value = object  # Child index or nil
        end
        return(value)
      end

# Bulk getter method?
#  group_index(:key1, :key2, :key3) => [value1, value2, value3]  # this is same as Hash#values_at
#  group_index(:key1, :key2, :key3) => {:key1 => value1, :key2 => value2, :key3 => value3}  # Rails/ActiveSupport has x.slice(:a, :b)
#    Ruby 2.5 has Hash#slice, same as above
# or:
#  {:key1 => nil, :key2 => nil} & group_index => {:key1 => value1, :key2 => value2}  # extracts values from index

      # Set the current value of the local variable associated with key.
      def []=(key, value)
        if (not key.class == Symbol and not key.class == String)
          raise(TypeError, "no implicit conversion of #{key.class} into Symbol")
        end

        object = __hash__[key.to_sym]
        if (object.class == Symbol)
          # NOTE: Starting with Ruby 2.1 this should use `binding.local_variable_set`.
          @local_binding.eval("#{object} = #{value.inspect}")
        elsif (object.class == self.class)
          raise(KeyError, "values are not assignable to a GroupIndex key")
        else
# TODO: need full prefix chain
#  .prefix_absolute   .prefix_global    .global_prefix   .absolute_prefix  .ext_prefix   .full_prefix
#  __group__.prefix_absolute
          raise(NameError, "undefined local variable '#{__group__.prefix}#{key}' for #{@local_binding}")
        end
        return(value)
      end


# Other syntax?:  group_index[] = {:key1 => value1, :key2 => value2}
# similar to above (group_index[:key1] = value1) but works in bulk
# similar in some respect to hash.merge(other) or hash.update(other)
# but may want to save merge for actually merging of indexes; no variable setting
#
#possibly replace with just an operator... keeping namespace clean
#options:  [], <<, >>, +

#  <<  "left shift"
#     - Integer: bitwise shift   5 << 7 => int
#     - Array: append/push to end of array    arr << 99 => Array   # mutates/destructive
#     - String: append/push to end of string; also mutates/destructive
#
# other related:
#     - Array:   merge:  array | other_array => new_array     NOTE: eliminates duplicates!
#     - Hash:    hash.merge({:a => 55}) => new_hash    same as:   hash | other_hash => new_hash  "merge"  alternately could interpret with +
#                hash.merge!({:a => 55}) => hash       no equiv. operator
#
#     propose?   hash << other_hash => hash    alias to Hash#merge!; similar to Array#<< (push)... also destructive
#
#                in `hash1 | hash2` right side (last actor) overwrites left side: hash2 wins, but returns new Hash
#                `hash1 << hash2` is consistent! hash2 wins; but hash1 (mutated) is returned
#                `hash1 >> hash2` could be proposed for reverse_merge!; hash1 (mutated) is returned
#                all of these can be chained, I think

      # Same as merge!
      # Use to assign local variables with a Hash. Multiple variables can be set at once.
      #   group_index << {:key1 => value1, :key2 => value2}
      # Can be chained together:
      #   group_index << hash1 << hash2
      # Does not allow adding new keys/variables that are not already in the index!
      def merge!(object)
        if (not object.respond_to?(:to_hash))
          raise(TypeError, "no implicit conversion of #{object.class} into Hash")
        end

        object.to_hash.each { |key, value| self[key] = value }
        #return(self.to_h)
        return(self)  # should return self, right? only way to allow chaining
# maybe only allow returning a Hash?
# `merge` and `merge!` should be consistent: either both returning a GroupIndex or Hash
# NOT consistent right now
      end

      alias_method :<<, :merge!

# merging two groups with nested elements might not work right...
# it's not doing anything recursive or smart.

# merge must also be able to merge a Hash in both directions
#   hash | group => Hash
#   group | hash => Group

# How does merge work?

#   hash | group => Hash
#   group implicitly does .to_hash first, then merges -- WORKS!

#   group | hash => ?  Hash?
#   hash = {:a => 55}  # acts as setter for variables ????   not sure

#   group | group => Group  (new one)
#   is this as simple as merging the Hashes?
#   need a constructor to create group from Hash (the whole index, not the values)

# can use `merge` to set all inputs/parameters initially in the template scope
#   template.group.merge!(inputs)  # nice!


# REVISIT THIS
      # Merge is non-destructive; it returns a new object.
# CAN 2 GROUPS BE MERGED?
# isn't that weird? there won't be a corresponding real Group to match
#   could create an impromptu synthetic Group on the spot
      def merge(object)
        if (not object.respond_to?(:to_hash))
          raise(TypeError, "no implicit conversion of #{object.class} into Hash")
        end

# need .dup method

        # should dup self first; then do merge! and return the dup
        #object.each { |key, value| self << key; self[key] = value }
        #return(self.to_h)

        #index = self.class.new(@local_binding, @__group__, @__parent__) # this is like dup
        #index << object

        # For now, force both to Hashes and merge them.
        return(self.to_h.merge(object))
      end

      alias_method :|, :merge

      def method_missing(symbol, *args)
        indexes = __hash__.select { |_, value| value.class == self.class }
        if (not index = indexes[symbol])
          raise(NoMethodError, "undefined method or group '#{symbol}' for #{inspect}")
        elsif (not args.empty?)
          raise(ArgumentError, "wrong number of arguments (#{args.length} for 0)")
        end
        return(index)
      end

      def to_h
        hash = {}; __hash__.each do |key, value|
          hash[key] = self[key] if (value.class == Symbol)
        end
        return(hash)
      end

      # This method allows GroupIndex to be treated implicitly as a Hash. In particular
      # to_hash enables GroupIndex to be destructured like a Hash with the splat operator **.
      # For example: hash = {:k1 => v1, :k2 => v2, **index}
      def to_hash
        return(to_h)
      end

      def to_s
        return(inspect)
      end

      def inspect
# NOPUB default `inspect` format for Ruby classes is: #<Module::Module::Class:0x007f929990ea88>
        #return("#<#{self.class} group=#{__group__.key.inspect} prefix=#{__group__.prefix.inspect} hash=#{__hash__.inspect}>")
        return("#<#{self.class} group=#{__group__.key.inspect}>")  # see if I like this
      end

    end

  end
end
