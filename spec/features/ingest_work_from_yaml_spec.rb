require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'example_work'

RSpec.describe "Ingesting a Work from YAML" do
  context "with config from ingest_work_from_yaml.yml" do
    before do
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/ingest_work_from_yaml.yml",
        source_files_path: "#{fixture_path}/sip_examples/ingest_work_from_yaml/sip"
      )

      @runner.run!
    end

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'ingests the Work with metadata' do
      expect(ExampleWork.where(title: "Wells Documentary, Vision of Herman B Wells").count).to eq 1
    end
  end

  context "with a shared_sip included" do
    before do
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/ingest_work_from_yaml.yml",
        source_files_path: "#{fixture_path}/sip_examples/ingest_work_from_yaml/sip",
        shared_file_path: "#{fixture_path}/sip_examples/ingest_work_from_yaml/shared_sip/shared_sip.yml"
      )
    end

    it 'raises an error on the shared_sip' do
      expect{ @runner.run! }.to raise_error('YAMLFile cannot have a shared sip.')
    end
  end
end
