# frozen_string_literal: true

require 'spec_helper'

describe Mercy::Report::Multiple do
  let(:subject)     { described_class::Dummy.new }
  let(:a_errors)    { 1 }
  let(:a_successes) { 1 }
  let(:b_errors)    { 1 }
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
          Document.create(
            status: status, doc_type: doc_type, external_id: Document.count
          )
        end
      end
    end
  end

  describe '#error?' do
    context 'when all subreports are with error' do
      it { expect(subject).to be_error }
    end

    context 'when one of the reports is not an error' do
      let(:a_successes) { 4 }

      it { expect(subject).to be_error }
    end

    context 'when none of the reports is an error' do
      let(:a_successes) { 4 }
      let(:b_successes) { 4 }

      it { expect(subject).not_to be_error }
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
