require 'rdf'

module Hyrax
  module Ingest
    module Fetcher
      class RdfUri < Base
        attr_reader :uri_str

        def initialize(options={})
          options = { uri_str: options } unless options.is_a? Hash
          @uri_str = options.delete(:uri_str)
          super
        end

        def fetch
          @fetched_value ||= ::RDF::URI.new(uri_str)
        end
      end
    end
  end
end
