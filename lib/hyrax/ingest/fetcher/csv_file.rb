require 'hyrax/ingest/fetcher/base'
require 'roo'

module Hyrax
  module Ingest
    module Fetcher
      class CSVFile < Base
        attr_reader :filename, :column

        def initialize(sip, shared_sip, options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :column is missing" unless options.key?(:column)
          raise ArgumentError, "CSVFile cannot have a shared sip." unless shared_sip.nil?
          @filename = options[:filename]
          @column = options[:column].strip.downcase
          super(sip, shared_sip)
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          return_row_value
        end

        private

        # @return Boolean True if the first and last characters of the
        #  @filename attribute are a slash, indicating it should be
        #  interpreted as a regular expression.
        def filename_is_regex?
          filename.to_s[0] == '/' && filename.to_s[-1] == '/'
        end

        # @return
        def csv
          @csv ||= begin
            file = if filename_is_regex?
                     regexp = Regexp.new(filename[1..-2])
                     sip.files.find { |file| File.basename(file) =~ regexp }
                   else
                     sip.files.find { |file| File.basename(file) == filename }
                   end
            raise Hyrax::Ingest::Errors::FileNotFoundInSIP.new(filename) unless file
            file
          end
          file.rewind if file
          @csv
        end

        def roo
          @roo ||= begin
            Roo::CSV.new(csv)
          end
        end

        def return_row_value
          raise Hyrax::Ingest::Errors::MissingCsvColumn.new(column) unless headers.include?(column)
          return roo.row(roo.last_row)[headers.index(column)]
        end

        def headers
          @headers ||= begin
            roo.row(roo.first_row).map(&:downcase)
          end
        end
      end
    end
  end
end
