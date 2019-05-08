# frozen_string_literal: true

require 'spec_helper'

describe Mercy::PeriodParser do
  subject { described_class }

  it_behaves_like 'a method that knows how to parse time', :parse,
                  '3' => 3.seconds,
                  '3seconds' => 3.seconds,
                  '3minutes' => 3.minutes,
                  '3hours' => 3.hours,
                  '3days' => 3.days,
                  '3months' => 3.months,
                  '3years' => 3.years

  context 'when value is already a period' do
    it 'returns the value itself' do
      expect(described_class.parse(3.minutes)).to eq(3.minutes)
    end
  end
end
