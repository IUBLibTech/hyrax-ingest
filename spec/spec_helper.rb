ENV['environment'] = ENV['RAILS_ENV'] ||= 'test'

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require_relative './support/fixture_helpers'

RSpec.configure do |config|
  config.include FixtureHelpers
end
