require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module Reporting
      class Configuration
        attr_reader :default_template_path
        attr_accessor :default_output_file

        def initialize
          @default_template_path = File.expand_path('../views/hyrax_ingest_report.html.erb', __FILE__)
          @default_output_file = File.expand_path('hyrax_ingest_report.html')
        end

        def default_template_path=(path)
          raise Hyrax::Ingest::Errors::ConfigurationError, "\"#{path}\" does not exist" unless File.exist? path
          @default_template_path = path
        end
      end
    end
  end
end
