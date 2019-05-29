# frozen_string_literal: true

require 'spec_helper'

describe ExampleReportController, type: :controller do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'status' do
    let(:expected_response) do
      {
        'status' => 'error',
        'errors_a' => {
          'ids' =>        [10],
          'percentage' => 0.02,
          'status' =>     'ok'
        },
        'errors_b' => {
          'ids' =>        [20],
          'percentage' => 0.25,
          'status' =>     'error'
        }
      }
    end

    let(:a_successes) { 49 }
    let(:b_successes) { 3 }

    before do
      Document.delete_all
      a_successes.times { Document.create(doc_type: :a) }
      b_successes.times { Document.create(doc_type: :b) }
      Document.with_error.create(doc_type: :a, external_id: 10)
      Document.with_error.create(doc_type: :b, external_id: 20)

      get :status
    end

    context 'when there are no documents' do
      it 'returns 200' do
        expect(response.status).to eq(500)
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end
  end

  describe 'count_status' do
    let(:expected_response) do
      {
        'status' => 'error',
        'successes' => {
          'status' => 'error',
          'a' => {
            'count' =>  10,
            'status' => 'ok'
          },
          'b' => {
            'count' =>  2,
            'status' => 'error'
          }
        }
      }
    end

    let(:a_successes) { 10 }
    let(:b_successes) { 2 }

    before do
      Document.delete_all

      a_successes.times do
        Document.with_success.create(doc_type: :a)
      end
      b_successes.times do
        Document.with_success.create(doc_type: :b)
      end

      get :count_status
    end

    context 'when there are no documents' do
      it 'returns 200' do
        expect(response.status).to eq(500)
      end

      it 'returns status json' do
        expect(parsed_response).to eq(expected_response)
      end
    end
  end
end
