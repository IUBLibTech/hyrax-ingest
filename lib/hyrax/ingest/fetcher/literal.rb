require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Literal < Base
        attr_reader :literal_value

        def initialize(sip, shared_sip, literal_value='')
          raise ArgumentError, "Literal cannot have a shared sip." unless shared_sip.nil?
          @literal_value = literal_value
          super(sip, shared_sip)
        end

        def fetch
          literal_value
        end
      end
    end
  end
end
