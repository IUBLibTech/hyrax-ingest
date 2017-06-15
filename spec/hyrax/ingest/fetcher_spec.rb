require 'spec_helper'
require 'hyrax/ingest/fetcher'
require 'hyrax/ingest/sip'

RSpec.describe Hyrax::Ingest::Fetcher do
  describe '.find_class_by_name' do
    before do
      # Create a couple of test fetcher classses with the same base name,
      # but in different namespaces.
      module ::ArbitraryNamespace1
        class TestFetcherClass < Hyrax::Ingest::Fetcher::Base; end
      end

      module ::ArbitraryNamespace2
        class TestFetcherClass < Hyrax::Ingest::Fetcher::Base; end
      end

      allow(described_class).to receive(:all_classes).and_return(
        [
          ::ArbitraryNamespace1::TestFetcherClass,
          ::ArbitraryNamespace2::TestFetcherClass
        ]
      )
    end

    context 'when the fetcher class name is ambiguous given the list of all available fetcher classes' do
      it 'raises a Hyrax::Ingest::Errors::AmbiguousFetcherClass' do
        expect { described_class.factory("TestFetcherClass") }.to raise_error Hyrax::Ingest::Errors::AmbiguousFetcherClass
      end
    end

    context 'when the fetcher class name is unknown' do
      it 'raises a Hyrax::Ingest::Errors::UnknownFetcherClass error' do
        expect { described_class.factory("ThisClassDoesNotExist") }.to raise_error Hyrax::Ingest::Errors::UnknownFetcherClass
      end
    end

    after do
        # undefine constants defined for these tests
        ::ArbitraryNamespace1.send(:remove_const, :TestFetcherClass)
        ::ArbitraryNamespace2.send(:remove_const, :TestFetcherClass)
        Object.send(:remove_const, :ArbitraryNamespace1)
        Object.send(:remove_const, :ArbitraryNamespace2)
    end
  end

  describe '.factory' do
    context 'when given params that specify fetching to an XMLFilke fetcher class' do
      it 'returns an instance of Hyrax::Ingest::Fetcher::XMLFile' do
        expect(described_class.factory('XMLFile', filename: 'foo', xpath: 'bar')).to be_a Hyrax::Ingest::Fetcher::XMLFile
      end
    end
  end
end
