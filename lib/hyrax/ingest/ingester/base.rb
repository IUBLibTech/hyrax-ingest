require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_shared_sip'
require 'hyrax/ingest/has_iteration'
require 'hyrax/ingest/has_logger'
require 'hyrax/ingest/has_report'
require 'hyrax/ingest/has_depositor'

module Hyrax
  module Ingest
    module Ingester
      class Base
        include HasSIP
        include HasSharedSIP
        include HasIteration
        include HasReport
        include HasLogger
        include HasDepositor

        def initialize(config={})
          self.depositor = config.delete(:depositor)
        end

        # no-op, meant to be overrriden
        def run!; end
      end
    end
  end
end
