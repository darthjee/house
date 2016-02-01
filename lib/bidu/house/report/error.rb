module Bidu
  module House
    module Report
      class Error
        include JsonParser

        ALLOWED_PARAMETERS=[:period, :threshold]

        attr_reader :json

        json_parse :threshold, type: :float
        json_parse :period, type: :period
        json_parse :scope, :id, :clazz, :base_scope, :external_key, case: :snake

        def initialize(options)
          @json = {
            external_key: :id,
            threshold: 0.02,
            period: 1.day,
            scope: :with_error,
            base_scope: :all
          }.merge(options)
        end

        def status
          @status ||= error? ? :error : :ok
        end

        def percentage
          @percentage ||= fetch_percentage
        end

        def scoped
          @scoped ||= fetch_scoped(last_entries, scope)
        end

        def error?
          @error ||= percentage > threshold
        end

        def status
          error? ? :error : :ok
        end

        def as_json
          {
            ids: scoped.pluck(external_key),
            percentage: percentage,
            status: status
          }
        end

        private

        def fetch_percentage
          if (scope.is_a?(Symbol))
            last_entries.percentage(*(scope.to_s.split('.').map(&:to_sym)))
          else
            last_entries.percentage(scope)
          end
        end

        def fetch_scoped(base, scope)
          if (scope.is_a?(Symbol))
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
end
