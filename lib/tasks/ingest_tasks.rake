require 'hyrax/ingest/runner'
require 'rails'

namespace :hyrax do
  desc 'Ingest one or more SIPs, using a specified package configuration'
  task :ingest, [:package_type] do |_task, args|
    package_types = {}
    Dir[Rails.root.join('config', 'ingests', '*.yml')].each do |path|
      package_types[File.basename(path, File.extname(path))] = path
    end
    package_config = package_types[args.package_type]
    abort "Invalid package_type: #{args.package_type}.  Valid package types: #{package_types.keys.join(', ')}" unless package_config

    sip_paths = ARGV[1..-1]
    abort 'usage: rake hyrax:ingest[package_type] /path/to/sip...' if sip_paths.none?
    sip_paths.each do |sip_path|
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: package_config,
        source_files_path: sip_path
      )
      @runner.run!
    end
  end
end
