require 'hyrax_helper'
require 'hyrax/ingest/batch_runner'

RSpec.describe Hyrax::Ingest::BatchRunner do
  subject { described_class.new(config_file_path: config_file_path) }
  let(:config_file_path) { "#{fixture_path}/ingest_config_examples/blank_config.yml" }
  let(:runners) { (0..5).to_a.map { instance_double(Hyrax::Ingest::Runner) } }

  # Mock the return value of BatchRunner#runners
  before { allow(subject).to receive(:runners).and_return(runners) }

  describe '#run!' do
    it 'calls #run! for all runners' do
      # Set the expectations on each Runner instance.
      runners.each { |runner| expect(runner).to receive(:run!).exactly(1).times.ordered }
      # Call the method under test.
      subject.run!
    end
  end
end
