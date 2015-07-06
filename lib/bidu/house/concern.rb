module Bidu
  module House
    extend ActiveSupport::Concern

    def render_status(key)
      status = self.class.status_builder.build(key, params)
      render json: status.as_json, status: status.status
    end
  end
end
