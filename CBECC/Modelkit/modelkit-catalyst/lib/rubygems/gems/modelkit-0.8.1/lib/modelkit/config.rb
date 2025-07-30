# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

require("toml-rb")


module Modelkit

  ConfigError = Class.new(StandardError)


  # A Config object corresponds to a configuration file on the file system.
  # Configuration files are formatted using TOML syntax (see https://github.com/toml-lang/toml).
  # The object immediately reads the file on initialization. File paths that do not exist yet create a blank Config object.
  # For now, the Config object is READ ONLY. (Writing is harder because it must preserve formatting and comments in the existing file.)
  class Config

    attr_reader :path


    def initialize(path)
      if (not path.kind_of?(String))
        raise(TypeError, "no implicit conversion of #{path.class} into String")
      end

      @path = File.expand_path(path)
      @hash = Hash.new

      if (File.exist?(@path))
        begin
          @hash = TomlRB.load_file(@path, :symbolize_keys => true)
        rescue Exception => exception
          raise(ConfigError, "error in #{@path}\n#{exception.message}")  # Pass through TOML error message
        end

      else
        # Only create a new file when the Config object is written to; do nothing now.
      end
    end


    # Read values for the specified key. The key must always be a String.
    # A dot is used to delimit table and keys names. For example: `config.read("table.key")`
    # reads the value 42 from the following TOML:
    #
    # [table]
    # key = 42
    #
    def read(key)
      if (not key.kind_of?(String))
        raise(TypeError, "no implicit conversion of #{key.class} into String")
      end

      sub_hash = @hash
      sub_keys = key.split(".")
      for k in sub_keys
        sub_hash = sub_hash[k.to_sym]
        break if (not sub_hash)  # Key was not found; stop reading
      end

      return(sub_hash)
    end


    # An alias for `read(key)`.
    def [](key)
      return(read(key))
    end


    def to_h
      return(@hash)
    end


    # Return a canonical string representation.
    def inspect
      return("#<#{self.class}:#{self.path}>")
    end


    # This method is called for string interpolation.
    def to_s
      return(self.path)
    end

  end

end
