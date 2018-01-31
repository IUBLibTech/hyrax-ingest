require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'
require 'interloper'
require 'hyrax/ingest/has_logger'
require 'hyrax/ingest/has_report'



module Hyrax
  module Ingest
    module Fetcher
      class Base
        include Interloper
        include HasReport
        include HasLogger

        # Callback to log missing values that have been marked as required.
        after(:fetch) do
          # Use a flag to only report the missing value once.
          unless @after_fetch_run_once
            if required? && fetched_value_is_empty?
              report_missing_required_value
            end
            @after_fetch_run_once = true
          end
        end

        def initialize(options={})
          @required = options.delete(:required)
        end

        # Boolean reader for @required.
        def required?; !!@required; end

        # Subclasses should override this method with the logic required to
        # fetch values from a SIP. The overidden method should set
        # @fetched_value, and return it.
        # @see Hyrax::Ingest::Fetcher::XMLFile#fetch
        # @abstract
        def fetch
          @fetched_value
        end

        protected

          # Determines whether the value that was fetched by #fetch is empty
          # or not. Be default, the fetched value is empty if it is nil, an
          # empty string, an empty array, an empty hash, or an array
          # containing any combination of those. Overwrite this method in
          # subclasses to change the definition of empty in those contexts.
          # The return value is used for reporting which values are missing,
          # but required.
          # @return [Boolean] True if @fetched_value is considered to be empty; false otherwise.
          def fetched_value_is_empty?
            Array(@fetched_value).reduce(true) do |all_empty, val|
              all_empty &&= ( val.nil? || ( val.respond_to?(:empty?) && val.empty? ) )
            end
          end

          # Reports occurrences of missing required values.
          # Subclasses should override this method to provide further detail
          # by passing an options hash that will be available for reporting.
          # @see Hyrax::Ingest::Fetcher::XMLFile#report_missing_required_value
          # @example
          #     # Provide additional info to the report.
          #     def report_missing_require_value
          #       super(foo: "bar")
          #     end
          def report_missing_required_value(params={})
            short_class_name = self.class.to_s.gsub(/.*\:\:/, '')
            logger.warn "Missing required value from #{short_class_name} with params = #{params}"
            report.stat[:missing_required_values][self.class] ||= []
            report.stat[:missing_required_values][self.class] << params
          end
      end
    end
  end
end
