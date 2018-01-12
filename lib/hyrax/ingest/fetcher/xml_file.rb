require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/has_sip'
require 'nokogiri'

module Hyrax
  module Ingest
    module Fetcher
      class XMLFile < Base
        attr_reader :filename, :xpath, :default

        include HasSIP

        def initialize(options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :xpath is missing" unless options.key?(:xpath)
          @filename = options[:filename]
          @xpath = options[:xpath]
          @default = options[:default]
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          fetched = noko.xpath(xpath).map(&:text)
          return fetched if fetched.present?
          return default if default.present?
          return []
        end

        private

          def noko
            @noko ||= Nokogiri::XML(sip.read_file(filename)).tap do |n|
              # TODO: allow using namespaces instead of blindly removing them.
              n.remove_namespaces!
            end
          end
      end
    end
  end
end
