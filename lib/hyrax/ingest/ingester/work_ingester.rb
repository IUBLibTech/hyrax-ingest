require 'hyrax/ingest/ingester/active_fedora_base_ingester'

module Hyrax
  module Ingest
    module Ingester
      class WorkIngester < ActiveFedoraBaseIngester
        attr_reader :file_sets_config

        def initialize(sip, config={})
          # TODO: Throw a useful custom error when :type option is missing.
          config[:af_model_class_name] ||= config.delete(:type)
          @file_sets_config = config.delete(:FileSets) || []
          super(sip, config)
        end

        def run!
          assign_properties!
          file_set_ingesters.each { |file_set_ingester| file_set_ingester.assign_properties! }
          af_model.save!
          assign_file_sets_to_work!
        end

        private

          def assign_file_sets_to_work!
            file_set_ingesters.each do |file_set_ingester|
              af_model.members += [file_set_ingester.af_model]
            end
          end

          def file_set_ingesters
            @file_set_ingesters ||= @file_sets_config.map do |file_set_config|
              Hyrax::Ingest::Ingester::FileSetIngester.new(sip, file_set_config)
            end
          end
      end
    end
  end
end
