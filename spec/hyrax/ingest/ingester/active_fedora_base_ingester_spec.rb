require 'hyrax_helper'
require 'hyrax/ingest/ingester/active_fedora_base_ingester'
require 'hyrax/ingest/sip'

RSpec.describe Hyrax::Ingest::Ingester::ActiveFedoraBaseIngester do

  let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
  let(:af_model_class_name) { 'TestActiveFedoraModel' }
  let(:properties_config) do
    {
      rdf_predicate: "http://example.org#test_property",
      from: {
        xml_file: {
          filename: "metadata.xml",
          xpath: "/path/to/title_1"
        }
      }
    }
  end

  subject { described_class.new(example_sip, af_model_class_name: af_model_class_name, properties_config: properties_config) }

  before do
    class TestActiveFedoraModel < ActiveFedora::Base; end
  end

  describe '#af_model' do
    it 'returns a new instance of the specified ActiveFedora model' do
      expect(subject.send(:af_model)).to be_a TestActiveFedoraModel
    end
  end

  describe '#run!' do
    let(:fake_property_assigners) do
      [instance_double(Hyrax::Ingest::Ingester::ActiveFedoraPropertyAssigner), instance_double(Hyrax::Ingest::Ingester::ActiveFedoraPropertyAssigner)]
    end

    before do
      fake_property_assigners.each do |fake_property_assigner|
        allow(fake_property_assigner).to receive(:assign!)
      end
      allow(subject).to receive(:property_assigners).and_return(fake_property_assigners)
    end

    it 'calls #assign! for all PropertyAssigner objects returned by #property_assigners' do
      fake_property_assigners.each do |fake_property_assigner|
        expect(fake_property_assigner).to receive(:assign!)
      end
      subject.run!
    end

    it 'returns the ingested objects' do
      expect(subject.run!).to be_an_instance_of(TestActiveFedoraModel)
    end
  end

  after do
    Object.send(:remove_const, :TestActiveFedoraModel)
  end
end
