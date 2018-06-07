module Arstotzka
  module TypeCast
    def to_period(value)
      Mercy::PeriodParser.parse(value)
    end

    def to_infinity_float(value)
      return -Float::INFINITY if value.match(/-inf/)
      return Float::INFINITY if value.match(/inf/)

      value.to_f
    end
  end
end
