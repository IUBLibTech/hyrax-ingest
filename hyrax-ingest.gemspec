$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "hyrax/ingest/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "hyrax-ingest"
  s.version     = Hyrax::Ingest::VERSION
  s.authors     = ["Andrew Myers"]
  s.email       = ["afredmyers@gmail.com"]
  s.summary     = "Summary of Hyrax::Ingest."
  s.description = "Description of Hyrax::Ingest."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_dependency "rails", "~> 5"
  s.add_dependency "hyrax", "~> 1.0.3"
  s.add_dependency "minitar"
  s.add_dependency "nokogiri"
  s.add_dependency "roo", "~> 2.7.0"
  s.add_dependency 'hyrax-preservation'
  s.add_dependency 'interloper', '~> 0.2.3'
  s.add_dependency 'functional_hash', '~> 0.2.1'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec"
  s.add_development_dependency "engine_cart"
  s.add_development_dependency "pry-byebug"
  s.add_development_dependency "solr_wrapper"
  s.add_development_dependency "fcrepo_wrapper"
end
