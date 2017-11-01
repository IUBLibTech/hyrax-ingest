require 'spec_helper'
require 'hyrax/ingest/reporting/configuration'

describe Hyrax::Ingest::Reporting::Configuration do
  subject { described_class.new }
  describe 'default_template_path=' do

    context 'when given a path to an actual file' do
      it 'does not raise an error' do
        expect { subject.default_template_path = Tempfile.new.path }.to_not raise_error
      end
    end

    context 'when given a path that does not exist' do
      it 'raises a Hyrax::Ingest::Errors::ConfigurationError' do
        expect { subject.default_template_path = 'does/not/exist' }.to raise_error Hyrax::Ingest::Errors::ConfigurationError
      end
    end
  end
end
