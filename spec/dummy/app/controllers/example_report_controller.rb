# frozen_string_literal: true

class ExampleReportController < ApplicationController
  include Mercy

  status_report :errors_a, base_scope: :type_a,
                           scope: :with_error,
                           clazz: Document,
                           external_key: :external_id
  status_report :errors_b, base_scope: :type_b,
                           scope: :with_error,
                           clazz: Document,
                           external_key: :external_id

  def status
    render_status
  end
end
