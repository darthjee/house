# frozen_string_literal: true

require 'spec_helper'

describe DocumentReportController, type: :controller do
  describe 'multiple reports' do
    include_context 'with documents setup'

    let(:parameters) { {} }

    let(:parsed_response) do
      JSON.parse(response.body)
    end

    let(:expected_status)            { 'ok' }
    let(:expected_error_ids_type_a)  { [] }
    let(:expected_percentage_type_a) { 0 }
    let(:expected_status_type_a)     { 'ok' }
    let(:expected_error_ids_type_b)  { [] }
    let(:expected_percentage_type_b) { 0 }
    let(:expected_status_type_b)     { 'ok' }
    let(:expected_error_ids_type_c)  { [] }
    let(:expected_percentage_type_c) { 0 }
    let(:expected_status_type_c)     { 'ok' }

    let(:expected_response) do
      {
        status: expected_status,
        errors: {
          status: expected_status,
          a: {
            ids: expected_error_ids_type_a,
            percentage: expected_percentage_type_a,
            status: expected_status_type_a
          },
          b: {
            ids: expected_error_ids_type_b,
            percentage: expected_percentage_type_b,
            status: expected_status_type_b
          },
          c: {
            ids: expected_error_ids_type_c,
            percentage: expected_percentage_type_c,
            status: expected_status_type_c
          }
        }
      }.deep_stringify_keys
    end

    before do
      get :multiple_status, params: parameters
    end

    context 'when there are no documents' do
      it 'Returns the status' do
        expect(response).to be_successful
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end

    context 'when there are documents with errors' do
      let(:a_successes) { 2 }
      let(:b_successes) { 49 }
      let(:a_errors)    { 2 }
      let(:b_errors)    { 1 }

      let(:expected_status)            { 'error' }
      let(:expected_error_ids_type_a)  { [51, 52] }
      let(:expected_percentage_type_a) { 0.5 }
      let(:expected_status_type_a)     { 'error' }
      let(:expected_error_ids_type_b)  { [53] }
      let(:expected_percentage_type_b) { 0.02 }

      it 'Returns the status' do
        expect(response.status).to eq(500)
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end
  end
end
