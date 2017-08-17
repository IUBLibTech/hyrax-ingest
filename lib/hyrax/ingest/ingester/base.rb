module Hyrax
  module Ingest
    module Ingester
      class Base
        attr_reader :sip
        def initialize(sip)
          @sip = sip
        end

        def run!
          # no-op, meant to be overrriden
        end
      end
    end
  end
end