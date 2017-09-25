require 'spec_helper'
require 'hyrax/ingest/logging'

describe Hyrax::Ingest::Logging do
  before do
    class TestClass1; include Hyrax::Ingest::Logging; end
    class TestClass2; include Hyrax::Ingest::Logging; end
  end

  describe '#logger' do
    it 'returns a Logger object' do
      expect(TestClass1.new.logger).to be_a Logger
    end

    it 'returns the same (singleton) Logger object when included in 2 different classes' do
      expect(TestClass1.new.logger).to eq TestClass2.new.logger
    end
  end

  # Remove our test classes from the namespace.
  after { [:TestClass1, :TestClass2].each { |sym| Object.send(:remove_const, sym) } }
end

