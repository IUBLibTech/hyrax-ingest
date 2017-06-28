require 'hyrax/ingest/engine'

# TODO: require pry for testing only.
require 'pry'
require 'hyrax'

module Hyrax
  module Ingest
    class << self
      def root
        File.expand_path('../../../', __FILE__)
      end
    end
  end
end
