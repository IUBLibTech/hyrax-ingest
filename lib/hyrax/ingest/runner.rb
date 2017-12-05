require 'hyrax/ingest/configuration'
require 'hyrax/ingest/ingester'
require 'hyrax/ingest/reporting'

module Hyrax
  module Ingest
    class Runner
      include Reporting

      attr_reader :config, :sip, :shared_sip

      def initialize(config_file_path:, source_files_path:, shared_file_path: nil)
        @sip = SIP.new(path: source_files_path)
        @shared_sip = shared_file_path != nil ? SIP.new(path: shared_file_path) : nil
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
            Hyrax::Ingest::Ingester.factory(ingester_name, sip, shared_sip, ingester_options)
          end
        end
    end
  end
end