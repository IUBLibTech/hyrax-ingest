require 'hyrax_helper'
require 'hyrax/ingest/ingester/preservation_event_ingester'

RSpec.describe Hyrax::Ingest::Ingester::PreservationEventIngester do
  describe '#run!' do
    let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
    let(:example_config) { { 'Files' => {}, 'properties' => {} } }

    subject { described_class.new(example_sip, example_config) }

    it 'calls save_model!' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject).to receive(:save_model!).ordered.exactly(1).times
      subject.run!
    end
  end
end
