require 'spec_helper'

describe Arstotzka::TypeCast do
  describe 'yard' do
    subject(:caster) { described_class::Dummy }

    describe '.to_period' do
      it do
        expect(caster.to_period('2days')).to be_a(Integer)
      end

      it 'converts string to period' do
        expect(caster.to_period('2days')).to eq(2.days)
      end
    end

    describe '.to_infinity_float' do
      it do
        expect(caster.to_infinity_float('-0.75')).to be_a(Float)
      end

      it 'converts to float' do
        expect(caster.to_infinity_float('-0.75')).to eq(-0.75)
      end

      context 'when converting infinity' do
        it 'converts to float' do
          expect(caster.to_infinity_float('inf'))
            .to eq(Float::INFINITY)
        end
      end

      context 'when converting negative infinity' do
        it 'converts to float' do
          expect(caster.to_infinity_float('-inf'))
            .to eq(-Float::INFINITY)
        end
      end
    end
  end
end
