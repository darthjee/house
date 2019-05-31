# frozen_string_literal: true

module Mercy
  class Report
    class Success < Mercy::Report::Range
      ALLOWED_PARAMETERS = %i[period minimum maximum].freeze
      DEFAULT_OPTION = {
        clazz: Document
      }.freeze

      expose :doc_type, case: :snake

      def base
        super.with_success.where(doc_type: doc_type)
      end
    end
  end
end
