require 'spec_helper'

describe Bidu::House::ErrorReport do
  let(:errors) { 1 }
  let(:successes) { 1 }
  let(:old_errors) { 0 }
  let(:threshold) { 0.02 }
  let(:period) { 1.day }
  let(:external_key) { :external_id }
  let(:options) do
    {
      period: period,
      threshold: threshold,
      scope: :with_error,
      clazz: Document,
      external_key: external_key
    }
  end
  let(:subject) { described_class.new(options) }
  before do
    Document.all.each(&:destroy)
    successes.times { Document.create status: :success }
    errors.times do |i|
      Document.create status: :error, external_id: 10 * successes + i, outter_external_id: i
    end
    old_errors.times { Document.create status: :error, created_at: 2.days.ago, updated_at: 2.days.ago }
  end

  describe '#status' do
    context 'when are more errors than the allowed by the threshold' do
      let(:errors) { 1 }
      let(:successes) { 3 }
      it { expect(subject.status).to eq(:error) }
    end

    context 'when the threshold is 0 and there are no errors' do
      let(:errors) { 0 }
      let(:threshold) { 0 }
      it { expect(subject.status).to eq(:ok) }
    end

    context 'when the threshold is 100% and there is 100% error' do
      let(:successes) { 0 }
      let(:threshold) { 1 }
      it { expect(subject.status).to eq(:ok) }
    end

    context 'when there are no documents' do
      let(:successes) { 0 }
      let(:errors) { 0 }
      it { expect(subject.status).to eq(:ok) }
    end

    context 'when there are older errors out of the period' do
      let(:old_errors) { 2 }
      let(:threshold) { 0.5 }

      it 'ignores the older errros' do
        expect(subject.status).to eq(:ok)
      end

      context 'when passing a bigger period' do
        let(:period) { 3.days }

        it 'consider the older errros' do
          expect(subject.status).to eq(:error)
        end
      end
    end
  end

  describe 'percentage' do
    context 'when there are 25% erros' do
      let(:errors) { 1 }
      let(:successes) { 3 }
      it { expect(subject.percentage).to eq(0.25) }
    end

    context 'when there are no errors' do
      let(:errors) { 0 }
      let(:threshold) { 0 }
      it { expect(subject.percentage).to eq(0) }
    end

    context 'when there is 100% error' do
      let(:successes) { 0 }
      let(:threshold) { 1 }
      it { expect(subject.percentage).to eq(1) }
    end

    context 'when there are no documents' do
      let(:successes) { 0 }
      let(:errors) { 0 }
      it { expect(subject.percentage).to eq(0) }
    end

    context 'when there are older errors out of the period' do
      let(:old_errors) { 2 }

      it 'ignores the older errros' do
        expect(subject.percentage).to eq(0.5)
      end

      context 'when passing a bigger period' do
        let(:period) { 3.days }

        it 'consider the older errros' do
          expect(subject.percentage).to eq(0.75)
        end
      end
    end
  end

  describe '#scoped' do
    context 'when there are 25% erros' do
      let(:errors) { 1 }
      let(:successes) { 3 }
      it 'returns only the scoped documents' do
        expect(subject.scoped.count).to eq(1)
      end
    end

    context 'when there are no errors' do
      let(:errors) { 0 }
      let(:threshold) { 0 }
      it { expect(subject.scoped).to be_empty }
    end

    context 'when there are no documents' do
      let(:successes) { 0 }
      let(:errors) { 0 }
      it { expect(subject.scoped).to be_empty }
    end

    context 'when there are older errors out of the period' do
      let(:old_errors) { 2 }

      it 'ignores the older errros' do
        expect(subject.scoped.count).to eq(1)
      end

      context 'when passing a bigger period' do
        let(:period) { 3.days }

        it 'consider the older errros' do
          expect(subject.scoped.count).to eq(3)
        end
      end
    end
  end

  describe '#as_json' do
    context 'when there are 75% erros' do
      let(:errors) { 3 }
      let(:successes) { 1 }
      let(:ids_expected) { [10, 11, 12] }
      let(:expected) do
        { ids: ids_expected, percentage: 0.75 }
      end

      it 'returns the external keys and error percentage' do
        expect(subject.as_json).to eq(expected)
      end

      context 'when configurated with different external key' do
        let(:external_key) { :outter_external_id }
        let(:ids_expected) { [0, 1, 2] }

        it 'returns the correct external keys' do
          expect(subject.as_json).to eq(expected)
        end
      end

      context 'when configurated without external key' do
        before { options.delete(:external_key) }
        let(:ids_expected) { Document.with_error.map(&:id) }

        it 'returns the ids as default id' do
          expect(subject.as_json).to eq(expected)
        end
      end
    end
  end
end
