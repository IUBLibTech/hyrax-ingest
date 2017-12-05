require 'hyrax_helper'
require 'hyrax/ingest/batch_runner'

RSpec.describe "Ingesting ActiveFedora models with shared source" do

  before do
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title'
      property :description, predicate: 'http://example.org#description' do |index|
        index.as :stored_searchable
      end
    end

    @runner = Hyrax::Ingest::BatchRunner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/ingest_af_models_with_shared_xml_source_spec.yml",
      sip_paths: Dir.glob("#{fixture_path}/sip_examples/ingest_af_models_with_shared_xml_source/not_shared/*"),
      shared_sip_path: "#{fixture_path}/sip_examples/ingest_af_models_with_shared_xml_source/shared/shared_sip.xml"
    )

    @runner.run!
  end

  context "when ingesting using config from ingest_af_models_with_shared_xml_source_spec.yml" do

    it "ingests multiple instances of MyModel" do
      expect(MyModel.all.count).to eq(2)
    end

    it "ingests shared values from an XML file" do
      expect(MyModel.first.title.first).to eq("Shared Title")
      expect(MyModel.first.title.count).to eq(1)

      expect(MyModel.last.title.first).to eq("Shared Title")
      expect(MyModel.last.title.count).to eq(1)
    end

    it "ingests non-shared values from seperate XML files" do
      expect(MyModel.where(description: "SIP 1 XML").count).to eq(1)
      expect(MyModel.where(description: "SIP 2 XML").count).to eq(1)
    end
  end

  after do
    Object.send(:remove_const, :MyModel)
  end
end
