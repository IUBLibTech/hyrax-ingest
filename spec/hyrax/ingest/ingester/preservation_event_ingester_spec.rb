require 'hyrax_helper'
require 'hyrax/ingest/ingester/preservation_event_ingester'

RSpec.describe Hyrax::Ingest::Ingester::PreservationEventIngester do
  describe '#run!' do
    let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
    let(:example_config) { { 'Files' => {}, 'properties' => {} } }

    subject { described_class.new(example_sip, example_config) }

    it 'calls af_model.save!' do
      expect(subject).to receive(:assign_properties!).ordered.exactly(1).times
      expect(subject.af_model).to receive(:save!).ordered.exactly(1).times
      subject.run!
    end
  end
end
