# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module Hierarchical

    attr_writer :parent

    def parent
      return(@parent ||= nil)
    end

    def children
      return(@children ||= [])
    end

    def children?
      return(not children.empty?)
    end

    # Adds an object to the children while ignoring duplicates.
    # The method does not check for circular references, nor does it clean up
    # its previous parent if it had one. Returns self for method chaining.
    def add_child(object)
      if (not children.include?(object))
        children << object
        object.parent = self
      end
      return(self)
    end

    def remove_child(object)
      if (children.delete(object))
        object.parent = nil
      end
      return(self)
    end

    def siblings
      if (parent)
        objects = parent.children.dup
        objects.delete(self)
      else
        objects = []
      end
      return(objects)
    end

    def siblings?
      return(not siblings.empty?)
    end

    # Returns ordered Array of ancestor objects.
    def ancestors
      objects = []
      next_object = self
      objects << next_object while (next_object = next_object.parent)
      return(objects)
    end

    def root
      return(ancestors.last or self)
    end

    def root?
      return(parent.nil?)
    end

    def traverse_depth(&block)
      traverse = Proc.new do |object, depth, block|
        yield(object, depth)
        object.children.each { |child| traverse.call(child, depth + 1, &block) }
      end
      traverse.call(self, 0, &block)
      return(self)
    end

    def traverse_breadth(&block)
      # Traverse all objects by depth first and sort into a hash using depth as the key.
      hash = {}
      max_depth = 0
      traverse_depth do |object, depth|
        if (hash[depth])
          hash[depth] << object
        else
          hash[depth] = [object]
        end
        max_depth = depth if (depth > max_depth)
      end

      # Iterate at each depth in the hash.
      (0..max_depth).each do |depth|
        hash[depth].each do |object|
          yield(object, depth)
        end
      end
      return(self)
    end

    def descendants
      objects = []
      traverse_depth { |object| objects << object }
      objects.shift  # Remove self
      return(objects)
    end

  end
end
