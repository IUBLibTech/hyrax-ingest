require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'example_work'

RSpec.describe "Ingesting a Work from YAML" do
  context "with config from ingest_work_from_yaml.yml" do
    before do
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/ingest_work_from_yaml.yml",
        sip_path: "#{fixture_path}/sip_examples/ingest_work_from_yaml/sip"
      )

      @runner.run!
    end

    it 'ingests the Work with metadata' do
      expect(ExampleWork.where(title: "Wells Documentary, Vision of Herman B Wells").count).to eq 1
    end
  end
end
