require 'hyrax_helper'
require 'hyrax/ingest/runner'

RSpec.describe "Ingesting an ActiveFedora model with missing metadata" do

  before do
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title' do |index|
        index.as :stored_searchable
      end

      validates :title, presence: true
    end
  end

  let(:config_file_path) { "#{fixture_path}/ingest_config_examples/ingest_af_model_with_missing_metadata.yml" }
  # Set a dummy source_files_path that we won't use.
  let(:source_files_path) { fixture_path }
  let(:runner) { Hyrax::Ingest::Runner.new(config_file_path: config_file_path, source_files_path: source_files_path) }

  context "with config from ingest_af_model_with_missing_metadata.yml" do
    before { runner.run! }

    it 'logs it as an error' do
      # TODO: making this test less brittle by not hardcoding the expected message.
      expect(runner.print_report).to include("Ingest of MyModel failed. Validation failed: Title can't be blank")
    end

    it 'does not ingest the object' do
      search_results = MyModel.all
      expect(search_results).to be_empty
    end
  end

  after { Object.send(:remove_const, :MyModel) }
end
