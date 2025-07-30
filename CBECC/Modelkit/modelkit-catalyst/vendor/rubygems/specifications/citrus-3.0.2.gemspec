# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "citrus"
  s.version = "3.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Michael Jackson"]
  s.date = "2015-02-19"
  s.description = "Parsing Expressions for Ruby"
  s.email = "mjijackson@gmail.com"
  s.extra_rdoc_files = ["README.md", "CHANGES"]
  s.files = ["README.md", "CHANGES"]
  s.homepage = "http://mjackson.github.io/citrus"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Citrus", "--main", "Citrus"]
  s.require_paths = ["lib"]
  s.rubygems_version = "2.0.14"
  s.summary = "Parsing Expressions for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
