require 'active_record/relation_ext'
require 'concern_builder'
require 'bidu/core_ext'

module Bidu
  module House
    extend ActiveSupport::Concern

    require 'bidu/house/error_report'
    require 'bidu/house/status'
    require 'bidu/house/class_methods'
    require 'bidu/house/class_methods/builder'
  end
end
