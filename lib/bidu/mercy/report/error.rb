module Bidu
  module Mercy
    class Report
      class Error < Report::ActiveRecord
        ALLOWED_PARAMETERS=[:period, :threshold]
        DEFAULT_OPTION = {
          external_key: :id,
          threshold: 0.02,
          period: 1.day,
          scope: :with_error,
          base_scope: :all,
          uniq: false
        }

        json_parse :threshold, type: :float
        json_parse :scope, :external_key, :uniq, :limit, case: :snake

        def initialize(options)
          super(self.class::DEFAULT_OPTION.merge(options))
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

        def as_json
          {
            ids: ids,
            percentage: percentage,
            status: status
          }
        end

        private

        def ids
          relation = scoped
          relation = relation.distinct if uniq
          relation = relation.limit(limit) if limit

          relation.pluck(external_key)
        end

        def fetch_percentage
          if (scope.is_a?(Symbol))
            last_entries.percentage(*(scope.to_s.split('.').map(&:to_sym)))
          else
            last_entries.percentage(scope)
          end
        end
      end
    end
  end
end
