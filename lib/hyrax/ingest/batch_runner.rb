require 'hyrax/ingest/runner'
require 'hyrax/ingest/has_report'
require 'hyrax/ingest/has_logger'
require 'hyrax/ingest/has_depositor'
require 'interloper'

module Hyrax
  module Ingest
    class BatchRunner
      include HasReport
      include HasLogger
      include HasDepositor
      include Interloper

      # Report before and after a batch is ingested.
      before(:run!) do
        logger.info "Starting batch ingest, batch size = #{iterations}."
        report.stat[:batch_size] = iterations
        report.stat[:datetime_started] = DateTime.now
      end

      after(:run!) do
        logger.info "Batch ingest complete."
        report.stat[:datetime_completed] = DateTime.now
        report.write_to_file
      end

      attr_reader :sip_paths

      def initialize(config_file_path:, sip_paths: [], shared_sip_path: nil, iterations: nil, depositor: nil)
        @sip_paths = sip_paths
        @shared_sip_path = shared_sip_path
        @config_file_path = config_file_path
        @iterations = iterations
        self.depositor = depositor
      end

      def run!
        runners.each { |runner| runner.run! }
      rescue StandardError => error
        # TODO: move to callback, but :rescue hook doesn't exist yet in
        # Interloper gem.
        report.stat[:datetime_completed] = DateTime.now
        report.failed_with error
        raise error
      ensure
        # TODO: move to callback, but :ensure hook doesn't exist yet in
        # Interloper gem.
        report.write_to_file
      end

      # Returns an array containing the IDs of new or updated records.
      # Currently only returns the IDs for ActiveFedora records (or
      # subclasses) that are specified at the top level (i.e. not nested) of
      # the ingest configuration.
      # @return [Array] list of IDs
      def ingested_ids
        ingested_ids_by_type.flatten
      end

      # Returns an hash containing the IDs of new or updated records, keyed by
      # the model class by which they were saved.
      # Example:
      #   { FileSet => ['123', '456'], Work => ['789'] }
      # Currently only returns the IDs for ActiveFedora records (or
      # subclasses) that are specified at the top level (i.e. not nested) of
      # the ingest configuration.
      # @return [Hash] IDs keyed by the model class by which they were saved.
      def ingested_ids_by_type
        {}.tap do |h|
          runners.each do |runner|
            runner.ingested_ids_by_type.each do |type, ids|
              h[type] ||= []
              h[type] += ids
              h[type].uniq!
            end
          end
        end
      end

      # Returns an array containing the IDs of new or updated records.
      # Currently only returns the IDs for ActiveFedora records (or
      # subclasses) that are specified at the top level (i.e. not nested) of
      # the ingest configuration.
      # @return [Array] list of IDs
      def ingested_ids
        ingested_ids_by_type.flatten
      end

      # Returns an hash containing the IDs of new or updated records, keyed by
      # the model class by which they were saved.
      # Example:
      #   { FileSet => ['123', '456'], Work => ['789'] }
      # Currently only returns the IDs for ActiveFedora records (or
      # subclasses) that are specified at the top level (i.e. not nested) of
      # the ingest configuration.
      # @return [Hash] IDs keyed by the model class by which they were saved.
      def ingested_ids_by_type
        {}.tap do |h|
          runners.each do |runner|
            runner.ingested_ids_by_type.each do |type, ids|
              h[type] ||= []
              h[type] += ids
              h[type].uniq!
            end
          end
        end
      end

      private

        def iterations
          # Return @iterations.to_i if it's not nil and not empty
          unless @iterations.nil? || @iterations.to_s.empty?
            @iterations
          else
            [1, @sip_paths.count].max
          end.to_i
        end

        def runners
          @runners ||= (0...iterations).map do |iteration|
            Hyrax::Ingest::Runner.new(config_file_path: @config_file_path, sip_path: @sip_paths[iteration], shared_sip_path: @shared_sip_path, iteration: iteration, depositor: depositor).tap do |runner|
              runner.report = report if runner.respond_to? :report=
            end
          end
        end
    end
  end
end