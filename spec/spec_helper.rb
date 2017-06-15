$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "hyrax/ingest"
require_relative './support/fixture_helpers'

RSpec.configure do |config|
  config.include FixtureHelpers
end

