require 'hyrax_helper'
require 'hyrax/ingest/ingester/file_set_ingester'

RSpec.describe Hyrax::Ingest::Ingester::FileSetIngester do
  describe '#run!' do
    let(:example_config) { { :Files => {}, properties: {}, depositor: 'admin@example.org'} }

    subject { described_class.new(example_config) }

    it 'calls assign_properties!,, apply_depositor_metadata!, save_model!, and add_files_to_file_set! in order' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject).to receive(:apply_depositor_metadata!).ordered.exactly(1).times
      expect(subject).to receive(:save_model!).ordered.exactly(1).times
      expect(subject).to receive(:add_files_to_file_set!).ordered.exactly(1).times

      subject.run!
    end

    it 'returns the ingested object' do
      expect(subject.run!).to be_an_instance_of(FileSet)
    end

    it 'sets the depositor' do
      subject.run!
      expect(subject.af_model.depositor).to eq 'admin@example.org'
    end
  end
end
