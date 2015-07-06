module JsonParser
  module TypeCast
    def to_period(value)
      Bidu::PeriodParser.parse(value)
    end
  end
end
