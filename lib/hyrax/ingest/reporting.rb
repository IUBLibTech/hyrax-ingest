require 'hyrax/ingest/reporting/configuration'

module Hyrax
  module Ingest
    module Reporting
      class << self
        def config
          @config ||= Hyrax::Ingest::Reporting::Configuration.new
        end
      end
    end
  end
end
