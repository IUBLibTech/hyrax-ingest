# This class adhere's to the Hyrax::Ingest::Fetcher::Base interface to work other classes within the Hyrax::Ingest
# gem. If effectively maps PREMIS Event Type abbreviations to the URI that is then associated with a
# Hyrax::Preservation::Event model.

require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'

module Hyrax
  module Ingest
    module Fetcher
      class PremisEventType < Base
        inherit_callbacks_for :fetch

        attr_reader :abbr

        def initialize(options={})
          options = { abbr: options } unless options.is_a? Hash
          @abbr = options.delete(:abbr)
          super
        end

        def fetch
          @fetched_value ||= Hyrax::Preservation::PremisEventType.find_by_abbr(@abbr).uri
        end
      end
    end
  end
end
