require 'hyrax_helper'
require 'hyrax/ingest/fetcher/yaml_file'


RSpec.describe Hyrax::Ingest::Fetcher::YAMLFile do
  let(:sip) { Hyrax::Ingest::SIP.new(path: "#{fixture_path}/sip_examples/ingest_work_from_yaml/sip") }
  let(:shared_sip) { nil }

  describe '#fetch' do
    context 'when :filename option is a string (not a regex) and yaml_path points to a value in the yaml' do
      let(:options) { {filename: 'wells.yaml', yaml_path: %w[work title] } }

      let(:fetcher_1) { described_class.new(sip, shared_sip, options) }
      let(:fetcher_2) { described_class.new(sip, shared_sip, options) }

      it 'returns the value from the YAML pointed to by the yaml_path' do
        expect(fetcher_1.fetch).to eq 'Wells Documentary, Vision of Herman B Wells'
      end

      it 'can fetch same metadata from the same SIP using 2 different fetcher objects' do
        expect(fetcher_1.fetch).to eq fetcher_2.fetch
      end
    end

    context 'when :filename options is a regexp' do
      let(:options) { { filename: '/_no_title.yaml$/', yaml_path: %w[work original_format] } }
      let(:fetcher) { described_class.new(sip, shared_sip, options) }

      it 'finds the file within the sip' do
        expect(fetcher.fetch).to eq 'Open Reel Audio Tape'
      end
    end
  end

  describe '.new' do
    context 'when missing :filename keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(sip, shared_sip, yaml_path: 'foo') }.to raise_error ArgumentError
      end
    end

    context 'when missing :yaml_path keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(sip, shared_sip, filename: 'boo') }.to raise_error ArgumentError
      end
    end
  end
end
