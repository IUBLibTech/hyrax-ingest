module Hyrax
  module Ingest
    class MapOperation
      attr_reader :fetcher, :assigner

      def initialize(fetcher:, assigner:)
        @fetcher = fetcher
        @assigner = assigner
      end

      def map!
        assigner.assign(fetcher.fetch)
      end
    end
  end
end
