require 'hyrax/ingest/fetcher/base'
require 'nokogiri'

module Hyrax
  module Ingest
    module Fetcher
      class XMLFile < Base
        attr_reader :filename, :xpath

        def initialize(sip, shared_sip, options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :xpath is missing" unless options.key?(:xpath)
          @filename = options[:filename]
          @xpath = options[:xpath]
          super(sip, shared_sip)
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          noko.xpath(xpath).map(&:text)
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
                regexp = Regexp.new(filename[1..-2])
                sip.files.find { |file| File.basename(file) =~ regexp }
              else
                sip.files.find { |file| File.basename(file) == filename }
              end
              raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(filename) unless file
              file.read
            end
            file.rewind if file
            @xml
          end

          def shared_xml
            @shared_xml ||= begin
              file = shared_sip.files.find { |file| File.basename(file) == filename }
              raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(filename) unless file
              file.read
            end
            file.rewind if file
            @shared_xml
          end

          def noko
            @noko ||= begin
              n = !is_shared_file? ? Nokogiri::XML(xml) : Nokogiri::XML(shared_xml)
              n.remove_namespaces!
            end
          end

          def is_shared_file?
            return false if shared_sip.nil? || filename != File.basename(shared_sip.files.first)
            true
          end
      end
    end
  end
end