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
          validate_ingester_config_hashes!
        end

        # @raise [Hyrax::Ingest::Errors::InvalidConfig] When the top level
        #   'ingest' key is missing.
        def validate_top_level_key!
          raise Hyrax::Ingest::Errors::InvalidConfig.new(config_file_path, "Top-level key 'ingest' is missing.") unless config[:ingest]
        end

        def validate_ingester_configs_array!
          raise Hyrax::Ingest::Errors::InvalidConfig.new(config_file_path, "Value under top-level 'ingest' key must be an array containing the configuration for each ingester you want to use.") unless config[:ingest].respond_to?(:each)
        end

        def validate_ingester_config_hashes!
          config[:ingest].each do |ingest_config|
            raise Hyrax::Ingest::Errors::InvalidConfig.new(config_file_path, "Each ingester configuration must be a single key-value pair, where the key is the type of ingester, and the value is a hash containing the configuration for the ingester. But a #{ingester_config.class} was found instead.") unless ingest_config.respond_to? :keys
          end
        end
    end
  end
end
