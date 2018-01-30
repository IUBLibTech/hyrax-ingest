require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_iteration'
require 'roo'

module Hyrax
  module Ingest
    module Fetcher
      class CSVFile < Base
        attr_reader :filename, :column, :row, :header_row_number, :row_offset

        include HasSIP
        include HasIteration

        def initialize(options={})
          raise ArgumentError, "Required option :filename is missing" unless options.key?(:filename)
          raise ArgumentError, "Required option :column is missing" unless options.key?(:column)
          raise ArgumentError, "Required option :row is missing" unless options.key?(:row)

          @filename = options.fetch(:filename)
          @column = options.fetch(:column, '').to_s.strip.downcase
          @row = options.fetch(:row, '').to_s.strip.downcase
          @header_row_number = options.fetch(:header_row_number, 1)
          @row_offset = options[:row_offset]
        end

        def fetch
          # TODO: log a warning in the event of empty results.
          cell_value
        end

        private

          def roo
            @roo ||= Roo::CSV.new(sip.find_file_path(filename))
          end

          def cell_value
            roo.cell(row_number, column_number)
          end

          # @return The column number from which to retrieve the cell.
          def column_number
            @column_number ||= column_number_from_header || specific_column_number
            # TODO: custom error
            raise ArgumentError, "Value for column: option must be a number or a column header; '#{column}' was given." if @column_number.nil?
            @column_number
          end

          def column_number_from_header
            headers.index(column) + 1 if headers.index(column)
          end

          def specific_column_number
            column.to_i if string_is_integer?(column)
          end

          def row_number
            @row_number ||= next_row || specific_row_number
            # TODO: custom error
            raise ArgumentError, "Value for row: option must be a number or the keyword 'next'; #{@row} was given." if @row_number.nil?
            @row_number + row_offset
          end

          def next_row
            iteration + 1 if @row == 'next'
          end

          def specific_row_number
            row.to_i if string_is_integer?(row)
          end

          def row_offset
            @row_offset || header_row_number
          end

          def headers
            @headers ||= roo.row(header_row_number).map(&:to_s).map(&:downcase)
          end

          def string_is_integer?(str)
            str.to_i.to_s == str.to_s
          end
      end
    end
  end
end
