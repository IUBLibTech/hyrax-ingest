require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/errors'
require 'hyrax/ingest/reporting'
require 'active_fedora'

module Hyrax
  module Ingest
    module Ingester
      class ActiveFedoraPropertyAssigner
        include Reporting

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
          fetched_value = fetcher.fetch
          fetched_value = transformer.transform(fetched_value) if transformer
          report.value_assigned_to_property(fetched_value, property_name, rdf_predicate)
          af_model.set_value(property_name, fetched_value)
        end

        private
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
