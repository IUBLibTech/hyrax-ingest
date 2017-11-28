require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Base
        attr_reader :sip, :shared_sip

        def initialize(sip, shared_sip)
          raise Hyrax::Ingest::Errors::InvalidSIP.new(sip) unless sip.is_a? Hyrax::Ingest::SIP
          @sip = sip
          @shared_sip = shared_sip
        end

        # No-op method intended to be overwritten in subclasses.
        # @return nil
        def fetch; end
      end
    end
  end
end
