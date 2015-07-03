require 'active_record'

module ActiveRecord
  class Relation
    def percentage(*filters)
      count == 0 ?
        0 : where(*filters).count * 1.0 / count
    end
  end
end
