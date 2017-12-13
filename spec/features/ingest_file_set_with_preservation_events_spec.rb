require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'file_set'

RSpec.describe "Ingesting a FileSet with Preservation Events" do

  let(:config_file_path) { "#{fixture_path}/ingest_config_examples/ingest_file_set_with_preservation_events.yml" }
  # NOTE: We re-use an example SIP here
  let(:sip_path) { "#{fixture_path}/sip_examples/ingest_file_set_from_xml" }

  before do
    @runner = Hyrax::Ingest::Runner.new(config_file_path: config_file_path, sip_path: sip_path)
    @runner.run!
  end

  context "with config from ingest_file_set_with_preservation_events.yml" do

    let(:preservation_events) { Hyrax::Preservation::Event.all }
    let(:file_sets) { ::FileSet.all }

    it "does not have any errors" do
      expect(@runner.errors).to be_empty
    end

    it 'ingests the correctd number of records' do
      expect(preservation_events.count).to eq 1
      expect(file_sets.count).to eq 1
    end

    it 'ingests the Preservation Events that are associated with the FileSet' do
      preservation_events.each do |preservation_event|
        expect(preservation_event.premis_event_related_object).to eq file_sets.first
      end
    end
  end
end
