# frozen_string_literal: true

module Mercy
  class Report
    class DocTypeError < Mercy::Report::Error
      ALLOWED_PARAMETERS = %i[period threshold].freeze
      DEFAULT_OPTION = {
        threshold: 0.25,
        clazz: Document,
        external_key: :external_id
      }.freeze

      expose :doc_type, case: :snake

      def base
        super.where(doc_type: doc_type)
      end
    end
  end
end
