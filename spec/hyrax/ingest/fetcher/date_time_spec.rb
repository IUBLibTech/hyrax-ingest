require 'hyrax_helper'
require 'hyrax/ingest/fetcher/date_time'

RSpec.describe Hyrax::Ingest::Fetcher::DateTime do

  subject { described_class.new }
  let(:fetched_value) { subject.fetch }

  describe '#fetch' do
    it 'returns the current datetime' do
      expect(fetched_value.strftime('%Y%m%d%H%M%S')).to eq ::DateTime.now.strftime('%Y%m%d%H%M%S')
    end
  end
end
