require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/has_sip'
require 'nokogiri'
require 'hyrax/ingest/reporting'
require 'interloper'

module Hyrax
  module Ingest
    module Fetcher
      class XMLFile < Base
        include HasSIP

        attr_reader :filename, :xpath, :default, :fetched_value

        inherit_callbacks_after :fetch

        def initialize(options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :xpath is missing" unless options.key?(:xpath)
          @filename = options[:filename]
          @xpath = options[:xpath]
          @default = options[:default] || []
          super
        end

        # Overrides Hyrax::Ingest::Fetcher::Base#fetch
        # @return [String] The value fetched from the XML file
        def fetch
          @fetched_value ||= begin
            fetched_from_xml = noko.xpath(xpath).map(&:text)
            fetched_from_xml.empty? ? default : fetched_from_xml
          end
        end

        protected

          # Overrides
          # Hyrax::Ingest::Fetcher::Base#report_missing_required_value,
          # passing filename and xpath inforamtion. The report summary has
          # specific logic to look for these.
          def report_missing_required_value
            super(filename: filename, xpath: xpath)
          end

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
