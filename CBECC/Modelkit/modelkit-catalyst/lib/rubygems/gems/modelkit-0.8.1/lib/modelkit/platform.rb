# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

module Modelkit

  # Keep it simple, light. Yes, there are gems out there.
  module Platform

    def self.windows?
      return(@windows ||= !!(RbConfig::CONFIG['host_os'] =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/))
    end

    def self.mac?
      return(@mac ||= !!(RbConfig::CONFIG['host_os'] =~ /darwin|mac os/))
    end

    def self.linux?
      return(@linux ||= !!(RbConfig::CONFIG['host_os'] =~ /linux/))
    end

    # Both Linux and Mac are Unix platforms.
    def self.unix?
      return(not windows?)
    end


# could add .family => "windows", "mac", "linux", "other"
# or .os

  end

end
