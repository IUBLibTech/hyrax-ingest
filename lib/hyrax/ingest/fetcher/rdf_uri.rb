require 'rdf'

module Hyrax
  module Ingest
    module Fetcher
      class RdfUri < Base
        attr_reader :uri_str

        def initialize(sip, uri_str='')
          @uri_str = uri_str
          super(sip)
        end

        def fetch
          ::RDF::URI.new(uri_str)
        end
      end
    end
  end
end
