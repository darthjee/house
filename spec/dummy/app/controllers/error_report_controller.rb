# frozen_string_literal: true

class ErrorReportController < ApplicationController
  include Mercy

  status_report :error_a, base_scope: :type_a, clazz: Document
  status_report :error_b, scope: :'type_b.with_error', clazz: Document

  def status
    render_status
  end
end
