require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'hyrax/ingest/ingester/base'

RSpec.describe Hyrax::Ingest::Runner do
  # let(:fake_config) { instance_double Hyrax::Ingest::Configuration }
  subject { described_class.new(config_file_path: "#{fixture_path}/ingest_config_examples/blank_config.yml", source_files_path: fixture_path) }

  # before do
  #   # Need to explicitly allow the mocked object to receive all method calls
  #   # that the object it's mocking is expected to receive.
  #   allow(fake_config).to receive(:is_a?).and_return(true)
  # end

  describe '#run!' do
    let(:fake_ingesters) do
      [
        instance_double(Hyrax::Ingest::Ingester::Base),
        instance_double(Hyrax::Ingest::Ingester::Base)
      ]
    end

    before do
      allow(subject).to receive(:ingesters).and_return(fake_ingesters)
      fake_ingesters.each { |fake_ingester| allow(fake_ingester).to receive(:run!).and_return(nil) }
    end

    it 'calls #run! for all ingesters' do
      fake_ingesters.each do |fake_ingester|
        expect(fake_ingester).to receive(:run!).exactly(1).times
      end
      subject.run!
    end
  end
end
