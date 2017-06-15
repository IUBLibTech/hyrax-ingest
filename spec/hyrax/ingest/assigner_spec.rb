require 'spec_helper'
require 'hyrax/ingest/assigner'
require 'hyrax/ingest/errors'

RSpec.describe Hyrax::Ingest::Assigner do

  describe '.find_class_by_name' do
    before do
      # Create a couple of test assigner classses with the same base name,
      # but in different namespaces.
      module ::ArbitraryNamespace1
        class TestAssignerClass < Hyrax::Ingest::Assigner::Base; end
      end

      module ::ArbitraryNamespace2
        class TestAssignerClass < Hyrax::Ingest::Assigner::Base; end
      end

      allow(described_class).to receive(:all_classes).and_return(
        [
          ::ArbitraryNamespace1::TestAssignerClass,
          ::ArbitraryNamespace2::TestAssignerClass
        ]
      )
    end

    context 'when the assigner class name is ambiguous given the list of all available assigner classes' do
      it 'raises a Hyrax::Ingest::Errors::AmbiguousAssignerClass' do
        expect { described_class.factory("TestAssignerClass") }.to raise_error Hyrax::Ingest::Errors::AmbiguousAssignerClass
      end
    end

    context 'when the assigner class name is unknown' do
      it 'raises a Hyrax::Ingest::Errors::UnknownAssignerClass error' do
        expect { described_class.factory("ThisClassDoesNotExist") }.to raise_error Hyrax::Ingest::Errors::UnknownAssignerClass
      end
    end

    after do
      # undefine constants defined for these tests
      ::ArbitraryNamespace1.send(:remove_const, :TestAssignerClass)
      ::ArbitraryNamespace2.send(:remove_const, :TestAssignerClass)
      Object.send(:remove_const, :ArbitraryNamespace1)
      Object.send(:remove_const, :ArbitraryNamespace2)
    end
  end

  describe '.factory' do
    context 'when given params that specify assigning to an ActiveFedoraModel assigner class' do
      before do
        class TestActiveFedoraModel < ActiveFedora::Base
          property :foo, predicate: ::RDF::URI.new('http://example.org#foo')
        end
      end

      let(:options) { { type: "TestActiveFedoraModel", rdf_predicate: 'http://example.org#foo'} }

      it 'returns an instance of Hyrax::Ingest::Assigner::ActiveFedoraModel' do
        expect(described_class.factory('ActiveFedoraModel', options)).to be_a Hyrax::Ingest::Assigner::ActiveFedoraModel
      end

      # Undefine the test class
      after { Object.send(:remove_const, :TestActiveFedoraModel) }
    end
  end
end
