class Bidu::House::Report::Dummy1 < Bidu::House::Report
  DEFAULT_OPTION = {
    option_value: 1,
    other_option: 10
  }
  json_parse :option_value, :other_option, case: :snake
end
class Bidu::House::Report::Dummy2 < Bidu::House::Report::Dummy1; end
class Bidu::House::Report::Dummy3 < Bidu::House::Report::Dummy1
  DEFAULT_OPTION = { option_value: 5 }
end

class Bidu::House::Report::Dummy < Bidu::House::Report
end


