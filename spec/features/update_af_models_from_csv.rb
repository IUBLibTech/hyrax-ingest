require 'hyrax_helper'
require 'hyrax/ingest/batch_runner'

RSpec.describe "Updating AF Models from CSV" do

  before do
    class MyModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title'
      property :description, predicate: 'http://example.org#description'
    end
  end

  context "with config from update_af_models_from_csv.yml", :clean_fedora do

    before do
      my_model_attrs = [ { id: '123', title: 'Title 1', description: 'Description 1' }, { id: '456', title: 'Title 2', description: 'Description 2' } ]

      my_model_attrs.each do |fs|
        MyModel.new.tap do |model|
          model.id = fs[:id]
          model.title += [fs[:title]]
          model.description += [fs[:description]]
          model.save!
        end
      end

      @runner = Hyrax::Ingest::BatchRunner.new(
        config_file_path: "#{fixture_path}/ingest_config_examples/update_af_models_from_csv.yml",
        shared_sip_path: "#{fixture_path}/sip_examples/update_af_models_from_csv",
        iterations: 2
      )

      @runner.run!
    end

    it "updates the titles on the models" do
      expect(MyModel.find("123").title.first).to eq("Test Title 1")
    end
  end

  after do
    Object.send(:remove_const, :MyModel)
  end
end