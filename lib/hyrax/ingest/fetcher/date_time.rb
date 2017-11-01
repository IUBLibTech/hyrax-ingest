require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'
require 'date'

module Hyrax
  module Ingest
    module Fetcher
      class DateTime < Base
        attr_reader :date_time_method

        def initialize(options={})
          options = { date_time_method: options } unless options.is_a? Hash
          @date_time_method = options.delete[:date_time_method].to_sym
          super
        end

        def fetch
          @fetched_value ||= ::DateTime.send(date_time_method)
        rescue NoMethodError => e
          raise Hyrax::Ingest::Errors::InvalidFetchOption.new(date_time_method)
        end
      end
    end
  end
end
