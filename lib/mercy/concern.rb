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
  def render_status(key = :default)
    status = self.class.status_builder.build(key, params)
    status_hash = status.as_json.stringify_keys.to_deep_hash
    render json: status_hash, status: status.status
  end
end
