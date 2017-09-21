require 'hyrax/ingest/batch_runner'
require 'rails'

namespace :hyrax do
  desc 'Ingest one or more SIPs, using a specified package configuration'
  task :ingest => :environment do
    config_file_path = ENV['config_file_path']
    # Globbed paths represent batches, so expand them and add to the list of sip_paths.
    sip_paths = ENV['sip_paths'].to_s.split(',').map! do |sip_path|
      batch = Dir.glob(sip_path)
      batch.empty? ? sip_path : batch
    end.flatten

    if !config_file_path || sip_paths.empty?
      abort "Error: Invalid Parameters\n\nUsage: rake hyrax:ingest config_file=FILE sip_paths=DIR[,DIR,...]\n\n"
    end

    batch_runner = Hyrax::Ingest::BatchRunner.new(config_file_path: config_file_path, sip_paths: sip_paths)
    batch_runner.run!
  end
end
