# frozen_string_literal: true

module Mercy
  class Report
    class Dummy < Report
      ALLOWED_PARAMETERS = %i[period threshold].freeze
      def initialize(options); end
    end
  end
end

class Dummy
  ALLOWED_PARAMETERS = %i[period threshold].freeze
  def initialize(options); end
end
