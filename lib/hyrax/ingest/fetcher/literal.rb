require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Literal < Base
        attr_reader :literal_value

        def initialize(sip, literal_value='')
          @literal_value = literal_value
          super(sip)
        end

        def fetch
          literal_value
        end
      end
    end
  end
end
