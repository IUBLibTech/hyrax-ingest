require 'hyrax/ingest/errors'
require 'active_support/core_ext/hash/keys'

module Hyrax
  module Ingest
    class Configuration
      attr_reader :config_file_path

      def initialize(config_file_path:)
        @config_file_path = config_file_path.to_s
        raise Hyrax::Ingest::Errors::NoConfigFileFound.new(@config_file_path) unless File.exist? @config_file_path
        validate!
      end

      # @return [Array] Array of hashes, where each hash is the configuration options
      #   for an Ingester instance
      def ingester_configs
        @ingester_configs ||= config[:ingest]
      end

      private

        # @return [Hash] The config hash parsed from yaml file, and with keys
        #   converted from strings to symbols.
        def config
          @config ||= Psych.load_file(config_file_path).deep_symbolize_keys
        end

        # Validates the configuration.
        # @raise [Hyrax::Ingest::Errors::InvalidConfig] When the configuration is invalid.
        def validate!
          validate_top_level_key!
          validate_ingester_configs_array!
        end

        # @raise [Hyrax::Ingest::Errors::InvalidConfig] When the top level
        #   'ingest' key is missing.
        def validate_top_level_key!
          raise Hyrax::Ingest::Errors::InvalidConfig.new("Top-level key 'ingest' is missing.") unless config[:ingest]
        end

        def validate_ingester_configs_array!
          raise Hyrax::Ingest::Errors::InvalidConfig.new("Value under top-level 'ingest' key must be an array.") unless config[:ingest].respond_to?(:each)
        end
    end
  end
end
