require 'hyrax/ingest/sip'
require 'hyrax/ingest/mapping'
require 'active_support/core_ext/hash/keys'

module Hyrax
  module Ingest
    class Ingester
      attr_reader :sip_path, :mapping_config_path

      def initialize(sip_path:, mapping_config_path:)
        @sip_path = sip_path
        @mapping_config_path = mapping_config_path
      end

      def sip
        @sip ||= Hyrax::Ingest::SIP.new(path: sip_path)
      end

      def mapping
        @mapping ||= Hyrax::Ingest::Mapping.new(sip: sip, config: mapping_config)
      end

      def mapping_config
        @mapping_config ||= Psych::load_file(mapping_config_path).deep_symbolize_keys[:mapping]
      end

      # TODO: Follow through with saving.
      def ingest!
        mapping.map_all!
      end
    end
  end
end
