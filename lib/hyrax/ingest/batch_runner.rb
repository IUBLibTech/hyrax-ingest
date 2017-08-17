require 'hyrax/ingest/runner'

module Hyrax
  module Ingest
    class BatchRunner
      def initialize(config_file_path:, sip_paths:)
        @sip_paths = sip_paths
        @config_file_path = config_file_path
      end

      def run!
        runners.each { |runner| runner.run! }
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