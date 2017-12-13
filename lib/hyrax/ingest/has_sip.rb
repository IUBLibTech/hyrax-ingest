# Simple interface for injecting a Hyrax::Ingest::SIP dependency.

require 'hyrax/ingest/sip'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module HasSIP
      def sip=(sip)
        unless sip.nil?
          raise Hyrax::Ingest::Errors::InvalidSIP.new(sip) unless sip.is_a? Hyrax::Ingest::SIP
        end
        @sip = sip
      end

      # @return [Hyrax::Ingest::SIP] the value of @sip attribute.
      def sip; @sip; end
    end
  end
end
