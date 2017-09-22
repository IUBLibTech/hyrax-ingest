require 'spec_helper'
require 'hyrax/ingest/ingester/active_fedora_property_assigner'

RSpec.describe Hyrax::Ingest::Ingester::ActiveFedoraPropertyAssigner do
  describe '#assign!' do

    before do
      class TestAfModel < ActiveFedora::Base
        property :foo, predicate: 'http://example.org#foo', multiple: false
        property :bar, predicate: 'http://example.org#bar'
      end
    end

    let(:fake_af_model) { TestAfModel.new }

    context 'when fetcher returns a single value' do
      subject { described_class.new(rdf_predicate: 'http://example.org#foo', fetcher: fake_fetcher, af_model: fake_af_model) }
      let(:fake_fetcher) do
        instance_double(Hyrax::Ingest::Fetcher::Base).tap do |fake_fetcher|
          allow(fake_fetcher).to receive(:is_a?).with(Hyrax::Ingest::Fetcher::Base).and_return(true)
          allow(fake_fetcher).to receive(:fetch).and_return("some single value")
        end
      end

      it 'assigns a single value from a fetcher to the property on the ActiveFedora model' do
        subject.assign!
        expect(fake_af_model.foo).to eq fake_fetcher.fetch
      end
    end

    context 'when the fetcher returns multiple values' do
      subject { described_class.new(rdf_predicate: 'http://example.org#bar', fetcher: fake_fetcher, af_model: fake_af_model) }
      let(:fake_fetcher) do
        instance_double(Hyrax::Ingest::Fetcher::Base).tap do |fake_fetcher|
          allow(fake_fetcher).to receive(:is_a?).with(Hyrax::Ingest::Fetcher::Base).and_return(true)
          allow(fake_fetcher).to receive(:fetch).and_return(["multivalue 1", "multivalue 2"])
        end
      end

      it 'assigns multiple values from a fetcher to the property on the ActiveFedora model' do
        subject.assign!
        expect(fake_af_model.bar).to eq fake_fetcher.fetch
      end
    end
  end
end
