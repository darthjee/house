# frozen_string_literal: true

module Mercy
  module ClassMethods
    def status_report(*attr_names)
      id = attr_names.first
      options = {
        id: id
      }.merge(attr_names.extract_options!)

      status_builder.add_report_config(id, options)
    end

    def status_builder
      @status_builder ||= Mercy::StatusBuilder.new
    end
  end
end
