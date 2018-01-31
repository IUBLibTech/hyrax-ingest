require 'spec_helper'
require 'hyrax/ingest/reporting'
require 'hyrax/ingest/reporting/report'

describe Hyrax::Ingest::Reporting::Report do
  let(:subject) { described_class.new }
  before { subject.stat[:foo] = 123 }

  describe '#render' do
    let(:default_template_path) { create_tempfile("default template, foo = <%= stat[:foo] %>").path }
    let(:template_path) { create_tempfile("test template, foo = <%= stat[:foo] %>").path }
    before { Hyrax::Ingest::Reporting.config.default_template_path =  default_template_path }

    it 'renders the given template' do
      expect(subject.render(template_path: template_path)).to eq 'test template, foo = 123'
    end

    it 'renders the default template, if no template is passed' do
      expect(subject.render).to eq 'default template, foo = 123'
    end
  end

  def create_tempfile(content)
    Tempfile.new.tap do |file|
      file.write content
      file.close
    end
  end
end
