require 'spec_helper'

describe Bidu::House::At do
  let(:subject) { described_class.new(attributes) }

  describe '<' do
    context 'when defining hours' do
      let(:attributes) { { hour: 6 } }

      context 'when now is after given time' do
        let(:now) { Time.local(2016, 10, 10, 7, 0, 0) }

        it do
          expect(subject < now).to be_truthy
        end
      end

      context 'when now is a second after time' do
        let(:now) { Time.local(2016, 10, 10, 6, 0, 1) }

        it do
          expect(subject < now).to be_truthy
        end
      end

      context 'when now is right on time' do
        let(:now) { Time.local(2016, 10, 10, 6, 0, 0) }

        it do
          expect(subject < now).to be_falsey
        end
      end

      context 'when now is a second before time' do
        let(:now) { Time.local(2016, 10, 10, 5, 59, 59) }

        it do
          expect(subject < now).to be_falsey
        end
      end

      context 'when now is before time' do
        let(:now) { Time.local(2016, 10, 10, 5, 0, 0) }

        it do
          expect(subject < now).to be_falsey
        end
      end
    end
  end
end
