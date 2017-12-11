require 'hyrax/ingest/reporting'
require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_shared_sip'
require 'hyrax/ingest/has_iteration'

module Hyrax
  module Ingest
    module Ingester
      class Base
        include Reporting
        include HasSIP
        include HasSharedSIP
        include HasIteration

        # no-op, meant to be overrriden
        def run!; end
      end
    end
  end
end
