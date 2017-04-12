require 'spec_helper'
require 'hyrax/ingest/attribute_ingester.rb' # FIXME: improve include config to deprecate this

RSpec.describe Hyrax::Ingest::AttributeIngester do
  let(:id) { 'file:///foo/bar' }
  # NOTE: AttributeIngesterTestFactory defined below within this spec.
  let(:factory) { AttributeIngesterTestFactory }
  let(:context_mapping) { YAML.load_file(Rails.root.join('spec', 'config', 'test_context.yml')) }
  let(:options) { { factory: factory, context: context_mapping } }
  let(:attributes) { Hash.new }
  let(:att_ingester) { described_class.new(id, attributes, options) }

  describe "#attributes" do
    context "when using the default context mapping" do
      let(:attributes) { { foo: 'bar' } }
      it "drops the attribute" do
        expect(att_ingester.attributes['foobar']).to be_nil
      end
    end

   context "with a context mapping" do
      context "without a destination" do
        let(:context_mapping) { Hash.new }
        let(:attributes) { { title: 'foobar' } }
        it "drops the attribute" do
          expect(att_ingester.attributes['title']).to be_nil
        end
      end

      context "with a destination" do
        context "with a different name" do
          let(:attributes) { { foo: 'bar' } }
          let(:context_mapping) do
            {
              "@context" => {
                "id" => "@id",
                "foo" => {
                  "@id" => "http://opaquenamespace.org/ns/mods/titleForSort"
                }
              }
            }
          end

          it "passes the value to the new attribute" do
            expect(att_ingester.attributes['sort_title']).to eq 'bar'
          end
        end

        context "with a single-valued attribute" do
          context "with a single value" do
            let(:attributes) { { sort_title: 'foobar' } }
            it "passes the attribute" do
              expect(att_ingester.attributes['sort_title']).to eq 'foobar'
            end
          end

          context "with multiple values" do
            let(:attributes) { { sort_title: ['foo', 'bar'] } }
            # FIXME: the graph is accepting multiple values, and erroring out reading the att
            xit "passes the attribute, with the final value only" do
              expect(att_ingester.attributes['sort_title']).to eq 'bar'
            end
          end
        end

        context "with a multi-valued attribute" do
          context "with a single value" do
            let(:attributes) { { title: 'foobar' } }
            it "passes the attribute, array-wrapping the value" do
              expect(att_ingester.attributes['title']).to eq ['foobar']
            end
          end

          context "with multiple values" do
            let(:attributes) { { title: ['foo', 'bar'] } }
            it "passes the attribute, with all values" do
              expect(att_ingester.attributes['title']).to eq ['foo', 'bar']
            end
          end
        end
      end
    end
  end

  describe "#raw_attributes" do
    context "when using the default context mapping" do
      let(:attributes) { { foo: 'bar' } }
      it "drops the attribute" do
        expect(att_ingester.raw_attributes['foobar']).to be_nil
      end
    end

    context "with a context mapping" do
      context "without a destination" do
        let(:context_mapping) { Hash.new }
        let(:attributes) { { title: 'foobar' } }
        it "drops the attribute" do
          expect(att_ingester.raw_attributes['title']).to be_nil
        end
      end

      context "with a destination" do
        context "with a different name" do
          let(:attributes) { { foo: 'bar' } }
          let(:context_mapping) do
            {
              "@context" => {
                "id" => "@id",
                "foo" => {
                  "@id" => "http://opaquenamespace.org/ns/mods/titleForSort"
                }
              }
            }
          end

          it "passes the value to the new attribute" do
            expect(att_ingester.raw_attributes['sort_title']).to eq 'bar'
          end
        end


        context "with a single-valued attribute" do
          context "with a single value" do
            let(:attributes) { { sort_title: 'foobar' } }
            it "passes the attribute" do
              expect(att_ingester.raw_attributes['sort_title']).to eq 'foobar'
            end
          end


          context "with multiple values" do
            let(:attributes) { { sort_title: ['foo', 'bar'] } }
            it "passes the attribute, with the final value only" do
              expect(att_ingester.raw_attributes['sort_title']).to eq 'bar'
            end
          end
        end

        context "with a multi-valued attribute" do
          context "with a single value" do
            let(:attributes) { { title: 'foobar' } }
            it "passes the attribute, array-wrapping the value" do
              expect(att_ingester.raw_attributes['title']).to eq ['foobar']
            end
          end

          context "with multiple values" do
            let(:attributes) { { title: ['foo', 'bar'] } }
            it "passes the attribute, with all values" do
              expect(att_ingester.raw_attributes['title']).to eq ['foo', 'bar']
            end
          end
        end
      end
    end
  end
end

# Class used as a test factory for these tests.
# This is more straightforward than using mocks.
# TODO: Move to different location?
#class AttributeIngesterTestFactory < ActiveFedora::Base
#  property :sort_title, predicate: ::RDF::URI.new("http://opaquenamespace.org/ns/mods/titleForSort"), multiple: false
#  property :title, predicate: ::RDF::URI.new('http://purl.org/dc/terms/title'), multiple: true
#end
