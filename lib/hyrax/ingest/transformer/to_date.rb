require 'hyrax/ingest/transformer/base'

module Hyrax
  module Ingest
    module Transformer
      class ToDate < Base
        attr_reader :orig_format

        def initialize(orig_format)
          @orig_format = orig_format.to_sym
        end

        def transform(value)
          return transform_multiple(value) if value.respond_to?(:each)
          case orig_format
          when :from_timestamp_with_ms
            DateTime.strptime(value, '%Q')
          when :"from_yyyy-mm-dd"
            DateTime.parse(value)
          else
            raise Hyrax::Ingest::Errors::UnrecognizedTransformOption.new(orig_format)
          end
        end

        private

          def transform_multiple(values)
            values.map { |value| transform(value) }
          end
      end
    end
  end
end
