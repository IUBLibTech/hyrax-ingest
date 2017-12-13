# Simple interface for injecting a Hyrax::Ingest::SIP dependency.
require 'hyrax/ingest/sip'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module HasSharedSIP
      def shared_sip=(shared_sip)
        unless shared_sip.nil?
          raise Hyrax::Ingest::Errors::InvalidSIP.new(shared_sip) unless shared_sip.is_a? Hyrax::Ingest::SIP
        end
        @shared_sip = shared_sip
      end

      def shared_sip
        @shared_sip
      end
    end
  end
end
