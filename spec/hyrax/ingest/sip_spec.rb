require 'spec_helper'
require 'hyrax/ingest/sip.rb'
require 'pry'

RSpec.describe Hyrax::Ingest::SIP do
  describe '.new' do
    context 'when given an invalid path' do
      let(:path) { 'path/to/nothing' }
      it 'raises an InvalidSIPPath error' do
        expect { described_class.new(path: path) }.to raise_error Hyrax::Ingest::Errors::InvalidSIPPath
      end
    end
  end

  describe '#file_paths' do
    subject { described_class.new(path: "#{fixture_path}/sip_examples/fits_example_1.xml")}
    context 'when given a path to a single file' do
      it 'returns a list containing a single File object for the file specified by the path param' do
        expect(subject.file_paths.count).to eq 1
        expect(File.basename(subject.file_paths.first)).to eq 'fits_example_1.xml'
      end
    end
  end

  describe '#find_file' do
    subject { described_class.new(path: "#{fixture_path}/sip_examples/fits_example_1.xml")}
    context 'when given an exact filename' do
      it 'returns the file' do
        expect(subject.find_file_path('fits_example_1.xml')).to eq "#{fixture_path}/sip_examples/fits_example_1.xml"
      end
    end

    context 'when given a regex as a string' do
      it 'returns the file' do
        expect(subject.find_file_path('/^fits_/')).to eq "#{fixture_path}/sip_examples/fits_example_1.xml"
      end
    end


    context "when given a string that doesn't match any filename in the SIP" do
      it 'raises a FileNotFoundInSIP error' do
        expect { subject.find_file_path('not in the sip') }.to raise_error Hyrax::Ingest::Errors::FileNotFoundInSIP
      end
    end
  end
end
