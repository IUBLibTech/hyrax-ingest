module Hyrax
  module Ingest
    module Ingester
      class Base
        attr_reader :sip
        def initialize(sip)
          raise Hyrax::Ingest::Errors::InvalidSIP.new(sip) unless sip.is_a? Hyrax::Ingest::SIP
          @sip = sip
        end

        def run!
          # no-op, meant to be overrriden
        end
      end
    end
  end
end