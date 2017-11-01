require 'spec_helper'
require 'hyrax/ingest/reporting'

describe Hyrax::Ingest::Reporting do
  describe '.config' do
    it 'returns an instance of Hyrax::Ingest::Reporting::Configuration' do
      expect(Hyrax::Ingest::Reporting.config).to be_a Hyrax::Ingest::Reporting::Configuration
    end
  end
end
