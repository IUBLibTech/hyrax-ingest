require 'hyrax/ingest/assigner/base'
require 'active_fedora'

module Hyrax
  module Ingest
    module Assigner
      class ActiveFedoraModel < Base
        attr_reader :af_model, :rdf_predicate

        def initialize(type: nil, instance_name: nil, rdf_predicate:)
          @af_model = ActiveFedoraModel.fetch_or_create_instance(type: type, instance_name: instance_name)
          @rdf_predicate = rdf_predicate
        end

        def assign(value)
          # TODO: Account for multi-value vs. single value
          af_model.send(af_model_property_from_rdf_predicates).set(value)
        end

        private

          # Performs a lookup of property name by RDF predicate.
          # @return [Symbol] The symbol representing the accessor for the
          #   property that matches the RDF predicate stored in the
          #   @rdf_predicate attribtue.
          def af_model_property_from_rdf_predicates
            property = af_model.send(:properties).select do |_att, config|
              # TODO: Allow rdf_predicate to be a regex
              config.predicate == rdf_predicate
            end

            # TODO: Handle edge cases where:
            #  1) The rdf_predicate given matches ZERO properties
            #  2) The rdf_predicate given matches MULTIPLE properties.
            property.keys.first.to_sym
          end

        def self.fetch_or_create_instance(type: nil, instance_name: nil)
          key = instance_name || type
          raise Hyrax::Ingest::Errors::MissingRequiredAssignmentOptions.new('type') unless instances[key] || type
          instances[key] ||= type.constantize.new
        end

        # A reader for class instance attribute @instances.
        # @return [Hash] A registry of ActiveFedora model instances.
        def self.instances
          @instances ||= {}
        end
      end
    end
  end
end