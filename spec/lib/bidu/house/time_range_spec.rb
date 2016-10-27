require 'spec_helper'

describe Bidu::House::TimeRange do
  let(:subject) { described_class.new(attributes) }

  describe '#include?' do
    context 'when defining hours' do
      let(:attributes) { { from: '06:00', to: '20:00'} }

      context 'when now is between given range time' do
        let(:now) { Time.local(2016, 10, 10, 7, 0, 0) }

        it do
          expect(subject.include? now).to be_truthy
        end
      end

      context 'when now is a second after start time' do
        let(:now) { Time.local(2016, 10, 10, 6, 0, 1) }

        it do
          expect(subject.include? now).to be_truthy
        end
      end

      context 'when now is right on start time' do
        let(:now) { Time.local(2016, 10, 10, 6, 0, 0) }

        it do
          expect(subject.include? now).to be_truthy
        end
      end

      context 'when now is a second before start time' do
        let(:now) { Time.local(2016, 10, 10, 5, 59, 59) }

        it do
          expect(subject.include? now).to be_falsey
        end
      end

      context 'when now is before start time' do
        let(:now) { Time.local(2016, 10, 10, 5, 0, 0) }

        it do
          expect(subject.include? now).to be_falsey
        end
      end

      context 'when now is a second before the end time' do
        let(:now) { Time.local(2016, 10, 10, 19, 59, 59) }

        it do
          expect(subject.include? now).to be_truthy
        end
      end

      context 'when now is on end time' do
        let(:now) { Time.local(2016, 10, 10, 20, 0, 0) }

        it do
          expect(subject.include? now).to be_truthy
        end
      end

      context 'when now is a second after end time' do
        let(:now) { Time.local(2016, 10, 10, 20, 0, 1) }

        it do
          expect(subject.include? now).to be_falsey
        end
      end

      context 'when now is after end time' do
        let(:now) { Time.local(2016, 10, 10, 21, 0, 0) }

        it do
          expect(subject.include? now).to be_falsey
        end
      end
    end
  end
end
