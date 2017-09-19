# require 'hyrax/ingest/sip'
# require 'hyrax/ingest/mapping'
# require 'active_support/core_ext/hash/keys'
require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/ingester/file_set_ingester'
require 'hyrax/ingest/ingester/work_ingester'
require 'hyrax/ingest/ingester/preservation_event_ingester'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module Ingester
      class << self
        # @return [Set] the set of all Ingester classes available by default.
        def default_registered_classes
          Set.new.tap do |registered_classes|
            registered_classes << Hyrax::Ingest::Ingester::ActiveFedoraBaseIngester
            registered_classes << Hyrax::Ingest::Ingester::FileSetIngester
            registered_classes << Hyrax::Ingest::Ingester::WorkIngester
            registered_classes << Hyrax::Ingest::Ingester::PreservationEventIngester
          end
        end

        # @return [Set] The set of all registered Ingester classes
        def registered_classes
          @registered_classes ||= default_registered_classes
        end

        # @param [Class] klass The Ingester class to add to the set of available
        #   Ingester classes.
        # @raise [Hyrax::Ingest::Errors::InvalidIngesterClass] When the
        #   parameter given does not inherit from the base Ingester class.
        # @return [Set] The set of available ingester classes, with the new
        #   one added.
        def register_class(klass)
          raise Hyrax::Ingest::Errors::InvalidIngesterClass.new(klass) unless klass.ancestors.include?(Hyrax::Ingest::Ingester::Base)
          registered_classes.add(klass)
        end

        # @param [Class] klass The Ingester class to add to the set of available
        #   Ingester classes.
        # @return [Set] The set of available ingester classes, with the specified
        #   class removed.
        def unregister_class(klass)
          registered_classes.delete(klass)
        end

        # @param [String] ingester_name The stringified name of the class
        #   constant. The string "Ingester" will be appended if it's not already on there.
        # @param [Hash] options The hash that will get passed to the
        #   constructor of the Ingester class.
        # @return An instance of the Ingester class.
        def factory(ingester_name, sip, options={})
          find_class_by_name(ingester_name).new(sip, options)
        end

        private
          # @param [String] class_name The stringified class name, with or
          #   without namespaces.
          # @raise [Hyrax::Ingest::Errors::UnknownIngesterClass] When there is no
          #   corresponding Ingester class for the given value of the `class_name`
          #   param.
          # @raise [Hyrax::Ingest::Errors::AmbiguousIngesterClass] When the value of
          #   `class_name` param is insufficient in determining a Ingester class.
          # @return [Class] The appropriate Ingester class.
          def find_class_by_name(class_name)
            class_name.to_s.sub!(/(Ingester)?$/, 'Ingester')
            found_classes = registered_classes.select do |class_const|
              (class_const.to_s == class_name) || (class_const.to_s =~ /::#{class_name}/)
            end
            raise Hyrax::Ingest::Errors::UnknownIngesterClass.new(class_name, registered_classes) if found_classes.count == 0
            raise Hyrax::Ingest::Errors::AmbiguousIngesterClass.new(class_name, found_classes) if found_classes.count > 1
            found_classes.first
          end
      end
    end
  end
end
