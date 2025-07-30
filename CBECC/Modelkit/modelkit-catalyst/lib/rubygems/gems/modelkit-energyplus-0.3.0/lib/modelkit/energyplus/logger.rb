# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit
  module EnergyPlus

    class Logger

      class << self
        alias_method :_new, :new
      end


      private_class_method :_new


      # Convenience facade for original '_new' method.
      def self.new(*targets)
        return(_new(targets, 'w'))
      end


      # Convenience facade for original '_new' method.
      def self.append(*targets)
        return(_new(targets, 'a'))
      end


      # Called by original 'new_' constructor.
      def initialize(targets, mode)
        @streams = []
        targets.each { |target|
          if (target.respond_to?(:puts) and target.respond_to?(:close))  # Target is already streamable
            stream = target

          elsif (target.class == String)  # Target is a file path
            # begin/rescue on File.open
            stream = File.open(target, mode)

          else
            # Not streamable; raise exception
          end

          @streams.push(stream)
        }
      end


      def write(string)
        bytes = 0
        @streams.each { |stream| bytes = stream.write(string) }
        return(bytes)
      end


      def puts(*objects)
        @streams.each { |stream| stream.puts(*objects) }
        return(nil)
      end


      def datetime(*objects)
        puts_prefix('[' + Time.now.to_s + ']', *objects)
        return(nil)
      end


      def info(*objects)
        puts_prefix('[INFO]', *objects)
        return(nil)
      end


      def warning(*objects)
        puts_prefix('[WARNING]', *objects)
        return(nil)
      end


      def error(*objects)
        puts_prefix('[ERROR]', *objects)
        return(nil)
      end


      # Place-holder method: Seems to be required by IO::popen.
      def flush
      end


      # Close all streams except for STDIN, STDOUT, and STDERR.
      def close
        @streams.each { |stream| stream.close if (stream.fileno > 2) }
        return(nil)
      end


    private
      def puts_prefix(prefix = '', *objects)
        if (objects.length > 0)
          prefixed_objects = objects.map { |object| prefix + '  ' + object.to_s }
        else
          prefixed_objects = [ prefix ]
        end
        self.puts(*prefixed_objects)
        return(nil)
      end

    end

  end
end
