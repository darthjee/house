module JsonParser
  module TypeCast
    def to_period(value)
      Mercy::PeriodParser.parse(value)
    end
  end
end
