require 'hyrax_helper'
require 'hyrax/ingest/runner'

RSpec.describe "Ingesting an ActiveFedora model with missing metadata" do
  let(:runner) { Hyrax::Ingest::Runner.new(config_file_path: config_file_path, sip_path: sip_path) }
  let(:sip_path) { nil }
  let(:log_file_path) { Tempfile.new.path }
  let(:ingest_log_output) { File.read(log_file_path) }
  let(:ingest_report) { runner.report }
  before { runner.logger = Logger.new(log_file_path) }

  before do
    # Define a test model
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title' do |index|
        index.as :stored_searchable
      end
    end
  end

  context 'when metadata is required via ActiveFedora property validation' do
    let(:config_file_path) { "#{fixture_path}/ingest_config_examples/ingest_af_model_with_missing_metadata.yml" }

    before do
      # Set the ActiveFedora model validation
      MyModel.validates :title, presence: true
      runner.run!
    end

    it 'prints an error in the log' do
      # TODO: making this test less brittle by not hardcoding the expected message.
      expect(ingest_log_output).to match /title.*can't be blank/
    end

    it 'adds to the number of "Records failed" in the summary report' do
      # TODO: making this test less brittle by not hardcoding the expected message.
      expect(ingest_report.stat[:count, :models_failed]).to eq 1
    end

    it 'does not add to the number of "Records ingested" in the summary report' do
      # TODO: making this test less brittle by not hardcoding the expected message.
      expect(ingest_report.stat[:count, :models_saved]).to eq 0
    end

    it 'does not ingest the object' do
      search_results = MyModel.all
      expect(search_results).to be_empty
    end
  end

  context 'when metadata is required per ingest config, but not required per ActiveFedora property validation' do

    # Set the config_file_path to be one where the metadata is missing, but the config file DOES require it.
    # Meanwhile, do NOT set any ActiveFedora model validations on the property.
    let(:config_file_path) { "#{fixture_path}/ingest_config_examples/ingest_af_model_with_missing_required_metadata.yml" }
    let(:sip_path) { "#{fixture_path}/sip_examples/ingest_af_model_with_missing_required_metadata" }

    before { runner.run! }

    it 'prints a warning in the log' do
      expect(ingest_log_output).to match /WARN.*Missing required value from Literal with params = {}/
      expect(ingest_log_output).to match /WARN.*Missing required value from XMLFile with params = {:filename=>"metadata.xml", :xpath=>"path\/to\/no_value"}/
    end

    it 'ingests the object' do
      search_results = MyModel.all
      expect(search_results.count).to eq 1
    end

    it 'includes the missing missing value in the ingest summary report' do
      expect(ingest_report.stat[:total_missing_required_values]).to eq 3
    end
  end

  # Destroy our test ActiveFedor model at the end of these tests.
  after { Object.send(:remove_const, :MyModel) }
end
