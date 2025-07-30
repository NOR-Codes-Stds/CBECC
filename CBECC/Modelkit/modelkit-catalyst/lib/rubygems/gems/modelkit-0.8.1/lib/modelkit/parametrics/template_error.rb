# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module Parametrics

    class TemplateError < StandardError

      # attributes for storing the caller stack _for_templates_

      def initialize(message = "problem in template")
        super(message)
      end

    end

  end
end
