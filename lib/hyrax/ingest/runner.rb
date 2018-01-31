require 'hyrax/ingest/configuration'
require 'hyrax/ingest/ingester'
require 'hyrax/ingest/reporting'
require 'hyrax/ingest/has_sip'
require 'hyrax/ingest/has_shared_sip'
require 'hyrax/ingest/has_iteration'
require 'hyrax/ingest/has_logger'
require 'hyrax/ingest/has_report'

module Hyrax
  module Ingest
    class Runner
      include Reporting
      include Interloper
      include HasSIP
      include HasSharedSIP
      include HasIteration
      include HasReport
      include HasLogger

      attr_reader :config

      before(:run!) do
        logger.info "Ingest iteration #{iteration+1} started."
        report.stat[:datetime_started] ||= DateTime.now
        report.stat[:batch_size] ||= 1
        report.stat[:files] += sip.file_paths if sip
        report.stat[:files] += shared_sip.file_paths if shared_sip
        report.stat[:config_file_path] = config.config_file_path
      end

      after(:run!) do
        logger.info "Ingest iteration #{iteration+1} complete."
        report.stat[:datetime_completed] ||= DateTime.now
      end

      def initialize(config_file_path:, sip_path: nil, shared_sip_path: nil, iteration: 0)
        self.sip = SIP.new(path: sip_path) if sip_path
        self.shared_sip = shared_sip_path != nil ? SIP.new(path: shared_sip_path) : nil
        self.iteration = iteration.to_i
        @config = Hyrax::Ingest::Configuration.new(config_file_path: config_file_path)
      end

      def run!
        ingesters.collect { |ingester| ingester.run! }
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
              ingester.logger = logger if ingester.respond_to? :logger=
              ingester.report = report if ingester.respond_to? :report=
            end
          end
        end
    end
  end
end