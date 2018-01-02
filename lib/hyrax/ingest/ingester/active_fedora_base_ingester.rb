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

        attr_reader :af_model_class_name, :properties_config, :update_params, :shared_sip

        def initialize(config={})
          raise ArgumentError, "Option :af_model_class_name is required" unless config.key?(:af_model_class_name)
          @af_model_class_name = config.delete(:af_model_class_name).to_s
          @properties_config = config.delete(:properties) || []
          @update_params = config.delete(:update)
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
              af_model_class.where(where_clause).first.tap do |found_record|
                raise Hyrax::Ingest::Errors::RecordNotFound.new(af_model_class, where_clause) unless found_record
              end
            else
              af_model_class.new
            end
          end

          def where_clause
            return unless update_params
            {}.tap do |where_clause|
              update_params.each do |field, from_params|
                where_clause[field] = begin
                  value = create_fetcher_from_config(from_params[:from]).fetch
                  # Cast to string unless value is an array
                  value = value.to_s unless value.respond_to? :each
                  value
                end
              end
            end
          end

          def property_assigners
            @property_assigners ||= properties_config.map do |property_config|
              property_assigner_options = {
                rdf_predicate: property_config[:rdf_predicate],
                fetcher: create_fetcher_from_config(property_config[:from]),
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

          def create_fetcher_from_config(fetcher_config)
            fetcher_class_name = fetcher_config.keys.first
            fetcher_class_options = fetcher_config.values.first
            Hyrax::Ingest::Fetcher.factory(fetcher_class_name, fetcher_class_options).tap do |fetcher|
              if fetcher.respond_to?(:sip=)
                fetcher.sip = if use_shared_sip?(fetcher_config[fetcher_class_name])
                  raise Hyrax::Ingest::Errors::NoSharedSIPSpecified unless shared_sip
                  shared_sip
                else
                  sip
                end
              end
              fetcher.iteration = iteration if fetcher.respond_to? :iteration=
            end
          end

          def use_shared_sip?(config)
            truthy_vals = ['1', 'true', 'TRUE', 'True', 'yes', true]
            return truthy_vals.include? config[:shared]
          end
      end
    end
  end
end
