require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/ingester/active_fedora_file_ingester'

module Hyrax
  module Ingest
    module Ingester
      class PreservationEventIngester < ActiveFedoraBaseIngester

        attr_reader :premis_event_related_object

        def initialize(sip, config={})
          config[:af_model_class_name] ||= 'Hyrax::Preservation::Event'
          @premis_event_related_object = config.delete(:premis_event_related_object)
          super(sip, config)
        end

        def run!
          assign_properties!
          af_model.premis_event_related_object = premis_event_related_object
          af_model.save!
        end
      end
    end
  end
end