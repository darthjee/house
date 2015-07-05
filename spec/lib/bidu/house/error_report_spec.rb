require 'spec_helper'

describe Bidu::House::ErrorReport do
  let(:errors) { 1 }
  let(:successes) { 1 }
  let(:old_errors) { 0 }
  let(:threshold) { 0.02 }
  let(:period) { 1.day }
  let(:options) do
    {
      period: period,
      threshold: threshold,
      scope: :with_error,
      clazz: Document
    }
  end
  let(:subject) { described_class.new(options) }
  before do
    Document.all.each(&:destroy)
    errors.times { Document.create status: :error }
    successes.times { Document.create status: :success }
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
end
