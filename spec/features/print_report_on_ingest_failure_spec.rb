require 'spec_helper'
require 'support/create_tempfile_helper'
require 'hyrax/ingest/batch_runner'

context 'when an ingest fails' do

  let(:test_report_path) { create_tempfile.path }
  let(:test_report_content) { File.read(test_report_path) }
  let(:iterations) { 100 }
  let(:iteration_to_fail) { rand(iterations) }
  let(:bullshit_error) { "all your base are belong to us" }
  let(:batch_runner) { Hyrax::Ingest::BatchRunner.new(config_file_path: "#{fixture_path}/ingest_config_examples/print_report_on_ingest_failure.yml", iterations: iterations) }

  before do
    # Define TestModel
    class TestModel < ActiveFedora::Base
      property :title, predicate: 'http://example.org#title'
    end

    # Configure reporting to write to the temp test report file.
    Hyrax::Ingest::Reporting.config.default_output_file = test_report_path

    # Tell a random Runner within the BatchRunner to fail when Runner#run! is called.
    allow(batch_runner.send(:runners)[iteration_to_fail]).to receive(:run!).and_raise(bullshit_error)
  end

  it 'an error is raised and the report summary is printed, with the error message, and the number of records ingested' do
    # Expect the report to show that models were saved up until the failure.
    expect { batch_runner.run! }.to raise_error bullshit_error
    expect(test_report_content).to include bullshit_error
    expect(batch_runner.report.stat[:count, :models_saved]).to eq iteration_to_fail
  end

  # Undefine TestModel
  after { Object.send(:remove_const, :TestModel) }
end
