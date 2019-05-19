# frozen_string_literal: true

class ErrorReportController < ApplicationController
  include Mercy

  status_report :error_a, base_scope: :type_a, clazz: Document
  status_report :error_b, scope: :'type_b.with_error', clazz: Document
  status_report :error_c, clazz: Document, threshold: 0.5,
    scope: "status = 'error'", base_scope: "doc_type = 'c'"

  def status
    render_status
  end
end
