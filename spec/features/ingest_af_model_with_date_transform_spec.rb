require 'hyrax_helper'
require 'hyrax/ingest/runner'

describe 'Ingest of ActiveFedora model with date transformation' do
  let(:timestamp_with_ms) { '1389834180000' }
  let(:date_time) { DateTime.strptime(timestamp_with_ms, '%Q') }

  before do
    class MyModel < ActiveFedora::Base
      property :date_time, predicate: 'http://example.org#dateTime' do |index|
        index.as :stored_searchable
      end
    end

    Hyrax::Ingest::Runner.new(config_file_path: "#{fixture_path}/ingest_config_examples/ingest_af_model_with_date_transform.yml", source_files_path: fixture_path).run!
  end

  let(:ingested_record) { MyModel.all.first }

  it 'transforms timestamps into dates' do
    expect(ingested_record.date_time).to eq [date_time]
  end

  after { Object.send(:remove_const, :MyModel) }
end
