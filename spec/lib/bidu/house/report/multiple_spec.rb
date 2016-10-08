require 'spec_helper'

describe Bidu::House::Report::Multiple do
  class Bidu::House::Report::DocTypeError < Bidu::House::Report::Error
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

  class Bidu::House::Report::Multiple::Dummy < Bidu::House::Report::Multiple
    DEFAULT_OPTION = {
      doc_type: [:a, :b]
    }
    json_parse :doc_type, case: :snake

    def reports_ids
      [ doc_type ].flatten
    end

    def sub_report_class
      Bidu::House::Report::DocTypeError
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
        Document.create(status: status, doc_type: doc_type, external_id: Document.count)
      end
    end
  end

  describe '#error?' do
    context 'when all subreports are with error' do
      it { expect(subject.error?).to be_truthy }
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
  end
end

