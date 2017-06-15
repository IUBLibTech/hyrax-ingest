require 'spec_helper'
require 'hyrax/ingest/assigner/active_fedora_model'

RSpec.describe Hyrax::Ingest::Assigner::ActiveFedoraModel do

  before do
    class TestActiveFedoraModel < ActiveFedora::Base
      property :foo, predicate: ::RDF::URI.new('http://example.org#foo')
    end
  end

  describe '.instances' do
    it 'returns a hash' do
      expect(described_class.instances).to be_a Hash
    end
  end

  describe '.fetch_or_create_instance' do
    context 'when a :type is specified, but no :instance_name is specified' do
      let(:type) { "TestActiveFedoraModel" }

      before do
        described_class.fetch_or_create_instance(type: type)
      end

      it 'creates the instances and stored is in the @instances hash, keyed by the class name' do
        expect(described_class.instances[type]).to be_a type.constantize
      end
    end

    context 'when an :instance_name is specified, but no type is specified' do
      context 'and when no instance has been created yet' do
        it 'throws a MissingRequiredAssignmentOptions error' do
          expect { described_class.fetch_or_create_instance(instance_name: "has not been created yet" ) }.to raise_error Hyrax::Ingest::Errors::MissingRequiredAssignmentOptions
        end
      end

      context 'and when the instance has already been created' do

        let(:instance_name) { "test_instance" }
        let(:type) { "TestActiveFedoraModel" }

        before do
          @instance_created = described_class.fetch_or_create_instance(type: type, instance_name: instance_name)
        end

        it 'returns the instance that has already been created' do
          expect(described_class.fetch_or_create_instance(instance_name: instance_name)).to eq @instance_created
        end
      end
    end
  end

  describe '#assign' do

    let(:options) { { type: "TestActiveFedoraModel", rdf_predicate: 'http://example.org#foo'} }
    subject { described_class.new(options) }

    before do
      subject.assign("some value")
    end

    it 'assigns a value to the property of an ActiveFedora model based on the assign options' do
      expect(subject.af_model.foo).to eq ["some value"]
    end
  end

  # Undefined test classes
  after { Object.send(:remove_const, :TestActiveFedoraModel) }
end
