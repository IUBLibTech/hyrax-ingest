require 'hyrax/ingest/errors'
require 'hyrax/ingest/sip'
require 'date'

module Hyrax
  module Ingest
    module Fetcher
      class DateTime < Base
        attr_reader :date_time_method

        def initialize(sip, shared_sip, date_time_method='')
          raise ArgumentError, "DateTime cannot have a shared sip." unless shared_sip.nil?
          @date_time_method = date_time_method.to_sym
          super(sip, shared_sip)
        end

        def fetch
          ::DateTime.send(date_time_method)
        rescue NoMethodError => e
          raise Hyrax::Ingest::Errors::InvalidFetchOption.new(date_time_method)
        end
      end
    end
  end
end
