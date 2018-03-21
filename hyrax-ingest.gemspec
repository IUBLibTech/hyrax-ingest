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
  s.homepage    = "https://github.com/IUBLibTech/hyrax-ingest"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "README.md"]

  s.add_runtime_dependency "rails", "~> 5"
  s.add_runtime_dependency 'hyrax', '~> 1.0', '>= 1.0.3'
  s.add_runtime_dependency "minitar", '~> 0.6.1'
  s.add_runtime_dependency 'nokogiri', '~> 1.8', '>= 1.8.2'
  s.add_runtime_dependency 'roo', '~> 2.7', '>= 2.7.0'
  s.add_runtime_dependency 'hyrax-preservation', '~> 0.1'
  s.add_runtime_dependency 'interloper', '~> 0.2.3'
  s.add_runtime_dependency 'functional_hash', '~> 0.2.1'

  s.add_development_dependency 'sqlite3', '~> 1.3', '>= 1.3.13'
  s.add_development_dependency 'rspec', '~> 3.7', '>= 3.7.0'
  s.add_development_dependency "engine_cart", '~> 1.2', '>= 1.2.0'
  s.add_development_dependency "pry-byebug", '~> 3.5', '>= 3.5.1'
  s.add_development_dependency "solr_wrapper", '~> 1.2.0', '>= 1.2.0'
  s.add_development_dependency "fcrepo_wrapper", '~> 0.9.0'
end
