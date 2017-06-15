require 'spec_helper'
require 'hyrax/ingest/mapping'

RSpec.describe Hyrax::Ingest::Mapping do

  before do
    class Work < ActiveFedora::Base; end
  end


  let(:sip) { Hyrax::Ingest::SIP.new(path: "#{fixture_path}/sip_examples/40000000054496_20160213-082528") }
  let(:config_yaml) { Psych.load_file("#{fixture_path}/ingest_mapping_samples/ingest_mapping_example_1.yml") }
  subject { described_class.new(sip: sip, config: config_yaml["mapping"]) }

  describe '#map_operations' do
    it 'returns a list of MapOperation instances' do
      subject.map_operations.each do |map_operation|
        expect(map_operation).to be_a Hyrax::Ingest::MapOperation
      end
    end
  end

  describe 'map_all!' do
    it 'calls #map! on all contained MapOperation instances' do
      subject.map_operations.each do |map_operation|
        expect(map_operation).to receive(:"map!").with(no_args).exactly(1).times
      end
      subject.map_all!
    end
  end
end
