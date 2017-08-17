require 'hyrax_helper'
require 'hyrax/ingest/batch_runner'

RSpec.describe Hyrax::Ingest::BatchRunner do

  let(:number_of_sips) { 5 }
  let(:sip_paths) { (0..number_of_sips).to_a.map { Dir.mktmpdir }  }
  let(:config_file_path) { "#{fixture_path}/ingest_config_examples/blank_config.yml" }

  subject { described_class.new(config_file_path: config_file_path, sip_paths: sip_paths) }


  describe '#run!' do
    # let(:mock_runners) do
    #   (0..number_of_sips).to_a.map { instance_double(Hyrax::Ingest::Runner) }
    # end

    # before do
    #   allow(subject).to receive(:runners).and_return(mock_runners)
    # end


    it 'calls #run! for all runners' do
      subject.send(:runners).each { |runner| expect(runner).to receive(:run!).exactly(1).times }
      subject.run!
    end
  end
end
