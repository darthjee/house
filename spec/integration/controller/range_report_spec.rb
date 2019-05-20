# frozen_string_literal: true

require 'spec_helper'

describe DocumentReportController, type: :controller do
  describe 'range reports' do
    let(:parameters) { {} }

    let(:successes) { 0 }
    let(:errors)    { 0 }

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

      successes.times { Document.with_success.create }
      errors.times    { Document.with_error.create }

      get :range_status, params: parameters
    end

    context 'when there are no documents' do
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
  end
end
