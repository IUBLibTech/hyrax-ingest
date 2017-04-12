require "hyrax/ingest/version"

module Hyrax
  module Ingest
    def self.root
      Pathname.new(File.expand_path('../../../', __FILE__))      
    end
  end
end
