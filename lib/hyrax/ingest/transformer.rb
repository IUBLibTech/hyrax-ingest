require 'hyrax/ingest/transformer/to_date'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module Transformer
      class << self
        # @return Set The set of all transformer classes.
        def all_classes
          @all_classes ||= Set.new.tap do |all_classes|
            all_classes << Hyrax::Ingest::Transformer::ToDate
          end
        end

        # @param [Hash] options The key is the transformer class name
        #   and the value is the hash of options to pass to the constructor of the transformer
        #   class.
        # @return An instance of the transformer class.
        def factory(class_name, options={})
          find_class_by_name(class_name).new(options)
        end

        # @param [String] class_name The stringified class name, with or
        #   without namespaces.
        # @raise [Hyrax::Ingest::Errors::UnknownTransformerClass] When there is no
        #   corresponding transformer class for the given value of the `class_name`
        #   param.
        # @raise [Hyrax::Ingest::Errors::UnknowntransformerClass] When the value of
        #   `class_name` param is insufficient in determining a transformer class.
        # @return [Class] The appropriate transformer class.
        def find_class_by_name(class_name)
          found_classes = all_classes.select do |class_const|
            (class_const.to_s == class_name) || (class_const.to_s =~ /::#{class_name}/)
          end
          raise Hyrax::Ingest::Errors::UnknownTransformerClass.new(class_name, all_classes) if found_classes.count == 0
          raise Hyrax::Ingest::Errors::AmbiguousTransformerClass.new(class_name, found_classes) if found_classes.count > 1
          found_classes.first
        end
      end
    end
  end
end
