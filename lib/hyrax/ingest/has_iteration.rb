# Simple interface for injecting a Hyrax::Ingest::SIP dependency.

require 'hyrax/ingest/sip'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module HasIteration
      def iteration=(iteration)
        @iteration = iteration.to_i
      end

      def iteration
        @iteration ||= 0
      end
    end
  end
end
