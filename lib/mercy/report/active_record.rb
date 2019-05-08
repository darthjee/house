# frozen_string_literal: true

module Mercy
  class Report
    class ActiveRecord < Report
      expose :period, type: :period
      expose :clazz, :base_scope, case: :snake

      private

      def fetch_scoped(base, scope)
        if scope.is_a?(Symbol)
          scope.to_s.split('.').inject(base) do |entries, method|
            entries.public_send(method)
          end
        else
          base.where(scope)
        end
      end

      def last_entries
        @last_entries ||= base.where('updated_at >= ?', period.seconds.ago)
      end

      def base
        fetch_scoped(clazz, base_scope)
      end
    end
  end
end
