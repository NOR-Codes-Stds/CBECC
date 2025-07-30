# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("observer")


module Modelkit

  # This an abstract superclass for all documents.
  # Implement these methods in each subclass.
  # This class has no concept of files, saving, loading, etc.
  # Documents only exist in memory.
  class Document
    include Observable

    attr_reader :conjugate_document  # Read only

# Should it just be 'conjugate' instead of 'conjugate_document'


    # Wrap the mechanism for serializing all documents.
    def self.load(data)
      # Ruby's Marshal is the easiest, but there are other approaches.
      return(Marshal.load(data))
    end


    # Wrap the mechanism for serializing all documents.
    # Does it make sense to make 'dump' an instance method? e.g., doc.dump
    def self.dump(document)
      # Ruby's Marshal is the easiest, but there are other approaches.
      return(Marshal.dump(document))
    end


    def initialize
      @conjugate_document = nil  # The raw document that is maintained in parallel
    end


    # Parse some raw text and decode the format for this type of document.
    # Gets used by Constructor.
    def parse(object)

    end


    # Generate formatted text for this type of document.
    def render

    end



    # Reads from a path?
    # This allows different IO read methods (all at once vs. line by line).
    #def read(path)
    #end


    # Writes to a path?
    # This allows different IO write methods (all at once vs. line by line).
    #def write(path)
    #end


    # Returns size of the as it would be saved on disk.
    def size
      return(0)
    end


    # Renders file to a consistent, normalized format that can be diffed in a readable way, i.e., objects sorted, formatting fixed, etc.
    # XML canonicalization: https://www.xml.com/pub/a/ws/2002/09/18/c14n.html
    #   https://en.wikipedia.org/wiki/Canonical_XML

    # Nokogiri has a built-in canonicalize feature!:  Nokogiri::XML(xml_string) { |config| config.strict }.canonicalize
    def normalize
      # returns a string dump
    end


    def normalize!
      # returns a string dump AND sets the content to match.
    end


    def dup  # or clone?
    end


    # do a SHA1 comparison on file dumps
    # do a comparison of contents/data only (ignoring comments, formatting, and order)
    def ===  # or == or eql?

    end


    # Searchable/regex type behavior.
    def find

    end

# def synch
#   reloads native data file and updates objects in an efficient way--only update stuff that has changed.

# Nice callback hooks allow the objects to update other sources.


    def export(format)  # e.g. export(Modelkit::GbXML) or export(Modelkit::EnergyPlus)
      #return(new_document)
    end


    def inspect
      hex_value = (object_id * 2).to_s(16)
      return("#<#{self.class}:0x#{hex_value}>")
    end

  end

end
