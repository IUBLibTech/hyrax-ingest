require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Literal < Base
        attr_reader :literal_value

        inherit_callbacks_for :fetch

        def initialize(options={})
          options = { value: options } unless options.is_a? Hash
          @literal_value = options.delete(:value)
          super
        end

        def fetch
          @fetched_value = literal_value
        end
      end
    end
  end
end
