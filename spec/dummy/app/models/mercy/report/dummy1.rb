# frozen_string_literal: true

module Mercy
  class Report
    class Dummy1 < Mercy::Report
      DEFAULT_OPTION = {
        option_value: 1,
        other_option: 10
      }.freeze
      expose :option_value, :other_option, case: :snake
    end

    class Dummy2 < Dummy1; end

    class Dummy3 < Dummy1
      DEFAULT_OPTION = { option_value: 5 }.freeze
    end
  end
end
