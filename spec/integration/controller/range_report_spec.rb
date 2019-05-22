# frozen_string_literal: true

require 'spec_helper'

describe DocumentReportController, type: :controller do
  describe 'range reports' do
    let(:parameters) { {} }

    let(:successes)     { 0 }
    let(:errors)        { 0 }
    let(:old_successes) { 11 }
    let(:old_errors)    { 11 }

    let(:expected_status)       { 'ok' }
    let(:expected_total_count)  { 0 }
    let(:expected_total_status) { 'ok' }
    let(:expected_error_count)  { 0 }
    let(:expected_error_status) { 'ok' }

    let(:parsed_response) do
      JSON.parse(response.body)
    end

    let(:expected_response) do
      {
        status: expected_status,
        total: {
          count:  expected_total_count,
          status: expected_total_status
        },
        error: {
          count:  expected_error_count,
          status: expected_error_status
        }
      }.deep_stringify_keys
    end

    before do
      Document.delete_all

      successes.times     { Document.with_success.create }
      errors.times        { Document.with_error.create }
      old_successes.times do
        Document.with_success.create(updated_at: 1.day.ago)
      end
      old_errors.times do
        Document.with_error.create(updated_at: 1.day.ago)
      end

      get :range_status, params: parameters
    end

    context 'when there are no documents for the given period' do
      let(:old_successes)         { 10 }
      let(:expected_status)       { 'error' }
      let(:expected_total_status) { 'error' }

      it 'fails on minimum' do
        expect(response.status).to eq(500)
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end

    context 'when there are errors below the maximum' do
      let(:errors)    { 8 }
      let(:successes) { 11 }

      let(:expected_total_count)  { 19 }
      let(:expected_error_count)  { 8 }

      it 'does not fail' do
        expect(response).to be_successful
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end

    context 'when there are errors above the maximum' do
      let(:errors)    { 11 }
      let(:successes) { 11 }

      let(:expected_total_count)  { 22 }
      let(:expected_error_count)  { 11 }
      let(:expected_status)       { 'error' }
      let(:expected_error_status) { 'error' }

      it 'fails due to maximum threshold' do
        expect(response.status).to eq(500)
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end

    context 'when passing params' do
      context 'when passing period' do
        let(:parameters) { { period: '2days' } }

        let(:expected_status)       { 'error' }
        let(:expected_total_count)  { 22 }
        let(:expected_total_status) { 'ok' }
        let(:expected_error_count)  { 11 }
        let(:expected_error_status) { 'error' }

        it 'fails due to maximum threshold' do
          expect(response.status).to eq(500)
        end

        it 'returns status json' do
          expect(parsed_response).to eq(expected_response)
        end
      end

      context 'when passing a minimum' do
        let(:parameters) { { minimum: 3 } }

        context 'when minimun is reached' do
          let(:errors)    { 4 }
          let(:successes) { 1 }

          let(:expected_total_count)  { 5 }
          let(:expected_error_count)  { 4 }

          it 'does not fail' do
            expect(response).to be_successful
          end

          it 'returns status json' do
            expect(parsed_response).to eq(expected_response)
          end
        end

        context 'when minimun is not reached' do
          let(:expected_status)       { 'error' }
          let(:expected_total_status) { 'error' }
          let(:expected_error_status) { 'error' }

          it 'fails on error due to minimum' do
            expect(response.status).to eq(500)
          end

          it 'returns status json' do
            expect(parsed_response).to eq(expected_response)
          end
        end
      end

      context 'when passing a maximum' do
        let(:parameters) { { maximum: 5 } }

        context 'when maximum is not reached' do
          let(:errors)    { 2 }
          let(:successes) { 3 }

          let(:expected_total_count)  { 5 }
          let(:expected_error_count)  { 2 }

          it 'does not fail' do
            expect(response).to be_successful
          end

          it 'returns status json' do
            expect(parsed_response).to eq(expected_response)
          end
        end

        context 'when maximum is reached' do
          let(:errors)    { 11 }
          let(:successes) { 1 }

          let(:expected_total_count)  { 12 }
          let(:expected_error_count)  { 11 }
          let(:expected_status)       { 'error' }
          let(:expected_total_status) { 'error' }
          let(:expected_error_status) { 'error' }

          it 'fails on error due to minimum' do
            expect(response.status).to eq(500)
          end

          it 'returns status json' do
            expect(parsed_response).to eq(expected_response)
          end
        end
      end
    end
  end
end
