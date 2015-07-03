module Bidu::House::ClassMethods

  def status_report(*attr_names)
    options = {
    }.merge(attr_names.extract_options!)

    builder = Builder.new(attr_names, self, options)
    builder.build
  end
end
