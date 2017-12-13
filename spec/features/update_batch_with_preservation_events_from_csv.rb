require 'hyrax_helper'
require 'hyrax/ingest/runner'
require 'file_set'

RSpec.describe "Updating records with checksums from a CSV" do


  # Helper method to grab the same CSV values being used in the ingest, so we
  # can compare them in tests.
  # @return [Array] An array of rows (hashes) where the key :id has values from
  #   the 'ID' column, and the key :checksum has values from the 'CHECKSUM'
  #   column.
  def csv_values
    @csv_values ||= begin
      require 'roo'
      Roo::CSV.new("#{fixture_path}/sip_examples/update_batch_with_preservation_events_from_csv").parse(id: 'ID', checksum: 'CHECKSUM')
    end
  end

  before do
    csv_values.each do |row|
      FileSet.new.tap do |file_set|
        file_set.id = row[:id]
        file_set.save!
      end
    end

    @runner = Hyrax::Ingest::Runner.new(
      config_file_path: "#{fixture_path}/ingest_config_examples/update_batch_with_preservation_events_from_csv.yml",
      shared_sip_path: "#{fixture_path}/sip_examples/update_batch_with_preservation_events_from_csv",
      iterations: 2
    )

    @runner.run!
  end

  it 'adds new preservation events to the existing file set objects' do
    csv_values.each do |row|
      preservation_event = FileSet.find(row[:id]).preservation_events.first
      expect(preservation_event.preservation_event_type).to eq 'mes'
      expect(preservation_event.preservation_event_outcome).to eq row[:checksum]
    end
  end
end
