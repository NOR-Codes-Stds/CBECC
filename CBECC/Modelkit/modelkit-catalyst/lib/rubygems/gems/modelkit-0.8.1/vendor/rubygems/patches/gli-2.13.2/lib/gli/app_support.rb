# Patches and overrides for GLI gem.

require("toml-rb")


module GLI
  module AppSupport

    def self.config_file_name
      return(@config_file_name)
    end


    def self.config_file_name=(file_name)
      @config_file_name = file_name
    end


    # Override the config file parsing to use a different method.
    def parse_config
      config_file_name = GLI::AppSupport.config_file_name

      config = {
        "commands" => {}
      }

      # Apply global config options from the user home directory first.
      search_dirs = [ENV["HOME"] + "/"]

      # Walk the directory nodes from top to bottom stacking up config options.
      search_dir = ""
      for dir_node in Dir.pwd.split("/")
        search_dir += dir_node + "/"
        search_dirs << search_dir
      end

      for dir in search_dirs
        config_path = dir + config_file_name

        if (File.exist?(config_path))
          toml_hash = TomlRB.load_file(config_path, :symbolize_keys => true)

          toml_hash.each { |key, value|
            if (value.class == Hash)  # Set command options
              # Perform one-level deep merge under "commands" only.
              if (config["commands"][key])
                config["commands"][key].merge!(value)
              else
                config["commands"][key] = value
              end
            else
              config[key] = value  # Set global options
            end
          }
        end
      end

      return(config)
    end

    module_function :parse_config  # Hack to allow method to be called directly


    # Patch for GLI bug where only short form options (e.g., -a, -i) would be recognized in the config file.
    def override_default(tokens, config)
      tokens.each do |name, token|
        all_aliases = [token.name]
        all_aliases += token.aliases if (token.aliases)
        matches = config.keys & all_aliases  # Could have multiple aliases in config file, i.e., over specified
        if not matches.empty?
          token.default_value = config[matches.last]  # Use last match; should be last occurrence in config file, but not necessarily
        end
      end
    end

  end
end
