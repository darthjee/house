# frozen_string_literal: true

require 'spec_helper'

describe Mercy::StatusBuilder do
  let(:errors)       { 1 }
  let(:successes)    { 3 }
  let(:old_errors)   { 2 }
  let(:key)          { :errors }
  let(:threshold)    { 0.02 }
  let(:period)       { 1.day }
  let(:external_key) { :external_id }
  let(:config) do
    {
      period: period,
      threshold: threshold,
      scope: :with_error,
      clazz: Document,
      id: :failures,
      external_key: :external_id,
      on: key
    }
  end
  let(:parameters) { {} }
  let(:status) { subject.build(key, parameters) }

  before do
    subject.add_report_config(key, config)
    Document.all.each(&:destroy)

    successes.times do |i|
      Document.create status: :success, external_id: 30 + i
    end

    errors.times do |i|
      Document.create status: :error, external_id: 10 + i
    end

    old_errors.times do |i|
      Document.create status: :error, external_id: 20 + i,
                      created_at: 2.days.ago, updated_at: 2.days.ago
    end
  end

  describe '#build' do
    let(:ids) { [10] }
    let(:status_expected) { :error }
    let(:percentage)      { 0.25 }
    let(:json_expected) do
      {
        status: status_expected,
        failures: {
          ids: ids,
          percentage: percentage,
          status: status_expected
        }
      }
    end

    it do
      expect(status).to be_a(Mercy::Status)
    end

    context 'when not specifying where to report' do
      let(:key) {}

      it 'register report under default' do
        expect(subject.build(:default).as_json).to eq(json_expected)
      end
    end

    it 'builds the report using the given configuration' do
      expect(status.as_json).to eq(json_expected)
    end

    context 'when passing a custom threshold parameter' do
      let(:parameters)      { { threshold: 1 } }
      let(:status_expected) { :ok }

      it 'uses custom threshold parameter' do
        expect(status.as_json).to eq(json_expected)
      end
    end

    context 'when passing a custom period parameter' do
      let(:ids) { [10, 20, 21] }
      let(:percentage) { 0.5 }
      let(:parameters) { { threshold: 0.4, period: 10.days } }

      it 'uses custom period parameter' do
        expect(status.as_json).to eq(json_expected)
      end
    end
  end
end
