require 'hyrax/ingest/configuration'
require 'hyrax/ingest/ingester'


module Hyrax
  module Ingest
    class Runner
      attr_reader :config, :sip

      def initialize(config_file_path:, source_files_path:)
        @sip = SIP.new(path: source_files_path)
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
            Hyrax::Ingest::Ingester.factory(ingester_name, sip, ingester_options)
          end
        end
    end
  end
end