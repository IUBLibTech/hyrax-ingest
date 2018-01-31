require 'hyrax_helper'
require 'hyrax/ingest/ingester/work_ingester'

RSpec.describe Hyrax::Ingest::Ingester::WorkIngester do
  before do
    class ExampleWork < ActiveFedora::Base
      include ::Hyrax::WorkBehavior
    end
  end

  describe '#run!' do
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
        ],
        depositor: 'admin@example.org'
      }
    }

    subject { described_class.new(example_config) }

    it 'calls assign_properties!, apply_depositor_metadata!, save_model!, and assign_file_sets_to_work! in that order' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject).to receive(:apply_depositor_metadata!).ordered.exactly(1).times
      expect(subject).to receive(:save_model!).ordered.exactly(1).times
      expect(subject).to receive(:assign_file_sets_to_work!).ordered.exactly(1).times

      subject.run!
    end

    it 'returns the ingested object' do
      expect(subject.run!).to be_an_instance_of(ExampleWork)
    end

    it 'sets the depositor' do
      subject.run!
      expect(subject.af_model.depositor).to eq 'admin@example.org'
    end
  end
end
