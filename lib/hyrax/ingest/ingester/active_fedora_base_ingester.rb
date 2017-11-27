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

        attr_reader :af_model_class_name, :properties_config, :update_params

        def initialize(sip, config={})
          raise ArgumentError, "Option :af_model_class_name is required" unless config.key?(:af_model_class_name)
          @af_model_class_name = config.delete(:af_model_class_name).to_s
          @properties_config = config.delete(:properties) || []
          @update_params = config.delete(:update)
          super(sip)
        end

        def run!
          report.model_ingest_started(af_model_class_name)
          assign_properties!
          save_model!
          report.model_ingest_complete(af_model_class_name)
          # return the new instance of the ActiveFedora model
          af_model
        end

        def af_model
          @af_model ||= new_or_existing_af_model
        end

        protected

          def save_model!(continue_if_invalid: true)
            af_model.instance_eval { save! }
            af_model.save!
            af_model
          rescue ActiveFedora::RecordInvalid => e
            report.model_ingest_failed_validation(af_model_class_name, e.message)
            raise e unless continue_if_invalid
            false
          end

          def assign_properties!
            property_assigners.each do |property_assigner|
              property_assigner.assign!
            end
          end

        private

          def af_model_class
            Object.const_get(af_model_class_name.to_s)
          rescue NameError => e
            raise Hyrax::Ingest::Errors::UnknownActiveFedoraModel.new(af_model_class_name)
          end

          def new_or_existing_af_model
            if where_clause
              af_model_class.where(where_clause).first
            else
              af_model_class.new
            end
          end

          def where_clause
            return unless update_params
            {}.tap do |where_clause|
              update_params.each do |field, from_params|
                where_clause[field] = begin
                  fetcher_class_name = from_params[:from].keys.first
                  fetcher_options = from_params[:from].values.first
                  fetcher = Hyrax::Ingest::Fetcher.factory(fetcher_class_name, sip, fetcher_options)
                  value = fetcher.fetch
                  # Cast to string unless value is an array
                  value = value.to_s unless value.respond_to? :each
                  value
                end
              end
            end
          end

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
