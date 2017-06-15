require 'spec_helper'
require 'hyrax/ingest/map_operation'
require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/assigner/base'

RSpec.describe Hyrax::Ingest::MapOperation do
  describe '#map!' do
    let(:fetcher) { Hyrax::Ingest::Assigner::Base.new }
    let(:assigner) { Hyrax::Ingest::Assigner::Base.new }
    subject { described_class.new(assigner: assigner, fetcher: fetcher) }

    it 'calls #assign on the assigner class with the results of calling #fetch on the fetcher class' do
      allow(fetcher).to receive(:fetch).with(no_args).and_return("foo")
      expect(fetcher).to receive(:fetch).with(no_args).exactly(1).times
      expect(assigner).to receive(:assign).with("foo").exactly(1).times
      subject.map!
    end
  end
end