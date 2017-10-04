require 'hyrax_helper'
require 'hyrax/ingest/batch_runner'

RSpec.describe Hyrax::Ingest::BatchRunner do

  let(:number_of_sips) { 5 }
  let(:sip_paths) { (0..number_of_sips).to_a.map { Dir.mktmpdir }  }
  let(:config_file_path) { "#{fixture_path}/ingest_config_examples/blank_config.yml" }

  subject { described_class.new(config_file_path: config_file_path, sip_paths: sip_paths) }

  describe '#run!' do
    it 'prints a log message, calls #run! for all runners, and prints another log message' do
      # We say 'at_least' because the Runners themselves will make additional
      # calls to #logger#info.
      expect(subject.report).to receive(:batch_ingest_started).exactly(1).times.ordered
      subject.send(:runners).each { |runner| expect(runner).to receive(:run!).exactly(1).times.ordered }
      expect(subject.report).to receive(:batch_ingest_complete).exactly(1).times.ordered
      subject.run!
    end
  end
end
