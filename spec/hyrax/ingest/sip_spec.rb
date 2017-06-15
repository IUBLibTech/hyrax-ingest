require 'spec_helper'
require 'hyrax/ingest/sip.rb'

RSpec.describe Hyrax::Ingest::SIP do
  describe '.new' do
    context 'when given an invalid path' do
      let(:path) { 'path/to/nothing' }
      it 'raises an InvalidSIPPath error' do
        expect { described_class.new(path: path) }.to raise_error Hyrax::Ingest::Errors::InvalidSIPPath
      end
    end
  end

  describe '#files' do
    subject { described_class.new(path: "#{fixture_path}/sip_examples/fits_example_1.xml")}
    context 'when given a path to a single file' do
      it 'returns a list containing a single File object for the file specified by the path param' do
        expect(subject.files.count).to eq 1
        expect(subject.files.first).to be_a File
        expect(File.basename(subject.files.first)).to eq 'fits_example_1.xml'
      end
    end
  end
end
