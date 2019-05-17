# frozen_string_literal: true

class DocumentReportController < ApplicationController
  include Mercy

  status_report :error_a, clazz: Document

  def status
    render_status
  end
end
