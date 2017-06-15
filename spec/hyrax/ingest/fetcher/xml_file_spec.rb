require 'spec_helper'
require 'hyrax/ingest/fetcher/xml_file'


RSpec.describe Hyrax::Ingest::Fetcher::XMLFile do
  describe '#fetch' do
    context 'when :filename option is a string (not a regex) and xpath points to a value in the xml' do
      let(:options) { {filename: 'MDPI_40000000542243_pod.xml', xpath: '/object/details/title' } }
      let(:sip) { Hyrax::Ingest::SIP.new(path: "#{fixture_path}/sip_examples/40000000054496_20160213-082528") }

      subject { described_class.new(options) }

      it 'returns the value from the XML pointed to by the xpath' do
        subject.sip = sip
        expect(subject.fetch).to eq '"Brain" Cam 1 Tape 1'
      end
    end
  end

  describe '.new' do
    context 'when missing :filename keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(xpath: 'foo') }.to raise_error ArgumentError
      end
    end

    context 'when missing :xpath keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(filename: 'boo') }.to raise_error ArgumentError
      end
    end
  end
end