require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class Base
        # No-op method intended to be overwritten in subclasses.
        # @return nil
        def fetch; end
      end
    end
  end
end
