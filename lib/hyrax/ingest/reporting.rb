require 'logger'
require 'singleton'

module Hyrax
  module Ingest

    module Reporting
      def report
        @reporter ||= Hyrax::Ingest::SharedReporter.instance
      end

      def self.config
        @config ||= {
          write_to: STDOUT,
          verbose: true,
          summarize: true
        }
      end
    end

    class SharedReporter
      include Singleton

      attr_reader :logger

      def initialize
        @logger = Logger.new(Reporting.config[:write_to]).tap do |logger|
          # Simplify the formatter to just put the message.
          logger.formatter = -> severity,datetime,progname,msg { "\n#{msg}" }
        end

        @summary = {}
      end

      def verbose?
        !!Reporting.config[:verbose]
      end

      def summarize?
        verbose? || !!Reporting.config[:summarize]
      end

      def batch_ingest_started(num_sips)
        logger.info "Batch ingest started: ingesting #{num_sips} SIPs." if summarize?
      end

      def batch_ingest_complete(num_sips)
        logger.info "Batch ingest complete: #{num_sips} SIPs ingested." if summarize?
      end

      def sip_ingest_started(iteration, total_count)
        logger.info "SIP #{iteration} of #{total_count} ingest started."
      end

      def sip_ingest_complete(iteration, total_count)
        logger.info "SIP #{iteration} of #{total_count} ingest complete."
      end

      def model_ingest_started(model_name)
        logger.info "Ingest of #{model_name} started." if verbose?
      end

      def model_ingest_complete(model_name)
        logger.info "Ingest of #{model_name} complete" if verbose?
      end

      def value_assigned_to_property(value, property_name, rdf_predicate)
         logger.info "value: '#{value}'\nproperty: #{property_name}\npredicate: #{rdf_predicate}\n" if verbose?
      end
    end
  end
end
