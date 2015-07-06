module Bidu
  module House
    extend ActiveSupport::Concern

    included do
      class << self
        def status_builder
          @status_builder ||= Bidu::House::StatusBuilder.new
        end
      end

      def render_status(key)
        status = self.class.status_builder.build(key, params)
        render json: status.as_json, status: status.status
      end
    end
  end
end
