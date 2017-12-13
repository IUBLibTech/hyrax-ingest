require 'hyrax_helper'
require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/reporting'

RSpec.describe Hyrax::Ingest::Fetcher::Base do
  subject { described_class.new }
  it 'responds to #fetch' do
    expect(subject).to respond_to :fetch
  end
end
