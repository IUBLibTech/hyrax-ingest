require 'spec_helper'
require 'hyrax/ingest/configuration'

describe Hyrax::Ingest::Configuration do
  describe '.new' do
    subject { described_class.new(config_file_path: config_file_path) }

    context 'when config file is missing top-level "ingest" key' do
      let(:config_file_path) { "#{fixture_path}/ingest_config_examples/invalid_config_missing_top_level_key.yml" }

      it 'raises a Hyrax::Ingest::Errors::InvalidConfig error' do
        expect { subject }.to raise_error Hyrax::Ingest::Errors::InvalidConfig
      end
    end

    context 'when config file path does not point to a file' do
      let(:config_file_path) { "#{fixture_path}/ingest_config_examples/invalid_config_missing_expected_array.yml" }

      it 'raises a Hyrax::Ingest::Errors:: error' do
        expect { subject }.to raise_error Hyrax::Ingest::Errors::InvalidConfig
      end
    end
  end
end
