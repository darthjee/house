require 'active_record'

module ActiveRecord
  class Relation
    def percentage(*filters)
      return 0 if count == 0

      if filters.first.is_a?(Symbol)
        filtered = filters.inject(self) do |relation, scope|
          relation.public_send(scope)
        end
      else
        filtered = where(*filters)
      end

      filtered.count * 1.0 / count
    end
  end
end
