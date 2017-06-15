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
        def initialize(fetcher_obj)
          super("No SIP was specified. Set the sip with #{fetcher_obj.class}#sip=")
        end
      end

      class InvalidSIP < Hyrax::Ingest::Error
        def initialize(fetcher_obj, invalid_sip_obj)
          super("Invalid SIP object. SIP must be an instance of Hyrax::Ingest::SIP (or an instance of a subclass) but an instance of #{invalid_sip_obj.class} was found. Set a valid SIP object with #{fetcher_obj.class}#sip=")
        end
      end

      class UnknownActiveFedoraModel < Hyrax::Ingest::Error
        def initialize(af_model_class)
          super("Unknown ActiveFedora model type #{af_model_class}")
        end
      end

      class FileNotFoundInSIP < Hyrax::Ingest::Error
        def initialize(string_or_regexp)
          super("No file matching #{string_or_regexp.inspect.to_s} was found in the SIP")
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
          super("Fetcher class '#{class_name}' not found. Available fetcher classes are: #{Array(available_classes).join(', ')}")
        end
      end

      class AmbiguousFetcherClass < Hyrax::Ingest::Error
        def initialize(class_name, matching_classes)
          super("Fetcher class name '#{class_name}' is ambiguous; could mean any one of the following classes: #{Array(matching_classes).join(',')}. Please use namespaces in the class name to be more specific.")
        end
      end

      class AmbiguousFetchOptions < Hyrax::Ingest::Error
        def initialize(ambiguous_options)
          super("Could not determine which fetcher class to use given the following options: #{Array(ambiguous_options).join(', ')}")
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

      class AmbiguousAssignmentOptions < Hyrax::Ingest::Error
        def initialize(ambiguous_options)
          super("Could not determine which assigner class to use given the following options: #{Array(ambiguous_options).join(', ')}")
        end
      end

      class MissingRequiredAssignmentOptions < Hyrax::Ingest::Error
        def initialize(missing_options)
          super("Missing required assignment options: #{Array(missing_options).join(', ')}")
        end
      end

      class InvalidAssignmentOptions < Hyrax::Ingest::Error
        def initialize(invalid_options)
          super("Invalid assignment options: #{Array(invalid_options).join(', ')}")
        end
      end
    end
  end
end
