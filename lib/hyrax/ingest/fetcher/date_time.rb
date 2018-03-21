require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'
require 'date'

module Hyrax
  module Ingest
    module Fetcher
      class DateTime < Base
        def fetch
          @fetched_value ||= ::DateTime.now
        end
      end
    end
  end
end
