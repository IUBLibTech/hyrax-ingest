require 'hyrax_helper'
require 'hyrax/ingest/runner'

RSpec.describe "Updating an ActiveFedora model" do

  before do
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title'
    end
  end

  context "with config from update_af_model_by_id.yml", :clean_fedora do
    let(:config_file_path) { "#{fixture_path}/ingest_config_examples/update_af_model_by_id.yml" }
    before do
      MyModel.new.tap do |model|
        model.id = '123'
        model.title += ['orig title']
        model.save!
      end

      Hyrax::Ingest::Runner.new(config_file_path: config_file_path).run!
    end

    it 'updates the model' do
      expect(MyModel.find('123').title.first).to eq 'updated title'
    end
  end

  after do
    Object.send(:remove_const, :MyModel)
  end
end
