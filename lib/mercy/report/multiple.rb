# frozen_string_literal: true

module Mercy
  class Report
    module Multiple
      def as_json
        {
          status: status
        }.merge(sub_reports_hash)
      end

      def error?
        sub_reports.any?(&:error?)
      end

      private

      def sub_reports_hash
        sub_reports.map(&:as_json).as_hash(reports_ids.map(&:to_s))
      end

      def sub_reports
        @sub_reports ||= reports_ids.map do |id|
          build_sub_report(id)
        end
      end

      def build_sub_report(id)
        sub_report_class.new(json.merge(key => id))
      end
    end
  end
end
