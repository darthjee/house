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

  status_report :successes, on: :successes,
                            clazz: Document,
                            type: Mercy::Report::Multiple::Successes,
                            minimum: 10

  def status
    render_status
  end

  def count_status
    render_status(:successes)
  end
end
