require 'spec_helper'
require 'hyrax/ingest/fetcher/base'

RSpec.describe Hyrax::Ingest::Fetcher::Base do
  subject { described_class.new }

  describe 'sip' do
    context 'when no SIP object has been specified' do
      it 'raises a Hyrax::Ingest::Errors::NoSIPSpecified error' do
        expect { subject.sip }.to raise_error Hyrax::Ingest::Errors::NoSIPSpecified
      end
    end

    context 'when a non-SIP object has been specified' do
      before { subject.sip = Object.new }
      it 'raises a Hyrax::Ingest::Errors::InvalidSIP error' do
        expect { subject.sip }.to raise_error Hyrax::Ingest::Errors::InvalidSIP
      end
    end
  end

  it 'responds to #fetch' do
    expect(subject).to respond_to :fetch
  end
end
