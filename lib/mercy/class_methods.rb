# frozen_string_literal: true

module Mercy
  # @api public
  #
  # module exposing methods to register reports
  module ClassMethods
    # register a report
    #
    # @param id [String,Symbol] report identifier
    # @param options [Hash] report options (see the report type for more options)
    # @option options type [Symbol,Class] type of the report.
    #   When a +Class+ is given, this will be used as report class.
    #   When a +Symbol+ is given, cleass will be found as a class
    #   defined in {Mercy::Report Mercy::Report}
    #
    # @return [Array<Symbol>] Existing reports for configuration
    #
    # @example
    #   class Document < ActiveRecord::Base
    #     scope :with_error,   -> { where(status: :error) }
    #     scope :type_a,       -> { where(doc_type: :a) }
    #     scope :type_b,       -> { where(doc_type: :b) }
    #   end
    #
    #   class ExampleReportController < ApplicationController
    #     include Mercy
    #
    #     status_report :errors_a, base_scope: :type_a,
    #                              scope: :with_error,
    #                              clazz: Document,
    #                              external_key: :external_id
    #     status_report :errors_b, base_scope: :type_b,
    #                              scope: :with_error,
    #                              clazz: Document,
    #                              external_key: :external_id
    #
    #     def status
    #       render_status
    #     end
    #   end
    #
    #   Rails.application.routes.draw do
    #     resources :example_report, only: [] do
    #       get :status, on: :collection
    #     end
    #   end
    #
    #   49.times { Document.create(doc_type: :a) }
    #   3.times { Document.create(doc_type: :b) }
    #   Document.with_error.create(doc_type: :a, external_id: 10)
    #   Document.with_error.create(doc_type: :b, external_id: 20)
    #
    #    get '/example_reports/status'
    #    #returns http_status: 500
    #    # json:
    #    # {
    #    #   "status":"error",
    #    #   "errors_a":{
    #    #     "ids":[10],
    #    #     "percentage":0.02,
    #    #     "status":"ok"
    #    #   },
    #    #   "errors_b":{
    #    #     "ids":[20],
    #    #     "percentage":0.25,
    #    #     "status":"error"
    #    #   }
    #    # }
    def status_report(id, **options)
      options[:id] = id

      status_builder.add_report_config(id, options)
    end

    # @private
    # @api private
    #
    # Status report builder for class
    #
    # @return [Mercy::StatusBuilder]
    def status_builder
      @status_builder ||= Mercy::StatusBuilder.new
    end
  end
end
