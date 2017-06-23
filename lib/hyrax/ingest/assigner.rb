require 'hyrax/ingest/assigner/active_fedora_model'

module Hyrax
  module Ingest
    module Assigner
      class << self

        # @return [Set] The set of all assigner classes.
        def all_classes
          @all_classes ||= Set.new.tap do |all_classes|
            all_classes << Hyrax::Ingest::Assigner::ActiveFedoraModel
          end
        end

        # @param [String] class_name The stringified name of the class
        #   constant.
        # @param [Hash] options The hash that will get passed to the
        #   constructor of the assigner class.
        # @return An instance of the assigner class.
        def factory(class_name, options={})
          find_class_by_name(class_name).new(**options)
        end

        # @param [String] class_name The stringified class name, with our
        #   without namespaces.
        # @raise [Hyrax::Ingest::Errors::UnknownAssignerClass] When there is no
        #   corresponding assigner class for the given value of the `class_name`
        #   param.
        # @raise [Hyrax::Ingest::Errors::UnknownAssignerClass] When the value of
        #   `class_name` param is insufficient in determining a assigner class.
        # @return [Class] The appropriate assigner class.
        def find_class_by_name(class_name)
          found_classes = all_classes.select do |class_const|
            (class_const.to_s == class_name) || (class_const.to_s =~ /::#{class_name}/)
          end
          raise Hyrax::Ingest::Errors::UnknownAssignerClass.new(class_name, all_classes) if found_classes.count == 0
          raise Hyrax::Ingest::Errors::AmbiguousAssignerClass.new(class_name, found_classes) if found_classes.count > 1
          found_classes.first
        end
      end
    end
  end
end