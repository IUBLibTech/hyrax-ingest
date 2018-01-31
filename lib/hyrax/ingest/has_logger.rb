require 'logger'

module Hyrax
  module Ingest
    module HasLogger
      def logger
        @logger ||= Logger.new(HasLogger.config.default_log_to)
      end

      def logger=(logger)
        raise Hyrax::Ingest::Errors::InvalidLogger unless logger.is_a? Logger
        @logger = logger
      end

      class << self
        def config
          @config ||= Configuration.new
        end
      end

      class Configuration
        attr_accessor :default_log_to
        def initialize
          @default_log_to = STDOUT
        end
      end
    end
  end
end
