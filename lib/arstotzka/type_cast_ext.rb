# frozen_string_literal: true

module Arstotzka
  module TypeCast
    def to_period(value)
      Mercy::PeriodParser.parse(value)
    end

    def to_infinity_float(value)
      return value if value.is_a?(Numeric)
      return -Float::INFINITY if value =~ /-inf/
      return Float::INFINITY if value =~ /inf/

      value.to_f
    end
  end
end
