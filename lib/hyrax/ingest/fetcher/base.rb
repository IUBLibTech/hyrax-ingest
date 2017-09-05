require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Base
        attr_reader :sip

        def initialize(sip)
          raise Hyrax::Ingest::Errors::InvalidSIP.new(sip) unless sip.is_a? Hyrax::Ingest::SIP
          @sip = sip
        end

        # No-op method intended to be overwritten in subclasses.
        # @return nil
        def fetch; end
      end
    end
  end
end
