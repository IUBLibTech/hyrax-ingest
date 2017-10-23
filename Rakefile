begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require "bundler/gem_tasks"
require "rspec/core/rake_task"
require 'engine_cart/rake_task'

Dir.glob('gem_development_tasks/**/*.rake').each { |r| import r }

task :default => :ci
