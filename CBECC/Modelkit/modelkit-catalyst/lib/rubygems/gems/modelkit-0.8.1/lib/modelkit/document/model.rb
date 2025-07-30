# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/document")
#require("modelkit/location")
#require("modelkit/location_converter")


module Modelkit
  class Document

    # The abstract superclass for all types of model documents.
    # Implement the additional methods here in addition to the Document methods.
    class Model < Document


      attr_accessor :location, :conjugate_document


      def initialize
        @conjugate_document = nil  ###################
  # conjugate
  # need something here to hold the context of the overall document...holds all the extra objects that are just passed through



        #@location = Modelkit::Model::Location.new
        #@location_converter = Modelkit::Model::LocationConverter.new(@location)

      end


      def create_conjugate
        #@conjugate_document = Nokogiri::XML::Document.new

      end


      def render
        #@location_converter.dump

      end


  # def synch
  #   reloads native data file and updates objects in an efficient way--only update stuff that has changed.

  # Nice callback hooks allow the objects to update other sources.


    end

  end
end
