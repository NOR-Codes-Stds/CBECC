# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module OpenStudio

  # Big Ladder additions to the old OpenStudio class.
  class DataDictionary

    # Scan the data dictionary file to detect the version number. The IDD version
    # number at the top of the file is a good surrogate for the version number of
    # the EnergyPlus executable, especially before the executable had the
    # command-line option to do --version.
    def self.detect_version(path)
      version = nil

      if (not File.exist?(path))
        raise(IOError, "path not found: #{path}")

      else
        pattern = /^\s*!\s*IDD_Version\s+(\S+)/
        match_data = nil
        line_number = 1

        File.foreach(path) { |line|
          if (match_data = pattern.match(line))
            version = match_data.captures.first
            break
          end

          line_number += 1
          break if (line_number == 1000)  # Limit the search to a reasonable length
        }
      end

      return(version)
    end

  end

end
