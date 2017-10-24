require 'solr_wrapper'
require 'fcrepo_wrapper'

desc 'Run tests as if on CI server'
task :ci => ["engine_cart:generate"] do
  ENV['RAILS_ENV'] = 'test'
  ENV['TRAVIS'] = '1'

  FcrepoWrapper.wrap(config: File.expand_path('../../.fcrepo_wrapper.test.yml', __FILE__)) do |fc|
    SolrWrapper.wrap(config: File.expand_path('../../.solr_wrapper.test.yml', __FILE__)) do |solr|
      solr.with_collection(name: 'hydra-test', dir: File.expand_path('../../.internal_test_app/solr/config', __FILE__)) do
        RSpec::Core::RakeTask.new(:rspec) do |task|
          task.rspec_opts      = ENV['RSPEC_OPTS']            unless ENV['RSPEC_OPTS'].nil?
          task.pattern         = ENV['RSPEC_PATTERN']         unless ENV['RSPEC_PATTERN'].nil?
          task.exclude_pattern = ENV['RSPEC_EXCLUDE_PATTERN'] unless ENV['RSPEC_EXCLUDE_PATTERN'].nil?
        end
        Rake::Task[:rspec].invoke
      end
    end
  end
end
