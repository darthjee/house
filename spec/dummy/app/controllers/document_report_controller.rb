# frozen_string_literal: true

class DocumentReportController < ApplicationController
  include Mercy

  status_report :error_a, base_scope: :type_a, clazz: Document
  status_report :error_b, scope: :'type_b.with_error', clazz: Document
  status_report :error_c, clazz: Document, threshold: 0.5,
                          scope: "status = 'error'",
                          base_scope: "doc_type = 'c'"

  status_report :total, type: :range, minimum: 1,
                        clazz: Document, on: :range
  status_report :error, type: :range, maximum: 10,
                        scope: :with_error,
                        clazz: Document, on: :range

  def error_status
    render_status
  end

  def range_status
    render_status(:range)
  end
end
