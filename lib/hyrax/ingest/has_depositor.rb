# Simple interface for injecting a Hyrax::Ingest::SIP dependency.
require 'hyrax/ingest/sip'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module HasDepositor
      def HasDepositor.included(mod)
        attr_accessor :depositor
      end
    end
  end
end
