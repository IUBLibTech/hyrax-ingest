require 'spec_helper'
require 'hyrax/ingest/assigner/base'

RSpec.describe Hyrax::Ingest::Assigner::Base do
  subject { described_class.new }
  it 'responds to #assign' do
    expect(subject).to respond_to :assign
  end

  it 'responds to #save!' do
    expect(subject).to respond_to :save!
  end
end
