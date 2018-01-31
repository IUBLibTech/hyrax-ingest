require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/ingester/file_set_ingester'

module Hyrax
  module Ingest
    module Ingester
      class WorkIngester < ActiveFedoraBaseIngester
        attr_reader :file_sets_config

        def initialize(config={})
          # TODO: Throw a useful custom error when :type option is missing.
          config[:af_model_class_name] ||= config.delete(:type)
          @file_sets_config = config.delete(:FileSets) || []
          super(config)
        end

        def run!
          assign_properties!
          assign_related_file_set_properties!
          apply_depositor_metadata!
          save_model!
          assign_file_sets_to_work!
          # return the new instance of the ActiveFedora model
          af_model
        end

        private

          def apply_depositor_metadata!
            af_model.apply_depositor_metadata(depositor) if depositor
          end

          def assign_related_file_set_properties!
            file_set_ingesters.each { |file_set_ingester| file_set_ingester.assign_properties! }
          end

          def assign_file_sets_to_work!
            file_set_ingesters.each do |file_set_ingester|
              af_model.members += [file_set_ingester.af_model]
            end
          end

          def file_set_ingesters
            @file_set_ingesters ||= @file_sets_config.map do |file_set_config|
              Hyrax::Ingest::Ingester::FileSetIngester.new(file_set_config).tap do |file_set_ingester|
                file_set_ingester.sip = sip if file_set_ingester.respond_to?(:sip=)
                file_set_ingester.shared_sip = shared_sip if file_set_ingester.respond_to?(:shared_sip=)
                file_set_ingester.iteration = iteration if file_set_ingester.respond_to?(:iteration=)
              end
            end
          end
      end
    end
  end
end
