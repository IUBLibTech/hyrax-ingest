require 'hyrax/ingest/configuration'
require 'hyrax/ingest/ingester'
require 'hyrax/ingest/reporting'
require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_shared_sip'
require 'hyrax/ingest/has_iteration'

module Hyrax
  module Ingest
    class Runner
      include Reporting

      attr_reader :config

      include HasSIP
      include HasSharedSIP
      include HasIteration

      def initialize(config_file_path:, source_files_path: nil, shared_file_path: nil, iteration: 0)
        self.sip = SIP.new(path: source_files_path) if source_files_path
        self.shared_sip = shared_file_path != nil ? SIP.new(path: shared_file_path) : nil
        self.iteration = iteration.to_i
        @config = Hyrax::Ingest::Configuration.new(config_file_path: config_file_path)
      end

      def run!
        ingesters.collect { |ingester| ingester.run! }
        sip.close_all_files
      end

      def errors
        @errors ||= []
      end

      private

        def ingesters
          @ingesters ||= config.ingester_configs.map do |ingester_config|
            ingester_name = ingester_config.keys.first
            ingester_options = ingester_config.values.first
            Hyrax::Ingest::Ingester.factory(ingester_name, ingester_options).tap do |ingester|
              ingester.sip = sip if ingester.respond_to? :sip=
              ingester.shared_sip = shared_sip if ingester.respond_to? :shared_sip=
              ingester.iteration = iteration if ingester.respond_to? :iteration=
            end
          end
        end
    end
  end
end