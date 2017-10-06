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
          case orig_format
          when :from_timestamp_with_ms
            DateTime.strptime(value, '%Q')
          else
            raise Hyrax::Ingest::Errors::UnrecognizedTransformOption.new(orig_format)
          end
        end
      end
    end
  end
end
