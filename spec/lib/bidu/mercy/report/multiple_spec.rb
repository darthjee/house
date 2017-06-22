require 'spec_helper'

describe Mercy::Report::Multiple do
  class Mercy::Report::DocTypeError < Mercy::Report::Error
    ALLOWED_PARAMETERS=[:period, :threshold]
    DEFAULT_OPTION = {
      threshold: 0.25,
      clazz: Document,
      external_key: :external_id
    }

    json_parse :doc_type, case: :snake

    def base
      super.where(doc_type: doc_type)
    end
  end

  class Mercy::Report::Multiple::Dummy < Mercy::Report
    include Mercy::Report::Multiple
    DEFAULT_OPTION = {
      doc_type: [:a, :b]
    }
    json_parse :doc_type, case: :snake

    def reports_ids
      [ doc_type ].flatten
    end

    def sub_report_class
      Mercy::Report::DocTypeError
    end

    def key
      :doc_type
    end
  end

  let(:subject) { described_class::Dummy.new }
  let(:a_errors) { 1 }
  let(:a_successes) { 1 }
  let(:b_errors) { 1 }
  let(:b_successes) { 1 }
  let(:setup) do
    {
      success: { a: a_successes, b: b_successes },
      error: { a: a_errors, b: b_errors }
    }
  end

  before do
    Document.delete_all
    setup.each do |status, map|
      map.each do |doc_type, quantity|
        quantity.times do
          Document.create(status: status, doc_type: doc_type, external_id: Document.count)
        end
      end
    end
  end

  describe '#error?' do
    context 'when all subreports are with error' do
      it { expect(subject.error?).to be_truthy }
    end

    context 'when one of the reports is not an error' do
      let(:a_successes) { 4 }

      it { expect(subject.error?).to be_truthy }
    end

    context 'when none of the reports is an error' do
      let(:a_successes) { 4 }
      let(:b_successes) { 4 }

      it { expect(subject.error?).to be_falsey }
    end
  end

  describe '#as_json' do
    let(:expected) do
      {
        'a' => { ids: [2], percentage: 0.5, status: :error },
        'b' => { ids: [3], percentage: 0.5, status: :error },
        status: :error
      }
    end

    context 'when all subreports are with error' do
      it { expect(subject.as_json).to eq(expected) }
    end

    context 'when one of the reports is not an error' do
      let(:a_successes) { 4 }
      let(:expected) do
        {
          'a' => { ids: [5], percentage: 0.2, status: :ok },
          'b' => { ids: [6], percentage: 0.5, status: :error },
          status: :error
        }
      end

      it { expect(subject.as_json).to eq(expected) }
    end

    context 'when none of the reports is an error' do
      let(:a_successes) { 4 }
      let(:b_successes) { 4 }
      let(:expected) do
        {
          'a' => { ids: [8], percentage: 0.2, status: :ok },
          'b' => { ids: [9], percentage: 0.2, status: :ok },
          status: :ok
        }
      end

      it { expect(subject.as_json).to eq(expected) }
    end
  end
end

