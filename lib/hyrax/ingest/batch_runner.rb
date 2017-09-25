require 'hyrax/ingest/runner'
require 'hyrax/ingest/logging'

module Hyrax
  module Ingest
    class BatchRunner
      include Hyrax::Ingest::Logging
      def initialize(config_file_path:, sip_paths:)
        @sip_paths = sip_paths
        @config_file_path = config_file_path
      end

      def run!
        logger.info("Batch ingest of #{runners.count} SIPs started.")
        runners.each_with_index do |runner, i|
          logger.info "Ingesting SIP #{i+1} of #{runners.count}"
          runner.run!
        end
        logger.info("Batch ingest complete!")
      end

      private

        def runners
          @runners ||= @sip_paths.map do |sip_path|
            Hyrax::Ingest::Runner.new(config_file_path: @config_file_path, source_files_path: sip_path)
          end
        end
    end
  end
end