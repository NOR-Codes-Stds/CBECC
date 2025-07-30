# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "toml-rb"
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Emiliano Mancuso", "Lucas Tolchinsky"]
  s.date = "2017-11-25"
  s.description = "A Toml parser using Citrus parsing library. "
  s.email = ["emiliano.mancuso@gmail.com", "lucas.tolchinsky@gmail.com"]
  s.homepage = "http://github.com/emancu/toml-rb"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14.1"
  s.summary = "Toml parser in ruby, for ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
    else
      s.add_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
    end
  else
    s.add_dependency(%q<citrus>, ["> 3.0", "~> 3.0"])
  end
end
