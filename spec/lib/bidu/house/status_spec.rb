require 'spec_helper'

describe Bidu::House::Status do
  let(:threshold) { 0.02 }
  let(:period) { 1.day }
  let(:report_options) do
    {
      period: period,
      threshold: threshold,
      scope: :with_error,
      clazz: Document,
      id: :errors
    }
  end
  let(:success_options) do
    report_options.merge(
      scope: :with_success,
      id: :success
    )
  end
  let(:errors) { 0 }
  let(:successes) { 1 }
  let(:error_report) { Bidu::House::ErrorReport.new(report_options) }
  let(:success_report) do
    Bidu::House::ErrorReport.new(success_options)
  end
  let(:reports) { [ error_report ] }
  let(:subject) { described_class.new(reports) }
  before do
    Document.all.each(&:destroy)
    errors.times { Document.create status: :error }
    successes.times { Document.create status: :success }
  end

  describe '#as_json' do
    let(:status_json) { subject.as_json }
    let(:status) { status_json[:status] }

    context 'when report is ok' do
      it 'returns a json with ok' do
        expect(status).to eq(:ok)
      end

      it 'returns the report json' do

      end
    end

    context 'when report is not ok' do
      let(:errors) { 1 }

      it 'returns a json with error' do
        expect(status).to eq(:error)
      end
    end

    context 'when there are both success and error reports' do
      let(:success_report) do
        Bidu::House::ErrorReport.new(report_options.merge(scope: :with_success))
      end
      let(:reports) { [ success_report, error_report ] }

      it 'returns a json with error' do
        expect(status).to eq(:error)
      end
    end
  end

  describe '#status' do
    context 'when report is ok' do
      it do
        expect(subject.status).to eq(:ok)
      end
    end

    context 'when report is not ok' do
      let(:errors) { 1 }

      it do
        expect(subject.status).to eq(:error)
      end
    end

    context 'when there are both success and error reports' do
      let(:reports) { [ success_report, error_report ] }

      it do
        expect(subject.status).to eq(:error)
      end
    end
  end

  describe '#as_json' do
    let(:errors) { 3 }
    let(:ids) { Document.with_error.map(&:id) }
    let(:expected) do
      {
        status: :error,
        errors: {
          ids: ids,
          percentage: 0.75
        }
      }
    end

    it 'creates a summary of the reports' do
      expect(subject.as_json).to eq(expected)
    end

    context 'when there are both success and error reports' do
      let(:success_ids) { Document.with_success.map(&:id) }
      let(:expected) do
        {
          status: :error,
          errors: {
            ids: ids,
            percentage: 0.75
          },
          success: {
            ids: success_ids,
            percentage: 0.25
          }
        }
      end
      let(:reports) { [ success_report, error_report ] }

      it 'creates a summary of all the reports' do
        expect(subject.as_json).to eq(expected)
      end
    end
  end
end
