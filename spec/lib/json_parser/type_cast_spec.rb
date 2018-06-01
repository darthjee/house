require 'spec_helper'

describe JsonParser::TypeCast do
  subject { dummy_class.new }

  let(:dummy_class) { Class.new { include JsonParser::TypeCast } }

  describe '.to_period' do
    it_behaves_like 'a method that knows how to parse time', :to_period, {
      '3' => 3.seconds,
      '3seconds' => 3.seconds,
      '3minutes' => 3.minutes,
      '3hours' => 3.hours,
      '3days' => 3.days,
      '3months' => 3.months,
      '3years' => 3.years
    }
  end
end
