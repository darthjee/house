require 'spec_helper'

describe Mercy::ReportBuilder do
  let(:errors) { 1 }
  let(:successes) { 3 }
  let(:old_errors) { 2 }
  let(:key) { :errors }
  let(:threshold) { 0.02 }
  let(:period) { 1.day }
  let(:external_key) { :external_id }
  let(:config) do
    {
      period: period,
      threshold: threshold,
      external_key: :external_id,
      scope: :with_error,
      id: key,
      clazz: Document
    }
  end
  let(:parameters) { {} }
  let(:report) { subject.build(key, parameters) }
  before do
    subject.add_config(key, config)
    Document.all.each(&:destroy)
    successes.times { |i| Document.create status: :success, external_id: 30+i }
    errors.times { |i| Document.create status: :error, external_id: 10+i }
    old_errors.times do |i|
      Document.create status: :error, external_id: 20+i, created_at: 2.days.ago, updated_at: 2.days.ago
    end
  end

  describe '#build' do
    let(:ids) { [ 10 ] }
    it do
      expect(report).to be_a(Mercy::Report::Error)
    end

    it 'builds the report using the given configuration' do
      expect(report.as_json).to eq( ids: ids, percentage: 0.25, status: :error )
      expect(report.error?).to be_truthy
    end

    context 'when passing a custom threshold parameter' do
      let(:parameters) { { threshold: 1 } }

      it 'uses custom threshold parameter' do
        expect(report.error?).to be_falsey
      end
    end

    context 'when passing a custom period parameter' do
      let(:parameters) { { threshold: 0.4, period: 10.days, status: :error } }

      it 'uses custom period parameter' do
        expect(report.error?).to be_truthy
      end
    end

    context 'when passing a custom other parameters' do
      let(:parameters) do
        { scope: :with_success, clazz: Mercy::Report::Error, external_key: :id, id: :failures }
      end

      it 'ignores the non customizable parameters' do
        expect(report.as_json).to eq( ids: ids, percentage: 0.25, status: :error )
        expect(report.error?).to be_truthy
        expect(report.id).to eq(:errors)
      end
    end
  end
end
