# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("modelkit/document")


module Modelkit
  class Document

    # A text document is just a string!
    class Text < Document

      def initialize(text = "")
        @conjugate_document = text
      end


      def parse(text)
        # Validate the input: is it string-like?
        @conjugate_document = text
        changed
        notify_observers  # (args)
        return(self)
      end


      def render
        return(@conjugate_document.dup)
      end


      def size
        return(@conjugate_document.bytesize)
      end


  ##### Special methods for this document class.
      def append(text)
        @conjugate_document << text
        changed
        notify_observers  # (args)
        return(self)
      end


      def clear
        @conjugate_document = ""
        changed
        notify_observers  # (args)
        return(self)
      end

    end

  end
end
