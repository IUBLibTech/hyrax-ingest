require 'hyrax/ingest/configuration'
require 'hyrax/ingest/ingester'
require 'hyrax/ingest/reporting'
require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_shared_sip'
require 'hyrax/ingest/has_iteration'

module Hyrax
  module Ingest
    class Runner
      include Reporting

      attr_reader :config

      include HasSIP
      include HasSharedSIP
      include HasIteration

      def initialize(config_file_path:, sip_path: nil, shared_file_path: nil, iteration: 0)
        self.sip = SIP.new(path: sip_path) if sip_path
        self.shared_sip = shared_file_path != nil ? SIP.new(path: shared_file_path) : nil
        self.iteration = iteration.to_i
        @config = Hyrax::Ingest::Configuration.new(config_file_path: config_file_path)
      end

      def run!
        ingesters.collect { |ingester| ingester.run! }
        sip.close_all_files if sip
      end

      def errors
        @errors ||= []
      end

      # TODO: Does not yet return IDs of associated objects that were ingested
      # as assocaited objects (i.e. objects that are nested under other
      # objects in the ingest configuration). It only returns IDs for objects that
      # are ingested per the top-level of ingest configuration.
      def ingested_ids_by_type
        {}.tap do |h|
          ingesters.each do |ingester|
            if ingester.respond_to? :af_model
              h[ingester.af_model.class] ||= []
              h[ingester.af_model.class] << ingester.af_model.id
            end
          end
        end
      end

      private

        def ingesters
          @ingesters ||= config.ingester_configs.map do |ingester_config|
            # TODO: Better way to handle invalid config than throwing big
            # error msgs from here.
            raise Hyrax::Ingest::Errors::InvalidConfig.new('Ingester config must be a single key value pair, where the key is the name of the ingester, and the value is the ingester configuration.') unless ingester_config.respond_to? :keys
            ingester_name = ingester_config.keys.first
            ingester_options = ingester_config.values.first
            Hyrax::Ingest::Ingester.factory(ingester_name, ingester_options).tap do |ingester|
              ingester.sip = sip if ingester.respond_to? :sip=
              ingester.shared_sip = shared_sip if ingester.respond_to? :shared_sip=
              ingester.iteration = iteration if ingester.respond_to? :iteration=
            end
          end
        end
    end
  end
end