require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'file_set'

RSpec.describe "Ingesting a FileSet from XML" do
  before do
    @runner = Hyrax::Ingest::Runner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/ingest_file_set_from_xml.yml",
      source_files_path: "#{fixture_path}/sip_examples/ingest_file_set_from_xml"
    )

    @runner.run!
  end

  context "with config from ingest_file_set_from_xml.yml" do
    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'ingests the model with metadata' do
      expect(FileSet.where(title: "Barcode29455_Latimer01.mov.mkv").count).to eq 1
    end
  end
end