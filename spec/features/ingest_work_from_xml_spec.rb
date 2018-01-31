require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'example_work'

RSpec.describe "Ingesting a Work from XML" do
  before do
    @runner = Hyrax::Ingest::Runner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/ingest_work_from_xml.yml",
      sip_path: "#{fixture_path}/sip_examples/ingest_work_from_xml"
    )

    @runner.run!
  end

  context "with config from ingest_work_from_xml.yml" do
    it 'ingests the Work with metadata' do
      expect(ExampleWork.where(title: "Example Work").count).to eq 1
    end
  end
end
