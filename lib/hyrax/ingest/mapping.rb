require 'hyrax/ingest/fetcher'
require 'hyrax/ingest/assigner'
require 'hyrax/ingest/map_operation'
require 'active_support/core_ext/hash/keys'

module Hyrax
  module Ingest
    class Mapping
      attr_reader :sip, :config

      def initialize(sip:, config:)
        @sip = sip
        # The config is an array of hashes. We want each hash to have all keys be symbols.
        @config = config.map { |map_operation_config| map_operation_config.deep_symbolize_keys }
      end

      def map_operations
        @map_operations ||= config.map do |params|
          # TODO: Handle edge cases of invalid config format custom error.
          fetcher_class_name, fetcher_options = params[:from].first
          assigner_class_name, assigner_options = params[:to].first
          fetcher = Hyrax::Ingest::Fetcher.factory(fetcher_class_name, fetcher_options)
          assigner = Hyrax::Ingest::Assigner.factory(assigner_class_name, assigner_options)
          Hyrax::Ingest::MapOperation.new(fetcher: fetcher, assigner: assigner)
        end
      end

      def map_all!
        map_operations.each { |map_operation| map_operation.map! }
      end
    end
  end
end
