# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "modelkit-energyplus"
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://bitbucket.org/bigladder/modelkit-energyplus/issues?status=new&status=open", "build" => "HEAD.39.f9df77f", "homepage_uri" => "https://bigladdersoftware.com/projects/modelkit/", "source_code_uri" => "https://bitbucket.org/bigladder/modelkit-energyplus/src" } if s.respond_to? :metadata=
  s.authors = ["Big Ladder Software LLC"]
  s.date = "2022-05-05"
  s.description = "Modelkit for EnergyPlus extends the Modelkit framework to work with the EnergyPlus engine."
  s.email = "info@bigladdersoftware.com"
  s.executables = ["modelkit-energyplus"]
  s.files = ["bin/modelkit-energyplus"]
  s.homepage = "https://bigladdersoftware.com/projects/modelkit/"
  s.licenses = ["BSD-3-Clause"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 2.0.0")
  s.rubygems_version = "2.0.14.1"
  s.summary = "Modelkit for EnergyPlus extends the Modelkit framework to work with EnergyPlus."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<modelkit>, ["~> 0.6"])
      s.add_runtime_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_development_dependency(%q<rake>, [">= 10.0"])
      s.add_development_dependency(%q<minitest>, ["~> 5.10.0"])
      s.add_development_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_development_dependency(%q<yard>, [">= 0"])
    else
      s.add_dependency(%q<modelkit>, ["~> 0.6"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
      s.add_dependency(%q<rake>, [">= 10.0"])
      s.add_dependency(%q<minitest>, ["~> 5.10.0"])
      s.add_dependency(%q<minitest-reporters>, [">= 0"])
      s.add_dependency(%q<yard>, [">= 0"])
    end
  else
    s.add_dependency(%q<modelkit>, ["~> 0.6"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.3"])
    s.add_dependency(%q<rake>, [">= 10.0"])
    s.add_dependency(%q<minitest>, ["~> 5.10.0"])
    s.add_dependency(%q<minitest-reporters>, [">= 0"])
    s.add_dependency(%q<yard>, [">= 0"])
  end
end
