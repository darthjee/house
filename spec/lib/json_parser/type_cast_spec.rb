require 'spec_helper'

describe JsonParser::TypeCast do
  subject { dummy_class.new }

  let(:dummy_class) { Class.new { include JsonParser::TypeCast } }

  describe '#to_period' do
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

  describe '#to_infinity_float' do
    context 'when value can be converted to integer' do
      let(:value) { (Random.rand * 201).to_i - 100 }

      it 'converts to integer' do
        expect(subject.to_infinity_float(value.to_s)).to eq(value)
      end

      it do
        expect(subject.to_infinity_float(value.to_s)).to be_a(Float)
      end
    end

    context 'when value is inf' do
      let(:value) { 'inf' }

      it 'converts to integer' do
        expect(subject.to_infinity_float(value)).to eq(1 / 0.0)
      end

      it do
        expect(subject.to_infinity_float(value)).to be_a(Float)
      end
    end

    context 'when value is -inf' do
      let(:value) { '-inf' }

      it 'converts to integer' do
        expect(subject.to_infinity_float(value)).to eq(-1 / 0.0)
      end

      it do
        expect(subject.to_infinity_float(value)).to be_a(Float)
      end
    end
  end
end
