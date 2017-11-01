require 'hyrax/ingest/reporting/report'
require 'hyrax/ingest/errors'

module Hyrax
  module Ingest
    module HasReport
      def report
        @report ||= Hyrax::Ingest::Reporting::Report.new
      end

      def report=(report)
        raise Hyrax::Ingest::Errors::InvalidIngestReport unless report.is_a? Hyrax::Ingest::Reporting::Report
        @report = report
      end
    end
  end
end
