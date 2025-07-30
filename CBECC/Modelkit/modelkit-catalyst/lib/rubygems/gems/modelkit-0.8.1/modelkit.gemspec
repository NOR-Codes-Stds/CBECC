# Copyright (c) 2011-2020 Big Ladder Software LLC. All rights reserved.
# See the file "license.txt" for additional terms and conditions.

# The version number for this Gem is determined dynamically at build time from
# the tag in the Git repository and is saved in a top-level file named "version".
# The version number is also set in the Gemspec which then becomes the reference
# authority in the source code via `Gem.loaded_specs["gem-name"].version`.
#
# This approach deviates from the common practice of storing the version number
# directly in the source code (usually in version.rb) with the goals of:
# - Managing the version number independently as part of the build process
# - Making the version number more accessible to users and non-Ruby programs
# - Avoiding the pattern of having to load code to read the version number
# - Better supporting Semantic Versioning so that each build can have a unique
#   identifier with version number _and_ build label.
#
# RubyGems does not fully support Semantic Versioning yet because it does not
# allow special characters in the version string such as "-" or "+". This limits
# what can be done with a build label appended to the version number. As a
# workaround, a full SemVer string is generated and saved to a file while the
# numeric-only version string is used in the Gemspec. The build label is also
# stored separately in the Gemspec using the metadata attribute.

spec_name = File.basename(__FILE__)
root_dir = __dir__
version_path = "#{root_dir}/version"
version = (`git -C "#{root_dir}" describe --tags --abbrev=0`).strip
if (version.empty?)
  puts("Warning: Unable to read version tag from Git repository for '#{spec_name}'")
  if (not File.exist?(version_path))
    puts("Version file not found; version number set to 0.0.0")
    version, build = ["0.0.0", "unknown"]
  else
    # NOTE: If version tag cannot be read from Git, you can manually create your
    # own file named "version" in the root directory.
    puts("Reading version number from file")
    version, build = File.read(version_path).split("+")
    version ? version.strip! : version = ""
    build ? build.strip! : build = ""
  end
else
  branch = (`git -C "#{root_dir}" rev-parse --abbrev-ref HEAD`).strip
  sha = (`git -C "#{root_dir}" rev-parse --verify --short HEAD`).strip
  count = (`git -C "#{root_dir}" rev-list --count HEAD ^#{version}`).strip
  status = (`git -C "#{root_dir}" status --porcelain`).empty? ? "" : ".dirty"

  build = (count == "0" ? "#{sha}#{status}" : "#{branch}.#{count}.#{sha}#{status}")
end

version_build = "#{version}+#{build}"
if (not File.exist?(version_path) or version_build != File.read(version_path).strip)
  puts "Writing version file for '#{spec_name}'"
  File.write(version_path, version_build)
end

Gem::Specification.new do |spec|
  spec.name = "modelkit"
  spec.version = version
  spec.metadata = {
    "build" => build,
    "homepage_uri" => "https://bigladdersoftware.com/projects/modelkit/",
    "source_code_uri" => "https://bitbucket.org/bigladder/modelkit/src",
    "bug_tracker_uri" => "https://bitbucket.org/bigladder/modelkit/issues?status=new&status=open"
  }

  spec.license = "BSD-3-Clause"
  spec.summary = "Modelkit is a framework for building energy modeling."
  spec.description = "Modelkit is a framework for building energy modeling with features for parametrics, scripting, and automation."
  spec.authors = ["Big Ladder Software LLC"]
  spec.email = "info@bigladdersoftware.com"
  spec.homepage = spec.metadata["homepage_uri"]

  spec.files = Dir["**/{*,.gitignore,.modelkit-config}"] - Dir["*.gem"]
  spec.require_paths = ["lib", "vendor"]
  spec.bindir = "bin"
  spec.executables = ["modelkit"]

  spec.required_ruby_version = ">= 2.0.0"
  spec.add_runtime_dependency("gli", "~> 2.13.2")
  spec.add_runtime_dependency("toml-rb", "~> 1.1.0")
  spec.add_runtime_dependency("rb-readline", "~> 0.5.3")
  spec.add_runtime_dependency("rake", ">= 10.0")
  spec.add_development_dependency("minitest", "~> 5.10.0")  # Starting with 5.11 the SpecReporter format looks bad
  spec.add_development_dependency("minitest-reporters")
  spec.add_development_dependency("yard")
end
