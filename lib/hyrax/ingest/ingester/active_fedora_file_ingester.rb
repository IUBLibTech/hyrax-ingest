module Hyrax
  module Ingest
    module Ingester
      class ActiveFedoraFileIngester

        attr_reader :type, :original_filename, :external_url, :content

        def initialize(type:, original_filename: nil, external_url: nil, content: nil)
          @type = type
          @original_filename = original_filename
          @external_url = external_url
          @content = content
        end
      end
    end
  end
end