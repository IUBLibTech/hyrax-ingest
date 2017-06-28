require 'hyrax_helper'
require 'hyrax/ingest/ingester/file_set_ingester'

RSpec.describe Hyrax::Ingest::Ingester::FileSetIngester do
  describe '#run!' do
    let(:properties_config) { { } }
    let(:files_config) { { } }

    subject { described_class.new(properties_config: properties_config, files_config: files_config) }

    it 'calls assign_properties!' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject.af_model).to receive(:save!).ordered.exactly(1).times
      expect(subject).to receive(:add_files_to_file_set!).ordered.exactly(1).times

      subject.run!
    end
  end
end
