require 'logger'
require 'singleton'

module Hyrax
  module Ingest

    module Reporting
      def report
        @report ||= Hyrax::Ingest::SharedReport.instance
      end

      def print_report
        report.print_report
      end

      def self.config
        Hyrax::Ingest::SharedReport.instance.config
      end

      def self.config=(config)
        Hyrax::Ingest::SharedReport.instance.config = config
      end
    end

    class SharedReport
      include Singleton

      attr_reader :config

      def initialize
        @summary = {}
        @config = default_config
      end

      def config=(config)
        validate_config!(config)
        @config = config
      end

      def default_config
        {
          filename: 'hyrax_ingest_report.log',
          append: false,
          verbose: true,
          summarize: true
        }
      end

      def print_report
        File.read(config[:filename])
      end

      def verbose?
        !!config[:verbose]
      end

      def summarize?
        verbose? || !!config[:summarize]
      end

      def write(text)
        File.open(config[:filename], 'a') { |f| f.write(text) }
      end

      def batch_ingest_started(num_sips)
        write "Batch ingest started: ingesting #{num_sips} SIPs." if summarize?
      end

      def batch_ingest_complete(num_sips)
        write "Batch ingest complete: #{num_sips} SIPs ingested." if summarize?
      end

      def sip_ingest_started(iteration, total_count)
        write "SIP #{iteration} of #{total_count} ingest started."
      end

      def sip_ingest_complete(iteration, total_count)
        write "SIP #{iteration} of #{total_count} ingest complete."
      end

      def model_ingest_started(model_name)
        write "Ingest of #{model_name} started." if verbose?
      end

      def model_ingest_complete(model_name)
        write "Ingest of #{model_name} complete" if verbose?
      end

      def model_ingest_failed_validation(model_name, validation_error_message)
        write "Ingest of #{model_name} failed. #{validation_error_message}"
      end

      def value_assigned_to_property(value, property_name, rdf_predicate)
         write "value: '#{value}'\nproperty: #{property_name}\npredicate: #{rdf_predicate}\n" if verbose?
      end

      private

        def validate_config!(config)
          raise ArgumentError, 'Reporting config must be a hash' unless config.is_a? Hash
          invalid_options = config.keys - default_config.keys
          raise Hyrax::Ingest::Errors::InvalidReportingConfigOption(invalid_options) unless invalid_options.empty?
          true
        end
    end
  end
end
