# frozen_string_literal: true

module Mercy
  extend ActiveSupport::Concern

  def render_status(key = :default)
    status = self.class.status_builder.build(key, params)
    status_hash = status.as_json.stringify_keys.to_deep_hash
    render json: status_hash, status: status.status
  end
end
