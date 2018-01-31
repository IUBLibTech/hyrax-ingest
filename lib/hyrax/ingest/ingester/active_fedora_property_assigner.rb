require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/errors'
require 'active_fedora'
require 'hyrax/ingest/has_report'
require 'hyrax/ingest/has_logger'

module Hyrax
  module Ingest
    module Ingester
      class ActiveFedoraPropertyAssigner
        include Interloper
        include HasReport
        include HasLogger

        after(:assign!) do
          logger.info "#{@fetched_and_transformed_value} assigned to property '#{property_name}' with rdf predicate '#{rdf_predicate}'"
        end

        attr_reader :rdf_predicate, :af_model, :fetcher, :transformer

        def initialize(options={})
          @rdf_predicate = options[:rdf_predicate]
          @fetcher = options[:fetcher]
          @af_model = options[:af_model]
          @transformer = options[:transformer]
          raise Hyrax::Ingest::Errors::UnknownActiveFedoraModel.new(@af_model.class) unless @af_model.is_a? ActiveFedora::Base
          raise Hyrax::Ingest::Errors::InvalidFetcher.new(@fetcher.class) unless @fetcher.is_a? Hyrax::Ingest::Fetcher::Base
        end

        def assign!
          af_model.set_value(property_name, fetched_and_transformed_value)
        rescue ::ActiveTriples::Relation::ValueError => e
          # Rethrow ActiveTriples::Relation::ValueError as something more specific to ingest.
          raise Hyrax::Ingest::Errors::InvalidActiveFedoraPropertyValue.new(fetched_value, property_name, rdf_predicate)
        end

        private

          def fetched_and_transformed_value
            @fetched_and_transformed_value ||= if transformer
              transformer.transform(fetched_value)
            else
              fetched_value
            end
          end

          def fetched_value
            @fetched_value ||= fetcher.fetch
          end

          # Performs a lookup of property name by RDF predicate.
          # @return [Symbol] The symbol representing the accessor for the
          #   property that matches the RDF predicate stored in the
          #   @rdf_predicate attribtue.
          def property_name
            @property ||= begin
              property = af_model.send(:properties).select do |_att, config|
                config.predicate == rdf_predicate
              end
              raise Hyrax::Ingest::Errors::UnknownRdfPredicate.new(rdf_predicate, af_model.class) if property.keys.count == 0
              property.keys.first.to_sym
            end
          end
      end
    end
  end
end
