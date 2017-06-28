require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'example_work'

RSpec.describe "Ingesting a Work containing a FileSet" do
  before do
    @runner = Hyrax::Ingest::Runner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/ingest_work_with_file_set.yml",
      source_files_path: "#{fixture_path}/sip_examples/ingest_work_with_file_set"
    )

    @runner.run!
  end

  context "with config from ingest_work_with_file_set.yml" do

    let(:ingested_work) { ExampleWork.where(title: "ExampleWork Title").first }

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'saves the FileSet as belonging to the Work' do
      expect(ingested_work.file_sets.size).to eq 1
    end

    it 'ingests metadata for the FileSet' do
      expect(ingested_work.file_sets.first&.title.first).to eq "FileSet Title"
    end
  end
end
