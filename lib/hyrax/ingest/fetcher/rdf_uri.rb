require 'rdf'

module Hyrax
  module Ingest
    module Fetcher
      class RdfUri < Base
        attr_reader :uri_str

        def initialize(sip, shared_sip, uri_str='')
          raise ArgumentError, "RdfUri cannot have a shared sip." unless shared_sip.nil?
          @uri_str = uri_str
          super(sip, shared_sip)
        end

        def fetch
          ::RDF::URI.new(uri_str)
        end
      end
    end
  end
end
