require 'erb'
require 'functional_hash'
require 'hyrax/ingest/reporting/configuration'

module Hyrax
  module Ingest
    module Reporting
      class Report
        attr_reader :stat

        def initialize
          @stat = default_stat
        end

        def default_stat
          # Initialize a FunctionalHash to serve as a stat tracker, and
          # add some default values in the same way you would a Hash.
          @stat = FunctionalHash.new.tap do |stat|
            # Stores an array of all SIP paths.
            stat[:sip_paths] = []

            # Stores a list of all files from SIPs that are part of the ingest.
            stat[:files] = []

            # Stores a hash where keys are Fetcher classes, and values are
            # the number of occurrences of missing rquired values.
            stat[:missing_required_values] = {}

            stat[:total_missing_required_values] = Proc.new do |s|
              stat[:missing_required_values].reduce(0) do |total, key_and_value|
                # When reducing a Hash, the 2nd arg to the block is a
                # 2-element array, where the 1st element is the key, and the
                # 2nd element is the value the key points to.
                occurrences = key_and_value.last
                total + occurrences.count
              end
            end

            # Filters the :missing_required_values hash to those for XML files.
            # stat[:xml_files_missing_required_values] = Proc.new do |s|
            #   s[:missing_required_values].select { |fetcher_class, params| fetcher_class.to_s =~ /XMLFile$/ }
            # end

            # Define a functional hash value that returns the count of the given key.
            stat[:count] = Proc.new do |s, key_to_count|
              s[key_to_count].respond_to?(:count) ? s[key_to_count].count : 0
            end

            stat[:models_saved] = []
            stat[:models_failed] = []
          end
        end

        def render(template_path: nil)
          template_path ||= Reporting.config.default_template_path
          template_content = File.read(File.expand_path(template_path))
          ERB.new(template_content).result(binding)
        end

        def write_to_file(filename: nil, template_path: nil)
          filename ||= Reporting.config.default_output_file
          File.write(filename, render(template_path: template_path))
        end

        def failed_with(error)
          errors << error
        end

        def errors
          @errors ||= []
        end

        def failed?
          !errors.empty?
        end
      end
    end
  end
end
