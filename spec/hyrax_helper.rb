# NOTE: This is needed here as well as in spec_helper.rb
ENV['environment'] = ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../../.internal_test_app/config/environment', __FILE__)

require 'spec_helper'
require 'rails'

require "hyrax/ingest"

require 'engine_cart'
EngineCart.load_application!


RSpec.configure do |config|
  config.before(:each) do
    require 'active_fedora/cleaner'
    ActiveFedora::Cleaner.clean! if ActiveFedora::Base.count > 0
  end

  config.after(:suite) do
    File.delete(Hyrax::Ingest::Reporting.config[:filename]) if File.exist? Hyrax::Ingest::Reporting.config[:filename]
  end
end