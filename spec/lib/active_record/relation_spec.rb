require 'spec_helper'

describe ActiveRecord::Relation do
  describe '#percentage' do
    let(:error_number) { 1 }
    let(:success_number) { 1 }

    before do
      Document.all.each(&:destroy)
      error_number.times { Document.create(status: :error) }
      success_number.times { Document.create(status: :success) }
    end

    context 'when there are 50% documents with error' do
      it do
        expect(Document.all.percentage(status: :error)).to eq(0.5)
      end
    end

    context 'when there are 25% documents with error' do
      let(:success_number) { 3 }

      it do
        expect(Document.all.percentage(status: :error)).to eq(0.25)
      end
    end

    context 'when passing a sub scope' do
      before do
        Document.create(status: :on_going)
      end

      it 'does the math inside the scope' do
        expect(Document.where(status: [:error, :success]).percentage(status: :error)).to eq(0.5)
      end
    end

    context 'when passing a scope name instead of query' do
      it 'does the math inside the scope' do
        expect(Document.all.percentage(:with_error)).to eq(0.5)
      end
    end
  end
end
