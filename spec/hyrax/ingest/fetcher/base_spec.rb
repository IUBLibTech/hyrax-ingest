require 'hyrax_helper'
require 'hyrax/ingest/fetcher/base'
require 'hyrax/ingest/reporting'

RSpec.describe Hyrax::Ingest::Fetcher::Base do
  let(:invalid_sip) { "This is not a valid SIP object" }
  let(:shared_sip) { nil }
  let(:valid_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }

  describe '.new' do
    context 'when a non-SIP object has been specified' do
      subject { described_class.new(invalid_sip, shared_sip) }
      it 'raises a Hyrax::Ingest::Errors::InvalidSIP error' do
        expect { subject }.to raise_error Hyrax::Ingest::Errors::InvalidSIP
      end
    end

    context 'when given a valid SIP object' do
      subject { described_class.new(valid_sip, shared_sip) }
      it 'does not raise an error' do
        expect { subject }.to_not raise_error
      end

      it 'responds to #fetch' do
        expect(subject).to respond_to :fetch
      end
    end
  end
end
