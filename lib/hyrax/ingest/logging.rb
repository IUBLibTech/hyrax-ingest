require 'logger'
require 'singleton'

module Hyrax
  module Ingest
    module Logging
      def logger
        @logger ||= Hyrax::Ingest::SharedLogger.instance
      end

      def self.config
        @config ||= {
          write_to: STDOUT
        }
      end
    end

    class SharedLogger < Logger
      include Singleton

      def initialize
        super(Logging.config[:write_to])
        # Simplify the formatter to just put the message.
        self.formatter = -> severity,datetime,progname,msg { "\n#{msg}" }
      end
    end
  end
end
