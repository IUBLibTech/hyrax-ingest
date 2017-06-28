require 'hyrax_helper'
require 'hyrax/ingest/fetcher/xml_file'


RSpec.describe Hyrax::Ingest::Fetcher::XMLFile do
  let(:sip) { Hyrax::Ingest::SIP.new(path: "#{fixture_path}/sip_examples/40000000054496_20160213-082528") }
  
  describe '#fetch' do
    context 'when :filename option is a string (not a regex) and xpath points to a value in the xml' do
      let(:options) { {filename: 'MDPI_40000000542243_pod.xml', xpath: '/object/details/title' } }

      subject { described_class.new(sip, options) }

      it 'returns the value from the XML pointed to by the xpath' do
        expect(subject.fetch).to eq '"Brain" Cam 1 Tape 1'
      end
    end
  end

  describe '.new' do
    context 'when missing :filename keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(sip, xpath: 'foo') }.to raise_error ArgumentError
      end
    end

    context 'when missing :xpath keyword argument' do
      it 'raises an ArgumentError' do
        expect { described_class.new(sip, filename: 'boo') }.to raise_error ArgumentError
      end
    end
  end
end