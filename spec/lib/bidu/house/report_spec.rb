require 'spec_helper'

describe Bidu::House::Report do
  describe '.default_options' do
    let(:report_class) { described_class::Dummy1 }
    let(:subject) { report_class.new }
    
    it 'setup the attributes using class default options' do
      expect(subject.option_value).to eq(1)
      expect(subject.other_option).to eq(10)
    end

    context 'when class inherit options' do
      let(:report_class) { described_class::Dummy2 }

      it 'setup the attributes using superclass default options' do
        expect(subject.option_value).to eq(1)
        expect(subject.other_option).to eq(10)
      end
    end

    context 'when class inherit options but overrides some' do
      let(:report_class) { described_class::Dummy3 }

      it 'setup the attributes using superclass default options' do
        expect(subject.option_value).to eq(5)
        expect(subject.other_option).to eq(10)
      end
    end
  end

  describe '#enabled?' do
    let(:subject) { described_class.new(options) }

    context 'when setting an operation_time' do
      let(:options) do
        { active: { from: '06:00', to: '20:00' } }
      end

      context 'when operating withing the time limit' do
        before { Timecop.freeze(Time.local(2016, 10, 10, 10, 0, 0)) }

        it do
          expect(subject.enabled?).to be_truthy
        end
      end

      context 'when operating outside the time limit' do
        before { Timecop.freeze(Time.local(2016, 10, 10, 23, 0, 0)) }

        it do
          expect(subject.enabled?).to be_falsey
        end
      end
    end
  end
end

