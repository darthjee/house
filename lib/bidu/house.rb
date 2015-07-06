require 'active_record/relation_ext'
require 'concern_builder'
require 'bidu/core_ext'
require 'bidu/period_parser'
require 'json_parser'
require 'json_parser/type_cast_ext'

module Bidu
  module House
    require 'bidu/house/concern'
    require 'bidu/house/error_report'
    require 'bidu/house/status'
    require 'bidu/house/report_builder'
    require 'bidu/house/status_builder'
    require 'bidu/house/class_methods'
    require 'bidu/house/class_methods/builder'
  end
end
