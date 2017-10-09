require 'hyrax/ingest/ingester/base'
require 'active_support/inflector'
require 'active_fedora'
require 'hyrax/ingest/ingester/active_fedora_property_assigner'
require 'hyrax/ingest/fetcher'
require 'hyrax/ingest/transformer'

module Hyrax
  module Ingest
    module Ingester
      class ActiveFedoraBaseIngester < Base

        attr_reader :af_model_class_name, :properties_config

        def initialize(sip, config={})
          raise ArgumentError, "Option :af_model_class_name is required" unless config.key?(:af_model_class_name)
          @af_model_class_name = config.delete(:af_model_class_name).to_s
          @properties_config = config.delete(:properties) || []
          super(sip)
        end

        def run!
          report.model_ingest_started(af_model_class_name)
          assign_properties!
          af_model.save!
          report.model_ingest_complete(af_model_class_name)
        end

        def af_model
          begin
            af_model_class = Object.const_get(af_model_class_name.to_s)
          rescue NameError => e
            raise Hyrax::Ingest::Errors::UnknownActiveFedoraModel.new(af_model_class_name)
          end
          @af_model ||= af_model_class.new
        end

        protected

          def assign_properties!
            property_assigners.each do |property_assigner|
              property_assigner.assign!
            end
          end

        private

          def property_assigners
            @property_assigners ||= properties_config.map do |property_config|
              fetcher_class_name = property_config[:from].keys.first
              fetcher_class_options = property_config[:from].values.first

              property_assigner_options = {
                rdf_predicate: property_config[:rdf_predicate],
                fetcher: Hyrax::Ingest::Fetcher.factory(fetcher_class_name, sip, fetcher_class_options),
                af_model: af_model
              }

              if property_config.key?(:transform)
                transformer_class_name = property_config[:transform].keys.first
                transformer_class_options = property_config[:transform].values.first
                property_assigner_options[:transformer] = Hyrax::Ingest::Transformer.factory(transformer_class_name, transformer_class_options)
              end

              ActiveFedoraPropertyAssigner.new(property_assigner_options)
            end
          end
      end
    end
  end
end
