module Bidu
  module House
    module Report
      class Error
        include JsonParser

        ALLOWED_PARAMETERS=[:period, :threshold]

        attr_reader :json

        json_parse :threshold, type: :float
        json_parse :period, type: :period
        json_parse :scope, :id, :clazz, :external_key, case: :snake

        def initialize(options)
          @json = {
            external_key: :id,
            threshold: 0.02,
            period: 1.day,
            scope: :with_error
          }.merge(options)
        end

        def status
          @status ||= error? ? :error : :ok
        end

        def percentage
          @percentage ||= fetch_percentage
        end

        def scoped
          @scoped ||= fetch_scoped
        end

        def error?
          percentage > threshold
        end

        def as_json
          {
            ids: scoped.pluck(external_key),
            percentage: percentage
          }
        end

        private

        def fetch_percentage
          if (scope.is_a?(String))
            last_entires.percentage(scope)
          else
            last_entires.percentage(*(scope.to_s.split('.').map(&:to_sym)))
          end
        end

        def fetch_scoped
          scope.to_s.split('.').inject(last_entires) do |entries, method|
            entries.public_send(method)
          end
        end

        def last_entires
          @last_entires ||= clazz.where('updated_at >= ?', period.seconds.ago)
        end
      end
    end
  end
end
