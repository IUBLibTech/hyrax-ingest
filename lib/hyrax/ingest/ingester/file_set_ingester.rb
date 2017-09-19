require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/ingester/active_fedora_file_ingester'

module Hyrax
  module Ingest
    module Ingester
      class FileSetIngester < ActiveFedoraBaseIngester
        attr_reader :files_config, :preservation_events_config

        def initialize(sip, config={})
          @files_config = config.delete(:Files) || []
          @preservation_events_config = config.delete(:PreservationEvents) || []
          config[:af_model_class_name] ||= 'FileSet'
          super(sip, config)
        end

        def run!
          assign_properties!
          af_model.save!
          ingest_preservation_events!
          add_files_to_file_set!
        end

        private

          def add_files_to_file_set!
            file_ingesters.each do |file_ingester|
              if (file_ingester.external_url)
                Hydra::Works::AddExternalFileToFileSet.call(af_model, file_ingester.external_url, file_ingester.type)
              else
                Hydra::Works::AddFileToFileSet.call(af_model, file_ingester.content, file_ingester.type)
              end
            end
          end

          def file_ingesters
            @file_ingesters ||= files_config.map do |file_config|
              Hyrax::Ingest::Ingester::ActiveFedoraFileIngester.new(file_config)
            end
          end

          def ingest_preservation_events!
            preservation_event_ingesters.each do |preservation_event_ingester|
              preservation_event_ingester.run!
            end
          end

          def preservation_event_ingesters
            preservation_event_ingesters ||= preservation_events_config.map do |preservation_event_config|
              preservation_event_config[:premis_event_related_object] = af_model
              Hyrax::Ingest::Ingester::PreservationEventIngester.new(sip, preservation_event_config)
            end
          end
      end
    end
  end
end