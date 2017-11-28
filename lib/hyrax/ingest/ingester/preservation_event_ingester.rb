require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/ingester/active_fedora_file_ingester'

module Hyrax
  module Ingest
    module Ingester
      class PreservationEventIngester < ActiveFedoraBaseIngester

        attr_reader :premis_event_related_object

        def initialize(sip, shared_sip, config={})
          config[:af_model_class_name] ||= 'Hyrax::Preservation::Event'
          @premis_event_related_object = config.delete(:premis_event_related_object)
          super(sip, shared_sip, config)
        end

        def run!
          assign_properties!
          af_model.premis_event_related_object = premis_event_related_object
          save_model!
          # return the new instance of the ActiveFedora model
          af_model
        end
      end
    end
  end
end