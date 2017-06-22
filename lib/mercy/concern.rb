module Mercy
  extend ActiveSupport::Concern

  def render_status(key = :default)
    status = self.class.status_builder.build(key, params)
    render json: status.as_json.stringify_keys.to_deep_hash, status: status.status
  end
end
