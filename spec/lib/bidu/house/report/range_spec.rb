require 'spec_helper'

describe Bidu::House::Report::Range do
  let(:errors) { 1 }
  let(:successes) { 1 }
  let(:old_errors) { 2 }
  let(:old_sucesses) { 2 }
  let(:period) { 1.day }
  let(:scope) { :with_error }
  let(:maximum) { nil }
  let(:minimum) { nil }
  let(:options) do
    {
      period: period,
      scope: scope,
      clazz: Document,
      minimum: minimum,
      maximum: maximum
    }
  end
  let(:subject) { described_class.new(options) }
  let(:types) { [:a] }
  before do
    Document.all.each(&:destroy)
    types.each do |type|
      successes.times { Document.create status: :success, doc_type: type }
      errors.times do |i|
        Document.create status: :error, external_id: 10 * successes + i, outter_external_id: i, doc_type: type
      end
      old_errors.times do
        Document.create status: :error, created_at: 2.days.ago, updated_at: 2.days.ago, doc_type: type
      end
      old_sucesses.times do
        Document.create status: :success, created_at: 2.days.ago, updated_at: 2.days.ago, doc_type: type
      end
    end
  end

  describe '#status' do
    context 'when looking for maximum counts' do
      context 'when there are more errors than the allowed by the maximum' do
        let(:errors) { 2 }
        let(:maximum) { 1 }
        it { expect(subject.status).to eq(:error) }
      end

      context 'when the maximum is 0 and there are no errors' do
        let(:errors) { 0 }
        let(:maximum) { 0 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the maximum is nil and there are no errors' do
        let(:errors) { 0 }
        let(:maximum) { nil }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is the same as the maximum' do
        let(:errors) { 1 }
        let(:maximum) { 1 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is less than the maximum' do
        let(:errors) { 1 }
        let(:maximum) { 2 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when there are older errors out of the period' do
        let(:maximum) { 1 }

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

    context 'when looking for minimum' do
      let(:scope) { :with_success }
      context 'when there are less successes than the allowed by the minimum' do
        let(:successes) { 1 }
        let(:minimum) { 2 }
        it { expect(subject.status).to eq(:error) }
      end

      context 'when the minimum is 0 and there are no sucesses' do
        let(:successes) { 0 }
        let(:minimum) { 0 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the minimum is nil and there are no sucesses' do
        let(:successes) { 0 }
        let(:minimum) { nil }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is the same as the minimum' do
        let(:successes) { 1 }
        let(:minimum) { 1 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is greater than the minimum' do
        let(:successes) { 2 }
        let(:minimum) { 1 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when there are older sucesses out of the period' do
        let(:successes) { 0 }
        let(:minimum) { 1 }

        it 'ignores the older sucesses' do
          expect(subject.status).to eq(:error)
        end

        context 'when passing a bigger period' do
          let(:period) { 3.days }
  
          it 'consider the older sucesses' do
            expect(subject.status).to eq(:ok)
          end
        end
      end
    end

    context 'when looking for a range' do
      let(:scope) { :all }
      let(:minimum) { 2 }
      let(:maximum) { 4 }

      context 'when there are less documents than the allowed by the minimum' do
        let(:successes) { 1 }
        let(:errors) { 0 }
        it { expect(subject.status).to eq(:error) }
      end

      context 'when the count is the same as the minimum' do
        let(:successes) { 1 }
        let(:errors) { 2 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is inside the range' do
        let(:successes) { 1 }
        let(:errors) { 2 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is the same as the maximum' do
        let(:successes) { 2 }
        let(:errors) { 2 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when the count is greater than the maximum' do
        let(:successes) { 3 }
        let(:errors) { 2 }
        it { expect(subject.status).to eq(:error) }
      end

      context 'when the minimum is 0 and the count is 0' do
        let(:successes) { 0 }
        let(:errors) { 0 }
        let(:minimum) { 0 }
        it { expect(subject.status).to eq(:ok) }
      end

      context 'when there are older sucesses out of the period' do
        let(:old_errors) { 1 }
        let(:old_sucesses) { 2 }

        context 'and the regular documents are not enough' do
          let(:successes) { 1 }
          let(:errors) { 0 }
 
          it 'ignores the older sucesses' do
            expect(subject.status).to eq(:error)
          end

          context 'when passing a bigger period' do
            let(:period) { 3.days }
  
            it 'consider the older sucesses' do
              expect(subject.status).to eq(:ok)
            end
          end
        end

        context 'and the regular documents are almost in the limit' do
          let(:successes) { 2 }
          let(:errors) { 1 }
 
          it 'ignores the older sucesses' do
            expect(subject.status).to eq(:ok)
          end

          context 'when passing a bigger period' do
            let(:period) { 3.days }
  
            it 'consider the older documents' do
              expect(subject.status).to eq(:error)
            end
          end
        end
      end
    end
  end

  describe '#count' do 
    let(:types) { [:a, :b] }
    let(:errors) { 1 }
    let(:scope) { :with_error }

    it 'returns all the documents found' do
      expect(subject.count).to eq(2)
    end
    
    context 'when configuring with a complex scope' do
      let(:old_errors) { 0 }
      let(:scope) { :'with_error.type_b' }
      let(:errors) { 1 }

      context 'as symbol' do
        let(:scope) { :'with_error.type_b' }

        it 'fetches from each scope in order' do
          expect(subject.count).to eq(1)
        end
      end

      context 'as string where scope' do
        let(:scope) { "status = 'error' and doc_type = 'b'" }

        it 'fetches from each scope in order' do
          expect(subject.count).to eq(1)
        end
      end

      context 'as hash where scope' do
        let(:scope) { { status: :error, doc_type: :b } }

        it 'fetches from each scope in order' do
          expect(subject.count).to eq(1)
        end
      end
    end
  end

  describe '#error?' do
    let(:errors) { 2 }
    let(:maximum) { 1 }

    context 'when errors count overcome maximum' do
      it { expect(subject.error?).to be_truthy }
    end

    context 'when errors count do not overcome maximum' do
      let(:errors) { 0 }
      it { expect(subject.error?).to be_falsey }
    end
  end

  describe '#as_json' do
    let(:expected) do
      { ids: ids_expected, percentage: percentage_expected, status: status_expected }
    end

    context 'when everything is ok' do
      let(:errors) { 1 }
      let(:successes) { 9 }
      let(:ids_expected) { [90] }
      let(:status_expected) { :ok }
      let(:percentage_expected) { 0.1 }
      let(:threshold) { 0.5 }

      it 'returns the external keys, status and error percentage' do
        expect(subject.as_json).to eq(expected)
      end

    end

    context 'when there are 75% erros' do
      let(:status_expected) { :error }
      let(:percentage_expected) { 0.75 }
      let(:errors) { 3 }
      let(:successes) { 1 }
      let(:ids_expected) { [10, 11, 12] }

      it 'returns the external keys, status and error percentage' do
        expect(subject.as_json).to eq(expected)
      end

      context 'when configurated with different external key' do
        let(:external_key) { :outter_external_id }
        let(:ids_expected) { [0, 1, 2] }

        it 'returns the correct external keys' do
          expect(subject.as_json).to eq(expected)
        end

        context 'when some external ids are the same' do
          let(:ids_expected) { [10, 10, 10] }
          before do
            Document.update_all(outter_external_id: 10)
          end

          it 'returns the correct external keys' do
            expect(subject.as_json).to eq(expected)
          end

          context 'and passing uniq option' do
            before { options[:uniq] = true }
            let(:ids_expected) { [10] }

            it 'returns the correct external keys only once' do
              expect(subject.as_json).to eq(expected)
            end
          end
        end

        context 'with a limit' do
          before { options[:limit] = 2 }
          let(:ids_expected) { [0, 1] }

          it 'returns only the limited ids' do
            expect(subject.as_json).to eq(expected)
          end
        end
      end

      context 'when configurated without external key' do
        before { options.delete(:external_key) }
        let(:ids_expected) { Document.with_error.where('created_at > ?', 30.hours.ago).map(&:id) }

        it 'returns the ids as default id' do
          expect(subject.as_json).to eq(expected)
        end
      end
    end
  end
end
