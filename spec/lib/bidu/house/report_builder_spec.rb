require 'spec_helper'

describe Bidu::House::ReportBuilder do
  let(:errors) { 1 }
  let(:successes) { 3 }
  let(:key) { :errors }
  let(:threshold) { 0.02 }
  let(:period) { 1.day }
  let(:external_key) { :external_id }
  let(:config) do
    {
      period: period,
      threshold: threshold,
      scope: :with_error,
      clazz: Document
    }
  end
  before do
    subject.add_config(key, config)
    Document.all.each(&:destroy)
    successes.times { Document.create status: :success }
    errors.times { Document.create status: :error }
  end

  describe '#build' do
    let(:ids) { Document.with_error.map(&:id) }
    it do
      expect(subject.build(key)).to be_a(Bidu::House::ErrorReport)
    end

    it 'builds the report using the given configuration' do
      expect(subject.build(key).as_json).to eq( ids: ids, percentage: 0.25 )
    end
  end
end
