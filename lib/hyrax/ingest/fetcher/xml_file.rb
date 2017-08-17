require 'hyrax/ingest/fetcher/base'
require 'nokogiri'

module Hyrax
  module Ingest
    module Fetcher
      class XMLFile < Base
        attr_reader :filename, :xpath

        def initialize(sip, options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :xpath is missing" unless options.key?(:xpath)
          @filename = options[:filename]
          @xpath = options[:xpath]
          super(sip)
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          noko.xpath(xpath).text
        end

        private

          # @return Boolean True if the first and last characters of the
          #  @filename attribute are a slash, indicating it should be
          #  interpreted as a regular expression.
          def filename_is_regex?
            filename.to_s[0] == '/' && filename.to_s[-1] == '/'
          end

          def xml
            @xml ||= begin
              file = if filename_is_regex?
                sip.files.find { |file| File.basename(file) =~ filename }
              else
                sip.files.find { |file| File.basename(file) == filename }
              end
              raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(filename) unless file
              file.read
            end
            file.rewind if file
            @xml
          end

          def noko
            @noko ||= begin
              n = Nokogiri::XML(xml)
              n.remove_namespaces!
            end
          end
      end
    end
  end
end