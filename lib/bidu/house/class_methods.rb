module Bidu::House::ClassMethods

  def status_report(*attr_names)
    options = {
    }.merge(attr_names.extract_options!)

    self.status_builder.add_report_config(attr_names.first, options)
  end
end
