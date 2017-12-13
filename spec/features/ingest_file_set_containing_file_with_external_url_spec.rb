require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'file_set'

RSpec.describe "Ingesting a FileSet containing a File with an external URL" do

  before do
    @runner = Hyrax::Ingest::Runner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/ingest_file_set_containing_file_with_external_url.yml",
      sip_path: "#{fixture_path}/sip_examples/ingest_file_set_containing_file_with_external_url"
    )
    @runner.run!
  end

  context "with config from ingest_file_set_containing_file_with_external_url.yml" do

    let(:ingested_file_set) { FileSet.where(title: "Example FileSet").first }

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'results in the FileSet having just one file' do
      expect(ingested_file_set.files.size).to eq 1
    end

    it 'results in the FileSet\'s contained File having one and only file having an external URL' do
      expect(ingested_file_set.files.first.mime_type).to eq 'message/external-body;access-type=URL;url="https://path/to/example_external_file.html"'
    end
  end
end
