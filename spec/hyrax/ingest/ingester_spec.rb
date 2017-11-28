require 'hyrax_helper'
require 'hyrax/ingest/ingester'

RSpec.describe Hyrax::Ingest::Ingester do

  let(:example_sip) { Hyrax::Ingest::SIP.new(path: fixture_path) }
  let(:shared_sip) { nil }

  describe '.default_registered_classes' do
    subject { described_class.default_registered_classes }
    it { is_expected.to include Hyrax::Ingest::Ingester::ActiveFedoraBaseIngester }
    it { is_expected.to include Hyrax::Ingest::Ingester::FileSetIngester }
    it { is_expected.to include Hyrax::Ingest::Ingester::WorkIngester }
  end

  describe '.register_class' do
    before do
      class CustomIngesterClass < Hyrax::Ingest::Ingester::Base; end
      # This is not valid because it doesn't extend Hyrax::Ingest::Ingester::Base
      class InvalidIngesterClass; end
    end

    context 'when given a class that extends Hyrax::Ingest::Ingester::Base' do

      before do
        expect(Hyrax::Ingest::Ingester.registered_classes).to_not include CustomIngesterClass
        Hyrax::Ingest::Ingester.register_class(CustomIngesterClass)
      end

      it 'adds the given class to the list of available classes' do
        expect(Hyrax::Ingest::Ingester.registered_classes).to include CustomIngesterClass
      end

      after { Hyrax::Ingest::Ingester.unregister_class(CustomIngesterClass) }
    end

    context 'when given a class that does not extend Hyrax::Ingest::Ingester::Base' do
      it 'raises a Hyrax::Ingest::Errors::InvalidIngesterClass error' do
        expect{ Hyrax::Ingest::Ingester.register_class(InvalidIngesterClass) }.to raise_error Hyrax::Ingest::Errors::InvalidIngesterClass
      end
    end

    after do
      # Remove classes used only for testing.
      [:CustomIngesterClass, :InvalidIngesterClass].each { |test_class_name| Object.send(:remove_const, test_class_name) }
    end
  end

  describe '.unregister_class' do
    before do
      class CustomIngesterClass < Hyrax::Ingest::Ingester::Base; end
      Hyrax::Ingest::Ingester.register_class(CustomIngesterClass)
      expect(Hyrax::Ingest::Ingester.registered_classes).to include CustomIngesterClass
    end

    it 'removes the given class from the set of registered classes.' do
      Hyrax::Ingest::Ingester.unregister_class(CustomIngesterClass)
      expect(Hyrax::Ingest::Ingester.registered_classes).not_to include CustomIngesterClass
    end

    # Remove test class
    after { Object.send(:remove_const, :CustomIngesterClass) }
  end

  describe '.factory' do
    context 'when given "ActiveFedoraBase" as an argument' do
      it 'returns an instance of Hyrax::Ingest::Ingester::ActiveFedoraBaseIngester' do
        options = {af_model_class_name: 'FakeModel'}
        expect(described_class.factory("ActiveFedoraBase", example_sip, shared_sip, options)).to be_a Hyrax::Ingest::Ingester::ActiveFedoraBaseIngester
      end
    end

    context 'when given "FileSet" as an argument' do
      it 'returns an instance of Hyrax::Ingest::Ingester::FileSetIngester' do
        expect(described_class.factory("FileSet", example_sip, shared_sip)).to be_a Hyrax::Ingest::Ingester::FileSetIngester
      end
    end

    context 'when given "Work" as an argument' do
      it 'returns an instance of Hyrax::Ingest::Ingester::WorkIngester' do
        expect(described_class.factory("Work", example_sip, shared_sip)).to be_a Hyrax::Ingest::Ingester::WorkIngester
      end
    end

    context 'when given "WorkIngester" as an argument' do
      it 'returns an instance of Hyrax::Ingest::Ingester::WorkIngester' do
        expect(described_class.factory("WorkIngester", example_sip, shared_sip)).to be_a Hyrax::Ingest::Ingester::WorkIngester
      end
    end

    context 'when given "ThisDoesNotExist" as an argument' do
      it 'raises a Hyrax::Ingest::Errors::UnknownIngesterClass error' do
        expect { described_class.factory("ThisDoesNotExist", example_sip, shared_sip) }.to raise_error Hyrax::Ingest::Errors::UnknownIngesterClass
      end
    end

    context 'when given an ambiguous argument that matches more than one Ingester class' do

      before do
        class WorkIngester < Hyrax::Ingest::Ingester::Base; end
        Hyrax::Ingest::Ingester.register_class(WorkIngester)
      end

      it 'raises a Hyrax::Ingest::Errors::AmbiguousIngesterClass error' do
        expect { described_class.factory("WorkIngester", example_sip, shared_sip) }.to raise_error Hyrax::Ingest::Errors::AmbiguousIngesterClass
      end

      after do
        Hyrax::Ingest::Ingester.unregister_class(WorkIngester)
        Object.send(:remove_const, :WorkIngester)
      end
    end
  end
end
