require 'hyrax/ingest/reporting'

module Hyrax
  module Ingest
    module Ingester
      class Base
        include Reporting

        attr_reader :sip
        def initialize(sip)
          raise Hyrax::Ingest::Errors::InvalidSIP.new(sip) unless sip.is_a? Hyrax::Ingest::SIP
          @sip = sip
        end

        # no-op, meant to be overrriden
        def run!; end
      end
    end
  end
end
