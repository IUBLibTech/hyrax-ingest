require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Base
        attr_writer :sip

        # No-op. Intended to be overridden.
        def initialize(options={}); end

        # No-op method intended to be overwritten in subclasses.
        # @return nil
        def fetch; end

        def sip
          raise Hyrax::Ingest::Errors::NoSIPSpecified.new(self) if @sip.nil?
          raise Hyrax::Ingest::Errors::InvalidSIP.new(self, @sip) unless @sip.is_a? Hyrax::Ingest::SIP
          @sip
        end
      end
    end
  end
end
