require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/has_sip'
require 'yaml'

module Hyrax
  module Ingest
    module Fetcher
      class YAMLFile < Base
        attr_reader :filename, :yaml_path

        include HasSIP

        def initialize(options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :yaml_path is missing" unless options.key?(:yaml_path)
          @filename = options[:filename]
          @yaml_path = options[:yaml_path]
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          yaml.dig(*yaml_path)
        end

        private

        # @return [Hash, Array, String] The YAML parsed into Ruby objects.
        def yaml
          @yaml ||= YAML.load sip.read_file(filename)
        end
      end
    end
  end
end
