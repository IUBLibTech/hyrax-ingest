require 'hyrax_helper'
require 'hyrax/ingest/ingester/work_ingester'

RSpec.describe Hyrax::Ingest::Ingester::WorkIngester do
  before do
    class ExampleWork < ActiveFedora::Base
      include ::Hyrax::WorkBehavior
    end
  end

  describe '#run!' do
    let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
    let(:example_config) {
      {
        type: 'ExampleWork',
        properties: [
          {
            rdf_predicate: "http://purl.org/dc/terms/title",
            from: { Literal: 'ExampleWork Title' }
          }
        ],
        FileSets: [
          { properties: [
            { rdf_predicate: "http://purl.org/dc/terms/title",
              from: { Literal: 'FileSet Title' } }
          ] }
        ]
      }
    }

    subject { described_class.new(example_sip, example_config) }

    it 'calls assign_properties!' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject.af_model).to receive(:save!).ordered.exactly(1).times
      expect(subject).to receive(:assign_file_sets_to_work!).ordered.exactly(1).times

      subject.run!
    end

    it 'returns the ingested object' do
      expect(subject.run!).to be_an_instance_of(ExampleWork)
    end
  end
end
