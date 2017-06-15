require 'hyrax/ingest/mapping'
require 'hyrax/ingest/fetcher/xml_file'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module Fetcher
      class << self
        # @return Set The set of all fetcher classes.
        def all_classes
          @all_classes ||= Set.new.tap do |all_classes|
            all_classes << Hyrax::Ingest::Fetcher::XMLFile
          end
        end

        # @param [String] class_name The stringified name of the class
        #   constant.
        # @param [Hash] options The hash that will get passed to the
        #   constructor of the fetcher class.
        # @return An instance of the fetcher class.
        def factory(class_name, options={})
          find_class_by_name(class_name).new(**options)
        end

        # @param [String] class_name The stringified class name, with our
        #   without namespaces.
        # @raise [Hyrax::Ingest::Errors::UnknownFetcherClass] When there is no
        #   corresponding fetcher class for the given value of the `class_name`
        #   param.
        # @raise [Hyrax::Ingest::Errors::UnknownfetcherClass] When the value of
        #   `class_name` param is insufficient in determining a fetcher class.
        # @return [Class] The appropriate fetcher class.
        def find_class_by_name(class_name)
          found_classes = all_classes.select do |class_const|
            (class_const.to_s == class_name) || (class_const.to_s =~ /::#{class_name}/)
          end
          raise Hyrax::Ingest::Errors::UnknownFetcherClass.new(class_name, all_classes) if found_classes.count == 0
          raise Hyrax::Ingest::Errors::AmbiguousFetcherClass.new(class_name, found_classes) if found_classes.count > 1
          found_classes.first
        end
      end
    end
  end
end