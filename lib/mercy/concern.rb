# frozen_string_literal: true

# @api public
#
# Concern exposing methods needed to build reports
module Mercy
  extend ActiveSupport::Concern

  # Render the status
  #
  # @param key [:Symbol] key of the configured report
  #
  # @return [String] Json rendered
  #
  # @example (see Mercy::ClassMethods#status_report)
  #
  # @example
  #   class Document < ActiveRecord::Base
  #     scope :with_success, -> { where(status: :success) }
  #   end
  #
  #   module Mercy
  #     class Report
  #       class Success < Mercy::Report::Range
  #         ALLOWED_PARAMETERS = %i[period minimum maximum].freeze
  #         DEFAULT_OPTION = {
  #           clazz: Document
  #         }.freeze
  #
  #         expose :doc_type, case: :snake
  #
  #         def base
  #           super.with_success.where(doc_type: doc_type)
  #         end
  #       end
  #     end
  #   end
  #
  #   module Mercy
  #     class Report
  #       module Multiple
  #         class Successes < Mercy::Report
  #           include Mercy::Report::Multiple
  #           DEFAULT_OPTION = {
  #             doc_type: %i[a b]
  #           }.freeze
  #           expose :doc_type, case: :snake
  #
  #           def reports_ids
  #             [doc_type].flatten
  #           end
  #
  #           def sub_report_class
  #             Mercy::Report::Success
  #           end
  #
  #           def key
  #             :doc_type
  #           end
  #         end
  #       end
  #     end
  #   end
  #
  #   class ExampleReportController < ApplicationController
  #     include Mercy
  #
  #     status_report :successes, on: :successes,
  #                               clazz: Document,
  #                               type: Mercy::Report::Multiple::Successes,
  #                               minimum: 10
  #
  #     def status
  #       render_status
  #     end
  #
  #     def count_status
  #       render_status(:successes)
  #     end
  #   end
  #
  #   Rails.application.routes.draw do
  #     resources :example_report, only: [] do
  #       get :count_status, on: :collection
  #     end
  #   end
  #
  #   10.times { Document.with_success.create(doc_type: :a) }
  #   2.times  { Document.with_success.create(doc_type: :b) }
  #
  #   get '/example_reports/count_status'
  #   #returns http_status: 500
  #   # json:
  #   # {
  #   #   'status' => 'error',
  #   #   'successes' => {
  #   #   'status' => 'error',
  #   #   'a' => {
  #   #     'count' =>  10,
  #   #     'status' => 'ok'
  #   #   },
  #   #   'b' => {
  #   #     'count' =>  2,
  #   #     'status' => 'error'
  #   #   }
  #   # }
  def render_status(key = :default)
    status = self.class.status_builder.build(key, params)
    status_hash = status.as_json.stringify_keys.to_deep_hash
    render json: status_hash, status: status.status
  end
end
