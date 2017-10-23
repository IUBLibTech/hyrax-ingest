require 'hyrax_helper'
require 'hyrax/ingest/ingester/file_set_ingester'

RSpec.describe Hyrax::Ingest::Ingester::FileSetIngester do
  describe '#run!' do
    let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
    let(:example_config) { { 'Files' => {}, 'properties' => {} } }

    subject { described_class.new(example_sip, example_config) }

    it 'calls assign_properties!, af_model.save!, and add_files_to_file_set! in order' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject).to receive(:save_model!).ordered.exactly(1).times
      expect(subject).to receive(:add_files_to_file_set!).ordered.exactly(1).times

      subject.run!
    end

    it 'returns the ingested object' do
      expect(subject.run!).to be_an_instance_of(FileSet)
    end
  end
end
