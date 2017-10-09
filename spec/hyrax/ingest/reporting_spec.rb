require 'spec_helper'
require 'hyrax/ingest/reporting'

describe Hyrax::Ingest::Reporting do
  before do
    class TestClass1; include Hyrax::Ingest::Reporting; end
    class TestClass2; include Hyrax::Ingest::Reporting; end
  end

  describe '#report' do
    it 'returns a SharedReporter object' do
      expect(TestClass1.new.report).to be_a Hyrax::Ingest::SharedReporter
    end

    it 'returns the same (singleton) Logger object when included in 2 different classes' do
      expect(TestClass1.new.report).to eq TestClass2.new.report
    end
  end

  # Remove our test classes from the namespace.
  after { [:TestClass1, :TestClass2].each { |sym| Object.send(:remove_const, sym) } }
end

