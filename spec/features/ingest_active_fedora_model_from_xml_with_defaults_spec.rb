require 'hyrax_helper'
require 'hyrax/ingest/runner'

RSpec.describe "Ingesting an ActiveFedora model from XML with default values" do

  before do
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title' do |index|
        index.as :stored_searchable
      end

      property :description, predicate: 'http://example.org#description'
    end
  end

  context "with values supplied in sip" do
    before do
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/ingest_active_fedora_model_from_xml_with_defaults.yml",
        sip_path: "#{fixture_path}/sip_examples/ingest_active_fedora_model_from_xml"
      )

      @runner.run!
    end

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'ingests the model with supplied metadata' do
      expect(MyModel.where(title: "Test Title 1").count).to eq 1
    end
  end

  context "with default values assumed" do
    before do
      @runner = Hyrax::Ingest::Runner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/ingest_active_fedora_model_from_xml_with_defaults.yml",
        sip_path: "#{fixture_path}/sip_examples/ingest_active_fedora_model_from_xml_with_defaults"
      )

      @runner.run!
    end

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'ingests the model with default metadata' do
      expect(MyModel.where(title: "Default title").count).to eq 1
    end
  end

  after do
    Object.send(:remove_const, :MyModel)
  end
end
