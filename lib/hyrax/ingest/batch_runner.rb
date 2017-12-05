require 'hyrax/ingest/runner'
require 'hyrax/ingest/reporting'

module Hyrax
  module Ingest
    class BatchRunner
      include Reporting
      def initialize(config_file_path:, sip_paths:, shared_sip_path: nil)
        @sip_paths = sip_paths
        @shared_sip_path = shared_sip_path
        @config_file_path = config_file_path
      end

      def run!
        report.batch_ingest_started(runners.count)
        runners.each_with_index do |runner, i|
          report.sip_ingest_started((i+1), runners.count)
          runner.run!
          report.sip_ingest_complete((i+1), runners.count)
        end
        report.batch_ingest_complete(runners.count)
      end

      private

        def runners
          @runners ||= @sip_paths.map do |sip_path|
            Hyrax::Ingest::Runner.new(config_file_path: @config_file_path, source_files_path: sip_path, shared_file_path: @shared_sip_path)
          end
        end
    end
  end
end