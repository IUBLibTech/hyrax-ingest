require 'hyrax/ingest/fetcher/base'
require 'yaml'

module Hyrax
  module Ingest
    module Fetcher
      class YAMLFile < Base
        attr_reader :filename, :yaml_path

        def initialize(sip, shared_sip, options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :yaml_path is missing" unless options.key?(:yaml_path)
          raise ArgumentError, "YAMLFile cannot have a shared sip." unless shared_sip.nil?
          @filename = options[:filename]
          @yaml_path = options[:yaml_path]
          super(sip, shared_sip)
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          yaml.dig(*yaml_path)
        end

        private

        # @return Boolean True if the first and last characters of the
        #  @filename attribute are a slash, indicating it should be
        #  interpreted as a regular expression.
        def filename_is_regex?
          filename.to_s[0] == '/' && filename.to_s[-1] == '/'
        end

        # @return
        def yaml
          @yaml ||= begin
            file = if filename_is_regex?
                     regexp = Regexp.new(filename[1..-2])
                     sip.files.find { |file| File.basename(file) =~ regexp }
                   else
                     sip.files.find { |file| File.basename(file) == filename }
                   end
            raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(filename) unless file
            YAML.load_file file
          end
          file.rewind if file
          @yaml
        end
      end
    end
  end
end
