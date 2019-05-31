# frozen_string_literal: true

module Mercy
  class Report
    module Multiple
      class Successes < Mercy::Report
        include Mercy::Report::Multiple
        DEFAULT_OPTION = {
          doc_type: %i[a b]
        }.freeze
        expose :doc_type, case: :snake

        def reports_ids
          [doc_type].flatten
        end

        def sub_report_class
          Mercy::Report::Success
        end

        def key
          :doc_type
        end
      end
    end
  end
end
