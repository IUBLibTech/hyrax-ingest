module Hyrax
  module Ingest
    # Base class that allows for rescuing from all Hyrax::Ingest errors.
    # Intentionally no-op.
    class Error < StandardError; end

    module Errors
      class InvalidSIPPath < Hyrax::Ingest::Error
        def initialize(invalid_path)
          super("#{invalid_path} is not a valid SIP path")
        end
      end

      class NoSIPSpecified < Hyrax::Ingest::Error
        def initialize(obj)
          super("No SIP was specified.")
        end
      end

      class NoSharedSIPSpecified < Hyrax::Ingest::Error
        def initialize
          super("No shared SIP was specified.")
        end
      end

      class InvalidSIP < Hyrax::Ingest::Error
        def initialize(invalid_sip_obj)
          super("Invalid SIP object. SIP must be an instance of Hyrax::Ingest::SIP (or an instance of a subclass) but an instance of #{invalid_sip_obj.class} was found.")
        end
      end

      class UnknownActiveFedoraModel < Hyrax::Ingest::Error
        def initialize(af_model_class_name)
          super("Unknown ActiveFedora model type '#{af_model_class_name.to_s}'")
        end
      end

      class FileNotFoundInSIP < Hyrax::Ingest::Error
        def initialize(sip_path, string_or_regexp)
          super("No file matching #{string_or_regexp.inspect.to_s} was found in the SIP at path '#{sip_path}'")
        end
      end

      class UnknownAssignerClass < Hyrax::Ingest::Error
        def initialize(class_name, available_classes)
          super("Assigner class '#{class_name}' not found. Available assigner classes are: #{Array(available_classes).join(', ')}")
        end
      end

      class AmbiguousAssignerClass < Hyrax::Ingest::Error
        def initialize(class_name, matching_classes)
          super("Assigner class name '#{class_name}' is ambiguous; could mean any one of the following classes: #{Array(matching_classes).join(',')}. Please use namespaces in the class name to be more specific.")
        end
      end

      class UnknownFetcherClass < Hyrax::Ingest::Error
        def initialize(class_name, available_classes)
          super("Fetcher class '#{class_name}' not found. Available transformer classes are: #{Array(available_classes).join(', ')}")
        end
      end

      class AmbiguousFetcherClass < Hyrax::Ingest::Error
        def initialize(class_name, matching_classes)
          super("Fetcher class name '#{class_name}' is ambiguous; could mean any one of the following classes: #{Array(matching_classes).join(',')}. Please use namespaces in the class name to be more specific.")
        end
      end

      class InvalidFetcher < Hyrax::Ingest::Error
        def initialize(class_name)
          super("Invalid fetcher '#{class_name}'; Fetcher objects must extend Hyrax::Ingest::Fetcher::Base.")
        end
      end

      class MissingConfigOptions < Hyrax::Ingest::Error
        def initialize(config_options)
          super("Missing config options: '#{config_options.join(', ')}'")
        end
      end

      class UnknownIngesterClass < Hyrax::Ingest::Error
        def initialize(class_name, available_classes)
          super("Ingester class '#{class_name}' not found. Available ingester classes are: #{Array(available_classes).join(', ')}")
        end
      end

      class AmbiguousIngesterClass < Hyrax::Ingest::Error
        def initialize(class_name, matching_classes)
          super("Ingester class name '#{class_name}' is ambiguous; could mean any one of the following classes: #{Array(matching_classes).join(',')}. Please use namespaces in the class name to be more specific.")
        end
      end

      class RecordNotFound < Hyrax::Ingest::Error
        def initialize(model_class_name, where_clause)
          super("Record of type '#{model_class_name}' could not be found where #{where_clause}.")
        end
      end

      class AmbiguousFetchOptions < Hyrax::Ingest::Error
        def initialize(ambiguous_options)
          super("Could not determine which transformer class to use given the following options: #{Array(ambiguous_options).join(', ')}")
        end
      end

      class MissingRequiredFetchOptions < Hyrax::Ingest::Error
        def initialize(missing_options)
          super("Missing required assignment options: #{Array(missing_options).join(', ')}")
        end
      end

      class InvalidFetchOptions < Hyrax::Ingest::Error
        def initialize(invalid_options)
          super("Invalid fetch options: #{Array(invalid_options).join(', ')}")
        end
      end

      class InvalidConfig < Hyrax::Ingest::Error
        def initialize(config_file_path, msg=nil)
          message = ["Invalid configuration in '#{config_file_path}'.", msg.to_s].join("\n")
          super(message)
        end
      end

      class InvalidIngesterClass < Hyrax::Ingest::Error
        def initialize(invalid_class)
          super("Invalid ingester class #{invalid_class} does not extend Hyrax::Ingest::Ingester::Base")
        end
      end

      class UnknownTransformerClass < Hyrax::Ingest::Error
        def initialize(class_name, available_classes)
          super("Transformer class '#{class_name}' not found. Available transformer classes are: #{Array(available_classes).join(', ')}")
        end
      end

      class AmbiguousTransformerClass < Hyrax::Ingest::Error
        def initialize(class_name, matching_classes)
          super("Transformer class name '#{class_name}' is ambiguous; could mean any one of the following classes: #{Array(matching_classes).join(',')}. Please use namespaces in the class name to be more specific.")
        end
      end

      class NoConfigFileFound < Hyrax::Ingest::Error
        def initialize(path)
          super("No ingest config file exists at '#{path}'.")
        end
      end

      class UnknownRdfPredicate < Hyrax::Ingest::Error
        def initialize(unknown_rdf_predicate, af_model_class_name)
          super("Unknown RDF Predicate '#{unknown_rdf_predicate}' for ActiveFedora model '#{af_model_class_name}'")
        end
      end

      class UnrecognizedTransformOption < Hyrax::Ingest::Error
        def initialize(unrecognized_transform_option)
          super("Unknown transform option: '#{unrecognized_transform_option}'")
        end
      end

      class UnableToPrintIngestReport < Hyrax::Ingest::Error
        def initialize(unable_to_read_from_this_thing)
          super("Cannot print ingest report from #{unable_to_read_from_this_thing}. To print a report, it must be written to a file.")
        end
      end

      class InvalidReportConfigOptions < Hyrax::Ingest::Error
        def initialize(invalid_options)
          super("Invalid reporting config options: #{invalid_options.join(', ')}")
        end
      end

      class MissingCsvColumn < Hyrax::Ingest::Error
        def initialize(invalid_column)
          super("Unknown column header for: #{invalid_column}.")
        end
      end

      class ConfigurationError < Hyrax::Ingest::Error; end

      class InvalidActiveFedoraPropertyValue < Hyrax::Ingest::Error
        def initialize(value, property_name, rdf_predicate)
          super("Could not assign '#{value}' to property #{property_name} (with RDF predicate '#{rdf_predicate}')")
        end
      end
    end
  end
end
